class DecoratedIssues < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def title
    return default_title if where_clause.to_h.empty?

    specific_title
  end

  private

  def default_title
    "Found #{pluralize(total_entries, 'issues')}"
  end

  def specific_title
    "Found #{pluralize(total_entries, 'issues')} "\
     "matching #{where_clause.to_h.values.join(' + ')}"
  end
end
