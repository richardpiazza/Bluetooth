import Foundation
import Combine
import Logging
#if canImport(CoreBluetooth)
import CoreBluetooth

public class CoreBluetoothPeripheralManager: NSObject {
    
    private static let logger = Logger(label: "bluetooth.package")
    
    /// Options configured at initialization that are used to configure the `CBCentralManager`.
    private let managerOptions: [String: Any]
    private lazy var queue = DispatchQueue(label: "bluetooth.core_bluetooth.peripheral_manager")
    
    private var authorizationSubject: CurrentValueSubject<ManagerAuthorization, Never> = .init(.notDetermined)
    private var stateSubject: CurrentValueSubject<ManagerState, Never> = .init(.unknown)
    private var isAdvertisingSubject: CurrentValueSubject<Bool, Never> = .init(false)
    
    public var advertisementData: AdvertisementData = BluetoothAdvertisementData()
    public var services: [MutableService] = []
    
    private var advertisedServices: [AdvertisedService] = []
    private var advertisingSubject: PassthroughSubject<Never, BluetoothError> = .init()
    
    internal lazy var peripheralManager: CBPeripheralManager = CBPeripheralManager(delegate: self, queue: queue, options: managerOptions)
    
    /// Initialize the service
    ///
    /// - parameters:
    ///   - showPowerAlert: A Boolean value that specifies whether the system should warn the user if the app
    ///                     instantiates the manager while Bluetooth is powered off.
    ///   - restoreIdentifier: A string containing a unique identifier (UID) for the manager to restore with.
    public init(showPowerAlert: Bool = true, restoreIdentifier: String? = nil) {
        var options: [String: Any] = [:]

        // This is required to be expressed as an 'NSNumber'
        options[CBPeripheralManagerOptionShowPowerAlertKey] = showPowerAlert as NSNumber
        if let identifier = restoreIdentifier, !identifier.isEmpty {
            options[CBPeripheralManagerOptionRestoreIdentifierKey] = identifier
        }

        managerOptions = options

        super.init()
        
        authorizationSubject = .init(ManagerAuthorization(CBManager.authorization))
    }
    
    private func terminateAdvertising(error: BluetoothError? = nil) {
        Self.logger.info("Terminating BLE Advertising")
        
        if let bluetoothError = error {
            Self.logger.error("\(bluetoothError.localizedDescription)")
        }
        
        if state == .poweredOn {
            peripheralManager.stopAdvertising()
        }
        
        isAdvertisingSubject.send(false)
        
        advertisedServices.removeAll()
    }
}

extension CoreBluetoothPeripheralManager: PeripheralManager {
    public var authorization: ManagerAuthorization { authorizationSubject.value }
    public var authorizationPublisher: AnyPublisher<ManagerAuthorization, Never> { authorizationSubject.eraseToAnyPublisher() }
    public var state: ManagerState { stateSubject.value }
    public var statePublisher: AnyPublisher<ManagerState, Never> { stateSubject.eraseToAnyPublisher() }
    public var isAdvertising: Bool { isAdvertisingSubject.value }
    public var isAdvertisingPublisher: AnyPublisher<Bool, Never> { isAdvertisingSubject.eraseToAnyPublisher() }
    
    public func requestAuthorization() {
        // Forces the `peripheralManager` to initialize and restore state.
        // If this were done at initialization, the system prompt could be presented at an inopportune time.
        _ = peripheralManager.isAdvertising
    }
    
    public func beginAdvertising() -> AnyPublisher<Never, BluetoothError> {
        return stateSubject
            .tryFilter { state in
                switch state {
                case .poweredOn: return true
                case .unknown, .resetting: return false
                default: throw BluetoothError.notPoweredOn
                }
            }
            .mapError{ $0 as! BluetoothError }
            .flatMap { _ in
                Future<Void, BluetoothError> { promise in
                    self.terminateAdvertising()
                    self.advertisedServices = self.services.map { AdvertisedService(manager: self.peripheralManager, mutableService: $0) }
                    self.isAdvertisingSubject.send(true)
                    self.peripheralManager.startAdvertising(self.advertisementData.dictionary)
                    promise(.success(()))
                }
            }
            .ignoreOutput()
            .handleEvents(receiveSubscription: { _ in
                Self.logger.debug("Beginning BLE Advertising")
            }, receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    Self.logger.error("\(error.localizedDescription)")
                }
            }, receiveCancel: {
                self.terminateAdvertising()
            })
            .eraseToAnyPublisher()
    }
}

extension CoreBluetoothPeripheralManager: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ manager: CBPeripheralManager) {
        stateSubject.send(ManagerState(manager.state))
        if manager.state == .poweredOff {
            terminateAdvertising(error: .notConnected)
        }
    }
    
    public func peripheralManagerDidStartAdvertising(_ manager: CBPeripheralManager, error: Error?) {
        advertisedServices.forEach {
            manager.add($0.service)
        }
    }
    
    public func peripheralManager(_ manager: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let advertisedService = advertisedServices.first(where: { $0.service == service }) {
            Self.logger.info("Added Service: \(advertisedService)")
        } else {
            Self.logger.info("Added Service: \(service)")
        }
    }
    
    public func peripheralManager(_ manager: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        advertisedServices.forEach { $0.subscribeCentral(central, toCharacteristic: characteristic) }
    }
    
    public func peripheralManager(_ manager: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        advertisedServices.forEach { $0.unsubscribeCentral(central, fromCharacteristic: characteristic) }
    }
    
    public func peripheralManager(_ manager: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        guard let characteristic = characteristic(with: request.characteristic.uuid) else {
            manager.respond(to: request, withResult: .attributeNotFound)
            return
        }
        
        do {
            try request.value = characteristic.read(request.offset)
            manager.respond(to: request, withResult: .success)
        } catch {
            manager.respond(to: request, withResult: .attributeNotLong)
        }
    }
    
    public func peripheralManager(_ manager: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        requests.forEach {
            guard let characteristic = characteristic(with: $0.characteristic.uuid) else {
                manager.respond(to: $0, withResult: .attributeNotFound)
                return
            }
            
            do {
                try characteristic.write($0.value, offset: $0.offset)
                manager.respond(to: $0, withResult: .success)
            } catch {
                manager.respond(to: $0, withResult: .attributeNotLong)
            }
        }
    }
}

private extension CoreBluetoothPeripheralManager {
    func characteristic(with id: CBUUID) -> MutableCharacteristic? {
        for service in advertisedServices {
            if let characteristic = service.characteristics.first(where: { $0.characteristic.uuid == id }) {
                return characteristic.mutableCharacteristic
            }
        }
        
        return nil
    }
}
#endif
