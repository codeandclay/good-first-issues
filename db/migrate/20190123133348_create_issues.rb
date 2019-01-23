class CreateIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :issues do |t|
      t.boolean :assigned
      t.text :description
      t.string :language
      t.string :repo_name
      t.string :title
      t.string :url
      t.string :user_avatar_url

      t.timestamps
    end
  end
end
