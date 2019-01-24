class IssuesController < ApplicationController
  def index
    if label = params[:label]
      @issues = paginated(Issue.by_label(label).includes(:labels))
    elsif language = params[:language]
      @issues = paginated(Issue.by_language(language).includes(:labels))
    else
      @issues = paginated(Issue.all.includes(:labels))
    end
    @title = IndexTitle.new(params).to_s
  end

  private

  def paginated(collection)
    collection.paginate(page: params[:page])
  end
end
