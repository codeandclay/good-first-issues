class AddLanguageIdToIssue < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :language_id, :integer
  end
end
