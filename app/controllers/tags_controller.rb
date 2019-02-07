class TagsController < ApplicationController
  def index
    @languages = Issue.includes(:language).distinct.pluck(:name).sort_by(&:downcase)
    @labels = Issue.includes(:labels)
                   .where
                   .not('labels.name': nil)
                   .distinct
                   .pluck(:name)
                   .sort_by(&:downcase)
    @number_of_issues = Issue.number_of_issues_for(language: params[:language], labels: params[:labels])
    @top_languages = Language.top
    @top_labels = Label.top
  end
end
