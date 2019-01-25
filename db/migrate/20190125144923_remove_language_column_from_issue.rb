class RemoveLanguageColumnFromIssue < ActiveRecord::Migration[5.2]
  def change
    remove_column :issues, :language, :string
  end
end
