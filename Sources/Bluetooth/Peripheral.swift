import Foundation
import Combine

/// A bluetooth peripheral (device).
public protocol Peripheral {
    /// The unique ID provided by the system for this peripheral.
    var id: BluetoothID { get }
    /// A human-readable name of the peripheral.
    var name: String { get }
    /// The current connection state of a CBPeripheral.
    var state: PeripheralState { get }
    /// A collection of metadata that is advertised.
    var advertisementData: AdvertisementData { get }
    /// A relative signal strength.
    var rssi: Int { get }
    /// Publisher that emits changes in the RSSI value.
    ///
    /// Values should be continuously sent while the subscription is maintained (or failure occurs).
    var rssiPublisher: AnyPublisher<Int, BluetoothError> { get }
    /// Indicates wether the peripheral is in a 'connected' state.
    var isConnected: Bool { get }
    /// Publisher that emits changes to the 'connected' state.
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    /// Collection of bluetooth `Service`s that have been discovered.
    var services: [Service] { get }
    
    /// Instructs the system to connect to this peripheral.
    ///
    /// - parameters:
    ///   - delay: Number of seconds to wait before attempting a connection.
    ///   - cancelPending: Cancels any pending requests for connection before scheduling a new one.
    ///   - options: Additional system options that can be provided to modify the connection request.
    /// - returns: A Publisher that emits with the 'connected' state or error.
    func connect(withDelay delay: Int, cancelPending: Bool, options: ConnectOptions?) -> AnyPublisher<Bool, BluetoothError>
    
    /// Instructs the `Peripheral` to perform a `Service` discovery.
    ///
    /// Bluetooth services must be discovered before they can be interacted with.
    ///
    /// - parameters:
    ///   - identifiers: Service identifiers for which to discover.
    /// - returns: A Publisher that emits the collection of discovered service or error.
    func discoverServices(withIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<[Service], BluetoothError>
    
    /// Instructs the system to disconnect from the peripheral.
    ///
    /// Ideally, this should not be needed, and instead a disconnection should occur automatically
    /// when the `connect()` publisher is canceled/nil.
    func disconnect()
}

public extension Peripheral {
    /// Indicates if the advertisement data promotes connection.
    var isConnectable: Bool { advertisementData.isConnectable ?? false }
    
    /// Perform a connection attempt using the default parameters.
    ///
    /// * `delay`: 0
    /// * `cancelPending`: true
    /// * `options`: nil
    func connect() -> AnyPublisher<Bool, BluetoothError> {
        return connect(withDelay: 0, cancelPending: true, options: nil)
    }
    
    @available(*, deprecated, renamed: "isConnectedPublisher")
    var connectionPublisher: AnyPublisher<Bool, Never> { isConnectedPublisher }
    
    @available(*, deprecated, renamed: "rssiPublisher")
    func readRSSI() -> AnyPublisher<Int, BluetoothError> { rssiPublisher }
}
