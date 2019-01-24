class IssuesController < ApplicationController
  def index
    if tag = safe_params[:tag]
      @issues = Label.find_by(name: tag).issues.paginate(page: params[:page])
    else
      @issues = Issue.paginate(page: params[:page])
    end
  end

  private

  def safe_params
    params.permit(:tag)
  end
end
