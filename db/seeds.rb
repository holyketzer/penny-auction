# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Role.delete_all

[
  { name: 'admin' },
  { name: 'manager' },
  { name: 'user' },
  { name: 'bot' }
].each do |role|
  Role.create!(role)
end