class Label < ApplicationRecord
  has_many :tags
  has_many :issues, through: :tags

  def self.top
    joins(:issues)
    .group(:name)
    .order('count_id desc')
    .count('id')
    .take(10)
    .map(&:first)
  end

  scope :by_search_term, lambda { |term|
    return Label.none if term.empty?
    where("name LIKE ?", "%#{term}%")
  }
end
