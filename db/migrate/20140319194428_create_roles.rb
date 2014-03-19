class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
    end

    change_table :users do |t|
      t.remove :role
      t.references :role, index: true
    end

    User.all.each { |user| user.update!(role: Role.default_role) }
  end
end
