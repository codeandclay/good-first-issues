require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  test 'A row can be created' do
    assert true, Issue.create
  end

  test 'An issue can have labels' do
    row = Issue.create
    row.labels << Label.create(name: 'Label One')
    row.labels << Label.create(name: 'Label Two')
    assert_equal 2, row.labels.count
  end

  test 'A collection of issues is returned when a label name is given' do
    label = Label.create(name: 'Label')
    10.times { label.issues << Issue.create }
    assert_equal 10, Issue.by_label('Label').count
  end

  test 'A collection of issues is returned whena language name is given' do
    10.times { Issue.create(language: 'Test') }
    assert_equal 10, Issue.by_language('Test').count
  end
end
