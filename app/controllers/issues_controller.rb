class IssuesController < ApplicationController
  def index
    if label = params[:label]
      @issues = paginated(Issue.by_label(label).includes(:labels))
    elsif language = params[:language]
      @issues = paginated(Issue.by_language(language).includes(:labels))
    else
      @issues = paginated(Issue.all.includes(:labels))
    end
    @title = title
  end

  private

  def title
    language_title || issue_title || base_title
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
end
