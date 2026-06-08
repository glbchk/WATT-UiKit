// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Available types of images which can be found for a car. Each type has specific image sizes.
public enum CarImageType: String, EnumType {
  /// Images provided by a Car Datasource.
  case provider = "provider"
  /// Full-sized image at 1536x864 px.
  case image = "image"
  /// Thumbnail of a full-sized image at 131x72 px.
  case imageThumbnail = "image_thumbnail"
  /// Full-sized brand (make) logo at 768x432 px.
  case brand = "brand"
  /// Thumbnail of a full-sized brand (make) logo at 56x24 px.
  case brandThumbnail = "brand_thumbnail"
  /// Placeholder image at 1536x864 px.
  case placeholder = "placeholder"
}
