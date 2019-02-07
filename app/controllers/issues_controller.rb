class IssuesController < ApplicationController
  def index
    @issues = DecoratedIssues.new(paginated_issues.preload(:labels, :language))
  end

  private

  def paginated_issues
    issues.paginate(page: params[:page])
  end

  def labels
    return if params[:labels].nil?
    params[:labels]
  end

  def language
    params[:language]
  end

  def issues
    Issue.by_language_and_labels(language, labels)
  end

  def paginated(collection)
    collection.paginate(page: params[:page])
  end
end
