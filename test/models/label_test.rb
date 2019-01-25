require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  def setup
    @language = Language.create
  end

  test 'A label can be created' do
    assert Label.create
  end

  test 'A label can be assigned to an issue' do
    label = Label.create(name: 'Test')
    issue = Issue.create(language: @language)
    issue.labels << label
    assert_equal 1, label.issues.count
  end

  test 'A label can be assigned to multiple issues' do
    label = Label.create(name: 'Test')
    issue_a = Issue.create(language: @language)
    issue_b = Issue.create(language: @language)
    issue_a.labels << label
    issue_b.labels << label
    assert_equal 2, label.issues.count
  end

  test 'Label names are unique' do
    Label.create(name: 'Example Label')
    assert_raises(ActiveRecord::RecordNotUnique) do
      Label.create(name: 'Example Label')
    end
  end
end
