class IndexTitle
  def initialize(params)
    @params = params
  end

  def to_s
    language_title || issue_title || base_title
  end

  private

  attr_accessor :params

  def language_title
    "#{params[:language]} issues" if params[:language]
  end

  def issue_title
    "Issues labelled #{params[:label]}" if params[:label]
  end

  def base_title
    'All issues'
  end
end
