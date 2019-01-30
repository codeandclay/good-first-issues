class RemoveIssueIdFromLabels < ActiveRecord::Migration[5.2]
  def change
    remove_reference :labels, :issue, index: true, foreign_key: true
  end
end
