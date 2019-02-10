class AddIndexOnNameToLanguages < ActiveRecord::Migration[5.2]
  def change
    add_index :languages, :name
  end
end
