import XCTest
@testable import Bluetooth
@testable import BluetoothEmulation

/// Verify the expected behaviors of an `EmulatedManager`.
final class EmulatedManagerTests: XCTestCase {
    
    func testRequestAuthorizationSuccess() {
        let manager = EmulatedManager(
            configuration: EmulatedManager.Configuration(
                authorizationBehavior: .success
            )
        )
        
        assertNeutralState(manager)
        manager.requestAuthorization()
        assertAuthorized(manager)
    }
    
    func testRequestAuthorizationFailure() {
        let manager = EmulatedManager(
            configuration: EmulatedManager.Configuration(
                authorizationBehavior: .failure
            )
        )
        
        assertNeutralState(manager)
        manager.requestAuthorization()
        assertDenied(manager)
    }
    
    private func assertNeutralState(_ manager: EmulatedManager) {
        XCTAssertEqual(manager.authorization, .notDetermined)
        XCTAssertEqual(manager.state, .unknown)
    }
    
    private func assertAuthorized(_ manager: EmulatedManager) {
        XCTAssertEqual(manager.authorization, .allowedAlways)
        XCTAssertEqual(manager.state, .poweredOn)
    }
    
    private func assertDenied(_ manager: EmulatedManager) {
        XCTAssertEqual(manager.authorization, .denied)
        XCTAssertEqual(manager.state, .unauthorized)
    }
}
