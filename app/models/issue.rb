class Issue < ApplicationRecord
  has_many :tags
  has_many :labels, through: :tags
  belongs_to :language

  default_scope { order(created_at: :desc) }

  scope :by_labels, lambda { |labels|
    joins(:labels).where(labels: { name: labels })
  }

  scope :by_languages, lambda { |languages|
    joins(:language).where(languages: { name: languages })
  }

  scope :by_languages_and_labels, lambda { |languages, labels|
    by_languages(languages).merge by_labels(labels)
  }
end
