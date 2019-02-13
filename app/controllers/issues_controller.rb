class IssuesController < ApplicationController
  before_action :save_params_to_session, only: [:index, :create]

  def index
    @issues = DecoratedIssues.new(paginated_issues.preload(:labels, :language))
  end

  def create
    @issues = DecoratedIssues.new(paginated_issues.preload(:labels, :language))
    respond_to do |format|
      format.js
    end
  end

  private

  def paginated_issues
    issues.paginate(page: params[:page])
  end

  def labels
    return if session[:labels].nil?
    session[:labels]
  end

  def language
    session[:language]
  end

  def issues
    Issue.by_language_and_labels(language, labels)
  end

  def paginated(collection)
    collection.paginate(page: params[:page])
  end
end
