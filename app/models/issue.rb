class Issue < ApplicationRecord
  has_and_belongs_to_many :labels
  default_scope { order(created_at: :desc) }

  def self.by_labels(labels)
    joins(:labels).where(labels: { name: labels })
  end

  def self.by_language(language)
    where(language: language)
  end
end
