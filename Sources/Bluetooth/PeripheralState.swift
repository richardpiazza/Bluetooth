import Foundation

/// Represents the current connection state of a CBPeripheral.
public enum PeripheralState {
    case disconnected
    case connecting
    case connected
    case disconnecting
}

extension PeripheralState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        case .disconnecting: return "Disconnecting"
        }
    }
}

#if canImport(CoreBluetooth)
import CoreBluetooth

public extension PeripheralState {
    init(_ state: CBPeripheralState) {
        switch state {
        case .connected: self = .connected
        case .connecting: self = .connecting
        case .disconnecting: self = .disconnecting
        case .disconnected: self = .disconnected
        @unknown default: self = .disconnected
        }
    }
}
#endif
