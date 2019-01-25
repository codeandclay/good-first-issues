class DropIssuesLabelsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :issues_labels do |t|
      t.references :issue_id
      t.references :label_id
    end
  end
end
