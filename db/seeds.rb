# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

[
  { name: 'admin' },
  { name: 'manager' },
  { name: 'user' },
  { name: 'bot' }
].each do |role|
  r = Role.where(role).first
  Role.create!(role) unless p.present?
end

[
  { name: 'Категории', action: :manage, subject: 'Category' },
  { name: 'Товары', action: :manage, subject: 'Product' },
  { name: 'Аукционы', action: :manage, subject: 'Auction' },
  { name: 'Пользователи', action: :manage, subject: 'User' },
  { name: 'Права', action: :manage, subject: 'Permission' },

  { name: 'Панель управления', action: :read, subject: :admin_panel },
  { name: 'Просмотр аукционов', action: :read, subject: 'Auction' },

  { name: 'Ставки', action: :create, subject: 'Bid' },
  { name: 'Профиль', action: :manage, subject: :profile }
].each do |permission|
  name = permission.delete(:name)
  p = Permission.where(permission).first
  if p.present?
    p.update(name: name)
  else
    Permission.create!(permission.merge(name: name))
  end
end