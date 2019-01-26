class IssuesController < ApplicationController
  def index
    @issues = DecoratedIssues.new(paginated_issues)
  end

  private

  def paginated_issues
    issues.includes(:labels, :language).paginate(page: params[:page])
  end

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
