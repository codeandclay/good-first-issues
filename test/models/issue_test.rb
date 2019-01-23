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
end
