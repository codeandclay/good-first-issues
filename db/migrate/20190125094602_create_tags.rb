class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.references :issue
      t.references :label
      t.timestamps
    end
  end
end
