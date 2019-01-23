class CreateJoinTableIssuesLabels < ActiveRecord::Migration[5.2]
  def change
    create_join_table :issues, :labels do |t|
      t.index [:issue_id, :label_id]
      t.index [:label_id, :issue_id]
    end
  end
end
