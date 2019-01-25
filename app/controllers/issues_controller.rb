class IssuesController < ApplicationController
  def index
    @issues = issues.includes(:labels).paginate(page: params[:page])
    @title = IndexTitle.new(params, @issues.length).to_s
  end

  private

  def labels
    params[:label]
  end

  def language
    params[:language]
  end

  def issues
    return Issue.by_language_and_labels(language, labels) if language && labels

    # TODO: I would prefer to do a union here to but the models are not
    # structurally compatible.
    #
    # return Issue.all unless labels || language
    # Issue.by_labels(labels).or Issue.by_language(language)
    #
    # ArgumentError (Relation passed to #or must be structurally compatible.
    # Incompatible values: [:joins])
    return Issue.by_labels(labels) if labels
    return Issue.by_language(language) if language

    Issue.all
  end

  def paginated(collection)
    collection.paginate(page: params[:page])
  end
end
