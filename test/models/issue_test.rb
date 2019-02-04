require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  def setup
    @language = Language.create(name: 'Test Language')
    @test_issue = Issue.create(language: @language)
  end

  test 'A row can be created' do
    assert true, Issue.create
  end

  test 'An issue can have labels' do
    row = @test_issue
    row.labels << Label.create(name: 'Label One')
    row.labels << Label.create(name: 'Label Two')
    assert_equal 2, row.labels.count
  end

  test 'A collection of issues is returned when a label name is given' do
    label = Label.create(name: 'Label')
    10.times { label.issues << Issue.create(language: @language) }
    assert_equal 10, Issue.by_labels('Label').count
  end

  test 'A collection of issues is returned when multiple labels are given' do
    label_a = Label.create(name: 'Label A')
    label_b = Label.create(name: 'Label B')
    10.times { label_a.issues << Issue.create(language: @language) }
    10.times { label_b.issues << Issue.create(language: @language) }
    assert_equal 20, Issue.by_labels(['Label A', 'Label B']).count
  end

  test 'A collection of issues is returned when a language name is given' do
    language = Language.create(name: 'The Language')
    10.times { Issue.create(language: language) }
    assert_equal 10, Issue.by_language('The Language').count
  end

  test 'A collection of issues is returned when language and labels are specified' do
    label_a = Label.create(name: 'bug')
    label_b = Label.create(name: 'fix')
    language_a = Language.create(name: 'Test Language A')
    2.times { Issue.create(language: language_a, labels: [label_a, label_b]) }
    3.times { Issue.create(language: language_a, labels: [label_a]) }
    5.times { Issue.create(language: language_a, labels: [label_b]) }
    assert_equal 5, Issue.by_language_and_labels('Test Language A', 'bug').count
  end

  test 'All labels are returned for an issue when filtering by label' do
    label_a = Label.create(name: 'bug')
    label_b = Label.create(name: 'fix')
    Issue.create(language: @language, labels: [label_a, label_b])
    assert_equal ['bug', 'fix'], Issue.by_labels('bug').first.labels.map(&:name)
  end
end
