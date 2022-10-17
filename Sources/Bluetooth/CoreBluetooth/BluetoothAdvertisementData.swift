import Foundation
#if canImport(CoreBluetooth)
import CoreBluetooth

public final class BluetoothAdvertisementData: AdvertisementData {
    /// Key: `CBAdvertisementDataLocalNameKey` (kCBAdvDataLocalName)
    ///
    /// - note: The value associated with this key is an `NSString`.
    public var localName: String?
    
    /// Key: `CBAdvertisementDataManufacturerDataKey` (kCBAdvDataManufacturerData)
    public private(set) var manufacturerData: Data?
    
    /// Key: `CBAdvertisementDataTxPowerLevelKey` (kCBAdvDataTxPowerLevel)
    ///
    /// This key and value are available if the broadcaster (peripheral) provides its Tx power level in its advertising packet.
    /// Using the RSSI value and the Tx power level, it is possible to calculate path loss.
    /// - note: The value associated with this key is an `NSNumber`.
    public private(set) var txPowerLevel: Int?
    
    /// Key: `CBAdvertisementDataIsConnectable` (kCBAdvDataIsConnectable)
    ///
    /// You can use this value to determine whether a peripheral is connectable at a particular moment.
    /// - note: The value for this key is an ` NSNumber`.
    public private(set) var isConnectable: Bool?
    
    /// Key: `CBAdvertisementDataServiceDataKey` (kCBAdvDataServiceData)
    ///
    /// The keys are CBUUID objects, representing CBService UUIDs. The values are Data objects, representing service-specific data.
    public private(set) var serviceData: [BluetoothID: Data]?
    
    /// Key: `CBAdvertisementDataServiceUUIDsKey` (kCBAdvDataServiceUUIDs)
    public var serviceUUIDs: [BluetoothID]?
    
    /// Key: `CBAdvertisementDataOverflowServiceUUIDsKey` (kCBAdvDataHashedServiceUUIDs)
    ///
    /// An array of one or more CBUUID objects, representing CBService UUIDs that were found in the “overflow”
    /// area of the advertisement data.
    public private(set) var overflowServiceUUIDs: [BluetoothID]?
    
    /// Key: `CBAdvertisementDataSolicitedServiceUUIDsKey` (kCBAdvDataSolicitedServiceUUIDs)
    public private(set) var solicitedServiceUUIDs: [BluetoothID]?
    
    public init(_ dictionary: [String: Any] = [:]) {
        merge(dictionary)
    }
    
    public var dictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CBAdvertisementDataLocalNameKey] = (localName != nil) ? localName! as NSString: nil
        dictionary[CBAdvertisementDataManufacturerDataKey] = manufacturerData
        dictionary[CBAdvertisementDataTxPowerLevelKey] = (txPowerLevel != nil) ? NSNumber(integerLiteral: txPowerLevel!) : nil
        dictionary[CBAdvertisementDataIsConnectable] = (isConnectable != nil) ? NSNumber(booleanLiteral: isConnectable!) : nil
        if let value = serviceData {
            dictionary[CBAdvertisementDataServiceDataKey] = value.reduce(into: [CBUUID: Data](), { (result, pair) in
                result[pair.key.cbUUID] = pair.value
            })
        } else {
            dictionary[CBAdvertisementDataServiceDataKey] = nil
        }
        dictionary[CBAdvertisementDataServiceUUIDsKey] = (serviceUUIDs != nil) ? serviceUUIDs!.map({ $0.cbUUID }) : nil
        dictionary[CBAdvertisementDataOverflowServiceUUIDsKey] = (overflowServiceUUIDs != nil) ? overflowServiceUUIDs!.map({ $0.cbUUID }) : nil
        dictionary[CBAdvertisementDataSolicitedServiceUUIDsKey] = (solicitedServiceUUIDs != nil) ? solicitedServiceUUIDs!.map({ $0.cbUUID }) : nil
        return dictionary
    }
    
    public func merge(_ other: [String: Any]) {
        var dictionary = self.dictionary
        dictionary.merge(other) { (_, new) -> Any in
            return new
        }
        
        localName = dictionary[CBAdvertisementDataLocalNameKey] as? String
        manufacturerData = dictionary[CBAdvertisementDataManufacturerDataKey] as? Data
        txPowerLevel = (dictionary[CBAdvertisementDataTxPowerLevelKey] as? NSNumber)?.intValue
        isConnectable = (dictionary[CBAdvertisementDataIsConnectable] as? NSNumber)?.boolValue
        if let value = dictionary[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] {
            serviceData = value.reduce(into: [BluetoothID: Data](), { (result, pair) in
                result[BluetoothID(pair.key)] = pair.value
            })
        }
        if let value = dictionary[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            serviceUUIDs = value.map({ BluetoothID($0) })
        }
        if let value = dictionary[CBAdvertisementDataOverflowServiceUUIDsKey] as? [CBUUID] {
            overflowServiceUUIDs = value.map({ BluetoothID($0) })
        }
        if let value = dictionary[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID] {
            solicitedServiceUUIDs = value.map({ BluetoothID($0) })
        }
    }
}
#endif
