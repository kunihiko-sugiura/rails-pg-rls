class User < ApplicationRecord
  include GenerateID

  validates :name
  belongs_to :tenant
end
