import Foundation

/// A protocol defining the basic information of Bluetooth Generic Attributes
///
/// More information can be found at: [https://www.bluetooth.com/specifications/gatt/](https://www.bluetooth.com/specifications/gatt/)
public protocol GATTSpecification {
    var id: BluetoothID { get }
    var commonName: String { get }
    var uti: String? { get }
}

public extension GATTSpecification where Self: CaseIterable {
    init?(id: BluetoothID) {
        guard let specification = Self.allCases.first(where: { $0.id == id }) else {
            return nil
        }
        
        self = specification
    }
    
    init?(uti: String) {
        guard let specification = Self.allCases.filter({ $0.uti != nil }).first(where: { $0.uti! == uti.lowercased() }) else {
            return nil
        }
        
        self = specification
    }
    
    init?(commonName: String) {
        guard let specification = Self.allCases.first(where: { $0.commonName == commonName }) else {
            return nil
        }
        
        self = specification
    }
}

public extension GATTSpecification where Self: CaseIterable & RawRepresentable, RawValue == String {
    var id: BluetoothID { .make(from: rawValue) }
}

public extension GATTSpecification where Self: CaseIterable & RawRepresentable, RawValue == UInt16 {
    var id: BluetoothID {
        var value = rawValue.bigEndian
        let data = withUnsafePointer(to: &value) {
            Data(buffer: UnsafeBufferPointer(start: $0, count: 1))
        }
        return .make(from: data)
    }
}
