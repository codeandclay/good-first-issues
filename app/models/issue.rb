class Issue < ApplicationRecord
  has_many :tags
  has_many :labels, through: :tags

  default_scope { order(created_at: :desc) }

  scope :by_labels, lambda { |labels|
    joins(:labels).where(labels: { name: labels })
  }

  scope :by_language, lambda { |language|
    where(language: language)
  }
end
