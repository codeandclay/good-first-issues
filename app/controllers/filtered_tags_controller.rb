class FilteredTagsController < ApplicationController
  before_action :save_params_to_session, only: :create

  def create
    @labels = Label.by_search_term(params[:filter_by])
    respond_to do |format|
      format.js
    end
  end
end
