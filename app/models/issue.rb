class Issue < ApplicationRecord
  has_and_belongs_to_many :labels
  default_scope { order(created_at: :desc) }

  def self.by_labels(name)
    joins(:labels).where(labels: { name: name })
  end

  def self.by_language(name)
    where(language: name)
  end
end
