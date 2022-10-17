import Foundation

/// A representation of an identifier used to represent bluetooth entities.
public struct BluetoothID: RawRepresentable, Hashable, Codable {
    public var rawValue: UUID
    
    public init(rawValue: UUID) {
        self.rawValue = rawValue
    }
    
    public init() {
        self.rawValue = UUID()
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(UUID.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    public static func make(from: String) -> BluetoothID { .init(rawValue: makeUUID(from: from)) }
    public static func make(from: Data) -> BluetoothID { .init(rawValue: makeUUID(from: from)) }
    
    /// Constructs a 128-bit UUID from the provided string.
    ///
    /// Specify 128-bit UUIDs as a string of hexadecimal digits punctuated by hyphens, for example, 68753A44-4D6F-1226-9C60-0050E4C00067.
    /// Specify 16- or 32-bit UUIDs as a string of 4 or 8 hexadecimal digits, respectively.
    ///
    /// Bluetooth Specification Version 4.0 [Vol 3], Section 3.2.1
    static func makeUUID(from: String) -> UUID {
        switch from.count {
        // 16-bit Base UUID
        case 4: return UUID(uuidString: "0000\(from)-0000-1000-8000-00805f9b34fb")!
        // 32-bit Base UUID
        case 8: return UUID(uuidString: "\(from)-0000-1000-8000-00805f9b34fb")!
        // Full UUID
        default: return UUID(uuidString: from)!
        }
    }
    
    /// Constructs a `UUID` from the hexadecimal string representation of the provided `Data`.
    static func makeUUID(from: Data) -> UUID {
        var bytes = [UInt8](repeating: 0, count: from.count)
        from.copyBytes(to: &bytes, count: from.count)
        let hex = bytes.map { String(format: "%02x", UInt($0)) }.joined()
        
        return makeUUID(from: hex)
    }
    
    static func == (lhs: BluetoothID, rhs: UUID) -> Bool {
        return lhs.rawValue == rhs
    }
}

extension BluetoothID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = Self.makeUUID(from: value)
    }
}

extension BluetoothID: CustomStringConvertible {
    public var description: String { rawValue.uuidString }
}

#if canImport(CoreBluetooth)
import CoreBluetooth

public extension BluetoothID {
    init(_ cbUUID: CBUUID) {
        rawValue = Self.makeUUID(from: cbUUID.uuidString)
    }
    
    var cbUUID: CBUUID { CBUUID(nsuuid: rawValue) }
    
    static func == (_ lhs: BluetoothID, _ rhs: CBUUID) -> Bool {
        return lhs.rawValue.uuidString == rhs.uuidString
    }
}
#endif
