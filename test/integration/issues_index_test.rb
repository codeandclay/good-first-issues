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
end
