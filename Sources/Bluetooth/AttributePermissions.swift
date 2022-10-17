import Foundation

public struct AttributePermissions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// Read-only.
    public static let readable = AttributePermissions(rawValue: 1 << 0)
    /// Write-only.
    public static let writeable = AttributePermissions(rawValue: 1 << 1)
    /// Readable by trusted devices.
    public static let readEncryptionRequired = AttributePermissions(rawValue: 1 << 2)
    /// Writeable by trusted devices.
    public static let writeEncryptionRequired = AttributePermissions(rawValue: 1 << 3)
}

extension AttributePermissions: CustomStringConvertible {
    public var description: String {
        var permissions: [String] = []
        if contains(.readable) {
            permissions.append("Readable")
        }
        if contains(.writeable) {
            permissions.append("Writeable")
        }
        if contains(.readEncryptionRequired) {
            permissions.append("Read Encryption Required")
        }
        if contains(.writeEncryptionRequired) {
            permissions.append("Write Encryption Required")
        }
        return "Attribute Permissions [\(permissions.joined(separator: ", "))]"
    }
}

extension AttributePermissions: CaseIterable {
    public static var allCases: [AttributePermissions] = [
        .readable, .writeable, .readEncryptionRequired, .writeEncryptionRequired
    ]
}

#if canImport(CoreBluetooth)
import CoreBluetooth

public extension AttributePermissions {
    init(_ attributePermissions: CBAttributePermissions) {
        var permissions: [AttributePermissions] = []
        if attributePermissions.contains(.readable) { permissions.append(.readable) }
        if attributePermissions.contains(.writeable) { permissions.append(.writeable) }
        if attributePermissions.contains(.readEncryptionRequired) { permissions.append(.readEncryptionRequired) }
        if attributePermissions.contains(.writeEncryptionRequired) { permissions.append(.writeEncryptionRequired) }
        
        rawValue = AttributePermissions(permissions).rawValue
    }
    
    var attributePermissions: CBAttributePermissions {
        var permissions: [CBAttributePermissions] = []
        if contains(.readable) { permissions.append(.readable) }
        if contains(.writeable) { permissions.append(.writeable) }
        if contains(.readEncryptionRequired) { permissions.append(.readEncryptionRequired) }
        if contains(.writeEncryptionRequired) { permissions.append(.writeEncryptionRequired) }
        
        return CBAttributePermissions(permissions)
    }
}
#endif
