module Spree
  class StoreFaviconImage < Asset
    if Spree.public_storage_service_name
      has_one_attached :attachment, service: Spree.public_storage_service_name
    else
      has_one_attached :attachment
    end

    Marcel::MimeType.extend 'image/x-icon', extensions: %w( ico )
    VALID_CONTENT_TYPES = ['image/png', 'image/x-icon', 'image/vnd.microsoft.icon'].freeze

    validates :attachment,
              content_type: VALID_CONTENT_TYPES,
              dimension: { max: 256..256 },
              aspect_ratio: :square,
              size: { less_than_or_equal_to: 1.megabyte }
  end
end
