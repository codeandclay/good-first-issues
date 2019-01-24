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
    assert_equal 10, Issue.by_labels('Label').count
  end

  test 'A collection of issues is returned when multiple labels are given' do
    label_a = Label.create(name: 'Label A')
    label_b = Label.create(name: 'Label B')
    10.times { label_a.issues << Issue.create }
    10.times { label_b.issues << Issue.create }
    assert_equal 20, Issue.by_labels(['Label A', 'Label B']).count
  end

  test 'A collection of issues is returned whena language name is given' do
    10.times { Issue.create(language: 'Test') }
    assert_equal 10, Issue.by_language('Test').count
  end
end
