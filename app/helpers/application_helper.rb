module ApplicationHelper
  def language_link(language)
    return selected_language_link if language == params['language']
    add_language_link(language)
  end

  def selected_language_link
    return if params['language'].nil?

    base_tag_link(
      body: params['language'],
      params: { labels: params[:labels] },
      css_class: 'language-badge'
    )
  end

  def add_language_link(language)
    base_tag_link(
      symbol: '&#65291;',
      body: language,
      params: { labels: params['labels'], language: language },
      css_class: 'language-badge'
    )
  end

  def label_link(label)
    return add_label_link(label) unless labels.include?(label)
    selected_label_link(label)
  end

  def selected_label_link(label)
    base_tag_link(
      body: label,
      params: {
        language: params['language'],
        labels: labels.reject { |i| i == label }
      },
      css_class: 'label-badge'
    )
  end

  def add_label_link(label)
    base_tag_link(
      body: label,
      symbol: '&#65291;',
      params: {
        language: params['language'],
        labels: labels + [label]
      },
      css_class: 'label-badge'
    )
  end

  def selected_labels_links
    return if params['labels'].nil?

    labels.map do |label|
      selected_label_link(label)
    end.join(' ').html_safe
  end

  def base_tag_link(symbol: '&#65293;', body:, params: {}, css_class: 'badge')
    link_to "#{sanitize(symbol)} #{body}", send(request_view.to_sym, params), class: css_class
  end

  def request_view
    "#{request.path[/\w+/] || 'root'}_path"
  end

  def labels
    return [] if params['labels'].nil?
    params['labels']
  end
end
