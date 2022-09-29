class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.belongs_to :user
      t.string :banner
      t.integer :genre
      t.string :description
      t.timestamps
    end
  end
end