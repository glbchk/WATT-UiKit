// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ChargeTripAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ChargeTripAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ChargeTripAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ChargeTripAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Query": return ChargeTripAPI.Objects.Query
    case "CarList": return ChargeTripAPI.Objects.CarList
    case "CarListNaming": return ChargeTripAPI.Objects.CarListNaming
    case "CarListMedia": return ChargeTripAPI.Objects.CarListMedia
    case "CarImage": return ChargeTripAPI.Objects.CarImage
    case "Vehicle": return ChargeTripAPI.Objects.Vehicle
    case "VehicleNaming": return ChargeTripAPI.Objects.VehicleNaming
    case "VehicleConnector": return ChargeTripAPI.Objects.VehicleConnector
    case "VehicleBattery": return ChargeTripAPI.Objects.VehicleBattery
    case "VehicleBody": return ChargeTripAPI.Objects.VehicleBody
    case "VehicleBodyWeight": return ChargeTripAPI.Objects.VehicleBodyWeight
    case "VehiclePerformance": return ChargeTripAPI.Objects.VehiclePerformance
    case "VehicleRange": return ChargeTripAPI.Objects.VehicleRange
    case "VehicleRangeValue": return ChargeTripAPI.Objects.VehicleRangeValue
    case "ChargetripRange": return ChargeTripAPI.Objects.ChargetripRange
    case "VehicleMedia": return ChargeTripAPI.Objects.VehicleMedia
    case "VehicleImage": return ChargeTripAPI.Objects.VehicleImage
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
