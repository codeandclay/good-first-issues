class Label < ApplicationRecord
  has_many :tags
  has_many :issues, through: :tags
end
