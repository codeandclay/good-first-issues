module ApplicationHelper
  ADDITION_SYMBOL = '&#65291;'.freeze
  SUBTRACTION_SYMBOL = '&#65293;'.freeze

  class BaseTagOptions
    ADDITION_SYMBOL = '&#65291;'.freeze
    SUBTRACTION_SYMBOL = '&#65293;'.freeze

    def initialize(body:, params:)
      @params = params
      @body = body
    end

    def to_h
      {
        body: body,
        params: new_params,
        symbol: symbol
      }
    end

    private

    attr_accessor :params, :body

    def action
      raise NotImplementedError
    end

    def symbol
      return SUBTRACTION_SYMBOL if action == :remove
      ADDITION_SYMBOL
    end

    def new_params
      raise NotImplementedError
    end
  end

  class LanguageTagOptions < BaseTagOptions
    def to_h
      super.merge(css_class: 'language-badge')
    end

    private

    def action
      return :remove if params[:language] == body
      :add
    end

    def new_params
      return { labels: params[:labels] } if action == :remove
      { labels: params[:labels], language: body }
    end
  end

  class LabelTagOptions < BaseTagOptions
    def to_h
      super.merge(css_class: 'label-badge')
    end

    private

    def action
      return :remove if [*params[:labels]].include?(body)
      :add
    end

    def new_params
      return { language: params['language'], labels: [*params[:labels]] + [body] } if action == :add
      { language: params['language'], labels: [*params[:labels]].reject { |i| i == body } }
    end
  end

  def language_link(name: params[:language], is_remote: false)
    return button_tag_for(LanguageTagOptions.new(body: name, params: params).to_h) if is_remote
    link_tag_for(LanguageTagOptions.new(body: name, params: params).to_h)
  end

  def label_link(name:, is_remote: false)
    return button_tag_for(LabelTagOptions.new(body: name, params: params).to_h) if is_remote
    link_tag_for(LabelTagOptions.new(body: name, params: params).to_h)
  end

  def labels
    return [] if params['labels'].nil?
    params['labels']
  end

  def selected_labels_links
    labels.map do |label|
      label_link(name: label)
    end.join(' ').html_safe
  end

  def link_tag_for(
    symbol: SUBTRACTION_SYMBOL,
    body:, params: {},
    css_class: 'badge',
    path: controller_path
  )
    link_to "#{sanitize(symbol)} #{body}", send(path, params), class: css_class
  end

  def button_tag_for(
    symbol: SUBTRACTION_SYMBOL,
    body:, params: {},
    css_class: 'badge',
    path: controller_path
  )
    button_to "#{sanitize(symbol)} #{body}", send(path, params), class: css_class, remote: true
  end

  def controller_path
    "#{controller_name}_path".to_sym
  end

  def params?
    params[:labels] || params[:language]
  end
end
