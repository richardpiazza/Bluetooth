import Foundation
import Combine
import Bluetooth

open class EmulatedPeripheral: Peripheral {
    
    public var id: BluetoothID
    public var name: String
    public var state: PeripheralState
    public var advertisementData: AdvertisementData
    
    public let rssiSubject: CurrentValueSubject<Int, BluetoothError>
    public var rssi: Int { rssiSubject.value }
    public var rssiPublisher: AnyPublisher<Int, BluetoothError> { rssiSubject.eraseToAnyPublisher() }
    
    public let isConnectedSubject: CurrentValueSubject<Bool, Never>
    public var isConnected: Bool { isConnectedSubject.value }
    public var isConnectedPublisher: AnyPublisher<Bool, Never> { isConnectedSubject.eraseToAnyPublisher() }
    
    public var services: [Service] = []
    
    public init(
        id: BluetoothID = .init(),
        name: String = "",
        state: PeripheralState = .disconnected,
        advertisementData: AdvertisementData = BluetoothAdvertisementData(),
        rssi: Int = 0,
        isConnected: Bool = false,
        services: [Service] = []
    ) {
        self.id = id
        self.name = name
        self.state = state
        self.advertisementData = advertisementData
        self.rssiSubject = .init(rssi)
        self.isConnectedSubject = .init(isConnected)
        self.services = services
    }
    
    public func connect(withDelay delay: Int, cancelPending: Bool, options: ConnectOptions?) -> AnyPublisher<Bool, BluetoothError> {
        Just(true)
            .setFailureType(to: BluetoothError.self)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .handleEvents(receiveSubscription: { _ in
                self.isConnectedSubject.send(true)
            }, receiveCancel: {
                self.isConnectedSubject.send(false)
            })
            .eraseToAnyPublisher()
    }
    
    public func disconnect() {
        isConnectedSubject.send(false)
    }
    
    public func discoverServices(withIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<[Service], BluetoothError> {
        let filtered = services.filter { identifiers.contains($0.id) }
        
        return Just(filtered)
            .setFailureType(to: BluetoothError.self)
            .eraseToAnyPublisher()
    }
    
    public func readRSSI() -> AnyPublisher<Int, BluetoothError> {
        rssiSubject.eraseToAnyPublisher()
    }
}
