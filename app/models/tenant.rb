class Tenant < ApplicationRecord
  include GenerateID

  validates :name
  has_many :users, dependent: :destroy
end
