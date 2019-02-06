class DecoratedIssues < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def title
    default_title
  end

  def updated_at
    Issue.first.updated_at
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
end
