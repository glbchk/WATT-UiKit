// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class BrandListAllQuery: GraphQLQuery {
  public static let operationName: String = "brandListAll"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query brandListAll { carList(size: 12, page: 0) { __typename id naming { __typename make } media { __typename brand { __typename id type url height width } } } }"#
    ))

  public init() {}

  public struct Data: ChargeTripAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("carList", [CarList?]?.self, arguments: [
        "size": 12,
        "page": 0
      ]),
    ] }

    /// Get a full list of cars.
    public var carList: [CarList?]? { __data["carList"] }

    /// CarList
    ///
    /// Parent Type: `CarList`
    public struct CarList: ChargeTripAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.CarList }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ChargeTripAPI.ID?.self),
        .field("naming", Naming?.self),
        .field("media", Media?.self),
      ] }

      /// Cars unique ID.
      public var id: ChargeTripAPI.ID? { __data["id"] }
      /// Naming of a car.
      public var naming: Naming? { __data["naming"] }
      /// Media of a car.
      public var media: Media? { __data["media"] }

      /// CarList.Naming
      ///
      /// Parent Type: `CarListNaming`
      public struct Naming: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.CarListNaming }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("make", String?.self),
        ] }

        /// Car manufacturer name.
        public var make: String? { __data["make"] }
      }

      /// CarList.Media
      ///
      /// Parent Type: `CarListMedia`
      public struct Media: ChargeTripAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.CarListMedia }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("brand", Brand?.self),
        ] }

        /// Latest make logo of the car.
        public var brand: Brand? { __data["brand"] }

        /// CarList.Media.Brand
        ///
        /// Parent Type: `CarImage`
        public struct Brand: ChargeTripAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ChargeTripAPI.Objects.CarImage }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ChargeTripAPI.ID?.self),
            .field("type", GraphQLEnum<ChargeTripAPI.CarImageType>?.self),
            .field("url", String?.self),
            .field("height", Int?.self),
            .field("width", Int?.self),
          ] }

          /// Image id.
          public var id: ChargeTripAPI.ID? { __data["id"] }
          /// Image type.
          public var type: GraphQLEnum<ChargeTripAPI.CarImageType>? { __data["type"] }
          /// Full path URL of a large image.
          public var url: String? { __data["url"] }
          /// Height of a large image in pixels.
          public var height: Int? { __data["height"] }
          /// Width of a large image in pixels.
          public var width: Int? { __data["width"] }
        }
      }
    }
  }
}
