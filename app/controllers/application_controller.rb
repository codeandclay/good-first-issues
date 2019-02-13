class ApplicationController < ActionController::Base
  private

  def save_params_to_session
    session[:language] = params[:language]
    session[:labels] = params[:labels]
  end
end
