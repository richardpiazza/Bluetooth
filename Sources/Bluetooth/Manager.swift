import Foundation
import Combine

/// Details that are shared between all Bluetooth _managers_ (Peripheral / Central)
public protocol Manager: AnyObject {
    /// The current authorization state of a **Bluetooth** `Manager`.
    var authorization: ManagerAuthorization { get }
    /// Publisher that emits as authorization changes.
    var authorizationPublisher: AnyPublisher<ManagerAuthorization, Never> { get }
    /// The current manager state of a **Bluetooth** `Manager`.
    var state: ManagerState { get }
    /// Publisher that emits as state changes.
    var statePublisher: AnyPublisher<ManagerState, Never> { get }
    
    /// Trigger the service to request bluetooth resource access on a device.
    ///
    /// On iOS this lazily initializes a `CBCentralManager`/`CBPeripheralManager` which, if not previously authorized,
    /// will display the system prompt.
    func requestAuthorization()
}

public extension Manager {
    /// Indicates if the `authorization` is `.allowedAlways`.
    var authorized: Bool { authorization == .allowedAlways }
}

public extension Manager {
    @available(*, deprecated, renamed: "requestAuthorization")
    func initialize() {
        requestAuthorization()
    }
    
    /// Waits for the `poweredOn` state before proceeding
    func ensureHardwareReady(waitForPoweredOn: Bool = false) -> AnyPublisher<ManagerState, BluetoothError> {
        requestAuthorization()
        
        return statePublisher
            .tryFilter { state in
                switch state {
                case .poweredOff where waitForPoweredOn:
                    return false
                case .poweredOff:
                    throw BluetoothError.notPoweredOn
                default:
                    return state == .poweredOn
                }
            }
            .first()
            .mapError { $0 as! BluetoothError }
            .eraseToAnyPublisher()
    }
}
