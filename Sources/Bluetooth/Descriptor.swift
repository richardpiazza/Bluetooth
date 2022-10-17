import Foundation

public protocol Descriptor {
    var id: BluetoothID { get }
    var characteristic: Characteristic { get }
    var value: Any? { get }
}
