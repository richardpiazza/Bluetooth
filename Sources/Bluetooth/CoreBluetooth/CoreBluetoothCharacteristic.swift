import Foundation
import Combine
import Logging
#if canImport(CoreBluetooth)
import CoreBluetooth

public final class CoreBluetoothCharacteristic {
    
    private static let logger = Logger(label: "bluetooth.package")
    
    unowned let _service: CoreBluetoothService
    public private(set) var _characteristic: CBCharacteristic
    
    public private(set) var data: Data? {
        didSet {
            readSubject.send(data)
            if let value = data {
                dataSubject.send(value)
            }
        }
    }
    
    public private(set) var isNotifying: Bool = false
    public private(set) var _descriptor: [CoreBluetoothDescriptor] = []
    
    public var canRead: Bool { _characteristic.properties.contains(.read) }
    public var canWrite: Bool {
        _characteristic.properties.contains(.write) ||
        _characteristic.properties.contains(.writeWithoutResponse) ||
        _characteristic.properties.contains(.authenticatedSignedWrites)
    }
    
    private var dataSubject: PassthroughSubject<Data, Never> = .init()
    private var readSubject: PassthroughSubject<Data?, BluetoothError> = .init()
    private var writeSubject: PassthroughSubject<Any, BluetoothError> = .init()
    private var notifyingSubject: PassthroughSubject<Bool, BluetoothError> = .init()
    
    public init(service: CoreBluetoothService, characteristic: CBCharacteristic) {
        _service = service
        _characteristic = characteristic
    }
}

extension CoreBluetoothCharacteristic: Characteristic {
    public var id: BluetoothID { BluetoothID(_characteristic.uuid) }
    public var service: Service { _service }
    public var dataPublisher: AnyPublisher<Data, Never> { dataSubject.eraseToAnyPublisher() }
    public var allowsSubscription: Bool { _characteristic.properties.contains(.notify) || _characteristic.properties.contains(.indicate) }
    
    public func read() -> AnyPublisher<Data?, BluetoothError> {
        guard canRead else {
            return Fail<Data?, BluetoothError>(error: .characteristicReadNotAvailable).eraseToAnyPublisher()
        }

        guard _service._service.characteristics?.contains(_characteristic) == true else {
            return Fail<Data?, BluetoothError>(error: .characteristicInvalidated(id)).eraseToAnyPublisher()
        }

        guard _service._peripheral.isConnected else {
            return Fail<Data?, BluetoothError>(error: .notConnected).eraseToAnyPublisher()
        }
        
        readSubject = .init()
        
        return readSubject
            .handleEvents(receiveSubscription: { _ in
                Self.logger.debug("Reading Value for Characteristic '\(self.name)'.")
                self._service._peripheral._peripheral.readValue(for: self._characteristic)
            }, receiveOutput: { output in
                Self.logger.debug("Characteristic '\(self.name)' bytes: \(output?.count ?? 0)")
            })
            .eraseToAnyPublisher()
    }
    
    public func write(data: Data) -> AnyPublisher<Any, BluetoothError> {
        guard canWrite else {
            return Fail<Any, BluetoothError>(error: .characteristicWriteNotAvailable).eraseToAnyPublisher()
        }
        
        guard _service._service.characteristics?.contains(_characteristic) == true else {
            return Fail<Any, BluetoothError>(error: .characteristicInvalidated(id)).eraseToAnyPublisher()
        }
        
        guard _service._peripheral.isConnected else {
            return Fail<Any, BluetoothError>(error: .notConnected).eraseToAnyPublisher()
        }
        
        writeSubject = .init()
        
        return writeSubject
            .handleEvents(receiveSubscription: { _ in
                Self.logger.debug("Writing Characteristic '\(self.name)' bytes: \(data.count)")
                self._service._peripheral._peripheral.writeValue(data, for: self._characteristic, type: .withResponse)
            })
            .eraseToAnyPublisher()
    }
    
    public func subscribeToChanges() -> AnyPublisher<Bool, BluetoothError> {
        guard !_characteristic.isNotifying else {
            return Just(isNotifying).setFailureType(to: BluetoothError.self).eraseToAnyPublisher()
        }
        
        notifyingSubject = .init()
        
        return notifyingSubject
            .handleEvents(receiveSubscription: { _ in
                self._service._peripheral._peripheral.setNotifyValue(true, for: self._characteristic)
            })
            .eraseToAnyPublisher()
    }
    
    public func unsubscribeFromChanges() -> AnyPublisher<Bool, BluetoothError> {
        guard _characteristic.isNotifying else {
            return Just(isNotifying).setFailureType(to: BluetoothError.self).eraseToAnyPublisher()
        }
        
        notifyingSubject = .init()
        
        return notifyingSubject
            .handleEvents(receiveSubscription: { _ in
                self._service._peripheral._peripheral.setNotifyValue(false, for: self._characteristic)
            })
            .eraseToAnyPublisher()
    }
}

extension CoreBluetoothCharacteristic {
    func setCharacteristic(_ characteristic: CBCharacteristic) {
        guard _characteristic.uuid == characteristic.uuid else {
            return
        }
        
        _characteristic = characteristic
    }
    
    func handleDisconnect() {
        readSubject.send(completion: .failure(.notConnected))
        writeSubject.send(completion: .failure(.notConnected))
        notifyingSubject.send(completion: .failure(.notConnected))
    }
    
    func handleValueUpdate(error: Error? = nil) {
        data = _characteristic.value
        
        if let error = error {
            readSubject.send(completion: .failure(.undefinedError(error)))
        } else {
            readSubject.send(completion: .finished)
        }
    }
    
    func handleValueWrite(error: Error? = nil) {
        if let error = error {
            writeSubject.send(completion: .failure(.undefinedError(error)))
        } else {
            writeSubject.send(completion: .finished)
        }
    }
    
    func handleNotificationState(error: Error? = nil) {
        isNotifying = _characteristic.isNotifying
        notifyingSubject.send(isNotifying)
        
        if let error = error {
            notifyingSubject.send(completion: .failure(.undefinedError(error)))
        } else {
            notifyingSubject.send(completion: .finished)
        }
    }
}
#endif
