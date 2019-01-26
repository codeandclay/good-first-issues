class AddDefaultValuesToIssues < ActiveRecord::Migration[5.2]
  def change
    change_column :issues, :url, :string, default: ''
    change_column :issues, :user_avatar_url, :string, default: ''
  end
end
