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
    # TODO: Is this possible to achieve in a single query?
    #
    # TODO: labels.any is necessary because of the fudge in
    # ApplicationController. Tags cannot be removed unless an empty string
    # `['']` is sent in the params `labels: ['']`. Otherwise the controller
    # will look at the params and see `nil` -- for instance, the pagination
    # links don't send labels or language params -- and decide not to change
    # the session values. But then we end up with an empty array here and so I
    # have to check is it's populated or not. Fix this!
    # Ideally I think I need a model/models to represent the session params.

    return by_language(language).merge by_labels(labels) if language && [*labels].any?
    return by_labels(labels) if [*labels].any?
    return by_language(language) if language

    all
  }

  def self.number_of_issues_for(language:, labels:)
    by_language_and_labels(language, labels).size
  end

  def self.ids_for_label(label_name)
    joins(:labels)
    .where(labels: { name: label_name })
    .distinct
    .pluck(:id)
  end
end
