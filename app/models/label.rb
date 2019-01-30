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
end
