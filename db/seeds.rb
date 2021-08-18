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

@role_day_pdt        = Role.where(:name => Setting.roles.day_pdt).first
@role_day_rpt        = Role.where(:name => Setting.roles.day_pdt_rpt).first
@role_mth_rpt        = Role.where(:name => Setting.roles.mth_pdt_rpt).first

@role_day_pdt_verify = Role.where(:name => Setting.roles.day_pdt_verify).first
@role_mth_rpt_verify = Role.where(:name => Setting.roles.mth_pdt_rpt_verify).first

@role_data_cube      = Role.where(:name => Setting.roles.data_cube).first
@role_data_compare   = Role.where(:name => Setting.roles.data_compare).first

@data_filler  = [@role_day_pdt , @role_day_rpt, @role_mth_rpt, @role_data_compare ,@role_data_cube]
@data_verifer = [@role_day_rpt, @role_day_pdt_verify, @role_mth_rpt_verify, @role_data_compare ,@role_data_cube ]

@renc = Company.create!(:area => "任城区", :name => "任城污水处理厂")
@jinx = Company.create!(:area => "金乡县", :name => "达斯玛特污水处理厂")
@jiax = Company.create!(:area => "嘉祥县", :name => "嘉祥水务")
@wens = Company.create!(:area => "汶上县", :name => "汶上水务")
@qufu = Company.create!(:area => "曲阜市", :name => "曲阜污水处理厂")
@yanz = Company.create!(:area => "兖州区", :name => "兖州水务")
@zouc = Company.create!(:area => "邹城市", :name => "邹城水务")
@beih = Company.create!(:area => "太白湖新区", :name => "北湖污水处理厂")

@rcws  = Factory.create!(:area => "任城区", :name => "任城污水处理厂", :company => @renc)
@dsmt  = Factory.create!(:area => "金乡县", :name => "达斯玛特污水处理厂", :company => @jinx)
@jxws  = Factory.create!(:area => "嘉祥县", :name => "嘉祥污水处理厂", :company => @jiax)
@wsfd  = Factory.create!(:area => "汶上县", :name => "汶上佛都污水处理厂", :company => @wens)
@wsqq  = Factory.create!(:area => "汶上县", :name => "汶上清泉污水处理厂", :company => @wens)
@wsqy  = Factory.create!(:area => "汶上县", :name => "汶上清源污水处理厂", :company => @wens)
@qfyw  = Factory.create!(:area => "曲阜市", :name => "曲阜第一污水处理厂", :company => @qufu)
@qfsw  = Factory.create!(:area => "曲阜市", :name => "曲阜第三污水处理厂", :company => @qufu)
@yzws  = Factory.create!(:area => "兖州区", :name => "兖州污水处理厂", :company => @yanz)
@yzsw  = Factory.create!(:area => "兖州区", :name => "兖州第三污水处理厂", :company => @yanz)
@yzdy  = Factory.create!(:area => "兖州区", :name => "兖州大禹污水处理厂", :company => @yanz)
@zcdy  = Factory.create!(:area => "邹城市", :name => "邹城第一污水处理厂", :company => @zouc)
@zcde  = Factory.create!(:area => "邹城市", :name => "邹城第二污水处理厂", :company => @zouc)
@zcds  = Factory.create!(:area => "邹城市", :name => "邹城第三污水处理厂", :company => @zouc)
@bhws  = Factory.create!(:area => "太白湖新区", :name => "北湖污水处理厂", :company => @beih)

User.create!(:phone => "053766880909", :password => "zcds0909", :password_confirmation => "zcds0909", :name => "邹城三污数据填报员", :roles => @data_filler, :factories => [@zcds])
User.create!(:phone => "053700006666", :password => "zcds6666", :password_confirmation => "zcds6666", :name => "邹城三污数据审核员", :roles => @data_verifer, :factories => [@zcds])
User.create!(:phone => "053766880606", :password => "zcde0606", :password_confirmation => "zcde0606", :name => "邹城二污数据填报员", :roles => @data_filler, :factories => [@zcde])
User.create!(:phone => "053711115678", :password => "zcde5678", :password_confirmation => "zcde5678", :name => "邹城二污数据审核员", :roles => @data_verifer, :factories => [@zcde])
User.create!(:phone => "053769693708", :password => "zcdy3708", :password_confirmation => "zcdy3708", :name => "邹城一污数据填报员", :roles => @data_filler, :factories => [@zcdy])
User.create!(:phone => "053737080101", :password => "zcdy0101", :password_confirmation => "zcdy0101", :name => "邹城一污数据审核员", :roles => @data_verifer, :factories => [@zcdy])
#-----------
User.create!(:phone => "053766886969", :password => "yzdy6969", :password_confirmation => "yzdy6969", :name => "兖州大禹数据填报员", :roles => @data_filler, :factories => [@yzdy])
User.create!(:phone => "053766665656", :password => "yzdy5656", :password_confirmation => "yzdy5656", :name => "兖州大禹数据审核员", :roles => @data_verifer, :factories => [@yzdy])
User.create!(:phone => "053766885858", :password => "yzsw5858", :password_confirmation => "yzsw5858", :name => "兖州三污数据填报员", :roles => @data_filler, :factories => [@yzsw])
User.create!(:phone => "053798985858", :password => "yzsw5858", :password_confirmation => "yzsw5858", :name => "兖州三污数据审核员", :roles => @data_verifer, :factories => [@yzsw])
User.create!(:phone => "053737081111", :password => "yzws1111", :password_confirmation => "yzws1111", :name => "兖州污水数据填报员", :roles => @data_filler, :factories => [@yzws])
User.create!(:phone => "053798983708", :password => "yzws3708", :password_confirmation => "yzws3708", :name => "兖州污水数据审核员", :roles => @data_verifer, :factories => [@yzws])
#-----------
User.create!(:phone => "053766889999", :password => "qfyw9999", :password_confirmation => "qfyw9999", :name => "曲阜一污数据填报员", :roles => @data_filler, :factories => [@qfyw])
User.create!(:phone => "053798986666", :password => "qfyw6666", :password_confirmation => "qfyw6666", :name => "曲阜一污数据审核员", :roles => @data_verifer, :factories => [@qfyw])
User.create!(:phone => "053756788989", :password => "qfsw8989", :password_confirmation => "qfsw8989", :name => "曲阜三污数据填报员", :roles => @data_filler, :factories => [@qfsw])
User.create!(:phone => "053756786789", :password => "qfsw6789", :password_confirmation => "qfsw6789", :name => "曲阜三污数据审核员", :roles => @data_verifer, :factories => [@qfsw])
#-----------
User.create!(:phone => "053766881234", :password => "wsqy6688", :password_confirmation => "wsqy6688", :name => "汶上清源数据填报员", :roles => @data_filler, :factories => [@wsqy])
User.create!(:phone => "053798981234", :password => "wsqy9898", :password_confirmation => "wsqy9898", :name => "汶上清源数据审核员", :roles => @data_verifer, :factories => [@wsqy])
User.create!(:phone => "053712348888", :password => "wsqq8888", :password_confirmation => "wsqq8888", :name => "汶上清泉数据填报员", :roles => @data_filler, :factories => [@wsqq])
User.create!(:phone => "053712349999", :password => "wsqq9999", :password_confirmation => "wsqq9999", :name => "汶上清泉数据审核员", :roles => @data_verifer, :factories => [@wsqq])
User.create!(:phone => "12395889588", :password => "wsfd9588", :password_confirmation => "wsfd9588", :name => "汶上佛都数据填报员", :roles => @data_filler, :factories => [@wsfd])
User.create!(:phone => "12395999599", :password => "wsfd9599", :password_confirmation => "wsfd9599", :name => "汶上佛都数据审核员", :roles => @data_verifer, :factories => [@wsfd])
#-----------
User.create!(:phone => "12305379188", :password => "rcws9188", :password_confirmation => "rcws9188", :name => "任城污水数据填报员", :roles => @data_filler, :factories => [@rcws])
User.create!(:phone => "12305379199", :password => "rcws9199", :password_confirmation => "rcws9199", :name => "任城污水数据审核员", :roles => @data_verifer, :factories => [@rcws])
#-----------
User.create!(:phone => "12305378888", :password => "dsmt8888", :password_confirmation => "dsmt8888", :name => "达斯玛特数据填报员", :roles => @data_filler, :factories => [@dsmt])
User.create!(:phone => "12305379999", :password => "dsmt9999", :password_confirmation => "dsmt9999", :name => "达斯玛特数据审核员", :roles => @data_verifer, :factories => [@dsmt])
#-----------
User.create!(:phone => "12305371818", :password => "jxws1818", :password_confirmation => "jxws1818", :name => "嘉祥污水数据填报员", :roles => @data_filler, :factories => [@jxws])
User.create!(:phone => "12305370101", :password => "jxws0101", :password_confirmation => "jxws0101", :name => "嘉祥污水数据审核员", :roles => @data_verifer, :factories => [@jxws])
#-----------
User.create!(:phone => "053766887788", :password => "bhws7788", :password_confirmation => "bhws7788", :name => "太白湖新区污水数据填报员", :roles => @data_filler, :factories => [@bhws])
User.create!(:phone => "053798987878", :password => "bhws7878", :password_confirmation => "bhws7878", :name => "太白湖新区污水数据审核员", :roles => @data_verifer, :factories => [@bhws])

user.factories << Factory.all

400.times.each do |t|
  pdt_date = Faker::Date.unique.between(from: '2020-01-01', to: '2021-08-15')
  DayPdtRpt.create!(
    :factory => @rcws,
    :name => pdt_date.to_s + @rcws.name + "生产运营数据", :pdt_date => pdt_date, :weather => '晴', :temper => Faker::Number.between(from: -10, to: 35), 
    :inf_qlty_bod => Faker::Number.within(range: 10..100), :inf_qlty_cod => Faker::Number.within(range: 10..100), :inf_qlty_ss => Faker::Number.within(range: 10..100), :inf_qlty_nhn => Faker::Number.within(range: 10..100), :inf_qlty_tn => Faker::Number.within(range: 10..100), :inf_qlty_tp => Faker::Number.within(range: 10..100), :inf_qlty_ph => Faker::Number.between(from: 0, to: 14), 
    :eff_qlty_bod => Faker::Number.within(range: 1..10), :eff_qlty_cod => Faker::Number.within(range: 10..50), :eff_qlty_ss => Faker::Number.within(range: 1..10), :eff_qlty_nhn => Faker::Number.within(range: 1..5), :eff_qlty_tn => Faker::Number.within(range: 1..15), :eff_qlty_tp => format("%0.2f", Faker::Number.within(range: 0.1..0.5)), :eff_qlty_ph => Faker::Number.between(from: 0, to: 14), :eff_qlty_fecal => Faker::Number.within(range: 10..500),  
    :sed_qlty_bod => Faker::Number.within(range: 10..100), :sed_qlty_cod => Faker::Number.within(range: 10..100), :sed_qlty_ss => Faker::Number.within(range: 10..100), :sed_qlty_nhn => Faker::Number.within(range: 10..100), :sed_qlty_tn => Faker::Number.within(range: 10..100), :sed_qlty_tp => Faker::Number.within(range: 10..100), :sed_qlty_ph => Faker::Number.between(from: 0, to: 14), 
    :inflow => Faker::Number.within(range: 10..100), :outflow => Faker::Number.within(range: 10..100), :inmud => Faker::Number.within(range: 10..100), :outmud => Faker::Number.within(range: 10..100), :mst => Faker::Number.within(range: 10..100), :power => Faker::Number.within(range: 10..100), :mdflow => Faker::Number.within(range: 10..100), :mdrcy => Faker::Number.within(range: 10..100), :mdsell => Faker::Number.within(range: 10..100)
  )
end

Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.cod,      :max => Setting.level_ones.cod_s, :name => Setting.inf_qlties.cod)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.bod,      :max => Setting.level_ones.bod_s, :name => Setting.inf_qlties.bod)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.ss,       :max => Setting.level_ones.ss_s, :name => Setting.inf_qlties.ss)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.nhn,      :max => Setting.level_ones.nhn_s, :name => Setting.inf_qlties.nhn)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.tn,       :max => Setting.level_ones.tn_s, :name => Setting.inf_qlties.tn)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.tp,       :max => Setting.level_ones.tp_s, :name => Setting.inf_qlties.tp)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.ph,       :max => Setting.level_ones.ph_s, :name => Setting.inf_qlties.ph)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.fecal,    :max => Setting.level_ones.fecal_s, :name => Setting.eff_qlties.fecal)
Quota.create!(:ctg => Setting.quota.ctg_flow, :code => Setting.quota.inflow , :name => Setting.day_pdt_rpts.inflow  )
Quota.create!(:ctg => Setting.quota.ctg_flow, :code => Setting.quota.outflow, :name => Setting.day_pdt_rpts.outflow )
Quota.create!(:ctg => Setting.quota.ctg_mud, :code => Setting.quota.inmud  ,  :name => Setting.day_pdt_rpts.inmud   )
Quota.create!(:ctg => Setting.quota.ctg_mud, :code => Setting.quota.outmud ,  :name => Setting.day_pdt_rpts.outmud  )
Quota.create!(:ctg => Setting.quota.ctg_mud, :code => Setting.quota.mst,    :max => Setting.level_ones.mst_s,  :name => Setting.day_pdt_rpts.mst     )
Quota.create!(:ctg => Setting.quota.ctg_power, :code => Setting.quota.power , :name => Setting.day_pdt_rpts.power   )
Quota.create!(:ctg => Setting.quota.ctg_md, :code => Setting.quota.mdflow ,   :name => Setting.day_pdt_rpts.mdflow  )
Quota.create!(:ctg => Setting.quota.ctg_md, :code => Setting.quota.mdrcy  ,   :name => Setting.day_pdt_rpts.mdrcy   )
Quota.create!(:ctg => Setting.quota.ctg_md, :code => Setting.quota.mdsell ,   :name => Setting.day_pdt_rpts.mdsell  )



