import Foundation
import Combine
import Logging
#if canImport(CoreBluetooth)
import CoreBluetooth

public final class CoreBluetoothCentralManager: NSObject {
    
    private static let logger = Logger(label: "bluetooth.package")
    
    /// Options configured at initialization that are used to configure the `CBCentralManager`.
    private let managerOptions: [String: Any]
    private lazy var queue = DispatchQueue(label: "bluetooth.core_bluetooth.central_manager")
    
    private var authorizationSubject: CurrentValueSubject<ManagerAuthorization, Never> = .init(.notDetermined)
    private var stateSubject: CurrentValueSubject<ManagerState, Never> = .init(.unknown)
    private var isScanningSubject: CurrentValueSubject<Bool, Never> = .init(false)
    
    private var _peripherals: [CoreBluetoothPeripheral] = []
    private var peripheralsSubject: PassthroughSubject<Peripheral, BluetoothError> = .init()

    internal lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: queue, options: managerOptions)
    
    /// Initialize the service
    ///
    /// - parameters:
    ///   - showPowerAlert: A Boolean value that specifies whether the system should warn the user if the app
    ///                     instantiates the manager while Bluetooth is powered off.
    ///   - restoreIdentifier: A string containing a unique identifier (UID) for the manager to restore with.
    public init(showPowerAlert: Bool = true, restoreIdentifier: String? = nil) {
        var options: [String: Any] = [:]

        // This is required to be expressed as an 'NSNumber'
        options[CBCentralManagerOptionShowPowerAlertKey] = showPowerAlert as NSNumber
        if let identifier = restoreIdentifier, !identifier.isEmpty {
            options[CBCentralManagerOptionRestoreIdentifierKey] = identifier
        }

        managerOptions = options

        super.init()
        
        authorizationSubject = .init(ManagerAuthorization(CBManager.authorization))
    }
    
    private func terminateScan(error: BluetoothError? = nil) {
        Self.logger.info("Terminating BLE Scan")
        
        if state == .poweredOn {
            centralManager.stopScan()
        }
        
        isScanningSubject.send(false)
        
        switch error {
        case .some(let bluetoothError):
            peripheralsSubject.send(completion: .failure(bluetoothError))
        case .none:
            peripheralsSubject.send(completion: .finished)
        }
    }
}

extension CoreBluetoothCentralManager: CentralManager {
    public var authorization: ManagerAuthorization { authorizationSubject.value }
    public var authorizationPublisher: AnyPublisher<ManagerAuthorization, Never> { authorizationSubject.eraseToAnyPublisher() }
    public var state: ManagerState { stateSubject.value }
    public var statePublisher: AnyPublisher<ManagerState, Never> { stateSubject.eraseToAnyPublisher() }
    public var isScanning: Bool { isScanningSubject.value }
    public var isScanningPublisher: AnyPublisher<Bool, Never> { isScanningSubject.eraseToAnyPublisher() }
    public var peripherals: [Peripheral] { _peripherals }
    
    public func requestAuthorization() {
        // Forces the `centralManager` to initialize and restore state.
        // If this were done at initialization, the system prompt could be presented at an inopportune time.
        _ = centralManager.isScanning
    }
    
    public func scanForPeripherals(withServiceIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<Peripheral, BluetoothError> {
        return stateSubject
            .tryFilter { state in
                switch state {
                case .poweredOn: return true
                case .unknown, .resetting: return false
                default: throw BluetoothError.notPoweredOn
                }
            }
            .mapError { $0 as! BluetoothError }
            .flatMap { _ in
                Future<Void, BluetoothError> { promise in
                    self.terminateScan()
                    self._peripherals.removeAll()
                    self.peripheralsSubject = .init()

                    promise(.success(()))

                    let services = (identifiers.isEmpty) ? nil : identifiers.map { $0.cbUUID }
                    let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: false as NSNumber]

                    self.isScanningSubject.send(true)

                    self.centralManager.scanForPeripherals(withServices: services, options: options)
                }
            }
            .flatMap { _ in self.peripheralsSubject }
            .handleEvents(receiveSubscription: { _ in
                Self.logger.info("Beginning BLE Scan")
            }, receiveOutput: { peripheral in
                Self.logger.info("Found Peripheral '\(peripheral.name)' [\(peripheral.id)].")
            }, receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    Self.logger.error("\(error.localizedDescription)")
                }
            }, receiveCancel: {
                self.terminateScan()
            })
            .eraseToAnyPublisher()
    }
    
    public func peripheral(withIdentifier identifier: BluetoothID) -> Peripheral? {
        if let existing = _peripherals.first(where: { $0.id == identifier }) {
            return existing
        }
        
        if let retrieved = centralManager.retrievePeripherals(withIdentifiers: [identifier.rawValue]).first {
            let peripheral = CoreBluetoothPeripheral(manager: self, peripheral: retrieved)
            _peripherals.append(peripheral)
            return peripheral
        }
        
        return nil
    }
    
    public func connectedPeripherals(withServiceIdentifiers identifiers: [BluetoothID]) -> [Peripheral] {
        let services = identifiers.map({ $0.cbUUID })
        let connected = centralManager.retrieveConnectedPeripherals(withServices: services)
        
        var peripherals: [Peripheral] = []
        
        connected.forEach { (element) in
            let peripheral: CoreBluetoothPeripheral
            if let existing = _peripherals.first(where: { $0.id == element.identifier }) {
                peripheral = existing
            } else {
                peripheral = CoreBluetoothPeripheral(manager: self, peripheral: element)
                _peripherals.append(peripheral)
            }
            
            peripherals.append(peripheral)
        }
        
        return peripherals
    }
}

extension CoreBluetoothCentralManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let authorization = ManagerAuthorization(CBManager.authorization)
        if self.authorization != authorization {
            authorizationSubject.send(authorization)
        }
        stateSubject.send(ManagerState(central.state))
        if central.state == .poweredOff {
            terminateScan(error: .notConnected)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let existing = _peripherals.first(where: { $0.id == peripheral.identifier }) {
            existing.restore(peripheral, advertisementData: advertisementData, rssi: RSSI.intValue)
        } else {
            let new = CoreBluetoothPeripheral(manager: self, peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI.intValue)
            _peripherals.append(new)
            peripheralsSubject.send(new)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let existing = _peripherals.first(where: { $0.id == peripheral.identifier }) else {
            centralManager.cancelPeripheralConnection(peripheral)
            return
        }
        
        existing.setConnected(true, error: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard let existing = _peripherals.first(where: { $0.id == peripheral.identifier }) else {
            return
        }
        
        existing.setConnected(false, error: error)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard let existing = _peripherals.first(where: { $0.id == peripheral.identifier }) else {
            return
        }
        
        existing.setConnected(false, error: error)
    }
}
#endif
