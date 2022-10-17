import Foundation
import Combine
import Bluetooth

open class EmulatedCharacteristic: Characteristic {
    
    public static let encoder = JSONEncoder()
    public static let decoder = JSONDecoder()
    
    public unowned var _service: EmulatedService?
    
    public var id: BluetoothID
    public var service: Service { _service ?? EmulatedService() }
    
    public let dataSubject: CurrentValueSubject<Data?, Never>
    public var data: Data? { dataSubject.value }
    public var dataPublisher: AnyPublisher<Data, Never> {
        dataSubject
            .filter { $0 != nil }
            .map { $0! }
            .eraseToAnyPublisher()
    }
    
    public var isNotifying: Bool
    public var allowsSubscription: Bool
    
    public init(
        id: BluetoothID = .init(),
        service: EmulatedService? = nil,
        data: Data? = nil,
        isNotifying: Bool = false,
        allowsSubscription: Bool = false
    ) {
        self.id = id
        _service = service
        dataSubject = .init(data)
        self.isNotifying = isNotifying
        self.allowsSubscription = allowsSubscription
    }
    
    open func read() -> AnyPublisher<Data?, BluetoothError> {
        Just(data)
            .setFailureType(to: BluetoothError.self)
            .eraseToAnyPublisher()
    }
    
    open func write(data: Data) -> AnyPublisher<Any, BluetoothError> {
        dataSubject.send(data)
        
        return Deferred { () -> AnyPublisher<Any, BluetoothError> in
            Record<Any, BluetoothError> { publisher in
                publisher.receive(completion: .finished)
            }
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    open func subscribeToChanges() -> AnyPublisher<Bool, BluetoothError> {
        defer {
            isNotifying = true
        }
        
        return Just(true)
            .setFailureType(to: BluetoothError.self)
            .eraseToAnyPublisher()
    }
    
    open func unsubscribeFromChanges() -> AnyPublisher<Bool, BluetoothError> {
        defer {
            isNotifying = false
        }
        
        return Just(false)
            .setFailureType(to: BluetoothError.self)
            .eraseToAnyPublisher()
    }
}
