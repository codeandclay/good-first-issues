class IssuesController < ApplicationController
  def index
    @issues = DecoratedIssues.new(paginated_issues.preload(:labels, :language))
  end

  private

  def paginated_issues
    issues.paginate(page: params[:page])
  end

  def labels
    params[:label]
  end

  def language
    params[:language]
  end

  def issues
    return Issue.by_language_and_labels(language, labels) if language && labels
    return Issue.by_labels(labels) if labels
    return Issue.by_language(language) if language

    Issue.all
  end

  def paginated(collection)
    collection.paginate(page: params[:page])
  end
end
