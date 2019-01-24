class IssuesController < ApplicationController
  def index
    if label = safe_params[:label]
      @issues = paginated(Issue.by_label(label))
    elsif language = safe_params[:language]
      @issues = paginated(Issue.by_language(language))
    else
      @issues = paginated(Issue)
    end
  end

  private

  def paginated(collection)
    collection.paginate(page: params[:page])
  end

  def safe_params
    params.permit(:label, :language)
  end
end
