require 'test_helper'

class IssuesControllerTest < ActionDispatch::IntegrationTest
  test 'The controller responds 200 when there are issues' do
    language = Language.new(name: 'C')
    label_a = Label.new(name: 'label a')
    label_b = Label.new(name: 'label b')
    10.times { Issue.create(
      language: language,
      labels: [label_a, label_b],
      url: 'https://example.com',
      user_avatar_url: 'https://example.com/image.png'
    ) }

    get issues_path
    assert_response :success
  end

  test 'The contoller repsonds 200 when there are missing urls' do
    language = Language.new(name: 'C')
    label_a = Label.new(name: 'label a')
    label_b = Label.new(name: 'label b')
    10.times { Issue.create(
      language: language,
      labels: [label_a, label_b]
    ) }

    get issues_path
    assert_response :success
  end
end
