import Foundation
import Combine

/// Extended details and functionality applied to managers in the **Central** role.
public protocol CentralManager: Manager {
    /// The current indication if a bluetooth scan for peripherals is in progress.
    var isScanning: Bool { get }
    /// Publisher that emits changes to the scanning status.
    var isScanningPublisher: AnyPublisher<Bool, Never> { get }
    /// Collection of _discovered_ peripherals.
    var peripherals: [Peripheral] { get }
    
    /// Instructs the manager to begin a scan for peripherals.
    ///
    /// A scan will be maintained as long as the subscription is valid.
    /// Each new subscription will:
    /// * Terminate any previous scan
    /// * Remove any discovered peripherals
    ///
    /// - parameters:
    ///   - identifiers: `Service` ids used to limit the results. Can be empty.
    /// - returns: A publisher which will emit single `Peripheral`s as they are discovered.
    func scanForPeripherals(withServiceIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<Peripheral, BluetoothError>
    
    /// Retrieve a `Peripheral` reference using a `BluetoothID`.
    ///
    /// - returns: A peripheral that is either currently discovered or previously known.
    func peripheral(withIdentifier identifier: BluetoothID) -> Peripheral?
    
    /// Retrieve currently connected (_discovered_) peripherals whose services match the provided identifiers.
    ///
    /// - parameters:
    ///   - identifiers: `Service` ids for which the peripherals must match.
    /// - returns: A collection of `Peripheral` in a connected state.
    func connectedPeripherals(withServiceIdentifiers identifiers: [BluetoothID]) -> [Peripheral]
}
