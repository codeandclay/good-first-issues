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
    Label.left_joins(:issues)
         .group(:id)
         .order('COUNT("issue.id") DESC')
         .where.not('labels.name': nil)
         .distinct.pluck(:name)
         .take(10)
  end

  def top_languages
    Language.left_joins(:issues)
           .group(:id)
           .order('COUNT("issue.id") DESC')
           .where.not('languages.name': nil)
           .distinct.pluck(:name)
           .take(20)
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
