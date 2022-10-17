import Foundation
import Combine

/// Representation of a Bluetooth Characteristic.
///
/// Characteristics are items of data which relate to a particular internal state.
/// Characteristics contain various parts. They have a type, a value, some properties and some permissions.
/// Properties define what another device can do with the characteristic over Bluetooth in terms of various defined operations such as READ, WRITE or NOTIFY.
/// * Reading a characteristic means transferring its current value from the attribute table to the connected device over Bluetooth.
/// * Writing allows the connected device to change that value in the state table.
/// * Notifications are a special message type which a device can send to a connected device whenever the value of the associated characteristic changes or perhaps periodically, controlled by a timer.
///
/// Not all Characteristics support all operations. The Characteristic’s properties tell you which operations are supported.
public protocol Characteristic {
    /// The identifier for the characteristic.
    var id: BluetoothID { get }
    /// A reference to the `Service` that contains this characteristic.
    var service: Service { get }
    /// The current bytes
    var data: Data? { get }
    /// Publisher that emits the characteristics data as it changes.
    var dataPublisher: AnyPublisher<Data, Never> { get }
    /// Indicates if the characteristic is set for 'notifications'.
    var isNotifying: Bool { get }
    /// Indicates if the characteristic allows for un-prompted transmission of its value.
    var allowsSubscription: Bool { get }
    
    /// Instruct the characteristic to perform a read of its current value.
    ///
    /// - returns: A Publisher which emits the characteristics value or error.
    func read() -> AnyPublisher<Data?, BluetoothError>
    
    /// Attempts to write data to the characteristic.
    ///
    /// - parameters:
    ///   - data: The bytes to write to the characteristic
    /// - returns: A Publisher which potentially emits, but realistically relays success/failure.
    func write(data: Data) -> AnyPublisher<Any, BluetoothError>
    
    /// Instructs the characteristic to begin notifications.
    ///
    /// - returns: A Publisher which emits the new notifying state or error.
    func subscribeToChanges() -> AnyPublisher<Bool, BluetoothError>
    
    /// Instructs the characteristic to end notifications.
    ///
    /// - returns: A Publisher which emits the new notifying state or error.
    func unsubscribeFromChanges() -> AnyPublisher<Bool, BluetoothError>
}

public extension Characteristic {
    /// Generic Attribute Service Specification (if known)
    var specification: GATTSpecification? { GATTCharacteristic.specification(for: id) }
    var name: String { specification?.commonName ?? "Characteristic '\(id)'" }
}
