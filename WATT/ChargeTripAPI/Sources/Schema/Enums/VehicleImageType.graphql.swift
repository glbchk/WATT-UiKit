// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Available types of images which can be found for a vehicle. Each type has specific image sizes.
public enum VehicleImageType: String, EnumType {
  /// Images provided by a Vehicle Datasource.
  case provider = "provider"
  /// Full-sized image at 1536x864 px.
  case image = "image"
  /// Thumbnail of a full-sized image at 131x72 px.
  case imageThumbnail = "image_thumbnail"
  /// Premium image.
  case imagePremium = "image_premium"
  /// Thumbnail of a premium image.
  case premiumImageThumbnail = "premium_image_thumbnail"
  /// Full-sized brand (make) logo at 768x432 px.
  case brand = "brand"
  /// Thumbnail of a full-sized brand (make) logo at 56x24 px.
  case brandThumbnail = "brand_thumbnail"
  /// Placeholder image at 1536x864 px.
  case placeholder = "placeholder"
}
