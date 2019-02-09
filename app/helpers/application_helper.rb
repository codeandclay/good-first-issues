module ApplicationHelper
  ADDITION_SYMBOL = '&#65291;'.freeze
  SUBTRACTION_SYMBOL = '&#65293;'.freeze

  def language_link(name: params[:language], is_remote: false)
    if action_for_language(name) == :remove
      base_tag_link(
        body: name,
        css_class: 'language-badge',
        params: { labels: params[:labels] },
        method: link_method(is_remote)
      )
    else
      base_tag_link(
        body: name,
        css_class: 'language-badge',
        params: { labels: params['labels'], language: name },
        method: link_method(is_remote),
        symbol: ADDITION_SYMBOL
      )
    end
  end

  def label_link(name:, is_remote: false)
    if action_for_label(name) == :remove
      base_tag_link(
        body: name,
        css_class: 'label-badge',
        params: {
          language: params['language'],
          labels: labels.reject { |i| i == name }
        },
        method: link_method(is_remote)
      )
    else
      base_tag_link(
        body: name,
        css_class: 'label-badge',
        params: {
          language: params['language'],
          labels: labels + [name]
        },
        method: link_method(is_remote),
        symbol: ADDITION_SYMBOL
      )
    end
  end

  def labels
    return [] if params['labels'].nil?
    params['labels']
  end

  def link_method(is_remote)
    return :button_to if is_remote
    :link_to
  end

  def action_for_language(name)
    return :remove if params[:language] == name
    :add
  end

  def action_for_label(name)
    return :remove if [*params[:labels]].include?(name)
    :add
  end

  def remove_labels_links
    labels.map do |label|
      label_link(name: label)
    end.join(' ').html_safe
  end

  def base_tag_link(method: :link_to, symbol: SUBTRACTION_SYMBOL, body:, params: {}, css_class: 'badge')
    send(method, "#{sanitize(symbol)} #{body}", send(controller_path, params), class: css_class)
  end

  def controller_path
    "#{controller_name}_path".to_sym
  end

  def params?
    params[:labels] || params[:language]
  end
end
