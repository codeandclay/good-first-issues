class Issue < ApplicationRecord
  has_many :tags
  has_many :labels, through: :tags
  belongs_to :language

  default_scope { order(created_at: :desc) }

  scope :by_labels, lambda { |labels|
    joins(:labels).where(labels: { name: labels }).distinct
  }

  scope :by_language, lambda { |language|
    joins(:language).where(languages: { name: language })
  }

  scope :by_language_and_labels, lambda { |language, labels|
    by_language(language).merge by_labels(labels)
  }
end
