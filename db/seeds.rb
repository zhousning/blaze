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

#区分厂区和集团用户是为了sidebar显示
@role_fct            = Role.where(:name => Setting.roles.role_fct).first
@role_grp            = Role.where(:name => Setting.roles.role_grp).first

@role_fct_setting    = Role.where(:name => Setting.roles.fct_setting).first

@role_day_pdt        = Role.where(:name => Setting.roles.day_pdt).first
@role_day_rpt        = Role.where(:name => Setting.roles.day_pdt_rpt).first
@role_mth_rpt_filler = Role.where(:name => Setting.roles.mth_pdt_rpt).first
@role_mth_rpt_index  = Role.where(:name => Setting.roles.mth_pdt_rpt_index).first

@role_day_pdt_verify = Role.where(:name => Setting.roles.day_pdt_verify).first
@role_day_pdt_cmp_verify = Role.where(:name => Setting.roles.day_pdt_cmp_verify).first
@role_mth_rpt_verify = Role.where(:name => Setting.roles.mth_pdt_rpt_verify).first
@role_mth_pdt_rpt_cmp_verify = Role.where(:name => Setting.roles.mth_pdt_rpt_cmp_verify).first

@role_data_cube      = Role.where(:name => Setting.roles.data_cube).first
@role_data_compare   = Role.where(:name => Setting.roles.data_compare).first
@role_area_time      = Role.where(:name => Setting.roles.area_time).first

@role_report         = Role.where(:name =>  Setting.roles.report).first
@role_fct_emp_inf    = Role.where(:name =>  Setting.roles.fct_emp_inf).first
@role_fct_emp_eff    = Role.where(:name =>  Setting.roles.fct_emp_eff).first
@role_fct_emp_inf_mg    = Role.where(:name =>  Setting.roles.fct_emp_inf_mg).first
@role_fct_emp_eff_mg    = Role.where(:name =>  Setting.roles.fct_emp_eff_mg).first
@role_grp_emp_inf    = Role.where(:name =>  Setting.roles.grp_emp_inf).first
@role_grp_emp_eff    = Role.where(:name =>  Setting.roles.grp_emp_eff).first
@role_grp_mgn_emp_inf    = Role.where(:name =>  Setting.roles.grp_mgn_emp_inf).first
@role_grp_mgn_emp_eff    = Role.where(:name =>  Setting.roles.grp_mgn_emp_eff).first

#厂区数据填报
@data_filler  = [@role_fct, @role_day_pdt, @role_mth_rpt_filler, @role_mth_rpt_index, @role_data_compare ,@role_data_cube, @role_area_time, @role_fct_emp_inf, @role_fct_emp_eff, @role_fct_emp_inf_mg, @role_fct_emp_eff_mg]
#厂区数据审核
@data_verifer = [@role_fct, @role_day_rpt, @role_day_pdt_verify, @role_mth_rpt_verify, @role_mth_rpt_index, @role_data_compare ,@role_data_cube, @role_area_time,  @role_fct_emp_inf, @role_fct_emp_eff]
#厂区管理者
@fct_mgn  = [@role_fct, @role_fct_setting, @role_day_rpt, @role_day_pdt_cmp_verify, @role_mth_pdt_rpt_cmp_verify, @role_mth_rpt_index, @role_data_compare ,@role_data_cube, @role_area_time, @role_fct_emp_inf, @role_fct_emp_eff]
#厂区领导
@fct_leader  = [@role_fct, @role_day_rpt, @role_mth_rpt_index, @role_data_compare ,@role_data_cube, @role_area_time, @role_fct_emp_inf, @role_fct_emp_eff]


#集团运营
@grp_opt = [@role_grp, @role_data_compare ,@role_data_cube, @role_area_time, @role_report, @role_grp_emp_inf, @role_grp_emp_eff] 

#集团管理者
@grp_mgn = [@role_grp, @role_data_compare ,@role_data_cube, @role_area_time, @role_report, @role_grp_mgn_emp_inf, @role_grp_mgn_emp_eff] 
                                                              
@renc = Company.create!(:area => "任城区", :name => "任城污水处理厂")
@jinx = Company.create!(:area => "金乡县", :name => "达斯玛特污水处理厂")
@jiax = Company.create!(:area => "嘉祥县", :name => "嘉祥水务")
@wens = Company.create!(:area => "汶上县", :name => "汶上水务")
@qufu = Company.create!(:area => "曲阜市", :name => "曲阜污水处理厂")
@yanz = Company.create!(:area => "兖州区", :name => "兖州水务")
@zouc = Company.create!(:area => "邹城市", :name => "邹城水务")
@beih = Company.create!(:area => "太白湖新区", :name => "北湖污水处理厂")

@rcws  = Factory.create!(:area => "任城区",     :name => "任城污水处理厂",     :company => @renc, :lnt => 116.648154, :lat => 35.471726, :design => 20000)
@bhws  = Factory.create!(:area => "太白湖新区", :name => "北湖污水处理厂",     :company => @beih, :lnt => 116.563934, :lat => 35.302149, :design => 20000)
@jxws  = Factory.create!(:area => "嘉祥县",     :name => "嘉祥污水处理厂",     :company => @jiax, :lnt => 116.344578, :lat => 35.397421, :design => 80000)
@qfyw  = Factory.create!(:area => "曲阜市",     :name => "曲阜第一污水处理厂", :company => @qufu, :lnt => 116.970989, :lat => 35.583201, :design => 40000)
@qfsw  = Factory.create!(:area => "曲阜市",     :name => "曲阜第三污水处理厂", :company => @qufu, :lnt => 116.910627, :lat => 35.560928, :design => 30000)
@wsqy  = Factory.create!(:area => "汶上县",     :name => "汶上清源污水处理厂", :company => @wens, :lnt => 116.480951, :lat => 35.712144, :design => 40000)
@wsfd  = Factory.create!(:area => "汶上县",     :name => "汶上佛都污水处理厂", :company => @wens, :lnt => 116.477282, :lat => 35.682433, :design => 30000)
@wsqq  = Factory.create!(:area => "汶上县",     :name => "汶上清泉污水处理厂", :company => @wens, :lnt => 116.374719, :lat => 35.744584, :design => 10000)
@yzws  = Factory.create!(:area => "兖州区",     :name => "兖州污水处理厂",     :company => @yanz, :lnt => 116.781921, :lat => 35.510729, :design => 60000)
@yzsw  = Factory.create!(:area => "兖州区",     :name => "兖州第三污水处理厂", :company => @yanz, :lnt => 116.781921, :lat => 35.510729, :design => 40000)
@yzdy  = Factory.create!(:area => "兖州区",     :name => "兖州大禹污水处理厂", :company => @yanz, :lnt => 116.918884, :lat => 35.457138, :design => 40000)
@zcdy  = Factory.create!(:area => "邹城市",     :name => "邹城第一污水处理厂", :company => @zouc, :lnt => 116.944881, :lat => 35.384207, :design => 80000)
@zcde  = Factory.create!(:area => "邹城市",     :name => "邹城第二污水处理厂", :company => @zouc, :lnt => 116.918884, :lat => 35.457138, :design => 60000)
@zcds  = Factory.create!(:area => "邹城市",     :name => "邹城第三污水处理厂", :company => @zouc, :lnt => 116.892618, :lat => 35.369115, :design => 20000)
@dsmt  = Factory.create!(:area => "金乡县",     :name => "达斯玛特污水处理厂", :company => @jinx, :lnt => 116.33235,  :lat => 35.095662, :design => 20000)

User.create!(:phone => "12396969696", :password => "wsfd9696", :password_confirmation => "wsfd9696", :name => "汶上佛都管理者", :roles => [], :factories => [])
User.create!(:phone => "053798989797", :password => "yzws9797", :password_confirmation => "yzws9797", :name => "兖州污水管理者", :roles => [], :factories => [])
User.create!(:phone => "053737089898", :password => "zcdy9898", :password_confirmation => "zcdy9898", :name => "邹城一污管理者", :roles => [], :factories => [])

User.create!(:phone => "053769693708", :password => "zcdy3708", :password_confirmation => "zcdy3708", :name => "邹城一污数据填报员", :roles => @data_filler, :factories => [@zcdy])
User.create!(:phone => "053737080101", :password => "zcdy0101", :password_confirmation => "zcdy0101", :name => "邹城一污数据审核员", :roles => @data_verifer, :factories => [@zcdy])
User.create!(:phone => "053766880606", :password => "zcde0606", :password_confirmation => "zcde0606", :name => "邹城二污数据填报员", :roles => @data_filler, :factories => [@zcde])
User.create!(:phone => "053711115678", :password => "zcde5678", :password_confirmation => "zcde5678", :name => "邹城二污数据审核员", :roles => @data_verifer, :factories => [@zcde])
User.create!(:phone => "053766880909", :password => "zcds0909", :password_confirmation => "zcds0909", :name => "邹城三污数据填报员", :roles => @data_filler, :factories => [@zcds])
User.create!(:phone => "053700006666", :password => "zcds6666", :password_confirmation => "zcds6666", :name => "邹城三污数据审核员", :roles => @data_verifer, :factories => [@zcds])
User.create!(:phone => "053700009999", :password => "zcds9999", :password_confirmation => "zcds9999", :name => "邹城污水管理者", :roles => @fct_mgn, :factories => [@zcdy, @zcde, @zcds])
User.create!(:phone => "053711114567", :password => "zcde4567", :password_confirmation => "zcde4567", :name => "邹城污水领导", :roles => @fct_leader, :factories => [@zcdy, @zcde, @zcds])
#-----------
User.create!(:phone => "053766886969", :password => "yzdy6969", :password_confirmation => "yzdy6969", :name => "兖州大禹数据填报员", :roles => @data_filler, :factories => [@yzdy])
User.create!(:phone => "053766665656", :password => "yzdy5656", :password_confirmation => "yzdy5656", :name => "兖州大禹数据审核员", :roles => @data_verifer, :factories => [@yzdy])
User.create!(:phone => "053766885858", :password => "yzsw5858", :password_confirmation => "yzsw5858", :name => "兖州三污数据填报员", :roles => @data_filler, :factories => [@yzsw])
User.create!(:phone => "053798985858", :password => "yzsw5858", :password_confirmation => "yzsw5858", :name => "兖州三污数据审核员", :roles => @data_verifer, :factories => [@yzsw])
User.create!(:phone => "053737081111", :password => "yzws1111", :password_confirmation => "yzws1111", :name => "兖州污水数据填报员", :roles => @data_filler, :factories => [@yzws])
User.create!(:phone => "053798983708", :password => "yzws3708", :password_confirmation => "yzws3708", :name => "兖州污水数据审核员", :roles => @data_verifer, :factories => [@yzws])
User.create!(:phone => "053766661818", :password => "yzdy1818", :password_confirmation => "yzdy1818", :name => "兖州污水管理者", :roles => @fct_mgn, :factories => [@yzws, @yzdy, @yzsw])
User.create!(:phone => "053798986868", :password => "yzsw6868", :password_confirmation => "yzsw6868", :name => "兖州污水领导", :roles => @fct_leader, :factories => [@yzws, @yzdy, @yzsw])
#-----------
User.create!(:phone => "053766889999", :password => "qfyw9999", :password_confirmation => "qfyw9999", :name => "曲阜一污数据填报员", :roles => @data_filler, :factories => [@qfyw])
User.create!(:phone => "053798986666", :password => "qfyw6666", :password_confirmation => "qfyw6666", :name => "曲阜一污数据审核员", :roles => @data_verifer, :factories => [@qfyw])
User.create!(:phone => "053756788989", :password => "qfsw8989", :password_confirmation => "qfsw8989", :name => "曲阜三污数据填报员", :roles => @data_filler, :factories => [@qfsw])
User.create!(:phone => "053756786789", :password => "qfsw6789", :password_confirmation => "qfsw6789", :name => "曲阜三污数据审核员", :roles => @data_verifer, :factories => [@qfsw])
User.create!(:phone => "053798981919", :password => "qfyw1919", :password_confirmation => "qfyw1919", :name => "曲阜污水管理者", :roles => @fct_mgn, :factories => [@qfyw, @qfsw])
User.create!(:phone => "053756781234", :password => "qfsw1234", :password_confirmation => "qfsw1234", :name => "曲阜污水领导", :roles => @fct_leader, :factories => [@qfyw, @qfsw])
#-----------
User.create!(:phone => "053766881234", :password => "wsqy6688", :password_confirmation => "wsqy6688", :name => "汶上清源数据填报员", :roles => @data_filler, :factories => [@wsqy])
User.create!(:phone => "053798981234", :password => "wsqy9898", :password_confirmation => "wsqy9898", :name => "汶上清源数据审核员", :roles => @data_verifer, :factories => [@wsqy])
User.create!(:phone => "053712348888", :password => "wsqq8888", :password_confirmation => "wsqq8888", :name => "汶上清泉数据填报员", :roles => @data_filler, :factories => [@wsqq])
User.create!(:phone => "053712349999", :password => "wsqq9999", :password_confirmation => "wsqq9999", :name => "汶上清泉数据审核员", :roles => @data_verifer, :factories => [@wsqq])
User.create!(:phone => "12395889588", :password => "wsfd9588", :password_confirmation => "wsfd9588", :name => "汶上佛都数据填报员", :roles => @data_filler, :factories => [@wsfd])
User.create!(:phone => "12395999599", :password => "wsfd9599", :password_confirmation => "wsfd9599", :name => "汶上佛都数据审核员", :roles => @data_verifer, :factories => [@wsfd])
User.create!(:phone => "053795661234", :password => "wsqy9566", :password_confirmation => "wsqy9566", :name => "汶上污水管理者", :roles => @fct_mgn, :factories => [@wsqy, @wsqq, @wsfd])
User.create!(:phone => "053712343708", :password => "wsqq3708", :password_confirmation => "wsqq3708", :name => "汶上污水领导", :roles => @fct_leader, :factories => [@wsqy, @wsqq, @wsfd])
#-----------
User.create!(:phone => "12305379188", :password => "rcws9188", :password_confirmation => "rcws9188", :name => "任城污水数据填报员", :roles => @data_filler, :factories => [@rcws])
User.create!(:phone => "12305379199", :password => "rcws9199", :password_confirmation => "rcws9199", :name => "任城污水数据审核员", :roles => @data_verifer, :factories => [@rcws])
User.create!(:phone => "12305377788", :password => "rcws7788", :password_confirmation => "rcws7788", :name => "任城污水管理者", :roles => @fct_mgn, :factories => [@rcws])
User.create!(:phone => "12305376699", :password => "rcws6699", :password_confirmation => "rcws6699", :name => "任城污水领导", :roles => @fct_leader, :factories => [@rcws])
#-----------
User.create!(:phone => "12305378888", :password => "dsmt8888", :password_confirmation => "dsmt8888", :name => "达斯玛特数据填报员", :roles => @data_filler, :factories => [@dsmt])
User.create!(:phone => "12305379999", :password => "dsmt9999", :password_confirmation => "dsmt9999", :name => "达斯玛特数据审核员", :roles => @data_verifer, :factories => [@dsmt])
User.create!(:phone => "12305376688", :password => "dsmt6688", :password_confirmation => "dsmt6688", :name => "达斯玛特管理者", :roles => @fct_mgn, :factories => [@dsmt])
User.create!(:phone => "12305379988", :password => "dsmt9988", :password_confirmation => "dsmt9988", :name => "达斯玛特管理者", :roles => @fct_leader, :factories => [@dsmt])
#-----------
User.create!(:phone => "12305371818", :password => "jxws1818", :password_confirmation => "jxws1818", :name => "嘉祥污水数据填报员", :roles => @data_filler, :factories => [@jxws])
User.create!(:phone => "12305370101", :password => "jxws0101", :password_confirmation => "jxws0101", :name => "嘉祥污水数据审核员", :roles => @data_verifer, :factories => [@jxws])
User.create!(:phone => "12305378989", :password => "jxws8989", :password_confirmation => "jxws8989", :name => "嘉祥污水管理者", :roles => @fct_mgn, :factories => [@jxws])
User.create!(:phone => "12305371111", :password => "jxws1111", :password_confirmation => "jxws1111", :name => "嘉祥污水领导", :roles => @fct_leader, :factories => [@jxws])
#-----------
User.create!(:phone => "053766887788", :password => "bhws7788", :password_confirmation => "bhws7788", :name => "太白湖新区污水数据填报员", :roles => @data_filler, :factories => [@bhws])
User.create!(:phone => "053798987878", :password => "bhws7878", :password_confirmation => "bhws7878", :name => "太白湖新区污水数据审核员", :roles => @data_verifer, :factories => [@bhws])
User.create!(:phone => "053798989188", :password => "bhws9188", :password_confirmation => "bhws9188", :name => "太白湖新区污水管理者", :roles => @fct_mgn, :factories => [@bhws])
User.create!(:phone => "053798989199", :password => "bhws9199", :password_confirmation => "bhws9199", :name => "太白湖新区污水领导", :roles => @fct_leader, :factories => [@bhws])

all_factories = Factory.all
user.factories << all_factories

#集团运营
grp_opt = User.create!(:phone => "15763703588", :password => "swjt3588", :password_confirmation => "swjt3588", :name => "水务集团运营", :roles => @grp_opt, :factories => all_factories)

#集团管理
grp_mgn = User.create!(:phone => "1236688", :password => "swjt6688", :password_confirmation => "swjt6688", :name => "水务集团管理者", :roles => @grp_mgn, :factories => all_factories)

Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.cod.gsub(/在线-|化验-/, ''),      :max => Setting.level_ones.cod_s, :name => Setting.inf_qlties.cod)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.bod,      :max => Setting.level_ones.bod_s, :name => Setting.inf_qlties.bod)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.nhn.gsub(/在线-|化验-/, ''),      :max => Setting.level_ones.nhn_s, :name => Setting.inf_qlties.nhn)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.tn.gsub(/在线-|化验-/, ''),       :max => Setting.level_ones.tn_s, :name => Setting.inf_qlties.tn)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.tp.gsub(/在线-|化验-/, ''),       :max => Setting.level_ones.tp_s, :name => Setting.inf_qlties.tp)
Quota.create!(:ctg => Setting.quota.ctg_cms, :code => Setting.quota.ss.gsub(/在线-|化验-/, ''),       :max => Setting.level_ones.ss_s, :name => Setting.inf_qlties.ss)
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


ChemicalCtg.create!(:code => Setting.chemical_ctgs.csn ,  :name => Setting.chemical_ctgs.csn_t   )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.jc ,   :name => Setting.chemical_ctgs.jc_t    )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.xxty , :name => Setting.chemical_ctgs.xxty_t  )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.pac ,  :name => Setting.chemical_ctgs.pac_t   )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.pam_yin ,  :name => Setting.chemical_ctgs.pam_yin_t   )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.pam_yang ,  :name => Setting.chemical_ctgs.pam_yang_t   )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.slht , :name => Setting.chemical_ctgs.slht_t  )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.jhlst ,:name => Setting.chemical_ctgs.jhlst_t )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.clsn , :name => Setting.chemical_ctgs.clsn_t  )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.hxt ,  :name => Setting.chemical_ctgs.hxt_t   )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.swj ,  :name => Setting.chemical_ctgs.swj_t   )
ChemicalCtg.create!(:code => Setting.chemical_ctgs.yy ,   :name => Setting.chemical_ctgs.yy_t    )


Mudfct.create!(:factory => @rcws, :name => '华能济宁运河发电有限公司')

Mudfct.create!(:factory => @zcdy, :name => '华能济宁运河发电有限公司')
Mudfct.create!(:factory => @zcdy, :name => '邹城光大环保能源有限公司')
Mudfct.create!(:factory => @zcdy, :name => '微山光大环保能源有限公司')
Mudfct.create!(:factory => @zcdy, :name => '微山鼎祥生态农业发展有限公司')

Mudfct.create!(:factory => @zcde, :name => '华能济宁运河发电有限公司')
Mudfct.create!(:factory => @zcde, :name => '邹城光大环保能源有限公司')
Mudfct.create!(:factory => @zcde, :name => '微山光大环保能源有限公司')
Mudfct.create!(:factory => @zcde, :name => '微山鼎祥生态农业发展有限公司')

Mudfct.create!(:factory => @zcds, :name => '华能济宁运河发电有限公司')
Mudfct.create!(:factory => @zcds, :name => '邹城光大环保能源有限公司')
Mudfct.create!(:factory => @zcds, :name => '微山光大环保能源有限公司')
Mudfct.create!(:factory => @zcds, :name => '微山鼎祥生态农业发展有限公司')

Mudfct.create!(:factory => @yzws, :name => '嘉祥县鹿富农业科技有限公司')
Mudfct.create!(:factory => @yzws, :name => '山东群青生态农业发展有限公司')
Mudfct.create!(:factory => @yzsw, :name => '嘉祥县鹿富农业科技有限公司')
Mudfct.create!(:factory => @yzsw, :name => '山东群青生态农业发展有限公司')
Mudfct.create!(:factory => @yzdy, :name => '嘉祥县鹿富农业科技有限公司')
Mudfct.create!(:factory => @yzdy, :name => '山东群青生态农业发展有限公司')

Mudfct.create!(:factory => @bhws, :name => '嘉祥县鹿富农业科技有限公司')

Mudfct.create!(:factory => @jxws, :name => '嘉祥县鹿富农业科技有限公司')
Mudfct.create!(:factory => @jxws, :name => '山东群青生态农业发展有限公司')

Mudfct.create!(:factory => @wsfd, :name => '济宁泽众资源综合利用有限公司')
Mudfct.create!(:factory => @wsfd, :name => '济宁隆晟特种养殖有限公司')
Mudfct.create!(:factory => @wsfd, :name => '山东群青生态农业发展有限公司')
Mudfct.create!(:factory => @wsqq, :name => '济宁泽众资源综合利用有限公司')
Mudfct.create!(:factory => @wsqq, :name => '济宁隆晟特种养殖有限公司')
Mudfct.create!(:factory => @wsqq, :name => '山东群青生态农业发展有限公司')
Mudfct.create!(:factory => @wsqy, :name => '济宁泽众资源综合利用有限公司')
Mudfct.create!(:factory => @wsqy, :name => '济宁隆晟特种养殖有限公司')
Mudfct.create!(:factory => @wsqy, :name => '山东群青生态农业发展有限公司')

Mudfct.create!(:factory => @qfyw, :name => '中联水泥')
Mudfct.create!(:factory => @qfsw, :name => '中联水泥')

#Factory.all.each do |f|
#  fake = Faker::Date
#  31.times.each do |t|
#    pdt_date = fake.between(from: '2021-01-01', to: '2021-01-31')
#    DayPdtRpt.create!(
#      :factory => f,
#      :name => pdt_date.to_s + f.name + "生产运营数据", :pdt_date => pdt_date, :weather => '晴', :min_temper => Faker::Number.between(from: -10, to: 35), 
#      :inf_qlty_bod => Faker::Number.within(range: 10..100), :inf_qlty_cod => Faker::Number.within(range: 10..100), :inf_qlty_ss => Faker::Number.within(range: 10..100), :inf_qlty_nhn => Faker::Number.within(range: 10..100), :inf_qlty_tn => Faker::Number.within(range: 10..100), :inf_qlty_tp => Faker::Number.within(range: 10..100), :inf_qlty_ph => Faker::Number.between(from: 0, to: 14), 
#      :eff_qlty_bod => Faker::Number.within(range: 1..10), :eff_qlty_cod => Faker::Number.within(range: 10..50), :eff_qlty_ss => Faker::Number.within(range: 1..10), :eff_qlty_nhn => Faker::Number.within(range: 1..5), :eff_qlty_tn => Faker::Number.within(range: 1..15), :eff_qlty_tp => format("%0.2f", Faker::Number.within(range: 0.1..0.5)), :eff_qlty_ph => Faker::Number.between(from: 0, to: 14), :eff_qlty_fecal => Faker::Number.within(range: 10..500),  
#      :sed_qlty_bod => Faker::Number.within(range: 10..100), :sed_qlty_cod => Faker::Number.within(range: 10..100), :sed_qlty_ss => Faker::Number.within(range: 10..100), :sed_qlty_nhn => Faker::Number.within(range: 10..100), :sed_qlty_tn => Faker::Number.within(range: 10..100), :sed_qlty_tp => Faker::Number.within(range: 10..100), :sed_qlty_ph => Faker::Number.between(from: 0, to: 14), 
#      :inflow => Faker::Number.within(range: 10..100), :outflow => Faker::Number.within(range: 10..100), :inmud => Faker::Number.within(range: 10..100), :outmud => Faker::Number.within(range: 10..100), :mst => Faker::Number.within(range: 10..100), :power => Faker::Number.within(range: 10..100), :mdflow => Faker::Number.within(range: 10..100), :mdrcy => Faker::Number.within(range: 10..100), :mdsell => Faker::Number.within(range: 10..100)
#    )
#  end
#end

rcws = Factory.first
31.times.each do |t|
  pdt_date = Date.new(2021, 1, t+1) 
  day_rpt = DayPdtRpt.create!(
    :factory => rcws,
    :name => pdt_date.to_s + rcws.name + "生产运营数据", :pdt_date => pdt_date, :weather => '晴', :min_temper => Faker::Number.between(from: -10, to: 35), 
    :inf_qlty_bod => Faker::Number.within(range: 10..100), :inf_qlty_cod => Faker::Number.within(range: 10..100), :inf_qlty_ss => Faker::Number.within(range: 10..100), :inf_qlty_nhn => Faker::Number.within(range: 10..100), :inf_qlty_tn => Faker::Number.within(range: 10..100), :inf_qlty_tp => Faker::Number.within(range: 10..100), :inf_qlty_ph => Faker::Number.between(from: 0, to: 14), 
    :eff_qlty_bod => Faker::Number.within(range: 1..10), :eff_qlty_cod => Faker::Number.within(range: 10..50), :eff_qlty_ss => Faker::Number.within(range: 1..10), :eff_qlty_nhn => Faker::Number.within(range: 1..5), :eff_qlty_tn => Faker::Number.within(range: 1..15), :eff_qlty_tp => format("%0.2f", Faker::Number.within(range: 0.1..0.5)), :eff_qlty_ph => Faker::Number.between(from: 0, to: 14), :eff_qlty_fecal => Faker::Number.within(range: 10..500),  
    :sed_qlty_bod => Faker::Number.within(range: 10..100), :sed_qlty_cod => Faker::Number.within(range: 10..100), :sed_qlty_ss => Faker::Number.within(range: 10..100), :sed_qlty_nhn => Faker::Number.within(range: 10..100), :sed_qlty_tn => Faker::Number.within(range: 10..100), :sed_qlty_tp => Faker::Number.within(range: 10..100), :sed_qlty_ph => Faker::Number.between(from: 0, to: 14), 
    :inflow => Faker::Number.within(range: 10..100), :outflow => Faker::Number.within(range: 10..100), :inmud => Faker::Number.within(range: 10..100), :outmud => Faker::Number.within(range: 10..100), :mst => Faker::Number.within(range: 10..100), :power => Faker::Number.within(range: 10..100), :mdflow => Faker::Number.within(range: 10..100), :mdrcy => Faker::Number.within(range: 10..100), :mdsell => Faker::Number.within(range: 10..100)
  )
  [1,2,3,4,5,6].each do |chemical|
    Chemical.create!(:name => chemical, :unprice => Faker::Number.within(range: 10..100), :dosage => Faker::Number.within(range: 10..100), :cmptc => Faker::Number.within(range: 10..100), :day_pdt_rpt => day_rpt)
  end
end
