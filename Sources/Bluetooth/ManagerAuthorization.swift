import Foundation

/// Represents the current authorization state of a BluetoothManager.
///
/// A proxy of `CBManagerAuthorization`
public enum ManagerAuthorization: String, Codable {
    /// User has not yet made a choice with regards to this application.
    case notDetermined
    /// This application is not authorized to use bluetooth. The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place.
    case restricted
    /// User has explicitly denied this application from using bluetooth.
    case denied
    /// User has authorized this application to use bluetooth always.
    case allowedAlways
}

extension ManagerAuthorization: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDetermined:
            return "User has not yet made a choice with regards to this application."
        case .restricted:
            return "This application is not authorized to use bluetooth. The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place."
        case .denied:
            return "User has explicitly denied this application from using bluetooth."
        case .allowedAlways:
            return "User has authorized this application to use bluetooth always."
        }
    }
}

#if canImport(CoreBluetooth)
import CoreBluetooth

public extension ManagerAuthorization {
    init(_ authorization: CBManagerAuthorization) {
        switch authorization {
        case .allowedAlways: self = .allowedAlways
        case .denied: self = .denied
        case .restricted: self = .restricted
        case .notDetermined: self = .notDetermined
        @unknown default: self = .notDetermined
        }
    }
}
#endif
