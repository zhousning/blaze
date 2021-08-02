# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

role = Role.create(:name => Setting.roles.super_admin)

admin_permissions = Permission.create(:name => Setting.permissions.super_admin, :subject_class => Setting.admins.class_name, :action => "manage")

role.permissions << admin_permissions

user = User.new(:phone => Setting.admins.phone, :password => Setting.admins.password, :password_confirmation => Setting.admins.password)
user.save!

user.roles = []
user.roles << role

AdminUser.create!(:phone => Setting.admins.phone, :email => Setting.admins.email, :password => Setting.admins.password, :password_confirmation => Setting.admins.password)

@user = User.create!(:phone => "15763703188", :password => "15763703188", :password_confirmation => "15763703188")

@company = Company.create!(:area => "曲阜", :name => "曲阜污水处理厂")
@qufu_one_fct = Factory.create!(:area => "曲阜", :name => "曲阜第一污水处理厂", :company => @company)
@qufu_thd_fct = Factory.create!(:area => "曲阜", :name => "曲阜第三污水处理厂", :company => @company)
@user.factories << @qufu_one_fct
@user.factories << @qufu_thd_fct
