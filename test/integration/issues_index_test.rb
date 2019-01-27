require 'test_helper'

class IssuesIndexTest < ActionDispatch::IntegrationTest
  test 'the truth' do
    language = Language.new(name: 'C')
    label_a = Label.new(name: 'label a')
    label_b = Label.new(name: 'label b')
    Issue.create(
      language: language,
      labels: [label_a, label_b],
      url: 'https://example.com',
      user_avatar_url: 'https://example.com/image.png'
    )

    get '/issues?label=label+a'
    assert_select 'a', 'label b'
  end
end
