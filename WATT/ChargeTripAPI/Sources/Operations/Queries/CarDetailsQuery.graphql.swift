// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CarDetailsQuery: GraphQLQuery {
  public static let operationName: String = "carDetails"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query carDetails($vehicleId: ID!) { vehicle(id: $vehicleId) { __typename id naming { __typename make model version } connectors { __typename standard } battery { __typename usable_kwh full_kwh } body { __typename seats weight { __typename nominal } width height } performance { __typename acceleration top_speed } range { __typename provider provider_is_estimated worst { __typename highway city combined } best { __typename highway city combined } chargetrip_range { __typename best worst } } media { __typename image { __typename id type url height width } make { __typename id type url height width } } } }"#
    ))

  public var vehicleId: ID

  public init(vehicleId: ID) {
    self.vehicleId = vehicleId
  }

  public var __variables: Variables? { ["vehicleId": vehicleId] }

  public struct Data: ChargeTripAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("vehicle", Vehicle?.self, arguments: ["id": .variable("vehicleId")]),
    ] }

    /// [BETA] Get information about a vehicle by its ID.
    public var vehicle: Vehicle? { __data["vehicle"] }

    /// Vehicle
    ///
    /// Parent Type: `Vehicle`
    public struct Vehicle: ChargeTripAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.Vehicle }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ChargeTripAPI.ID.self),
        .field("naming", Naming.self),
        .field("connectors", [Connector].self),
        .field("battery", Battery.self),
        .field("body", Body.self),
        .field("performance", Performance?.self),
        .field("range", Range.self),
        .field("media", Media.self),
      ] }

      /// Vehicles unique ID.
      public var id: ChargeTripAPI.ID { __data["id"] }
      /// Naming of the vehicle.
      public var naming: Naming { __data["naming"] }
      /// Available connectors for the vehicle.
      public var connectors: [Connector] { __data["connectors"] }
      /// Battery of the vehicle.
      public var battery: Battery { __data["battery"] }
      /// Body of the vehicle.
      public var body: Body { __data["body"] }
      /// Performance of the vehicle.
      public var performance: Performance? { __data["performance"] }
      /// Range of the vehicle.
      public var range: Range { __data["range"] }
      /// Media of the vehicle.
      public var media: Media { __data["media"] }

      /// Vehicle.Naming
      ///
      /// Parent Type: `VehicleNaming`
      public struct Naming: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleNaming }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("make", String.self),
          .field("model", String.self),
          .field("version", String?.self),
        ] }

        /// Vehicle manufacturer name.
        public var make: String { __data["make"] }
        /// Vehicle model name.
        public var model: String { __data["model"] }
        /// Version, edition or submodel of the vehicle.
        public var version: String? { __data["version"] }
      }

      /// Vehicle.Connector
      ///
      /// Parent Type: `VehicleConnector`
      public struct Connector: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleConnector }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("standard", GraphQLEnum<ChargeTripAPI.ConnectorType>.self),
        ] }

        /// Connector type, known as connector standard in OCPI.
        public var standard: GraphQLEnum<ChargeTripAPI.ConnectorType> { __data["standard"] }
      }

      /// Vehicle.Battery
      ///
      /// Parent Type: `VehicleBattery`
      public struct Battery: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleBattery }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("usable_kwh", Double.self),
          .field("full_kwh", Double.self),
        ] }

        /// Usable battery capacity in kWh.
        public var usable_kwh: Double { __data["usable_kwh"] }
        /// Full battery capacity in kWh.
        public var full_kwh: Double { __data["full_kwh"] }
      }

      /// Vehicle.Body
      ///
      /// Parent Type: `VehicleBody`
      public struct Body: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleBody }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("seats", Int.self),
          .field("weight", Weight.self),
          .field("width", Double.self),
          .field("height", Double.self),
        ] }

        /// Number of seats.
        public var seats: Int { __data["seats"] }
        /// Weight (unladen), default in kg.
        public var weight: Weight { __data["weight"] }
        /// Width with folded mirrors, default in mm.
        public var width: Double { __data["width"] }
        /// Height (average height for adjustable suspensions), default in mm.
        public var height: Double { __data["height"] }

        /// Vehicle.Body.Weight
        ///
        /// Parent Type: `VehicleBodyWeight`
        public struct Weight: ChargeTripAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleBodyWeight }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nominal", Double?.self),
          ] }

          /// Nominal weight, default in kg.
          public var nominal: Double? { __data["nominal"] }
        }
      }

      /// Vehicle.Performance
      ///
      /// Parent Type: `VehiclePerformance`
      public struct Performance: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehiclePerformance }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("acceleration", Double?.self),
          .field("top_speed", Double?.self),
        ] }

        /// Acceleration in seconds, default in kmph to 100.
        public var acceleration: Double? { __data["acceleration"] }
        /// Top speed of the vehicle, default in kmph.
        public var top_speed: Double? { __data["top_speed"] }
      }

      /// Vehicle.Range
      ///
      /// Parent Type: `VehicleRange`
      public struct Range: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleRange }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("provider", Double?.self),
          .field("provider_is_estimated", Bool?.self),
          .field("worst", Worst.self),
          .field("best", Best.self),
          .field("chargetrip_range", Chargetrip_range.self),
        ] }

        /// Index range, default in km.
        public var provider: Double? { __data["provider"] }
        /// Indicates if index range is estimated.
        public var provider_is_estimated: Bool? { __data["provider_is_estimated"] }
        /// Worst conditions are based on -10°C and use of heating.
        public var worst: Worst { __data["worst"] }
        /// Best conditions are based on 23°C and no use of A/C.
        public var best: Best { __data["best"] }
        /// Chargetrip's custom real-world range provides a carefully calculated display range for all-electric vehicle models.
        /// Chargetrip range is based on the theoretical distance driven using only the electric engine.
        /// Vehicles that do not have a full electric drivetrain type (all except Battery Electric Vehicles / BEV) therefore return relatively small ranges.
        /// More information on the CT range can be found at https://chargetrip.com/blog/what-is-ct-real-range
        public var chargetrip_range: Chargetrip_range { __data["chargetrip_range"] }

        /// Vehicle.Range.Worst
        ///
        /// Parent Type: `VehicleRangeValue`
        public struct Worst: ChargeTripAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleRangeValue }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("highway", Double.self),
            .field("city", Double.self),
            .field("combined", Double.self),
          ] }

          /// Estimated value on the highway or express roads, default in km.
          public var highway: Double { __data["highway"] }
          /// Estimated value on the cities road, default in km.
          public var city: Double { __data["city"] }
          /// Estimated combined value, default in km.
          public var combined: Double { __data["combined"] }
        }

        /// Vehicle.Range.Best
        ///
        /// Parent Type: `VehicleRangeValue`
        public struct Best: ChargeTripAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleRangeValue }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("highway", Double.self),
            .field("city", Double.self),
            .field("combined", Double.self),
          ] }

          /// Estimated value on the highway or express roads, default in km.
          public var highway: Double { __data["highway"] }
          /// Estimated value on the cities road, default in km.
          public var city: Double { __data["city"] }
          /// Estimated combined value, default in km.
          public var combined: Double { __data["combined"] }
        }

        /// Vehicle.Range.Chargetrip_range
        ///
        /// Parent Type: `ChargetripRange`
        public struct Chargetrip_range: ChargeTripAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.ChargetripRange }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("best", Int?.self),
            .field("worst", Int?.self),
          ] }

          /// Range calculated using the best conditions.
          /// Best conditions are based on 25°C, including use of A/C.
          /// More information on the CT range can be found at https://chargetrip.com/blog/what-is-ct-real-range
          public var best: Int? { __data["best"] }
          /// Range calculated using the worst conditions.
          /// Worst conditions are based on -0°C, including use of heating.
          /// More information on the CT range can be found at https://chargetrip.com/blog/what-is-ct-real-range
          public var worst: Int? { __data["worst"] }
        }
      }

      /// Vehicle.Media
      ///
      /// Parent Type: `VehicleMedia`
      public struct Media: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleMedia }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("image", Image.self),
          .field("make", Make.self),
        ] }

        /// Featured image of the vehicle from a 45-degree angle.
        public var image: Image { __data["image"] }
        /// Latest make logo.
        public var make: Make { __data["make"] }

        /// Vehicle.Media.Image
        ///
        /// Parent Type: `VehicleImage`
        public struct Image: ChargeTripAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleImage }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ChargeTripAPI.ID?.self),
            .field("type", GraphQLEnum<ChargeTripAPI.VehicleImageType>.self),
            .field("url", String.self),
            .field("height", Int.self),
            .field("width", Int.self),
          ] }

          /// Image id.
          public var id: ChargeTripAPI.ID? { __data["id"] }
          /// Image type.
          public var type: GraphQLEnum<ChargeTripAPI.VehicleImageType> { __data["type"] }
          /// Full path URL of a large image.
          public var url: String { __data["url"] }
          /// Height of a large image in pixels.
          public var height: Int { __data["height"] }
          /// Width of a large image in pixels.
          public var width: Int { __data["width"] }
        }

        /// Vehicle.Media.Make
        ///
        /// Parent Type: `VehicleImage`
        public struct Make: ChargeTripAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.VehicleImage }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ChargeTripAPI.ID?.self),
            .field("type", GraphQLEnum<ChargeTripAPI.VehicleImageType>.self),
            .field("url", String.self),
            .field("height", Int.self),
            .field("width", Int.self),
          ] }

          /// Image id.
          public var id: ChargeTripAPI.ID? { __data["id"] }
          /// Image type.
          public var type: GraphQLEnum<ChargeTripAPI.VehicleImageType> { __data["type"] }
          /// Full path URL of a large image.
          public var url: String { __data["url"] }
          /// Height of a large image in pixels.
          public var height: Int { __data["height"] }
          /// Width of a large image in pixels.
          public var width: Int { __data["width"] }
        }
      }
    }
  }
}
