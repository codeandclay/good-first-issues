class IssuesController < ApplicationController
  def index
    if tag = safe_params[:tag]
      @issues = paginated(Label.find_by(name: tag).issues)
    elsif language = safe_params[:language]
      @issues = paginated(Issue.where(language: language))
    else
      @issues = Issue.paginate(page: params[:page])
    end
  end

  private

  def paginated(collection)
    collection.paginate(page: params[:page])
  end

  def safe_params
    params.permit(:tag, :language)
  end
end
