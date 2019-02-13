class ApplicationController < ActionController::Base
  private

  def save_params_to_session
    # TODO: Fix this fudge.
    # Tags cannot be removed unless an empty string `['']` is sent in the
    # params `labels: ['']`. Otherwise the controller will look at the params
    # and see `nil` -- for instance, the pagination links don't send labels or
    # language params -- and decide not to change the session values.
    # Ideally I think I need a model/models to represent the session params.
    session[:language] = params[:language] unless params[:language].nil?
    session[:labels] = [*params[:labels]].reject(&:empty?) unless params[:labels].nil?
  end
end
