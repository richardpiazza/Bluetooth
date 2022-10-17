import Foundation
import Combine
#if canImport(CoreBluetooth)
import CoreBluetooth

public final class AdvertisedCharacteristic {
    
    unowned let _service: AdvertisedService
    var mutableCharacteristic: MutableCharacteristic
    var characteristic: CBMutableCharacteristic
    var subscribedCentrals: [CBCentral] = []
    var dataSubscription: AnyCancellable?
    
    public init(service: AdvertisedService, mutableCharacteristic: MutableCharacteristic) {
        _service = service
        self.mutableCharacteristic = mutableCharacteristic
        characteristic = CBMutableCharacteristic(
            type: mutableCharacteristic.id.cbUUID,
            properties: mutableCharacteristic.properties.characteristicProperties,
            value: mutableCharacteristic.data,
            permissions: mutableCharacteristic.permissions.attributePermissions
        )
        
        dataSubscription = mutableCharacteristic.dataPublisher
            .sink(receiveValue: { [weak self] data in
                self?.notifyCentrals(data)
            })
    }
    
    func subscribeCentral(_ central: CBCentral) {
        guard !subscribedCentrals.contains(where: { $0.identifier == central.identifier }) else {
            return
        }
        
        subscribedCentrals.append(central)
    }
    
    func unsubscribeCentral(_ central: CBCentral) {
        subscribedCentrals.removeAll(where: { $0.identifier == central.identifier })
    }
    
    private func notifyCentrals(_ data: Data?) {
        guard let value = data else {
            return
        }
        
        _service._manager.updateValue(value, for: characteristic, onSubscribedCentrals: subscribedCentrals)
    }
}

extension AdvertisedCharacteristic: CustomStringConvertible {
    public var description: String { "\(mutableCharacteristic.name) [\(mutableCharacteristic.id)]" }
}
#endif
