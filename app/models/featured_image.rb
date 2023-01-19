class FeaturedImage < ApplicationRecord
  include CommunityRelated

  has_one_attached :image
end
