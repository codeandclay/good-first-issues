class IssuesController < ApplicationController
  def index
    if label = safe_params[:label]
      @issues = paginated(Issue.by_label(label))
    elsif language = safe_params[:language]
      @issues = paginated(Issue.by_language(language))
    else
      @issues = paginated(Issue)
    end
    @title = title
  end

  private

  def title
    # language_title || issue_title || base_title
  end

  def language_title
    "#{params[:language]} issues" if params[:language]
  end

  def issue_title
    "Issues labelled #{params[:label]}" if params[:label]
  end

  def base_title
    'All issues'
  end

  def paginated(collection)
    collection.paginate(page: params[:page])
  end

  def safe_params
    params.permit(:label, :language)
  end
end
