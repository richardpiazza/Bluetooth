import Foundation
import Combine
import Logging
#if canImport(CoreBluetooth)
import CoreBluetooth

public final class CoreBluetoothPeripheral: NSObject {
    
    private static let logger = Logger(label: "bluetooth.package")
    
    unowned let _manager: CoreBluetoothCentralManager
    public private(set) var _peripheral: CBPeripheral
    
    private var _advertisementData: BluetoothAdvertisementData
    private var _services: [CoreBluetoothService] = []
    private var rssiSubject: CurrentValueSubject<Int, BluetoothError> = .init(0)
    private var isConnectedSubject: CurrentValueSubject<Bool, Never> = .init(false)
    private var servicesSubject: PassthroughSubject<[Service], BluetoothError> = .init()
    private var rssiReadingSubscription: AnyCancellable?
    
    public init(manager: CoreBluetoothCentralManager, peripheral: CBPeripheral, advertisementData: [String: Any] = [:], rssi: Int = 0) {
        _manager = manager
        _peripheral = peripheral
        _advertisementData = BluetoothAdvertisementData(advertisementData)
        
        super.init()
        
        peripheral.delegate = self
        rssiSubject.send(rssi)
    }
    
    private func waitForConnection() -> AnyPublisher<Bool, BluetoothError> {
        isConnectedSubject
            .dropFirst()
            .first()
            .tryMap { connected in
                guard connected else {
                    throw BluetoothError.notConnected
                }
                
                return connected
            }
            .mapError { $0 as! BluetoothError }
            .eraseToAnyPublisher()
    }
    
    private func beginRSSIReading(_ interval: TimeInterval = 5.0) {
        endRSSIReading()
        rssiReadingSubscription = Timer.publish(every: interval, tolerance: nil, on: .main, in: .default, options: nil)
            .autoconnect()
            .sink(receiveValue: { _ in
                self._peripheral.readRSSI()
            })
    }
    
    private func endRSSIReading() {
        rssiReadingSubscription?.cancel()
        rssiReadingSubscription = nil
    }
}

extension CoreBluetoothPeripheral: Peripheral {
    public var id: BluetoothID { BluetoothID(rawValue: _peripheral.identifier) }
    public var name: String { _peripheral.name ?? _peripheral.identifier.uuidString }
    public var state: PeripheralState { PeripheralState(_peripheral.state) }
    public var advertisementData: AdvertisementData { _advertisementData }
    public var rssi: Int { rssiSubject.value }
    public var isConnected: Bool { isConnectedSubject.value }
    public var isConnectedPublisher: AnyPublisher<Bool, Never> { isConnectedSubject.eraseToAnyPublisher() }
    public var services: [Service] { _services }
    
    public func connect(withDelay delay: Int, cancelPending: Bool, options: ConnectOptions?) -> AnyPublisher<Bool, BluetoothError> {
        guard state != .connected else {
            return Just(isConnected).setFailureType(to: BluetoothError.self).eraseToAnyPublisher()
        }
        
        if cancelPending || state == .connecting {
            disconnect()
        }
        
        // These values are required to be 'NSNumber'
        var connectOptions: [String: Any] = [:]
        let onConnection = options?.contains(.notifyOnConnection) ?? false
        connectOptions[CBConnectPeripheralOptionNotifyOnConnectionKey] = onConnection as NSNumber
        let onDisconnection = options?.contains(.notifyOnDisconnect) ?? false
        connectOptions[CBConnectPeripheralOptionNotifyOnDisconnectionKey] = onDisconnection as NSNumber
        let onNotification = options?.contains(.notifyOnAllEvents) ?? false
        connectOptions[CBConnectPeripheralOptionNotifyOnNotificationKey] = onNotification as NSNumber
        
        if delay > 0 {
            connectOptions[CBConnectPeripheralOptionStartDelayKey] = delay as NSNumber
        }
        
        return waitForConnection()
            .handleEvents(receiveSubscription: { _ in
                self._manager.centralManager.connect(self._peripheral, options: connectOptions)
            }, receiveCancel: {
                self.disconnect()
            })
            .eraseToAnyPublisher()
    }
    
    public func disconnect() {
        _services.forEach { (service) in
            service.handleDisconnect()
        }
        
        _services.removeAll()
        
        guard _peripheral.state != .disconnected else {
            return
        }
        
        _manager.centralManager.cancelPeripheralConnection(_peripheral)
    }
    
    public func discoverServices(withIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<[Service], BluetoothError> {
        guard isConnected else {
            return Fail<[Service], BluetoothError>(error: .notConnected).eraseToAnyPublisher()
        }
        
        servicesSubject = .init()
        
        return servicesSubject
            .handleEvents(receiveSubscription: { _ in
                self._peripheral.discoverServices(identifiers.map { $0.cbUUID })
            })
            .eraseToAnyPublisher()
    }
    
    public var rssiPublisher: AnyPublisher<Int, BluetoothError> {
        let current = rssiSubject
        rssiSubject = .init(current.value)
        current.send(completion: .finished)
        
        return rssiSubject
            .handleEvents(receiveSubscription: { _ in
                self.beginRSSIReading()
            }, receiveCompletion: { _ in
                self.endRSSIReading()
            }, receiveCancel: {
                self.endRSSIReading()
            })
            .eraseToAnyPublisher()
    }
}

extension CoreBluetoothPeripheral: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        guard error == nil else {
            rssiSubject.send(completion: .failure(.undefinedError(error!)))
            return
        }
        
        rssiSubject.send(rssi)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        handleServices(error: error)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        handleServices(error: nil)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        firstService(for: service)?.handleCharacteristics(error: error)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        firstCharacteristic(for: characteristic)?.handleValueUpdate(error: error)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        firstCharacteristic(for: characteristic)?.handleValueWrite(error: error)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        firstDescriptor(for: descriptor)?.handleDescriptorUpdate(error: error)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        firstDescriptor(for: descriptor)?.handleDescriptorWrite(error: error)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        firstCharacteristic(for: characteristic)?.handleNotificationState(error: error)
    }
}

extension CoreBluetoothPeripheral {
    func restore(_ peripheral: CBPeripheral, advertisementData: [String: Any]? = nil, rssi: Int? = nil) {
        if _peripheral != peripheral {
            _peripheral.delegate = nil
            _peripheral = peripheral
            _peripheral.delegate = self
        }
        
        if let advertisementData = advertisementData {
            _advertisementData.merge(advertisementData)
        }
        
        if let rssi = rssi {
            rssiSubject.send(rssi)
        }
    }
    
    func setConnected(_ connected: Bool, error: Error?) {
        if let e = error {
            Self.logger.error("\(e.localizedDescription)")
            Self.logger.warning("Peripheral [\(_peripheral.identifier)]")
        }
        
        isConnectedSubject.send(connected)
        if !connected {
            disconnect()
        }
    }
    
    func handleServices(error: Error? = nil) {
        let currentServices = Set(_services.map({ $0._service }))
        let updatedServices = Set(_peripheral.services ?? [])
        
        let remove = currentServices.subtracting(updatedServices)
        let add = updatedServices.subtracting(currentServices)
        let update = currentServices.intersection(updatedServices)
        
        _services.removeAll(where: { remove.contains($0._service) })
        
        update.forEach { (service) in
            if let index = _services.firstIndex(where: { $0._service == service }) {
                _services[index].setService(service)
            }
        }
        
        add.forEach { (service) in
            let new = CoreBluetoothService(peripheral: self, service: service)
            Self.logger.debug("Discovered Service '\(new.name)' [\(new.id)].")
            _services.append(new)
        }
        
        servicesSubject.send(services)
        
        if let error = error {
            servicesSubject.send(completion: .failure(.undefinedError(error)))
        } else {
            servicesSubject.send(completion: .finished)
        }
    }
    
    func firstService(for service: CBService) -> CoreBluetoothService? {
        _services.first(where: { $0._service == service })
    }
    
    func firstService(for characteristic: CBCharacteristic) -> CoreBluetoothService? {
        _services.first { (service) -> Bool in
            service._characteristics.contains(where: { $0._characteristic == characteristic })
        }
    }
    
    func firstCharacteristic(for characteristic: CBCharacteristic) -> CoreBluetoothCharacteristic? {
        guard let service = firstService(for: characteristic) else {
            return nil
        }
        
        guard let characteristic = service._characteristics.first(where: { $0._characteristic == characteristic }) else {
            return nil
        }
        
        return characteristic
    }
    
    func firstDescriptor(for descriptor: CBDescriptor) -> CoreBluetoothDescriptor? {
        var found: CoreBluetoothDescriptor? = nil
        
        _services.forEach { (service) in
            service._characteristics.forEach { (characteristic) in
                if let element = characteristic._descriptor.first(where: { $0.descriptor == descriptor} ) {
                    found = element
                    return
                }
            }
        }
        
        return found
    }
}
#endif
