import Foundation
import Combine
import Harness
import Bluetooth

open class EmulatedCentralManager: EmulatedManager, CentralManager {
    
    public struct Configuration: EnvironmentConfiguration {
        public static let environmentKey = "BLUETOOTH_CENTRAL_MANAGER_CONFIGURATION"
        
        /// Initialized authorization of the emulated manager.
        public var authorization: ManagerAuthorization?
        /// Behavior when authorization requested
        public var authorizationBehavior: AuthorizationBehavior?
        /// Initialized state of the emulated manager.
        public var state: ManagerState?
        /// Rate at which peripherals are discovered and emitted.
        public var scanEmitRate: TimeInterval?
        
        public init(
            authorization: ManagerAuthorization? = nil,
            authorizationBehavior: AuthorizationBehavior? = nil,
            state: ManagerState? = nil,
            scanEmitRate: TimeInterval? = nil
        ) {
            self.authorization = authorization
            self.authorizationBehavior = authorizationBehavior
            self.state = state
            self.scanEmitRate = scanEmitRate
        }
    }
    
    public let isScanningSubject: CurrentValueSubject<Bool, Never> = .init(false)
    public var isScanning: Bool { isScanningSubject.value }
    public var isScanningPublisher: AnyPublisher<Bool, Never> { isScanningSubject.eraseToAnyPublisher() }
    
    public var peripherals: [Peripheral]
    
    internal var scanEmitRate: TimeInterval
    
    public init(
        authorization: ManagerAuthorization = .notDetermined,
        authorizationBehavior: AuthorizationBehavior = .failure,
        state: ManagerState = .unknown,
        peripherals: [Peripheral] = []
    ) {
        self.peripherals = peripherals
        scanEmitRate = 2.0
        super.init(authorization: authorization, authorizationBehavior: authorizationBehavior, state: state)
    }
    
    public init(configuration: Configuration) {
        self.peripherals = []
        scanEmitRate = configuration.scanEmitRate ?? 2.0
        super.init(configuration:
            EmulatedManager.Configuration(
                authorization: configuration.authorization,
                authorizationBehavior: configuration.authorizationBehavior,
                state: configuration.state
            )
        )
    }
    
    // Emit a peripheral every x seconds (https://stackoverflow.com/a/61212823/3639846)
    public func scanForPeripherals(withServiceIdentifiers identifiers: [BluetoothID]) -> AnyPublisher<Peripheral, BluetoothError> {
        Timer.publish(every: scanEmitRate, on: .main, in: .default).autoconnect()
            .zip(peripherals.publisher)
            .map { $0.1 }
            .setFailureType(to: BluetoothError.self)
            .handleEvents(receiveSubscription: { _ in
                self.isScanningSubject.send(true)
            }, receiveCompletion: { _ in
                self.isScanningSubject.send(false)
            }, receiveCancel: {
                self.isScanningSubject.send(false)
            })
            .eraseToAnyPublisher()
    }
    
    public func peripheral(withIdentifier identifier: BluetoothID) -> Peripheral? {
        peripherals.first(where: { $0.id == identifier })
    }
    
    public func connectedPeripherals(withServiceIdentifiers identifiers: [BluetoothID]) -> [Peripheral] {
        peripherals.filter { peripheral in
            !peripheral.services.filter({ identifiers.contains($0.id) }).isEmpty
        }
    }
}
