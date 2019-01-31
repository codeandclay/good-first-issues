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

  def languages
    params[:language]
  end

  def issues
    # TODO: Is this possible to achieve in a single query?
    return Issue.by_languages_and_labels(languages, labels) if languages && labels
    return Issue.by_labels(labels) if labels
    return Issue.by_languages(languages) if languages

    Issue.all
  end

  def paginated(collection)
    collection.paginate(page: params[:page])
  end
end
