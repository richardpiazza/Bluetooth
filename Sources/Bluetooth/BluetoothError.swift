import Foundation

/// Represents the errors encountered during Bluetooth interactions.
public enum BluetoothError: LocalizedError {
    /// An unknown `CBManagerState` has been encountered.
    case unknownState
    /// The CBManager state is not 'poweredOn'.
    case notPoweredOn
    /// Bluetooth is not supported on this device/platform.
    case notSupported
    /// Bluetooth permission not granted.
    case notAuthorized
    /// The scan/connection timeout has expired.
    case timeoutExpired
    /// The bluetooth device **is not** in '.connected' state.
    case notConnected
    /// The service with the specified UUID was not found.
    case serviceNotFound(_ id: BluetoothID)
    /// The service object reference has been invalidated.
    ///
    /// This occurs when a device moves to the 'disconnected' state. All services and their
    /// characteristic references are de-initialized.
    case serviceInvalidated(_ id: BluetoothID)
    /// The characteristic with the specified UUID was not found.
    case characteristicNotFound(_ id: BluetoothID)
    /// The characteristic object reference has been invalidated.
    ///
    /// This occurs when a device moves to the 'disconnected' state. All services and their
    /// characteristic references are de-initialized.
    case characteristicInvalidated(_ id: BluetoothID)
    case characteristicReadNotAvailable
    case characteristicWriteNotAvailable
    case undefinedError(_ error: Error?)

    public var isConnectionEnded: Bool {
        switch self {
        case .notConnected:
            return true
        default:
            return false
        }
    }

    public var errorDescription: String? {
        switch self {
        case .unknownState: return "Bluetooth is in an unknown state"
        case .notPoweredOn: return "Bluetooth is not powered on"
        case .notSupported: return "Bluetooth is not supported on this device/platform"
        case .notAuthorized: return "Bluetooth is not authorized for use"
        case .timeoutExpired: return "Timeout has expired"
        case .notConnected: return "The device is no longer connected"
        case .serviceNotFound(let uuid): return "The service was not found (\(uuid))"
        case .serviceInvalidated(let uuid): return "The service instance is no longer valid (\(uuid))"
        case .characteristicNotFound(let uuid): return "The characteristic was not found (\(uuid))"
        case .characteristicInvalidated(let uuid): return "The characteristic instance is no longer valid (\(uuid))"
        case .characteristicReadNotAvailable: return "Reading from the characteristic is not permitted"
        case .characteristicWriteNotAvailable: return "Writing to the characteristic is not permitted"
        case .undefinedError(.some(let error)): return "An error occurred: \(error.localizedDescription)"
        case .undefinedError(.none): return "An unknown error occurred"
        }
    }
}
