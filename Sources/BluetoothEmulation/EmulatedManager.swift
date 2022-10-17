import Foundation
import Combine
import Harness
import Bluetooth

open class EmulatedManager: Manager {
    
    public enum AuthorizationBehavior: Codable {
        /// Transitions to an authorized/powered-on state.
        ///
        /// * `authorization` is set to `.alwaysAllowed`
        /// * `state` is set to `.poweredOn`
        case success
        /// Transitions to a denied/unauthorized state.
        ///
        /// * `authorization` is set to `.denied`
        /// * `state` is set to `.unauthorized`
        case failure
    }
    
    public struct Configuration: EnvironmentConfiguration {
        public static var environmentKey: String = "BLUETOOTH_MANAGER_CONFIGURATION"
        
        /// Initialized authorization of the emulated manager.
        public var authorization: ManagerAuthorization?
        /// Behavior when authorization requested
        public var authorizationBehavior: AuthorizationBehavior?
        /// Initialized state of the emulated manager.
        public var state: ManagerState?
        
        public init(
            authorization: ManagerAuthorization? = nil,
            authorizationBehavior: AuthorizationBehavior? = nil,
            state: ManagerState? = nil
        ) {
            self.authorization = authorization
            self.authorizationBehavior = authorizationBehavior
            self.state = state
        }
    }
    
    public let authorizationSubject: CurrentValueSubject<ManagerAuthorization, Never>
    public var authorization: ManagerAuthorization { authorizationSubject.value }
    public var authorizationPublisher: AnyPublisher<ManagerAuthorization, Never> { authorizationSubject.eraseToAnyPublisher() }
    
    public let stateSubject: CurrentValueSubject<ManagerState, Never>
    public var state: ManagerState { stateSubject.value }
    public var statePublisher: AnyPublisher<ManagerState, Never> { stateSubject.eraseToAnyPublisher() }
    
    internal var authorizationBehavior: AuthorizationBehavior
    
    public init(
        authorization: ManagerAuthorization = .notDetermined,
        authorizationBehavior: AuthorizationBehavior = .failure,
        state: ManagerState = .unknown
    ) {
        authorizationSubject = .init(authorization)
        stateSubject = .init(state)
        self.authorizationBehavior = authorizationBehavior
    }
    
    public init(configuration: Configuration) {
        authorizationSubject = .init(configuration.authorization ?? .notDetermined)
        stateSubject = .init(configuration.state ?? .unknown)
        authorizationBehavior = configuration.authorizationBehavior ?? .failure
    }
    
    public func requestAuthorization() {
        switch authorizationBehavior {
        case .success:
            guard authorization != .allowedAlways else {
                return
            }
            
            authorizationSubject.send(.allowedAlways)
            stateSubject.send(.poweredOn)
        case .failure:
            guard authorization != .denied else {
                return
            }
            
            authorizationSubject.send(.denied)
            stateSubject.send(.unauthorized)
        }
    }
}
