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
    assert_equal 10, Issue.by_labels('Label').length
  end

  test 'A collection of issues is returned when multiple labels are given' do
    label_a = Label.create(name: 'Label A')
    label_b = Label.create(name: 'Label B')
    20.times {
      issue = Issue.create(language: @language)
      issue.labels << label_a
      issue.labels << label_b
    }
    assert_equal 20, Issue.by_labels(['Label A', 'Label B']).length
  end

  test 'A collection of issues is returned when a language name is given' do
    language = Language.create(name: 'The Language')
    10.times { Issue.create(language: language) }
    assert_equal 10, Issue.by_language('The Language').length
  end

  test 'A collection of issues is returned when language and labels are specified' do
    label_a = Label.create(name: 'bug')
    label_b = Label.create(name: 'fix')
    language_a = Language.create(name: 'Test Language A')
    2.times { Issue.create(language: language_a, labels: [label_a, label_b]) }
    3.times { Issue.create(language: language_a, labels: [label_a]) }
    5.times { Issue.create(language: language_a, labels: [label_b]) }
    assert_equal 5, Issue.by_language_and_labels('Test Language A', 'bug').length
  end

  test 'All labels are returned for an issue when filtering by label' do
    label_a = Label.create(name: 'bug')
    label_b = Label.create(name: 'fix')
    Issue.create(language: @language, labels: [label_a, label_b])
    assert_equal ['bug', 'fix'], Issue.by_labels('bug').first.labels.map(&:name)
  end

  test 'An issue must contain all labels used as filter' do
    label_a = Label.create(name: 'bug')
    label_b = Label.create(name: 'fix')
    label_c = Label.create(name: 'enhancement')
    label_d = Label.create(name: 'bounty')
    Issue.create(language: @language, labels: [label_a, label_b])
    Issue.create(language: @language, labels: [label_a, label_c])
    Issue.create(language: @language, labels: [label_b, label_d])
    assert_equal 1, Issue.by_labels(['bug', 'fix']).length
  end

  test 'An issue is returned once only if multiple tags match' do
    label_a = Label.create(name: 'bug')
    label_b = Label.create(name: 'fix')
    Issue.create(language: @language, labels: [label_a, label_b])
    assert_equal 1, Issue.by_labels(['bug', 'fix']).length
  end

  test 'Issue id is returned when a label name is provided' do
    label_a = Label.create(name: 'bug')
    label_b = Label.create(name: 'fix')
    Issue.create(language: @language, labels: [label_a, label_b])
    assert_equal [Issue.first.id], Issue.ids_for_label(label_a.name)
  end

  test 'Multiple issue ids are returned when a label name is provided' do
    label_a = Label.create(name: 'bug')
    label_b = Label.create(name: 'fix')
    issue_a = Issue.create(language: @language, labels: [label_a, label_b])
    issue_b = Issue.create(language: @language, labels: [label_a, label_b])
    assert_empty [issue_a.id, issue_b.id] - Issue.ids_for_label(label_a.name)
  end
end
