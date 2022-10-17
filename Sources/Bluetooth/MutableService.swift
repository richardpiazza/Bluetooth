import Foundation
import Combine

public protocol MutableService {
    var id: BluetoothID { get }
    var name: String { get }
    var characteristics: [MutableCharacteristic] { get }
}

public extension MutableService {
    /// Generic Attribute Service Specification (if known)
    var specification: GATTSpecification? { GATTService.specification(for: id) }
    var name: String { specification?.commonName ?? "Service '\(id)'" }
}
