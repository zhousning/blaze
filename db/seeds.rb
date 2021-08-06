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

100.times.each do |t|
  pdt_date = Faker::Date.unique.between(from: '2021-05-01', to: '2021-9-25')
  DayPdtRpt.create!(
    :factory => @qufu_one_fct,
    :name => pdt_date.to_s + @qufu_one_fct.name + "生产运营数据", :pdt_date => pdt_date, :weather => '晴', :temper => Faker::Number.between(from: -10, to: 35), 
    :inf_qlty_bod => Faker::Number.within(range: 10..100), :inf_qlty_cod => Faker::Number.within(range: 10..100), :inf_qlty_ss => Faker::Number.within(range: 10..100), :inf_qlty_nhn => Faker::Number.within(range: 10..100), :inf_qlty_tn => Faker::Number.within(range: 10..100), :inf_qlty_tp => Faker::Number.within(range: 10..100), :inf_qlty_ph => Faker::Number.between(from: 0, to: 14), 
    :eff_qlty_bod => Faker::Number.within(range: 10..100), :eff_qlty_cod => Faker::Number.within(range: 10..100), :eff_qlty_ss => Faker::Number.within(range: 10..100), :eff_qlty_nhn => Faker::Number.within(range: 10..100), :eff_qlty_tn => Faker::Number.within(range: 10..100), :eff_qlty_tp => Faker::Number.within(range: 10..100), :eff_qlty_ph => Faker::Number.between(from: 0, to: 14), :eff_qlty_fecal => Faker::Number.within(range: 10..100),  
    :sed_qlty_bod => Faker::Number.within(range: 10..100), :sed_qlty_cod => Faker::Number.within(range: 10..100), :sed_qlty_ss => Faker::Number.within(range: 10..100), :sed_qlty_nhn => Faker::Number.within(range: 10..100), :sed_qlty_tn => Faker::Number.within(range: 10..100), :sed_qlty_tp => Faker::Number.within(range: 10..100), :sed_qlty_ph => Faker::Number.between(from: 0, to: 14), 
    :inflow => Faker::Number.within(range: 10..100), :outflow => Faker::Number.within(range: 10..100), :inmud => Faker::Number.within(range: 10..100), :outmud => Faker::Number.within(range: 10..100), :mst => Faker::Number.within(range: 10..100), :power => Faker::Number.within(range: 10..100), :mdflow => Faker::Number.within(range: 10..100), :mdrcy => Faker::Number.within(range: 10..100), :mdsell => Faker::Number.within(range: 10..100)
  )
end

Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.cod,     :name => Setting.inf_qlties.cod)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.bod,     :name => Setting.inf_qlties.bod)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.ss,      :name => Setting.inf_qlties.ss)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.nhn,     :name => Setting.inf_qlties.nhn)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.tn,      :name => Setting.inf_qlties.tn)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.tp,      :name => Setting.inf_qlties.tp)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.ph,      :name => Setting.inf_qlties.ph)
Quota.create!(:ctg => Setting.quota.ctg_flow, :code => Setting.quota.inflow , :name => Setting.day_pdt_rpts.inflow  )
Quota.create!(:ctg => Setting.quota.ctg_flow, :code => Setting.quota.outflow, :name => Setting.day_pdt_rpts.outflow )
Quota.create!(:ctg => Setting.quota.ctg_mud, :code => Setting.quota.inmud  , :name => Setting.day_pdt_rpts.inmud   )
Quota.create!(:ctg => Setting.quota.ctg_mud, :code => Setting.quota.outmud , :name => Setting.day_pdt_rpts.outmud  )
Quota.create!(:ctg => Setting.quota.ctg_mud, :code => Setting.quota.mst    , :name => Setting.day_pdt_rpts.mst     )
Quota.create!(:ctg => Setting.quota.ctg_power, :code => Setting.quota.power  , :name => Setting.day_pdt_rpts.power   )
Quota.create!(:ctg => Setting.quota.ctg_md, :code => Setting.quota.mdflow , :name => Setting.day_pdt_rpts.mdflow  )
Quota.create!(:ctg => Setting.quota.ctg_md, :code => Setting.quota.mdrcy  , :name => Setting.day_pdt_rpts.mdrcy   )
Quota.create!(:ctg => Setting.quota.ctg_md, :code => Setting.quota.mdsell , :name => Setting.day_pdt_rpts.mdsell  )
#Quota.create!(:ctg => , :code => , :name => )











