class User < ApplicationRecord
  include GenerateId

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  belongs_to :tenant
end
