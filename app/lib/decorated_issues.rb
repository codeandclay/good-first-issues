class DecoratedIssues < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def title
    "Found #{pluralize(total_entries, 'issues')}"
  end
end
