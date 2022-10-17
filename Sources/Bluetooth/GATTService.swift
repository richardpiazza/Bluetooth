import Foundation

/// GATT Services
///
/// A collection of characteristics and relationships to other services that encapsulate the behavior of part of a device.
///
/// [https://www.bluetooth.com/specifications/gatt/services/](https://www.bluetooth.com/specifications/gatt/services/)
public enum GATTService: UInt16, CaseIterable, GATTSpecification {
    
    public struct Custom: GATTSpecification {
        public var id: BluetoothID
        public var commonName: String
        public var uti: String?
        
        public init(id: BluetoothID, name: String, uti: String? = nil) {
            self.id = id
            self.commonName = name
            self.uti = uti
        }
    }
    
    private static var _customRegistry: [Custom] = [
        Custom(id: "D0611E78-BBB4-4591-A5F8-487910AE4366", name: " Continuity"),
        Custom(id: "9fa480e0-4967-4542-9390-d343dc5d04ae", name: " Nearby"),
        Custom(id: "7905f431-b5ce-4e99-a40f-4b1e122d00d0", name: " Notification Center Service"),
        Custom(id: "89d3502b-0f36-433a-8ef4-c502ad55f8dc", name: " Media Service"),
    ]
    
    public static var customRegistry: [Custom] {
        return _customRegistry
    }
    
    public static func registerCustom(_ custom: Custom) {
        guard !_customRegistry.contains(where: { $0.id == custom.id }) else {
            return
        }
        
        _customRegistry.append(custom)
    }
    
    public static func deregisterCustom(_ custom: Custom) {
        _customRegistry.removeAll(where: { $0.id == custom.id })
    }
    
    public static func specification(for id: BluetoothID) -> GATTSpecification? {
        if let gattService = GATTService(id: id) {
            return gattService
        }
        
        if let customService = customRegistry.first(where: { $0.id == id }) {
            return customService
        }
        
        return nil
    }
    
    public static var allServices: [GATTSpecification] {
        return _customRegistry + allCases
    }
    
    case generic = 0x1800
    case alertNotification = 0x1811
    case automationIO = 0x1815
    case battery = 0x180F
    case binarySensor = 0x183B
    case bloodPressure = 0x1810
    case bodyComposition = 0x181B
    case bondManagement = 0x181E
    case continuousGlucoseMonitoring = 0x181F
    case currentTime = 0x1805
    case cyclingPower = 0x1818
    case cyclingSpeedAndCadence = 0x1816
    case deviceInformation = 0x180A
    case emergencyConfiguration = 0x183C
    case environmentalSensing = 0x181A
    case fitnessMachine = 0x1826
    case genericAttribute = 0x1801
    case glucose = 0x1808
    case healthThermometer = 0x1809
    case heartRate = 0x180D
    case httpProxy = 0x1823
    case humanInterfaceDevice = 0x1812
    case immediateAlert = 0x1802
    case indoorPositioning = 0x1821
    case insulinDelivery = 0x183A
    case internetProtocolSupport = 0x1820
    case linkLoss = 0x1803
    case locationAndNavigation = 0x1819
    case meshProvisioning = 0x1827
    case meshProxy = 0x1828
    case nextDSTChange = 0x1807
    case objectTransfer = 0x1825
    case phoneAlertStatus = 0x180E
    case pulseOximeter = 0x1822
    case reconnectionConfiguration = 0x1829
    case referenceTimeUpdate = 0x1806
    case runningSpeedAndCadence = 0x1814
    case scanParameters = 0x1813
    case transportDiscovery = 0x1824
    case txPower = 0x1804
    case userData = 0x181C
    case weightScale = 0x181D
    
    public var commonName: String {
        switch self {
        case.generic: return "Generic Access"
        case .alertNotification: return "Alert Notification"
        case .automationIO: return "Automation IO"
        case .battery: return "Battery"
        case .binarySensor: return "Binary Sensor"
        case .bloodPressure: return "Blood Pressure"
        case .bodyComposition: return "Body Composition"
        case .bondManagement: return "Bond Management"
        case .continuousGlucoseMonitoring: return "Continuous Glucose Monitoring"
        case .currentTime: return "Current Time"
        case .cyclingPower: return "Cycling Power"
        case .cyclingSpeedAndCadence: return "Cycling Speed and Cadence"
        case .deviceInformation: return "Device Information"
        case .emergencyConfiguration: return "Emergency Configuration"
        case .environmentalSensing: return "Environmental Sensing"
        case .fitnessMachine: return "Fitness Machine"
        case .genericAttribute: return "Generic Attribute"
        case .glucose: return "Glucose"
        case .healthThermometer: return "Health Thermometer"
        case .heartRate: return "Heart Rate"
        case .httpProxy: return "HTTP Proxy"
        case .humanInterfaceDevice: return "Human Interface Device"
        case .immediateAlert: return "Immediate Alert"
        case .indoorPositioning: return "Indoor Positioning"
        case .insulinDelivery: return "Insulin Delivery"
        case .internetProtocolSupport: return "Internet Protocol Support"
        case .linkLoss: return "Link Loss"
        case .locationAndNavigation: return "Location and Navigation"
        case .meshProvisioning: return "Mesh Provisioning"
        case .meshProxy: return "Mash Proxy"
        case .nextDSTChange: return "Next DST Change"
        case .objectTransfer: return "Object Transfer"
        case .phoneAlertStatus: return "Phone Alert Status"
        case .pulseOximeter: return "Pulse Oximeter"
        case .reconnectionConfiguration: return "Reconnection Configuration"
        case .referenceTimeUpdate: return "Reference Time Update"
        case .runningSpeedAndCadence: return "Running Speed and Cadence"
        case .scanParameters: return "Scan Parameters"
        case .transportDiscovery: return "Transport Discovery"
        case .txPower: return "Tx Power"
        case .userData: return "User Data"
        case .weightScale: return "Weight Scale"
        }
    }
    
    public var uti: String? {
        switch self {
        case .generic: return "org.BluetoothService.generic_access"
        case .alertNotification: return "org.BluetoothService.alert_notification"
        case .automationIO: return "org.BluetoothService.automation_io"
        case .battery: return "org.BluetoothService.battery_service"
        case .binarySensor: return "org.BluetoothService.binary_sensor"
        case .bloodPressure: return "org.BluetoothService.blood_pressure"
        case .bodyComposition: return "org.BluetoothService.body_composition"
        case .bondManagement: return "org.BluetoothService.bond_management"
        case .continuousGlucoseMonitoring: return "org.BluetoothService.continuous_glucose_monitoring"
        case .currentTime: return "org.BluetoothService.current_time"
        case .cyclingPower: return "org.BluetoothService.cycling_power"
        case .cyclingSpeedAndCadence: return "org.BluetoothService.cycling_speed_and_cadence"
        case .deviceInformation: return "org.BluetoothService.device_information"
        case .environmentalSensing: return "org.BluetoothService.environmental_sensing"
        case .fitnessMachine: return "org.BluetoothService.fitness_machine"
        case .genericAttribute: return "org.BluetoothService.generic_attribute"
        case .glucose: return "org.BluetoothService.glucose"
        case .healthThermometer: return "org.BluetoothService.health_thermometer"
        case .heartRate: return "org.BluetoothService.heart_rate"
        case .httpProxy: return "org.BluetoothService.http_proxy"
        case .humanInterfaceDevice: return "org.BluetoothService.human_interface_device"
        case .immediateAlert: return "org.BluetoothService.immediate_alert"
        case .indoorPositioning: return "org.BluetoothService.indoor_positioning"
        case .insulinDelivery: return "org.BluetoothService.insulin_delivery"
        case .internetProtocolSupport: return "org.BluetoothService.internet_protocol_support"
        case .linkLoss: return "org.BluetoothService.link_loss"
        case .locationAndNavigation: return "org.BluetoothService.location_and_navigation"
        case .meshProvisioning: return "org.BluetoothService.mesh_provisioning"
        case .meshProxy: return "org.BluetoothService.mesh_proxy"
        case .nextDSTChange: return "org.BluetoothService.next_dst_change"
        case .objectTransfer: return "org.BluetoothService.object_transfer"
        case .phoneAlertStatus: return "org.BluetoothService.phone_alert_status"
        case .pulseOximeter: return "org.BluetoothService.pulse_oximeter"
        case .reconnectionConfiguration: return "org.BluetoothService.reconnection_configuration"
        case .referenceTimeUpdate: return "org.BluetoothService.reference_time_update"
        case .runningSpeedAndCadence: return "org.BluetoothService.running_speed_and_cadence"
        case .scanParameters: return "org.BluetoothService.scan_parameters"
        case .transportDiscovery: return "org.BluetoothService.transport_discovery"
        case .txPower: return "org.BluetoothService.tx_power"
        case .userData: return "org.BluetoothService.user_data"
        case .weightScale: return "org.BluetoothService.weight_scale"
        default: return nil
        }
    }
}
