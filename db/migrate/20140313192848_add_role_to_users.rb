class AddRoleToUsers < ActiveRecord::Migration
  def up
    add_column :users, :role, :string, default: 'user'

    User.all.each do |user|
      user.update!(role: 'admin') if user.is_admin
    end

    remove_column :users, :is_admin
  end

  def down
    add_column :users, :is_admin, :boolean

    User.all.each do |user|
      user.update!(is_admin: true) if user.role == 'admin'
    end

    remove_column :users, :role
  end
end
