import Foundation
#if canImport(CoreBluetooth)
import CoreBluetooth

public final class AdvertisedService {
    
    unowned let _manager: CBPeripheralManager
    var mutableService: MutableService
    var service: CBMutableService
    var characteristics: [AdvertisedCharacteristic] = []
    
    public init(manager: CBPeripheralManager, mutableService: MutableService) {
        _manager = manager
        self.mutableService = mutableService
        service = CBMutableService(type: mutableService.id.cbUUID, primary: true)
        
        characteristics = mutableService.characteristics.map { AdvertisedCharacteristic(service: self, mutableCharacteristic: $0) }
        service.characteristics = characteristics.map { $0.characteristic }
    }
    
    func subscribeCentral(_ central: CBCentral, toCharacteristic characteristic: CBCharacteristic) {
        for char in characteristics {
            if char.characteristic.uuid == characteristic.uuid {
                char.subscribeCentral(central)
            }
        }
    }
    
    func unsubscribeCentral(_ central: CBCentral, fromCharacteristic characteristic: CBCharacteristic) {
        for char in characteristics {
            if char.characteristic.uuid == characteristic.uuid {
                char.unsubscribeCentral(central)
            }
        }
    }
}

extension AdvertisedService: CustomStringConvertible {
    public var description: String {
        """
        \(mutableService.name) [\(mutableService.id)]
        Characteristics [
        \(characteristics.map(\.description).joined(separator: "\n"))
        ]
        """
    }
}
#endif
