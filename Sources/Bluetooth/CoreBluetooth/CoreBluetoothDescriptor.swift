import Foundation
import Combine
#if canImport(CoreBluetooth)
import CoreBluetooth

public final class CoreBluetoothDescriptor {
    unowned let _characteristic: CoreBluetoothCharacteristic
    public private(set) var descriptor: CBDescriptor
    
    public private(set) var value: Any? {
        didSet {
        }
    }
    
    public init(characteristic: CoreBluetoothCharacteristic, descriptor: CBDescriptor) {
        _characteristic = characteristic
        self.descriptor = descriptor
    }
}

extension CoreBluetoothDescriptor: Descriptor {
    public var id: BluetoothID { BluetoothID(descriptor.uuid) }
    public var characteristic: Characteristic { _characteristic }
}

extension CoreBluetoothDescriptor {
    func handleDescriptorUpdate(error: Error? = nil) {
        
    }
    
    func handleDescriptorWrite(error: Error? = nil) {
        
    }
}
#endif
