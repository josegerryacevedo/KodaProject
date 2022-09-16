class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :audience
      t.belongs_to :user
      t.string :image
      t.timestamps
    end
  end
end