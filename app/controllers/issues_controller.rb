class IssuesController < ApplicationController
  def index
    @issues = DecoratedIssues.new(paginated_issues.preload(:labels, :language))
  end

  private

  def paginated_issues
    issues.paginate(page: params[:page])
  end

  def labels
    return if params[:labels].nil? || JSON.parse(params[:labels]).empty?
    JSON.parse(params[:labels])
  end

  def language
    params[:language]
  end

  def issues
    # TODO: Is this possible to achieve in a single query?
    return Issue.by_language_and_labels(language, labels) if language && labels
    return Issue.by_labels(labels) if labels
    return Issue.by_language(language) if language

    Issue.all
  end

  def paginated(collection)
    collection.paginate(page: params[:page])
  end
end
