class Issue < ApplicationRecord
  has_and_belongs_to_many :labels
  default_scope { order(created_at: :desc) }

  def self.by_label(name)
    Label.find_by(name: name).issues
  end

  def self.by_language(name)
    where(language: name)
  end
end
