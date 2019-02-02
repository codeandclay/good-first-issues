require 'test_helper'

class IssuesControllerTest < ActionDispatch::IntegrationTest
    def setup
    set_instance_variables = Proc.new { |k,v| instance_variable_set("@#{k}", v) }

    @languages = {
      'language_a' => 'Language A',
      'language_b' => 'Language B',
      'language_c' => 'Language C',
      'language_d' => 'Language D'
    }.map do |k,v|
      instance_variable_set("@#{k}", v)
    end

    @labels = {
      'label_a' => 'Label A',
      'label_b' => 'Label B',
      'label_c' => 'Label C',
      'label_d' => 'Label D'
    }.map do |k,v|
      instance_variable_set("@#{k}", v)
    end

    @issues = @languages.zip(@labels).map do |language, label|
      Issue.create(
        language: Language.create(name: language),
        labels: [Label.create(name: label)]
      )
    end
  end

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

  test 'The controller returns issues with expected labels per row' do
    language = Language.new(name: 'C')
    label_a = Label.new(name: 'label a')
    label_b = Label.new(name: 'label b')
    Issue.create(
      language: language,
      labels: [label_a, label_b],
      url: 'https://example.com',
      user_avatar_url: 'https://example.com/image.png'
    )

    get issues_path
    expected = ["label a", "label b"]
    actual = assigns(:issues).first.labels.map { |label| label.name }
    assert_equal  expected, actual
  end

  test 'an issue will be displayed with all its labels when only one is provided in params' do
    @issues.first.labels << Label.create(name: 'Label X')
    get '/issues?labels=Label+A'
    actual = assigns(:issues).first.labels.map(&:name)
    assert_equal ['Label A', 'Label X'], actual
  end

  test 'issues will be shown that intersecy the provide labels and languages params' do
    @issues.first.labels << Label.create(name: 'Label X')
    @issues.last.labels << Label.first_or_create(name: 'Label X')
    get '/issues?languages=Language+A&labels=Label+X'
    assert_equal 1, assigns(:issues).count
  end
end
