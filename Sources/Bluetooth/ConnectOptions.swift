import Foundation

/// System notification options for connecting to devices.
public struct ConnectOptions: OptionSet {
    public let rawValue: Int

    /// Display an alert for a given peripheral if the app is suspended when a successful connection is made.
    ///
    /// Sets `CBConnectPeripheralOptionNotifyOnConnectionKey`
    public static let notifyOnConnection = ConnectOptions(rawValue: 1 << 0)

    /// Display a disconnection alert for a given peripheral if the app is suspended at the time of the
    /// disconnection.
    ///
    /// Sets `CBConnectPeripheralOptionNotifyOnDisconnectKey`
    public static let notifyOnDisconnect = ConnectOptions(rawValue: 1 << 1)

    /// Display an alert for all notifications received from a given peripheral if the app is suspended at the time.
    ///
    /// Sets `CBConnectPeripheralOptionNotifyOnNotificationKey`
    public static let notifyOnAllEvents = ConnectOptions(rawValue: 1 << 2)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
