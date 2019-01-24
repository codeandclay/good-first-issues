class Issue < ApplicationRecord
  has_and_belongs_to_many :labels
  default_scope { order(created_at: :desc) }
end
