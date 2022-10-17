import Foundation
import Combine
import Bluetooth

open class EmulatedService: Service {
    
    public unowned var _peripheral: EmulatedPeripheral?
    
    public var id: BluetoothID
    public var peripheral: Peripheral { _peripheral ?? EmulatedPeripheral() }
    public var characteristics: [Characteristic]
    
    public init(
        id: BluetoothID = .init(),
        peripheral: EmulatedPeripheral? = nil,
        characteristics: [Characteristic] = []
    ) {
        self.id = id
        _peripheral = peripheral
        self.characteristics = characteristics
    }
    
    public func discoverCharacteristics(withIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<[Characteristic], BluetoothError> {
        let filtered = characteristics.filter { identifiers.contains($0.id) }
        
        return Just(filtered)
            .setFailureType(to: BluetoothError.self)
            .eraseToAnyPublisher()
    }
}
