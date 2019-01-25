class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.references :issues
      t.references :labels
      t.timestamps
    end
  end
end
