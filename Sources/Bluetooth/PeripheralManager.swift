import Foundation
import Combine

public protocol PeripheralManager: Manager {
    var advertisementData: AdvertisementData { get set }
    var services: [MutableService] { get set }
    var isAdvertising: Bool { get }
    var isAdvertisingPublisher: AnyPublisher<Bool, Never> { get }
    
    func beginAdvertising() -> AnyPublisher<Never, BluetoothError>
}
