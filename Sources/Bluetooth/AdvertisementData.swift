import Foundation

public protocol AdvertisementData {
    /// The local name of a peripheral.
    var localName: String? { get set }
    /// The manufacturer data of a peripheral.
    var manufacturerData: Data? { get }
    /// A value representing the transmit power of a peripheral.
    var txPowerLevel: Int? { get }
    /// A Boolean value that indicates whether the advertising event type is connectable.
    var isConnectable: Bool? { get }
    /// A dictionary containing service-specific advertisement data.
    var serviceData: [BluetoothID: Data]? { get }
    /// Service UUIDs.
    var serviceUUIDs: [BluetoothID]? { get set }
    /// An array of one or more CBUUID objects, representing CBService UUIDs that were found in the “overflow” area of the advertisement data.
    var overflowServiceUUIDs: [BluetoothID]? { get }
    /// An array of one or more CBUUID objects, representing CBService UUIDs.
    var solicitedServiceUUIDs: [BluetoothID]? { get }
    
    var dictionary: [String: Any] { get }
}
