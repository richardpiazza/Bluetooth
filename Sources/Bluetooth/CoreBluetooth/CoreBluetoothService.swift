import Foundation
import Combine
import Logging
#if canImport(CoreBluetooth)
import CoreBluetooth

public final class CoreBluetoothService {
    
    private static let logger = Logger(label: "bluetooth.package")
    
    unowned let _peripheral: CoreBluetoothPeripheral
    public private(set) var _service: CBService
    public private(set) var _characteristics: [CoreBluetoothCharacteristic] = []
    
    private var characteristicsSubject: PassthroughSubject<[Characteristic], BluetoothError> = .init()
    
    public init(peripheral: CoreBluetoothPeripheral, service: CBService) {
        _peripheral = peripheral
        _service = service
    }
}

extension CoreBluetoothService: Service {
    public var id: BluetoothID { BluetoothID(_service.uuid) }
    public var characteristics: [Characteristic] { _characteristics }
    public var peripheral: Peripheral { _peripheral }
    
    public func discoverCharacteristics(withIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<[Characteristic], BluetoothError> {
        guard _peripheral._peripheral.services?.contains(_service) == true else {
            return Fail<[Characteristic], BluetoothError>(error: .serviceInvalidated(id)).eraseToAnyPublisher()
        }
        
        guard _peripheral.isConnected else {
            return Fail<[Characteristic], BluetoothError>(error: .notConnected).eraseToAnyPublisher()
        }
        
        characteristicsSubject = .init()
        
        return characteristicsSubject
            .handleEvents(receiveSubscription: { _ in
                self._peripheral._peripheral.discoverCharacteristics(identifiers.map({ $0.cbUUID }), for: self._service)
            })
            .eraseToAnyPublisher()
    }
}

extension CoreBluetoothService {
    func setService(_ service: CBService) {
        guard _service.uuid == service.uuid else {
            return
        }
        
        _service = service
    }
    
    func handleDisconnect() {
        _characteristics.forEach({
            $0.handleDisconnect()
        })
    }
    
    func handleCharacteristics(error: Error? = nil) {
        let currentCharacteristics = Set(_characteristics.map({ $0._characteristic }))
        let updatedCharacteristics = Set(_service.characteristics ?? [])
        
        let remove = currentCharacteristics.subtracting(updatedCharacteristics)
        let add = updatedCharacteristics.subtracting(currentCharacteristics)
        let update = currentCharacteristics.intersection(updatedCharacteristics)
        
        _characteristics.removeAll(where: { remove.contains($0._characteristic) })
        
        update.forEach { (characteristic) in
            if let index = _characteristics.firstIndex(where: { $0._characteristic == characteristic }) {
                _characteristics[index].setCharacteristic(characteristic)
            }
        }
        
        add.forEach { (characteristic) in
            let new = CoreBluetoothCharacteristic(service: self, characteristic: characteristic)
            Self.logger.debug("Discovered Characteristic '\(new.name)'.")
            _characteristics.append(new)
        }
        
        if let error = error {
            characteristicsSubject.send(completion: .failure(.undefinedError(error)))
        } else {
            characteristicsSubject.send(characteristics)
            characteristicsSubject.send(completion: .finished)
        }
    }
}
#endif
