import Foundation
import Combine

/// A bluetooth peripheral service.
public protocol Service {
    /// The identifier for the service.
    var id: BluetoothID { get }
    /// A human-readable name of the service.
    var name: String { get }
    /// A reference to the `Peripheral` that contains the service.
    var peripheral: Peripheral { get }
    /// Collection of bluetooth `Characteristic`s that have been discovered.
    var characteristics: [Characteristic] { get }
    
    /// Instructs the `Service` to perform a `Characteristic` discovery.
    ///
    /// Bluetooth characteristics must be discovered before they can be interacted with.
    ///
    /// - parameters:
    ///   - identifiers: Characteristic identifiers for which to discover.
    /// - returns: A Publisher which emits a collection of the discovered characteristics (or error).
    func discoverCharacteristics(withIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<[Characteristic], BluetoothError>
}

public extension Service {
    /// Generic Attribute Service Specification (if known)
    var specification: GATTSpecification? { GATTService.specification(for: id) }
    var name: String { specification?.commonName ?? "Service '\(id)'" }
}
