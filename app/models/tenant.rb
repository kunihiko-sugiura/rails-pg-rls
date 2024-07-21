class Tenant < ApplicationRecord
  include GenerateId

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  has_many :users, dependent: :destroy
end
