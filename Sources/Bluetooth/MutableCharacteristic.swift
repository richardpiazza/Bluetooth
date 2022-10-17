import Foundation
import Combine

public protocol MutableCharacteristic {
    var id: BluetoothID { get }
    var service: MutableService { get }
    var name: String { get }
    var data: Data? { get }
    var properties: CharacteristicProperties { get }
    var permissions: AttributePermissions { get }
    
    var dataPublisher: AnyPublisher<Data?, Never> { get }
    
    func read(_ offset: Int) throws -> Data?
    func write(_ data: Data?, offset: Int) throws
}

public extension MutableCharacteristic {
    /// Generic Attribute Service Specification (if known)
    var specification: GATTSpecification? { GATTCharacteristic.specification(for: id) }
    var name: String { specification?.commonName ?? "Characteristic '\(id)'" }
}
