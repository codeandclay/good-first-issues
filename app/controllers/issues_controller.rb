class IssuesController < ApplicationController
  def index
    @issues = issues.includes(:labels).paginate(page: params[:page])
    @title = IndexTitle.new(params).to_s
  end

  private

  def labels
    params[:label]
  end

  def issues
    return Issue.by_labels(labels) if labels
    return Issue.by_language(language) if language

    Issue.all
  end

  def language
    params[:language]
  end

  def paginated(collection)
    collection.paginate(page: params[:page])
  end
end
