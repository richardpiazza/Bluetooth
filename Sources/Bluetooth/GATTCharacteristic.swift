import Foundation

/// GATT Characteristics
///
/// Defined characteristic attribute types as declared in the GATT Specifications.
///
/// [https://www.bluetooth.com/specifications/gatt/characteristics/](https://www.bluetooth.com/specifications/gatt/characteristics/)
public enum GATTCharacteristic: UInt16, CaseIterable, GATTSpecification {
    
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
        Custom(id: "8667556c-9a37-4c91-84ed-54ee27d90049", name: " Continuity (Characteristic)"),
        Custom(id: "af0badb1-5b99-43cd-917a-a77bc549e3cc", name: " Nearby (Characteristic)"),
        Custom(id: "69d1d8f3-45e1-49a8-9821-9bbdfdaad9d9", name: " NCS Control Point"),
        Custom(id: "9fbf120d-6301-42d9-8c58-25e699a21dbd", name: " NCS Notification Source"),
        Custom(id: "22eac6e9-24d6-4bb5-be44-b36ace7c7bfb", name: " NCS Data Source"),
        Custom(id: "9b3c81d8-57b1-4a8a-b8df-0e56f7ca51c2", name: " MS Remote Command"),
        Custom(id: "2f7cabce-808d-411f-9a0c-bb92ba96c102", name: " MS Entity Update"),
        Custom(id: "c6b2f38c-23ab-46d8-a6ab-a3a870bbd5d7", name: " MS Entity Attribute"),
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
        if let gattService = GATTCharacteristic(id: id) {
            return gattService
        }
        
        if let customService = customRegistry.first(where: { $0.id == id }) {
            return customService
        }
        
        return nil
    }
    
    public static var allCharacteristics: [GATTSpecification] {
        return _customRegistry + allCases
    }
    
    case aerobicHeartRateLowerLimit = 0x2A7E
    case aerobicHeartRateUpperLimit = 0x2A84
    case aerobicThreshold = 0x2A7F
    case age = 0x2A80
    case aggregate = 0x2A5A
    case alertCategoryID = 0x2A43
    case alertCategoryIDBitMask = 0x2A42
    case alertLevel = 0x2A06
    case alertNotificationControlPoint = 0x2A44
    case alertStatus = 0x2A3F
    case altitude = 0x2AB3
    case anaerobicHeartRateLowerLimit = 0x2A81
    case anaerobicHeartRateUpperLimit = 0x2A82
    case anaerobicThreshold = 0x2A83
    case analog = 0x2A58
    case analogOutput = 0x2A59
    case apparentWindDirection = 0x2A73
    case apparentWindSpeed = 0x2A72
    case appearance = 0x2A01
    case barometricPressureTrend = 0x2AA3
    case batteryLevel = 0x2A19
    case batteryLevelState = 0x2A1B
    case batteryPowerState = 0x2A1A
    case bloodPressureFeature = 0x2A49
    case bloodPressureMeasurement = 0x2A35
    case bodyCompositionFeature = 0x2A9B
    case bodyCompositionMeasurement = 0x2A9C
    case bodySensorLocation = 0x2A38
    case bondManagementControlPoint = 0x2AA4
    case bondManagementFeatures = 0x2AA5
    case bootKeyboardInputReport = 0x2A22
    case bootKeyboardOutputReport = 0x2A32
    case bootMouseInputReport = 0x2A33
    case bssControlPoint = 0x2B2B
    case bssResponse = 0x2B2C
    case centralAddressResolution = 0x2AA6
    case cgmFeature = 0x2AA8
    case cgmMeasurement = 0x2AA7
    case cgmSessionRunTime = 0x2AAB
    case cgmSessionStartTime = 0x2AAA
    case cgmSpecificOpsControlPoint = 0x2AAC
    case cgmStatus = 0x2AA9
    case clientSupportedFeatures = 0x2B29
    case crossTrainerData = 0x2ACE
    case cscFeature = 0x2A5C
    case cscMeasurement = 0x2A5B
    case currentTime = 0x2A2B
    case cyclingPowerControlPoint = 0x2A66
    case cyclingPowerFeature = 0x2A65
    case cyclingPowerMeasurement = 0x2A63
    case cyclingPowerVector = 0x2A64
    case databaseChangeIncrement = 0x2A99
    case databaseHash = 0x2B2A
    case dateOfBirth = 0x2A85
    case dateOfThresholdAssessment = 0x2A86
    case dateTime = 0x2A08
    case dateUTC = 0x2AED
    case dayDateTime = 0x2A0A
    case dayOfWeek = 0x2A09
    case descriptorValueChanged = 0x2A7D
    case deviceName = 0x2A00
    case dewPoint = 0x2A7B
    case digital = 0x2A56
    case digitalOutput = 0x2A57
    case dstOffset = 0x2A0D
    case elevation = 0x2A6C
    case emailAddress = 0x2A87
    case emergencyID = 0x2B2D
    case emergencyText = 0x2B2E
    case exactTime100 = 0x2A0B
    case exactTime256 = 0x2A0C
    case fatBurnHeartRateLowerLimit = 0x2A88
    case fatBurnHeartRateUpperLimit = 0x2A89
    case firmwareRevision = 0x2A26
    case firstName = 0x2A8A
    case fitnessMachineControlPoint = 0x2AD9
    case fitnessMachineFeature = 0x2ACC
    case fitnessMachineStatus = 0x2ADA
    case fiveZoneHeartRateLimits = 0x2A8B
    case floorNumber = 0x2AB2
    case gender = 0x2A8C
    case glucoseFeature = 0x2A51
    case glucoseMeasurement = 0x2A18
    case glucoseMeasurementContext = 0x2A34
    case gustFactor = 0x2A74
    case hardwareRevision = 0x2A27
    case heartRateControlPoint = 0x2A39
    case heartRateMax = 0x2A8D
    case heartRateMeasurement = 0x2A37
    case heatIndex = 0x2A7A
    case height = 0x2A8E
    case hidControlPoint = 0x2A4C
    case hidInformation = 0x2A4A
    case hipCircumference = 0x2A8F
    case httpControlPoint = 0x2ABA
    case httpEntityBody = 0x2AB9
    case httpHeaders = 0x2AB7
    case httpStatusCode = 0x2AB8
    case httpsSecurity = 0x2ABB
    case humidity = 0x2A6F
    case iddAnnunciationStatus = 0x2B22
    case iddCommandControlPoint = 0x2B25
    case iddCommandData = 0x2B26
    case iddFeatures = 0x2B23
    case iddHistoryData = 0x2B28
    case iddRecordAccessControlPoint = 0x2B27
    case iddStatus = 0x2B21
    case iddStatusChanged = 0x2B20
    case iddStatusReaderControlPoint = 0x2B24
    case iEEE11073_20601RegulatoryCertificationDataList = 0x2A2A
    case indoorBikeData = 0x2AD2
    case indoorPositioningConfiguration = 0x2AAD
    case intermediateCuffPressure = 0x2A36
    case intermediateTemperature = 0x2A1E
    case irradiance = 0x2A77
    case language = 0x2AA2
    case lastName = 0x2A90
    case latitude = 0x2AAE
    case lnControlPoint = 0x2A6B
    case lnFeature = 0x2A6A
    case localEastCoordinate = 0x2AB1
    case localNorthCoordinate = 0x2AB0
    case localTime = 0x2A0F
    case locationAndSpeedCharacteristic = 0x2A67
    case locationName = 0x2AB5
    case longitude = 0x2AAF
    case magneticDeclination = 0x2A2C
    case magneticFluxDensity2D = 0x2AA0
    case magneticFluxDensity3D = 0x2AA1
    case manufacturerName = 0x2A29
    case maximumRecommendedHeartRate = 0x2A91
    case measurementInterval = 0x2A21
    case modelNumber = 0x2A24
    case navigation = 0x2A68
    case networkAvailability = 0x2A3E
    case newAlert = 0x2A46
    case objectActionControlPoint = 0x2AC5
    case objectChanged = 0x2AC8
    case objectFirstCreated = 0x2AC1
    case objectID = 0x2AC3
    case objectLastModified = 0x2AC2
    case objectListControlPoint = 0x2AC6
    case objectListFilter = 0x2AC7
    case objectName = 0x2ABE
    case objectProperties = 0x2AC4
    case objectSize = 0x2AC0
    case objectType = 0x2ABF
    case otsFeature = 0x2ABD
    case peripheralPreferredConnectionParameters = 0x2A04
    case peripheralPrivacyFlag = 0x2A02
    case plxContinuousMeasurementCharacteristic = 0x2A5F
    case plxFeatures = 0x2A60
    case plxSpotCheckMeasurement = 0x2A5E
    case pnpID = 0x2A50
    case pollenConcentration = 0x2A75
    case position2D = 0x2A2F
    case position3D = 0x2A30
    case positionQuality = 0x2A69
    case pressure = 0x2A6D
    case protocolMode = 0x2A4E
    case pulseOximetryControlPoint = 0x2A62
    case rainfall = 0x2A78
    case rcFeature = 0x2B1D
    case rcSettings = 0x2B1E
    case reconnectionAddress = 0x2A03
    case reconnectionConfigurationControlPoint = 0x2B1F
    case recordAccessControlPoint = 0x2A52
    case referenceTimeInformation = 0x2A14
    case registeredUserCharacteristic = 0x2B37
    case removable = 0x2A3A
    case report = 0x2A4D
    case reportMap = 0x2A4B
    case resolvablePrivateAddressOnly = 0x2AC9
    case restingHeartRate = 0x2A92
    case ringerControlPoint = 0x2A40
    case ringerSetting = 0x2A41
    case rowerData = 0x2AD1
    case rcsFeature = 0x2A54
    case rcsMeasurement = 0x2A53
    case scControlPoint = 0x2A55
    case scanIntervalWindow = 0x2A4F
    case scanRefresh = 0x2A31
    case scientificTemperatureCelsius = 0x2A3C
    case secondaryTimeZone = 0x2A10
    case sensorLocation = 0x2A5D
    case serialNumber = 0x2A25
    case serverSupportedFeatures = 0x2B3A
    case serviceChanged = 0x2A05
    case serviceRequired = 0x2A3B
    case softwareRevision = 0x2A28
    case sportTypeForAerobicAndAnaerobicThresholds = 0x2A93
    case stairClimberData = 0x2AD0
    case stepClimberData = 0x2ACF
    case string = 0x2A3D
    case supportedHeartRateRange = 0x2AD7
    case supportedInclinationRange = 0x2AD5
    case supportedNewAlertCategory = 0x2A47
    case supportedPowerRange = 0x2AD8
    case supportedResistanceLevelRange = 0x2AD6
    case supportedSpeedRange = 0x2AD4
    case supportedUnreadAlertCategory = 0x2A48
    case systemID = 0x2A23
    case tdsControlPoint = 0x2ABC
    case temperature = 0x2A6E
    case temperatureCelsius = 0x2A1F
    case temperatureFahrenheit = 0x2A20
    case temperatureMeasurement = 0x2A1C
    case temperatureType = 0x2A1D
    case threeZoneHeartRateLimits = 0x2A94
    case timeAccuracy = 0x2A12
    case timeBroadcast = 0x2A15
    case timeSource = 0x2A13
    case timeUpdateControlPoint = 0x2A16
    case timeUpdateState = 0x2A17
    case timeWithDST = 0x2A11
    case timeZone = 0x2A0E
    case trainingStatus = 0x2AD3
    case treadmillData = 0x2ACD
    case trueWindDirection = 0x2A71
    case trueWindSpeed = 0x2A70
    case twoZoneHeartRateLimit = 0x2A95
    case txPowerLevel = 0x2A07
    case uncertainty = 0x2AB4
    case unreadAlertStatus = 0x2A45
    case uri = 0x2AB6
    case userControlPoint = 0x2A9F
    case userIndex = 0x2A9A
    case uvIndex = 0x2A76
    case vo2Max = 0x2A96
    case waistCircumference = 0x2A97
    case weight = 0x2A98
    case weightMeasurement = 0x2A9D
    case weightScaleFeature = 0x2A9E
    case windChill = 0x2A79
    
    public var commonName: String {
        switch self {
        case .aerobicHeartRateLowerLimit: return "Aerobic Heart Rate Lower Limit"
        case .aerobicHeartRateUpperLimit: return "Aerobic Heart Rate Upper Limit"
        case .aerobicThreshold: return "Aerobic Threshold"
        case .age: return "Age"
        case .aggregate: return "Aggregate"
        case .alertCategoryID: return "Alert Category ID"
        case .alertCategoryIDBitMask: return "Alert Category ID Bit Mask"
        case .alertLevel: return "Alert Level"
        case .alertNotificationControlPoint: return "Alert Notification Control Point"
        case .alertStatus: return "Alert Status"
        case .altitude: return "Altitude"
        case .anaerobicHeartRateLowerLimit: return "Anaerobic Heart Rate Lower Limit"
        case .anaerobicHeartRateUpperLimit: return "Anaerobic Heart Rate Upper Limit"
        case .anaerobicThreshold: return "Anaerobic Threshold"
        case .analog: return "Analog"
        case .analogOutput: return "Analog Output"
        case .apparentWindDirection: return "Apparent Wind Direction"
        case .apparentWindSpeed: return "Apparent Wind Speed"
        case .appearance: return "Appearance"
        case .barometricPressureTrend: return "Barometric Pressure Trend"
        case .batteryLevel: return "Battery Level"
        case .batteryLevelState: return "Battery Level State"
        case .batteryPowerState: return "Battery Power State"
        case .bloodPressureFeature: return "Blood Pressure Feature"
        case .bloodPressureMeasurement: return "Blood Pressure Measurement"
        case .bodyCompositionFeature: return "Body Composition Feature"
        case .bodyCompositionMeasurement: return "Body Composition Measurement"
        case .bodySensorLocation: return "Body Sensor Location"
        case .bondManagementControlPoint: return "Bond Management Control Point"
        case .bondManagementFeatures: return "Bond Management Features"
        case .bootKeyboardInputReport: return "Boot Keyboard Input Report"
        case .bootKeyboardOutputReport: return "Boot Keyboard Output Report"
        case .bootMouseInputReport: return "Boot Mouse Input Report"
        case .bssControlPoint: return "BSS Control Point"
        case .bssResponse: return "BSS Response"
        case .centralAddressResolution: return "Central Address Resolution"
        case .cgmFeature: return "CGM Feature"
        case .cgmMeasurement: return "CGM Measurement"
        case .cgmSessionRunTime: return "CGM Session Run Time"
        case .cgmSessionStartTime: return "CGM Session Start Time"
        case .cgmSpecificOpsControlPoint: return "CGM Specific Ops Control Point"
        case .cgmStatus: return "CGM Status"
        case .clientSupportedFeatures: return "Client Supported Features"
        case .crossTrainerData: return "Cross Trainer Data"
        case .cscFeature: return "CSC Feature"
        case .cscMeasurement: return "CSC Measurement"
        case .currentTime: return "Current Time"
        case .cyclingPowerControlPoint: return "Cycling Power Control Point"
        case .cyclingPowerFeature: return "Cycling Power Feature"
        case .cyclingPowerMeasurement: return "Cycling Power Measurement"
        case .cyclingPowerVector: return "Cycling Power Vector"
        case .databaseChangeIncrement: return "Database Change Increment"
        case .databaseHash: return "Database Hash"
        case .dateOfBirth: return "Date of Birth"
        case .dateOfThresholdAssessment: return "Date of Threshold Assessment"
        case .dateTime: return "Date Time"
        case .dateUTC: return "Date UTC"
        case .dayDateTime: return "Day Date Time"
        case .dayOfWeek: return "Day of Week"
        case .descriptorValueChanged: return "Descriptor Value Changed"
        case .deviceName: return "Device Name"
        case .dewPoint: return "Dew Point"
        case .digital: return "Digital"
        case .digitalOutput: return "Digital Output"
        case .dstOffset: return "DST Offset"
        case .elevation: return "Elevation"
        case .emailAddress: return "Email Address"
        case .emergencyID: return "Emergency ID"
        case .emergencyText: return "Emergency Text"
        case .exactTime100: return "Exact Time 100"
        case .exactTime256: return "Exact Time 256"
        case .fatBurnHeartRateLowerLimit: return "Fat Burn Heart Rate Lower Limit"
        case .fatBurnHeartRateUpperLimit: return "Fat Burn Heart Rate Upper Limit"
        case .firmwareRevision: return "Firmware Revision"
        case .firstName: return "First Name"
        case .fitnessMachineControlPoint: return "Fitness Machine Control Point"
        case .fitnessMachineFeature: return "Fitness Machine Feature"
        case .fitnessMachineStatus: return "Fitness Machine Status"
        case .fiveZoneHeartRateLimits: return "Five Zone Heart Rate Limits"
        case .floorNumber: return "Floor Number"
        case .gender: return "Gender"
        case .glucoseFeature: return "Glucose Feature"
        case .glucoseMeasurement: return "Glucose Measurement"
        case .glucoseMeasurementContext: return "Glucose Measurement Context"
        case .gustFactor: return "Gust Factor"
        case .hardwareRevision: return "Hardware Revision"
        case .heartRateControlPoint: return "Heart Rate Control Point"
        case .heartRateMax: return "Heart Rate Max"
        case .heartRateMeasurement: return "Heart Rate Measurement"
        case .heatIndex: return "Heat Index"
        case .height: return "Height"
        case .hidControlPoint: return "HID Control Point"
        case .hidInformation: return "HID Information"
        case .hipCircumference: return "Hip Circumference"
        case .httpControlPoint: return "HTTP Control Point"
        case .httpEntityBody: return "HTTP Entity Body"
        case .httpHeaders: return "HTTP Headers"
        case .httpStatusCode: return "HTTP Status Code"
        case .httpsSecurity: return "HTTPS Security"
        case .humidity: return "Humidity"
        case .iddAnnunciationStatus: return "IDD Annunciation Status"
        case .iddCommandControlPoint: return "IDD Command Control Point"
        case .iddCommandData: return "IDD Command Data"
        case .iddFeatures: return "IDD Features"
        case .iddHistoryData: return "IDD History Data"
        case .iddRecordAccessControlPoint: return "IDD Record Access Control Point"
        case .iddStatus: return "IDD Status"
        case .iddStatusChanged: return "IDD Status Changed"
        case .iddStatusReaderControlPoint: return "IDD Status Reader Control Point"
        case .iEEE11073_20601RegulatoryCertificationDataList: return "IEEE 11073-20601 Regulatory Certification Data List"
        case .indoorBikeData: return "Indoor Bike Data"
        case .indoorPositioningConfiguration: return "Indoor Positioning Configuration"
        case .intermediateCuffPressure: return "Intermediate Cuff Pressure"
        case .intermediateTemperature: return "Intermediate Temperature"
        case .irradiance: return "Irradiance"
        case .language: return "Language"
        case .lastName: return "Last Name"
        case .latitude: return "Latitude"
        case .lnControlPoint: return "LN Control Point"
        case .lnFeature: return "LN Feature"
        case .localEastCoordinate: return "Local East Coordinate"
        case .localNorthCoordinate: return "Local North Coordinate"
        case .localTime: return "Local Time Information"
        case .locationAndSpeedCharacteristic: return "Location and Speed Characteristic"
        case .locationName: return "Location Name"
        case .longitude: return "Longitude"
        case .magneticDeclination: return "Magnetic Declination"
        case .magneticFluxDensity2D: return "Magnetic Flux Density – 2D"
        case .magneticFluxDensity3D: return "Magnetic Flux Density – 3D"
        case .manufacturerName: return "Manufacturer Name"
        case .maximumRecommendedHeartRate: return "Maximum Recommended Heart Rate"
        case .measurementInterval: return "Measurement Interval"
        case .modelNumber: return "Model Number"
        case .navigation: return "Navigation"
        case .networkAvailability: return "Network Availability"
        case .newAlert: return "New Alert"
        case .objectActionControlPoint: return "Object Action Control Point"
        case .objectChanged: return "Object Changed"
        case .objectFirstCreated: return "Object First-Created"
        case .objectID: return "Object ID"
        case .objectLastModified: return "Object Last-Modified"
        case .objectListControlPoint: return "Object List Control Point"
        case .objectListFilter: return "Object List Filter"
        case .objectName: return "Object Name"
        case .objectProperties: return "Object Properties"
        case .objectSize: return "Object Size"
        case .objectType: return "Object Type"
        case .otsFeature: return "OTS Feature"
        case .peripheralPreferredConnectionParameters: return "Peripheral Preferred Connection Parameters"
        case .peripheralPrivacyFlag: return "Peripheral Privacy Flag"
        case .plxContinuousMeasurementCharacteristic: return "PLX Continuous Measurement Characteristic"
        case .plxFeatures: return "PLX Features"
        case .plxSpotCheckMeasurement: return "PLX Spot-Check Measurement"
        case .pnpID: return "PnP ID"
        case .pollenConcentration: return "Pollen Concentration"
        case .position2D: return "Position 2D"
        case .position3D: return "Position 3D"
        case .positionQuality: return "Position Quality"
        case .pressure: return "Pressure"
        case .protocolMode: return "Protocol Mode"
        case .pulseOximetryControlPoint: return "Pulse Oximetry Control Point"
        case .rainfall: return "Rainfall"
        case .rcFeature: return "RC Feature"
        case .rcSettings: return "RC Settings"
        case .reconnectionAddress: return "Reconnection Address"
        case .reconnectionConfigurationControlPoint: return "Reconnection Configuration Control Point"
        case .recordAccessControlPoint: return "Record Access Control Point"
        case .referenceTimeInformation: return "Reference Time Information"
        case .registeredUserCharacteristic: return "Registered User Characteristic"
        case .removable: return "Removable"
        case .report: return "Report"
        case .reportMap: return "Report Map"
        case .resolvablePrivateAddressOnly: return "Resolvable Private Address Only"
        case .restingHeartRate: return "Resting Heart Rate"
        case .ringerControlPoint: return "Ringer Control Point"
        case .ringerSetting: return "Ringer Setting"
        case .rowerData: return "Rower Data"
        case .rcsFeature: return "RSC Feature"
        case .rcsMeasurement: return "RSC Measurement"
        case .scControlPoint: return "SC Control Point"
        case .scanIntervalWindow: return "Scan Interval Window"
        case .scanRefresh: return "Scan Refresh"
        case .scientificTemperatureCelsius: return "Scientific Temperature Celsius"
        case .secondaryTimeZone: return "Secondary Time Zone"
        case .sensorLocation: return "Sensor Location"
        case .serialNumber: return "Serial Number"
        case .serverSupportedFeatures: return "Server Supported Features"
        case .serviceChanged: return "Service Changed"
        case .serviceRequired: return "Service Required"
        case .softwareRevision: return "Software Revision"
        case .sportTypeForAerobicAndAnaerobicThresholds: return "Sport Type for Aerobic and Anaerobic Thresholds"
        case .stairClimberData: return "Stair Climber Data"
        case .stepClimberData: return "Step Climber Data"
        case .string: return "String"
        case .supportedHeartRateRange: return "Supported Heart Rate Range"
        case .supportedInclinationRange: return "Supported Inclination Range"
        case .supportedNewAlertCategory: return "Supported New Alert Category"
        case .supportedPowerRange: return "Supported Power Range"
        case .supportedResistanceLevelRange: return "Supported Resistance Level Range"
        case .supportedSpeedRange: return "Supported Speed Range"
        case .supportedUnreadAlertCategory: return "Supported Unread Alert Category"
        case .systemID: return "System ID"
        case .tdsControlPoint: return "TDS Control Point"
        case .temperature: return "Temperature"
        case .temperatureCelsius: return "Temperature Celsius"
        case .temperatureFahrenheit: return "Temperature Fahrenheit"
        case .temperatureMeasurement: return "Temperature Measurement"
        case .temperatureType: return "Temperature Type"
        case .threeZoneHeartRateLimits: return "Three Zone Heart Rate Limits"
        case .timeAccuracy: return "Time Accuracy"
        case .timeBroadcast: return "Time Broadcast"
        case .timeSource: return "Time Source"
        case .timeUpdateControlPoint: return "Time Update Control Point"
        case .timeUpdateState: return "Time Update State"
        case .timeWithDST: return "Time with DST"
        case .timeZone: return "Time Zone"
        case .trainingStatus: return "Training Status"
        case .treadmillData: return "Treadmill Data"
        case .trueWindDirection: return "True Wind Direction"
        case .trueWindSpeed: return "True Wind Speed"
        case .twoZoneHeartRateLimit: return "Two Zone Heart Rate Limit"
        case .txPowerLevel: return "Tx Power Level"
        case .uncertainty: return "Uncertainty"
        case .unreadAlertStatus: return "Unread Alert Status"
        case .uri: return "URI"
        case .userControlPoint: return "User Control Point"
        case .userIndex: return "User Index"
        case .uvIndex: return "UV Index"
        case .vo2Max: return "VO2 Max"
        case .waistCircumference: return "Waist Circumference"
        case .weight: return "Weight"
        case .weightMeasurement: return "Weight Measurement"
        case .weightScaleFeature: return "Weight Scale Feature"
        case .windChill: return "Wind Chill"
        }
    }
    
    public var uti: String? {
        switch self {
        case .aerobicHeartRateLowerLimit: return "org.bluetooth.characteristic.aerobic_heart_rate_lower_limit"
        case .aerobicHeartRateUpperLimit: return "org.bluetooth.characteristic.aerobic_heart_rate_upper_limit"
        case .aerobicThreshold: return "org.bluetooth.characteristic.aerobic_threshold"
        case .age: return "org.bluetooth.characteristic.age"
        case .aggregate: return "org.bluetooth.characteristic.aggregate"
        case .alertCategoryID: return "org.bluetooth.characteristic.alert_category_id"
        case .alertCategoryIDBitMask: return "org.bluetooth.characteristic.alert_category_id_bit_mask"
        case .alertLevel: return "org.bluetooth.characteristic.alert_level"
        case .alertNotificationControlPoint: return "org.bluetooth.characteristic.alert_notification_control_point"
        case .alertStatus: return "org.bluetooth.characteristic.alert_status"
        case .altitude: return "org.bluetooth.characteristic.altitude"
        case .anaerobicHeartRateLowerLimit: return "org.bluetooth.characteristic.anaerobic_heart_rate_lower_limit"
        case .anaerobicHeartRateUpperLimit: return "org.bluetooth.characteristic.anaerobic_heart_rate_upper_limit"
        case .anaerobicThreshold: return "org.bluetooth.characteristic.anaerobic_threshold"
        case .analog: return "org.bluetooth.characteristic.analog"
        case .analogOutput: return "org.bluetooth.characteristic.analog_output"
        case .apparentWindDirection: return "org.bluetooth.characteristic.apparent_wind_direction"
        case .apparentWindSpeed: return "org.bluetooth.characteristic.apparent_wind_speed"
        case .appearance: return "org.bluetooth.characteristic.gap.appearance"
        case .barometricPressureTrend: return "org.bluetooth.characteristic.barometric_pressure_trend"
        case .batteryLevel: return "org.BluetoothCharacteristic.battery_level"
        case .batteryLevelState: return "org.bluetooth.characteristic.battery_level_state"
        case .batteryPowerState: return "org.bluetooth.characteristic.battery_power_state"
        case .bloodPressureFeature: return "org.bluetooth.characteristic.blood_pressure_feature"
        case .bloodPressureMeasurement: return "org.bluetooth.characteristic.blood_pressure_measurement"
        case .bodyCompositionFeature: return "org.bluetooth.characteristic.body_composition_feature"
        case .bodyCompositionMeasurement: return "org.bluetooth.characteristic.body_composition_measurement"
        case .bodySensorLocation: return "org.bluetooth.characteristic.body_sensor_location"
        case .bondManagementControlPoint: return "org.bluetooth.characteristic.bond_management_control_point"
        case .bondManagementFeatures: return "org.bluetooth.characteristic.bond_management_feature"
        case .bootKeyboardInputReport: return "org.bluetooth.characteristic.boot_keyboard_input_report"
        case .bootKeyboardOutputReport: return "org.bluetooth.characteristic.boot_keyboard_output_report"
        case .bootMouseInputReport: return "org.bluetooth.characteristic.boot_mouse_input_report"
        case .bssControlPoint: return nil
        case .bssResponse: return nil
        case .centralAddressResolution: return "org.bluetooth.characteristic.gap.central_address_resolution"
        case .cgmFeature: return "org.bluetooth.characteristic.cgm_feature"
        case .cgmMeasurement: return "org.bluetooth.characteristic.cgm_measurement"
        case .cgmSessionRunTime: return "org.bluetooth.characteristic.cgm_session_run_time"
        case .cgmSessionStartTime: return "org.bluetooth.characteristic.cgm_session_start_time"
        case .cgmSpecificOpsControlPoint: return "org.bluetooth.characteristic.cgm_specific_ops_control_point"
        case .cgmStatus: return "org.bluetooth.characteristic.cgm_status"
        case .clientSupportedFeatures: return nil
        case .crossTrainerData: return "org.bluetooth.characteristic.cross_trainer_data"
        case .cscFeature: return "org.bluetooth.characteristic.csc_feature"
        case .cscMeasurement: return "org.bluetooth.characteristic.csc_measurement"
        case .currentTime: return "org.BluetoothCharacteristic.current_time"
        case .cyclingPowerControlPoint: return "org.bluetooth.characteristic.cycling_power_control_point"
        case .cyclingPowerFeature: return "org.bluetooth.characteristic.cycling_power_feature"
        case .cyclingPowerMeasurement: return "org.bluetooth.characteristic.cycling_power_measurement"
        case .cyclingPowerVector: return "org.bluetooth.characteristic.cycling_power_vector"
        case .databaseChangeIncrement: return "org.bluetooth.characteristic.database_change_increment"
        case .databaseHash: return nil
        case .dateOfBirth: return "org.bluetooth.characteristic.date_of_birth"
        case .dateOfThresholdAssessment: return "org.bluetooth.characteristic.date_of_threshold_assessment"
        case .dateTime: return "org.bluetooth.characteristic.date_time"
        case .dateUTC: return "org.bluetooth.characteristic.date_utc"
        case .dayDateTime: return "org.bluetooth.characteristic.day_date_time"
        case .dayOfWeek: return "org.bluetooth.characteristic.day_of_week"
        case .descriptorValueChanged: return "org.bluetooth.characteristic.descriptor_value_changed"
        case .deviceName: return "org.bluetooth.characteristic.gap.device_name"
        case .dewPoint: return "org.bluetooth.characteristic.dew_point"
        case .digital: return "org.bluetooth.characteristic.digital"
        case .digitalOutput: return "org.bluetooth.characteristic.digital_output"
        case .dstOffset: return "org.bluetooth.characteristic.dst_offset"
        case .elevation: return "org.bluetooth.characteristic.elevation"
        case .emailAddress: return "org.bluetooth.characteristic.email_address"
        case .emergencyID: return nil
        case .emergencyText: return nil
        case .exactTime100: return "org.bluetooth.characteristic.exact_time_100"
        case .exactTime256: return "org.bluetooth.characteristic.exact_time_256"
        case .fatBurnHeartRateLowerLimit: return "org.bluetooth.characteristic.fat_burn_heart_rate_lower_limit"
        case .fatBurnHeartRateUpperLimit: return "org.bluetooth.characteristic.fat_burn_heart_rate_upper_limit"
        case .firmwareRevision: return "org.bluetooth.characteristic.firmware_revision_string"
        case .firstName: return "org.bluetooth.characteristic.first_name"
        case .fitnessMachineControlPoint: return "org.bluetooth.characteristic.fitness_machine_control_point"
        case .fitnessMachineFeature: return "org.bluetooth.characteristic.fitness_machine_feature"
        case .fitnessMachineStatus: return "org.bluetooth.characteristic.fitness_machine_status"
        case .fiveZoneHeartRateLimits: return "org.bluetooth.characteristic.five_zone_heart_rate_limits"
        case .floorNumber: return "org.bluetooth.characteristic.floor_number"
        case .gender: return "org.bluetooth.characteristic.gender"
        case .glucoseFeature: return "org.bluetooth.characteristic.glucose_feature"
        case .glucoseMeasurement: return "org.bluetooth.characteristic.glucose_measurement"
        case .glucoseMeasurementContext: return "org.bluetooth.characteristic.glucose_measurement_context"
        case .gustFactor: return "org.bluetooth.characteristic.gust_factor"
        case .hardwareRevision: return "org.bluetooth.characteristic.hardware_revision_string"
        case .heartRateControlPoint: return "org.bluetooth.characteristic.heart_rate_control_point"
        case .heartRateMax: return "org.bluetooth.characteristic.heart_rate_max"
        case .heartRateMeasurement: return "org.bluetooth.characteristic.heart_rate_measurement"
        case .heatIndex: return "org.bluetooth.characteristic.heat_index"
        case .height: return "org.bluetooth.characteristic.height"
        case .hidControlPoint: return "org.bluetooth.characteristic.hid_control_point"
        case .hidInformation: return "org.bluetooth.characteristic.hid_information"
        case .hipCircumference: return "org.bluetooth.characteristic.hip_circumference"
        case .httpControlPoint: return "org.bluetooth.characteristic.http_control_point"
        case .httpEntityBody: return "org.bluetooth.characteristic.http_entity_body"
        case .httpHeaders: return "org.bluetooth.characteristic.http_headers"
        case .httpStatusCode: return "org.bluetooth.characteristic.http_status_code"
        case .httpsSecurity: return "org.bluetooth.characteristic.https_security"
        case .humidity: return "org.bluetooth.characteristic.humidity"
        case .iddAnnunciationStatus: return "org.bluetooth.characteristic.idd_annunciation_status"
        case .iddCommandControlPoint: return "org.bluetooth.characteristic.idd_command_control_point"
        case .iddCommandData: return "org.bluetooth.characteristic.idd_command_data"
        case .iddFeatures: return "org.bluetooth.characteristic.idd_features"
        case .iddHistoryData: return "org.bluetooth.characteristic.idd_history_data"
        case .iddRecordAccessControlPoint: return "org.bluetooth.characteristic.idd_record_access_control_point"
        case .iddStatus: return "org.bluetooth.characteristic.idd_status"
        case .iddStatusChanged: return "org.bluetooth.characteristic.idd_status_changed"
        case .iddStatusReaderControlPoint: return "org.bluetooth.characteristic.idd_status_reader_control_point"
        case .iEEE11073_20601RegulatoryCertificationDataList: return "org.bluetooth.characteristic.ieee_11073-20601_regulatory_certification_data_list"
        case .indoorBikeData: return "org.bluetooth.characteristic.indoor_bike_data"
        case .indoorPositioningConfiguration: return "org.bluetooth.characteristic.indoor_positioning_configuration"
        case .intermediateCuffPressure: return "org.bluetooth.characteristic.intermediate_cuff_pressure"
        case .intermediateTemperature: return "org.bluetooth.characteristic.intermediate_temperature"
        case .irradiance: return "org.bluetooth.characteristic.irradiance"
        case .language: return "org.bluetooth.characteristic.language"
        case .lastName: return "org.bluetooth.characteristic.last_name"
        case .latitude: return "org.bluetooth.characteristic.latitude"
        case .lnControlPoint: return "org.bluetooth.characteristic.ln_control_point"
        case .lnFeature: return "org.bluetooth.characteristic.ln_feature"
        case .localEastCoordinate: return "org.bluetooth.characteristic.local_east_coordinate"
        case .localNorthCoordinate: return "org.bluetooth.characteristic.local_north_coordinate"
        case .localTime: return "org.bluetoothCharacteristic.local_time_information"
        case .locationAndSpeedCharacteristic: return "org.bluetooth.characteristic.location_and_speed"
        case .locationName: return "org.bluetooth.characteristic.location_name"
        case .longitude: return "org.bluetooth.characteristic.longitude"
        case .magneticDeclination: return "org.bluetooth.characteristic.magnetic_declination"
        case .magneticFluxDensity2D: return "org.bluetooth.characteristic.magnetic_flux_density_2D"
        case .magneticFluxDensity3D: return "org.bluetooth.characteristic.magnetic_flux_density_3D"
        case .manufacturerName: return "org.bluetoothCharacteristic.manufacturer_name_string"
        case .maximumRecommendedHeartRate: return "org.bluetooth.characteristic.maximum_recommended_heart_rate"
        case .measurementInterval: return "org.bluetooth.characteristic.measurement_interval"
        case .modelNumber: return "org.bluetoothCharacteristic.model_number_string"
        case .navigation: return "org.bluetooth.characteristic.navigation"
        case .networkAvailability: return "org.bluetooth.characteristic.network_availability"
        case .newAlert: return "org.bluetooth.characteristic.new_alert"
        case .objectActionControlPoint: return "org.bluetooth.characteristic.object_action_control_point"
        case .objectChanged: return "org.bluetooth.characteristic.object_changed"
        case .objectFirstCreated: return "org.bluetooth.characteristic.object_first_created"
        case .objectID: return "org.bluetooth.characteristic.object_id"
        case .objectLastModified: return "org.bluetooth.characteristic.object_last_modified"
        case .objectListControlPoint: return "org.bluetooth.characteristic.object_list_control_point"
        case .objectListFilter: return "org.bluetooth.characteristic.object_list_filter"
        case .objectName: return "org.bluetooth.characteristic.object_name"
        case .objectProperties: return "org.bluetooth.characteristic.object_properties"
        case .objectSize: return "org.bluetooth.characteristic.object_size"
        case .objectType: return "org.bluetooth.characteristic.object_type"
        case .otsFeature: return "org.bluetooth.characteristic.ots_feature"
        case .peripheralPreferredConnectionParameters: return "org.bluetooth.characteristic.gap.peripheral_preferred_connection_parameters"
        case .peripheralPrivacyFlag: return "org.bluetooth.characteristic.gap.peripheral_privacy_flag"
        case .plxContinuousMeasurementCharacteristic: return "org.bluetooth.characteristic.plx_continuous_measurement"
        case .plxFeatures: return "org.bluetooth.characteristic.plx_features"
        case .plxSpotCheckMeasurement: return "org.bluetooth.characteristic.plx_spot_check_measurement"
        case .pnpID: return "org.bluetooth.characteristic.pnp_id"
        case .pollenConcentration: return "org.bluetooth.characteristic.pollen_concentration"
        case .position2D: return "org.bluetooth.characteristic.position_2d"
        case .position3D: return "org.bluetooth.characteristic.position_3d"
        case .positionQuality: return "org.bluetooth.characteristic.position_quality"
        case .pressure: return "org.bluetooth.characteristic.pressure"
        case .protocolMode: return "org.bluetooth.characteristic.protocol_mode"
        case .pulseOximetryControlPoint: return "org.bluetooth.characteristic.pulse_oximetry_control_point"
        case .rainfall: return "org.bluetooth.characteristic.rainfall"
        case .rcFeature: return "org.bluetooth.characteristic.rc_feature"
        case .rcSettings: return "org.bluetooth.characteristic.rc_settings"
        case .reconnectionAddress: return "org.bluetooth.characteristic.gap.reconnection_address"
        case .reconnectionConfigurationControlPoint: return "org.bluetooth.characteristic.reconnection_configuration_control_point"
        case .recordAccessControlPoint: return "org.bluetooth.characteristic.record_access_control_point"
        case .referenceTimeInformation: return "org.bluetooth.characteristic.reference_time_information"
        case .registeredUserCharacteristic: return nil
        case .removable: return "org.bluetooth.characteristic.removable"
        case .report: return "org.bluetooth.characteristic.report"
        case .reportMap: return "org.bluetooth.characteristic.report_map"
        case .resolvablePrivateAddressOnly: return "org.bluetooth.characteristic.resolvable_private_address_only"
        case .restingHeartRate: return "org.bluetooth.characteristic.resting_heart_rate"
        case .ringerControlPoint: return "org.bluetooth.characteristic.ringer_control_point"
        case .ringerSetting: return "org.bluetooth.characteristic.ringer_setting"
        case .rowerData: return "org.bluetooth.characteristic.rower_data"
        case .rcsFeature: return "org.bluetooth.characteristic.rsc_feature"
        case .rcsMeasurement: return "org.bluetooth.characteristic.rsc_measurement"
        case .scControlPoint: return "org.bluetooth.characteristic.sc_control_point"
        case .scanIntervalWindow: return "org.bluetooth.characteristic.scan_interval_window"
        case .scanRefresh: return "org.bluetooth.characteristic.scan_refresh"
        case .scientificTemperatureCelsius: return "org.bluetooth.characteristic.scientific_temperature_celsius"
        case .secondaryTimeZone: return "org.bluetooth.characteristic.secondary_time_zone"
        case .sensorLocation: return "org.bluetooth.characteristic.sensor_location"
        case .serialNumber: return "org.bluetooth.characteristic.serial_number_string"
        case .serverSupportedFeatures: return nil
        case .serviceChanged: return "org.bluetooth.characteristic.gatt.service_changed"
        case .serviceRequired: return "org.bluetooth.characteristic.service_required"
        case .softwareRevision: return "org.bluetooth.characteristic.software_revision_string"
        case .sportTypeForAerobicAndAnaerobicThresholds: return "org.bluetooth.characteristic.sport_type_for_aerobic_and_anaerobic_thresholds"
        case .stairClimberData: return "org.bluetooth.characteristic.stair_climber_data"
        case .stepClimberData: return "org.bluetooth.characteristic.step_climber_data"
        case .string: return "org.bluetooth.characteristic.string"
        case .supportedHeartRateRange: return "org.bluetooth.characteristic.supported_heart_rate_range"
        case .supportedInclinationRange: return "org.bluetooth.characteristic.supported_inclination_range"
        case .supportedNewAlertCategory: return "org.bluetooth.characteristic.supported_new_alert_category"
        case .supportedPowerRange: return "org.bluetooth.characteristic.supported_power_range"
        case .supportedResistanceLevelRange: return "org.bluetooth.characteristic.supported_resistance_level_range"
        case .supportedSpeedRange: return "org.bluetooth.characteristic.supported_speed_range"
        case .supportedUnreadAlertCategory: return "org.bluetooth.characteristic.supported_unread_alert_category"
        case .systemID: return "org.bluetooth.characteristic.system_id"
        case .tdsControlPoint: return "org.bluetooth.characteristic.tds_control_point"
        case .temperature: return "org.bluetooth.characteristic.temperature"
        case .temperatureCelsius: return "org.bluetooth.characteristic.temperature_celsius"
        case .temperatureFahrenheit: return "org.bluetooth.characteristic.temperature_fahrenheit"
        case .temperatureMeasurement: return "org.bluetooth.characteristic.temperature_measurement"
        case .temperatureType: return "org.bluetooth.characteristic.temperature_type"
        case .threeZoneHeartRateLimits: return "org.bluetooth.characteristic.three_zone_heart_rate_limits"
        case .timeAccuracy: return "org.bluetooth.characteristic.time_accuracy"
        case .timeBroadcast: return "org.bluetooth.characteristic.time_broadcast"
        case .timeSource: return "org.bluetooth.characteristic.time_source"
        case .timeUpdateControlPoint: return "org.bluetooth.characteristic.time_update_control_point"
        case .timeUpdateState: return "org.bluetooth.characteristic.time_update_state"
        case .timeWithDST: return "org.bluetooth.characteristic.time_with_dst"
        case .timeZone: return "org.bluetooth.characteristic.time_zone"
        case .trainingStatus: return "org.bluetooth.characteristic.training_status"
        case .treadmillData: return "org.bluetooth.characteristic.treadmill_data"
        case .trueWindDirection: return "org.bluetooth.characteristic.true_wind_direction"
        case .trueWindSpeed: return "org.bluetooth.characteristic.true_wind_speed"
        case .twoZoneHeartRateLimit: return "org.bluetooth.characteristic.two_zone_heart_rate_limit"
        case .txPowerLevel: return "org.bluetooth.characteristic.tx_power_level"
        case .uncertainty: return "org.bluetooth.characteristic.uncertainty"
        case .unreadAlertStatus: return "org.bluetooth.characteristic.unread_alert_status"
        case .uri: return "org.bluetooth.characteristic.uri"
        case .userControlPoint: return "org.bluetooth.characteristic.user_control_point"
        case .userIndex: return "org.bluetooth.characteristic.user_index"
        case .uvIndex: return "org.bluetooth.characteristic.uv_index"
        case .vo2Max: return "org.bluetooth.characteristic.vo2_max"
        case .waistCircumference: return "org.bluetooth.characteristic.waist_circumference"
        case .weight: return "org.bluetooth.characteristic.weight"
        case .weightMeasurement: return "org.bluetooth.characteristic.weight_measurement"
        case .weightScaleFeature: return "org.bluetooth.characteristic.weight_scale_feature"
        case .windChill: return "org.bluetooth.characteristic.wind_chill"
        }
    }
}
