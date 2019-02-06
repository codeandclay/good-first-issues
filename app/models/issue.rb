class Issue < ApplicationRecord
  has_many :tags
  has_many :labels, through: :tags
  belongs_to :language

  default_scope { order(created_at: :desc) }

  scope :by_labels, lambda { |labels|
    # `labels` needs to be coerced to an array so that the scope can accept a
    # single string as an argument.
    where(id: [*labels].map { |label| ids_for_label(label) }.reduce(&:&))
  }

  scope :by_language, lambda { |language|
    joins(:language).where(languages: { name: language })
  }

  scope :by_language_and_labels, lambda { |language, labels|
    by_language(language).merge by_labels(labels)
  }

  def self.ids_for_label(label_name)
    joins(:labels)
    .where(labels: { name: label_name })
    .distinct
    .pluck(:id)
  end
end
