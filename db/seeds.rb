# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

locked_bot_permissions = []

user_permissions = [
  { name: 'Просмотр аукционов', action: :read, subject: 'Auction' },
  { name: 'Ставки', action: :create, subject: 'Bid' },
  { name: 'Профиль', action: :manage, subject: :profile }
]

bot_permissions = user_permissions

manager_permissions = user_permissions + [
  { name: 'Категории', action: :manage, subject: 'Category' },
  { name: 'Товары', action: :manage, subject: 'Product' },
  { name: 'Аукционы', action: :manage, subject: 'Auction' },
  { name: 'Панель управления', action: :read, subject: :admin_panel }
]

admin_permissions = manager_permissions + [
  { name: 'Пользователи', action: :manage, subject: 'User' },
  { name: 'Права', action: :manage, subject: 'Permission' }
]

admin_permissions.each do |permission|
  name = permission.delete(:name)
  p = Permission.where(permission).first
  if p.present?
    p.update(name: name)
  else
    Permission.create!(permission.merge(name: name))
  end
end

roles = [
  { name: 'admin' },
  { name: 'manager' },
  { name: 'user' },
  { name: 'bot' },
  { name: 'locked_bot' }
]

roles.each do |role_hash|
  role = Role.where(role_hash).first
  role = Role.create!(role_hash) unless role.present?
  Rails.logger.debug "Role #{role.name}"

  if role.permissions.empty?
    permissions = eval("#{role.name}_permissions")
    permissions.each do |permission_hash|
      permission = Permission.where(permission_hash).first
      role.permissions << permission
      Rails.logger.debug "   granted permission #{permission.name}"
    end
  end
end