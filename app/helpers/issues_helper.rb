module IssuesHelper
  def combined_labels(label)
    if params['labels'].nil?
      labels = []
    else
      labels = JSON.parse params['labels']
    end

    (labels + [label]).to_json
  end
end
