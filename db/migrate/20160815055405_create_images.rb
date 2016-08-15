class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.text :image
      t.integer :author_id
      t.text :comment

      t.timestamps null: false
    end
  end
end
