class Community < ApplicationRecord
  has_many :community_users
  has_many :site_settings

  has_one :featured_image, required: true

  default_scope { where(is_fake: false) }

  validates :host, uniqueness: { case_sensitive: false }
end
