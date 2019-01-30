class DecoratedIssues < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def title
    return default_title if where_clause.to_h.empty?

    specific_title
  end

  def updated_at
    first.updated_at
  end

  def top_labels
    Label.top
  end

  def top_languages
    Language.top
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
