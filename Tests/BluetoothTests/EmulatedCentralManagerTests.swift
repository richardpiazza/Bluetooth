import XCTest
import Combine
@testable import Bluetooth
@testable import BluetoothEmulation

/// Verify the expected behaviors of an `EmulatedCentralManager`.
final class EmulatedCentralManagerTests: XCTestCase {
    
    private let peripherals: [EmulatedPeripheral] = [
        EmulatedPeripheral(),
        EmulatedPeripheral(id: .peripheral1),
        EmulatedPeripheral(),
        EmulatedPeripheral(
            id: .peripheral2,
            services: [
                EmulatedService(id: .service1)
            ]
        ),
        EmulatedPeripheral(),
    ]
    
    private var cancelStore: [AnyCancellable] = []
    
    func testScanForPeripherals() {
        let service = EmulatedCentralManager(
            configuration: EmulatedCentralManager.Configuration(
                authorization: .allowedAlways,
                state: .poweredOn,
                scanEmitRate: 0.5
            )
        )
        service.peripherals = peripherals
        
        XCTAssertFalse(service.isScanning)
        
        var peripherals: [Peripheral] = []
        
        let scanExpectation = expectation(description: #function)
        
        service
            .scanForPeripherals(withServiceIdentifiers: [])
            .sink(receiveCompletion: { completion in
                scanExpectation.fulfill()
            }, receiveValue: { peripheral in
                peripherals.append(peripheral)
            })
            .store(in: &cancelStore)
        
        XCTAssertTrue(service.isScanning)
        wait(for: [scanExpectation], timeout: 5.0)
        XCTAssertEqual(peripherals.count, 5)
        XCTAssertFalse(service.isScanning)
    }
    
    func testPeripheralWithIdentifier() {
        let service = EmulatedCentralManager(peripherals: peripherals)
        XCTAssertNotNil(service.peripheral(withIdentifier: .peripheral1))
    }
    
    func testConnectedPeripherals() throws {
        let service = EmulatedCentralManager(peripherals: peripherals)
        let connected = service.connectedPeripherals(withServiceIdentifiers: [.service1])
        let peripheral = try XCTUnwrap(connected.first)
        XCTAssertEqual(peripheral.id, .peripheral2)
    }
}

extension BluetoothID {
    static let peripheral1 = BluetoothID(rawValue: UUID(uuidString: "E25D7781-EBDD-440D-B2DF-82321CF060C7")!)
    static let peripheral2 = BluetoothID(rawValue: UUID(uuidString: "EF89E4B6-EE7D-404B-8E35-EA99F93B7077")!)
    static let service1 = BluetoothID(rawValue: UUID(uuidString: "47F474A1-DD88-4251-8CFA-58E1C4DA1565")!)
}
