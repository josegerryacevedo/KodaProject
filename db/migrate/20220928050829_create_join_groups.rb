class CreateJoinGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :join_groups do |t|
      t.belongs_to :user
      t.belongs_to :group
      t.string :state
      t.integer :role
      t.timestamps
    end
  end
end