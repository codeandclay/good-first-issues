module ApplicationHelper
  def combined_labels(label_name)
    if params['labels'].nil?
      labels = []
    else
      labels = JSON.parse params['labels']
    end

    return labels.to_json if labels.include? label_name

    (labels + [label_name]).to_json
  end

  def labels_without_label(label_name)
    labels = JSON.parse params['labels']
    (labels.delete_if { |i| i == label_name }).to_json
  end

  def language_link(language_name)
    if params['language'] == language_name
      link_to language_name_to_remove(language_name), issues_path(labels: params['labels']), class: 'language-badge'
    else
      link_to language_name_to_add(language_name), issues_path(language: language_name, labels: params['labels']), class: 'language-badge'
    end
  end

  def language_name_to_add(language_name)
    add_language = "#{sanitize('&#65291;')} #{language_name}"
    return add_language if params['language'].nil?
    return language_name if params['language'] == language_name
    add_language
  end

  def language_name_to_remove(language_name)
    remove_language = "#{sanitize('&#65293;')} #{language_name}"
  end

  def label_link(label_name)
    if params['labels'] and JSON.parse(params['labels']).include? label_name
      link_to label_name_to_remove(label_name), issues_path(labels: labels_without_label(label_name), language: params['language']), class: 'label-badge'
    else
      link_to label_name_to_add(label_name), issues_path(labels: combined_labels(label_name), language: params['language']), class: 'label-badge'
    end
  end

  def label_name_to_add(label_name)
    add_label = "#{sanitize('&#65291;')} #{label_name}"
    return add_label if params['labels'].nil?
    return label_name if JSON.parse(params['labels']).include? label_name
    add_label
  end

  def label_name_to_remove(label_name)
    "#{sanitize('&#65293;')} #{label_name}"
  end
end
