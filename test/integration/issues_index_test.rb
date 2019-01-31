require 'test_helper'

class IssuesIndexTest < ActionDispatch::IntegrationTest
  test 'an issue will be displayed with all its labels when only one is provided in params' do
    language = Language.new(name: 'C')
    label_a = Label.new(name: 'label a')
    label_b = Label.new(name: 'label b')
    Issue.create(
      language: language,
      labels: [label_a, label_b],
      url: 'https://example.com',
      user_avatar_url: 'https://example.com/image.png'
    )

    get '/issues?labels=label+a'
    assert_select 'a', 'label b'
  end

  test 'an issue will be shown that matches the provided label and language params' do
    language_a = Language.new(name: 'C')
    language_b = Language.new(name: 'D')
    label_a = Label.new(name: 'label a')
    label_b = Label.new(name: 'label b')
    Issue.create(
      language: language_a,
      labels: [label_a],
      url: 'https://example.com',
      user_avatar_url: 'https://example.com/image.png'
    )
    Issue.create(
      language: language_b,
      labels: [label_a],
      url: 'https://example.com',
      user_avatar_url: 'https://example.com/image.png'
    )
    get '/issues?label=label+a&language=C'
    assert_select 'a', 'C'
    assert_select 'a', 'label a'
  end
end
