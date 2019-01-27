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

  # Note: I cannot get this to fail so I have commented it out. See note in
  # the contoller. Once I know what's going on, I expect I will be able to
  # implement this test.

  # test 'The controller returns issues with expected labels per row' do
  #   language = Language.new(name: 'C')
  #   label_a = Label.new(name: 'label a')
  #   label_b = Label.new(name: 'label b')
  #   Issue.create(
  #     language: language,
  #     labels: [label_a, label_b],
  #     url: 'https://example.com',
  #     user_avatar_url: 'https://example.com/image.png'
  #   )

  #   get issues_path
  #   expected = ["label a", "label b"]
  #   actual = assigns(:issues).first.labels.map { |label| label.name }
  #   assert_equal  expected, actual
  # end
end
