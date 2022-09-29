class AddColumnToJoinGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :join_groups, :is_owner, :boolean, default: 0
  end
end