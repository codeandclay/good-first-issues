class Language < ApplicationRecord
  has_many :issues

  def self.top
    joins(:issues)
    .group(:name)
    .order('count_id DESC')
    .count('id')
    .take(10)
    .map(&:first)
  end

  scope :by_search_term, lambda { |term|
    where("name like ?", "%#{term}%")
  }
end
