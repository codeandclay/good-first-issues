require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  test 'A label can be created' do
    assert true, Label.create
  end

  test 'A label can be assigned to an issue' do
    label = Label.create(name: 'Test')
    issue = Issue.create
    issue.labels << label
    assert_equal 1, label.issues.count
  end

  test 'A label can be assigned to multiple issues' do
    label = Label.create(name: 'Test')
    issue_a = Issue.create
    issue_b = Issue.create
    issue_a.labels << label
    issue_b.labels << label
    assert_equal 2, label.issues.count
  end
end
