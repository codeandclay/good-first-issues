module ApplicationHelper
  ADDITION_SYMBOL = '&#65291;'.freeze
  SUBTRACTION_SYMBOL = '&#65293;'.freeze

  class BaseTagOptions
    ADDITION_SYMBOL = '&#65291;'.freeze
    SUBTRACTION_SYMBOL = '&#65293;'.freeze

    def initialize(body:, tags:)
      @tags = tags
      @body = body
    end

    def to_h
      {
        body: body,
        params: new_tags,
        symbol: symbol
      }
    end

    private

    attr_accessor :tags, :body

    def action
      raise NotImplementedError
    end

    def symbol
      return SUBTRACTION_SYMBOL if action == :remove
      ADDITION_SYMBOL
    end

    def new_tags
      raise NotImplementedError
    end
  end

  class LanguageTagOptions < BaseTagOptions
    def to_h
      super.merge(css_class: 'language-badge')
    end

    private

    def action
      return :remove if tags[:language] == body
      :add
    end

    def new_tags
      return { labels: tags[:labels] } if action == :remove
      { labels: tags[:labels], language: body }
    end
  end

  class LabelTagOptions < BaseTagOptions
    def to_h
      super.merge(css_class: 'label-badge')
    end

    private

    def action
      return :remove if [*tags[:labels]].include?(body)
      :add
    end

    def new_tags
      return { language: tags[:language], labels: [*tags[:labels]] + [body] } if action == :add
      { language: tags[:language], labels: [*tags[:labels]].reject { |i| i == body } }
    end
  end

  def language_link(name: language, is_remote: false)
    tags = {language: language, labels: labels}
    return button_tag_for(LanguageTagOptions.new(body: name, tags: tags).to_h) if is_remote
    link_tag_for(LanguageTagOptions.new(body: name, tags: tags).to_h)
  end

  def label_link(name:, is_remote: false)
    tags = {language: language, labels: labels}
    return button_tag_for(LabelTagOptions.new(body: name, tags: tags).to_h) if is_remote
    link_tag_for(LabelTagOptions.new(body: name, tags: tags).to_h)
  end

  def selected_labels_links
    labels.map do |label|
      label_link(name: label, is_remote: true)
    end.join(' ').html_safe
  end

  def link_tag_for(
    symbol: SUBTRACTION_SYMBOL,
    body:,
    params: {},
    css_class: 'badge',
    path: controller_path
  )
    link_to "#{sanitize(symbol)} #{body}", issues_path(params), class: css_class
  end

  def button_tag_for(
    symbol: SUBTRACTION_SYMBOL,
    body:,
    params: {},
    css_class: 'badge',
    path: controller_path
  )
    button_to "#{sanitize(symbol)} #{body}", issues_path(params), class: css_class, remote: true
  end

  def controller_path
    "#{controller_name}_path".to_sym
  end

  def params?
    labels.present? || language
  end

  def labels
    return [] if params['labels'].nil?
    params['labels']
  end

  def language
    params[:language]
  end
end
