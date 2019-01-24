class IssuesController < ApplicationController
  def index
    @issues = Issue.paginate(page: params[:page])
  end
end
