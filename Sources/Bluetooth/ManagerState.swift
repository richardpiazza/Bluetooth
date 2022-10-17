import Foundation

/// Represents the current state of a CBManager.
///
/// Proxy of `CBManagerState`
public enum ManagerState: String, Codable {
    /// State unknown, update imminent.
    case unknown
    /// The connection with the system service was momentarily lost, update imminent.
    case resetting
    /// The platform doesn't support the Bluetooth Low Energy Central/Client role.
    case unsupported
    /// The application is not authorized to use the Bluetooth Low Energy role.
    case unauthorized
    /// Bluetooth is currently powered off.
    case poweredOff
    /// Bluetooth is currently powered on and available to use.
    case poweredOn
}

extension ManagerState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "State unknown, update imminent."
        case .resetting:
            return "The connection with the system service was momentarily lost, update imminent."
        case .unsupported:
            return "The platform doesn't support the BLE Central/Client role."
        case .unauthorized:
            return "The application is not authorized to use the BLE role."
        case .poweredOff:
            return "Bluetooth is currently powered off."
        case .poweredOn:
            return "Bluetooth is currently powered on and available to use."
        }
    }
}

#if canImport(CoreBluetooth)
import CoreBluetooth

public extension ManagerState {
    init(_ state: CBManagerState) {
        switch state {
        case .poweredOn: self = .poweredOn
        case .poweredOff: self = .poweredOff
        case .unauthorized: self = .unauthorized
        case .unsupported: self = .unsupported
        case .resetting: self = .resetting
        case .unknown: self = .unknown
        @unknown default: self = .unknown
        }
    }
}
#endif
