import Foundation

public struct CharacteristicProperties: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// Permits broadcasts of the characteristic value using a characteristic configuration descriptor. Not allowed for local characteristics.
    public static let broadcast = CharacteristicProperties(rawValue: 1 << 0)
    /// Permits reads of the characteristic value.
    public static let read = CharacteristicProperties(rawValue: 1 << 1)
    /// Permits writes of the characteristic value, without a response.
    public static let writeWithoutResponse = CharacteristicProperties(rawValue: 1 << 2)
    /// Permits writes of the characteristic value.
    public static let write = CharacteristicProperties(rawValue: 1 << 3)
    /// Permits notifications of the characteristic value, without a response.
    public static let notify = CharacteristicProperties(rawValue: 1 << 4)
    /// Permits indications of the characteristic value.
    public static let indicate = CharacteristicProperties(rawValue: 1 << 5)
    /// Permits signed writes of the characteristic value
    public static let authenticatedSignedWrites = CharacteristicProperties(rawValue: 1 << 6)
    /// If set, additional characteristic properties are defined in the characteristic extended properties descriptor. Not allowed for local characteristics.
    public static let extendedProperties = CharacteristicProperties(rawValue: 1 << 7)
    /// If set, only trusted devices can enable notifications of the characteristic value.
    public static let notifyEncryptionRequired = CharacteristicProperties(rawValue: 1 << 8)
    /// If set, only trusted devices can enable indications of the characteristic value.
    public static let indicateEncryptionRequired = CharacteristicProperties(rawValue: 1 << 9)
}

extension CharacteristicProperties: CustomStringConvertible {
    public var description: String {
        var properties: [String] = []
        if contains(.broadcast) { properties.append("Broadcast") }
        if contains(.read) { properties.append("Read") }
        if contains(.writeWithoutResponse) { properties.append("Write Without Response") }
        if contains(.write) { properties.append("Write") }
        if contains(.notify) { properties.append("Notify") }
        if contains(.indicate) { properties.append("Indicate") }
        if contains(.authenticatedSignedWrites) { properties.append("Authenticated Signed Writes") }
        if contains(.extendedProperties) { properties.append("Extended Properties") }
        if contains(.notifyEncryptionRequired) { properties.append("Notify Encryption Required") }
        if contains(.indicateEncryptionRequired) { properties.append("Indicate Encryption Required") }
        
        return "Characteristic Properties [\(properties.joined(separator: ", "))]"
    }
}

extension CharacteristicProperties: CaseIterable {
    public static var allCases: [CharacteristicProperties] = [
        .broadcast, .read, .writeWithoutResponse, .write, .notify, .indicate,
        .authenticatedSignedWrites, .extendedProperties, .notifyEncryptionRequired, .indicateEncryptionRequired
    ]
}

public extension CharacteristicProperties {
    var mutableAvailable: Bool {
        contains(.broadcast) || contains(.extendedProperties)
    }
    
    var canRead: Bool {
        contains(.read)
    }
    
    var canWrite: Bool {
        (contains(.write) || contains(.writeWithoutResponse) || contains(.authenticatedSignedWrites))
    }
    
    var requiresEncryption: Bool {
        (contains(.notifyEncryptionRequired) || contains(.indicateEncryptionRequired) || contains(.authenticatedSignedWrites))
    }
}

#if canImport(CoreBluetooth)
import CoreBluetooth

public extension CharacteristicProperties {
    init(_ characteristicProperties: CBCharacteristicProperties) {
        var properties: [CharacteristicProperties] = []
        if characteristicProperties.contains(.broadcast) { properties.append(.broadcast) }
        if characteristicProperties.contains(.read) { properties.append(.read) }
        if characteristicProperties.contains(.writeWithoutResponse) { properties.append(.writeWithoutResponse) }
        if characteristicProperties.contains(.write) { properties.append(.write) }
        if characteristicProperties.contains(.notify) { properties.append(.notify) }
        if characteristicProperties.contains(.indicate) { properties.append(.indicate) }
        if characteristicProperties.contains(.authenticatedSignedWrites) { properties.append(.authenticatedSignedWrites) }
        if characteristicProperties.contains(.extendedProperties) { properties.append(.extendedProperties) }
        if characteristicProperties.contains(.notifyEncryptionRequired) { properties.append(.notifyEncryptionRequired) }
        if characteristicProperties.contains(.indicateEncryptionRequired) { properties.append(.indicateEncryptionRequired) }
        
        rawValue = CharacteristicProperties(properties).rawValue
    }
    
    var characteristicProperties: CBCharacteristicProperties {
        var properties: [CBCharacteristicProperties] = []
        if contains(.broadcast) { properties.append(.broadcast) }
        if contains(.read) { properties.append(.read) }
        if contains(.writeWithoutResponse) { properties.append(.writeWithoutResponse) }
        if contains(.write) { properties.append(.write) }
        if contains(.notify) { properties.append(.notify) }
        if contains(.indicate) { properties.append(.indicate) }
        if contains(.authenticatedSignedWrites) { properties.append(.authenticatedSignedWrites) }
        if contains(.extendedProperties) { properties.append(.extendedProperties) }
        if contains(.notifyEncryptionRequired) { properties.append(.notifyEncryptionRequired) }
        if contains(.indicateEncryptionRequired) { properties.append(.indicateEncryptionRequired) }
        
        return CBCharacteristicProperties(properties)
    }
}
#endif
