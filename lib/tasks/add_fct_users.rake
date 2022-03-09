require 'yaml'
require 'logger'

namespace 'db' do
  desc "init fct user"
  task(:add_fct_users => :environment) do
    @role_sfct           = Role.where(:name => Setting.roles.role_sfct).first
    @role_sday_pdt       = Role.where(:name => Setting.roles.sday_pdt).first
    @role_sday_rpt       = Role.where(:name => Setting.roles.sday_pdt_rpt).first
    @role_smth_rpt_filler = Role.where(:name => Setting.roles.smth_pdt_rpt).first
    @role_smth_rpt_index  = Role.where(:name => Setting.roles.smth_pdt_rpt_index).first
    
    @role_sday_pdt_verify = Role.where(:name => Setting.roles.sday_pdt_verify).first
    @role_sday_pdt_cmp_verify = Role.where(:name => Setting.roles.sday_pdt_cmp_verify).first
    @role_smth_rpt_verify = Role.where(:name => Setting.roles.smth_pdt_rpt_verify).first
    @role_smth_pdt_rpt_cmp_verify = Role.where(:name => Setting.roles.smth_pdt_rpt_cmp_verify).first
    
    @role_sreport         = Role.where(:name =>  Setting.roles.sreport).first
    @role_sdata_cube      = Role.where(:name => Setting.roles.sdata_cube).first
    @role_sdata_compare   = Role.where(:name => Setting.roles.sdata_compare).first
    @role_sarea_time      = Role.where(:name => Setting.roles.sarea_time).first

    @role_cmpy_mth_rpt_filler = Role.where(:name => Setting.roles.cmpy_mth_rpt).first
    @role_cmpy_mth_rpt_index  = Role.where(:name => Setting.roles.cmpy_mth_rpt_index).first
    
    @sdata_filler  = [@role_sfct, @role_sday_pdt, @role_sday_rpt, @role_smth_rpt_filler, @role_smth_rpt_index, @role_sdata_compare ,@role_sdata_cube, @role_sarea_time]
    @sdata_verifer = [@role_sfct, @role_sday_rpt, @role_sday_pdt_verify, @role_smth_rpt_verify, @role_smth_rpt_index, @role_sdata_compare ,@role_sdata_cube, @role_sarea_time]
    @sfct_mgn  = [@role_sfct, @role_sday_rpt, @role_sday_pdt_cmp_verify, @role_smth_pdt_rpt_cmp_verify, @role_smth_rpt_index, @role_sdata_compare ,@role_sdata_cube, @role_sarea_time, @role_cmpy_mth_rpt_filler, @role_cmpy_mth_rpt_index]
    @sfct_leader  = [@role_sfct, @role_sday_rpt, @role_smth_rpt_index, @role_sdata_compare ,@role_sdata_cube, @role_sarea_time, @role_cmpy_mth_rpt_filler, @role_cmpy_mth_rpt_index]

    cfcts = YAML.load_file("lib/tasks/data/cfct_users.yaml")
    nfcts = YAML.load_file("lib/tasks/data/nfct_users.yaml")
    @log_dir = "lib/tasks/data/" 
    @log = Logger.new(@log_dir + '供水账户.log')
    chash = Hash.new
    nhash = Hash.new
    cfhash = Hash.new
    nfhash = Hash.new

    cfcts.each do |fct|
      cpmy = fct[0].to_s
      unless chash[cpmy]
        @ccompany = Ccompany.create(:name => cpmy)
        chash[cpmy] = @ccompany
      else
        @ccompany = chash[cpmy]
      end

      cfactories = []
      fct[1].each do |c|
        @cfactory = Sfactory.create!(:name => c.to_s + '(城镇)', :ccompany => @ccompany, :category => Setting.sfactories.city )
        cfactories << @cfactory
      end
      cfhash[cpmy] = cfactories

      number = Faker::Number.within(range: 100000..1000000).to_s
      cztby = 'cztb' + number
      czshy = 'czsh' + number
      password = 'cz' + number[2..-1]
      User.create!(:phone => cztby, :password => password, :password_confirmation => password, :name => cpmy + "城镇数据填报员", :roles => @sdata_filler, :sfactories => cfactories, :ccompany => @ccompany)
      User.create!(:phone => czshy, :password => password, :password_confirmation => password, :name => cpmy + "城镇数据审核员", :roles => @sdata_verifer, :sfactories => cfactories, :ccompany => @ccompany)
      @log.error cpmy + "城镇数据填报员: 账户" + cztby + ' 密码' + password   
      @log.error cpmy + "城镇数据审核员: 账户" + czshy + ' 密码' + password   
    end

    nfcts.each do |fct|
      cpmy = fct[0].to_s
      unless nhash[cpmy]
        @ncompany = Ncompany.create(:name => cpmy)
        nhash[cpmy] = @ncompany
      else
        @ncompany = nhash[cpmy]
      end

      nfactories = []
      fct[1].each do |c|
        @nfactory  = Sfactory.create!(:name => c.to_s + '(农供)', :ncompany => @ncompany, :category => Setting.sfactories.country )
        nfactories << @nfactory
      end
      nfhash[cpmy] = nfactories

      number = Faker::Number.within(range: 100000..1000000).to_s
      ngtby = 'ngtb' + number
      ngshy = 'ngsh' + number
      password = 'ng' + number[2..-1]
      User.create!(:phone => ngtby, :password => password, :password_confirmation => password, :name => cpmy + "农供数据填报员", :roles => @sdata_filler, :sfactories => nfactories, :ncompany => @ncompany)
      User.create!(:phone => ngshy, :password => password, :password_confirmation => password, :name => cpmy + "农供数据审核员", :roles => @sdata_verifer, :sfactories => nfactories, :ncompany => @ncompany)

      @log.error cpmy + "农供数据填报员: 账户" + ngtby + ' 密码' + password   
      @log.error cpmy + "农供数据审核员: 账户" + ngshy + ' 密码' + password   
    end
      
    chash.each_pair do |k, v|
      sfactories = (cfhash[k] || []) + (nfhash[k] || [])
      if k != '梁山水务'
        name = k.gsub('水务', '污水管理者')
        user = User.where(:name => name).first
        user.roles << @sfct_mgn
        user.update_attributes(:ccompany => v, :ncompany => nhash[k], :sfactories => sfactories)
      else
        number = Faker::Number.within(range: 100000..1000000).to_s
        glz = 'glz' + number
        password = 'glz' + number[2..-1]
        User.create!(:phone => glz, :password => password, :password_confirmation => password, :name => k + "管理者", :roles => @sfct_mgn, :ccompany => v, :ncompany => nhash[k], :sfactories => sfactories)
        @log.error k + "管理者: 账户" + glz + ' 密码' + password
      end
    end

    all_sfactories = Sfactory.all
    
    #集团运营
    @grp_sopt = [@role_sdata_compare ,@role_sdata_cube, @role_sarea_time, @role_sreport] 
    grp_sopt = User.where(:phone => "15763703588").first 
    grp_sopt.sfactories << all_sfactories
    grp_sopt.roles << @grp_sopt
    
    #集团管理者
    @grp_smgn = [@role_sdata_compare ,@role_sdata_cube, @role_sarea_time, @role_sreport] 
    grp_smgn = User.where(:phone => "1236688").first 
    grp_smgn.sfactories << all_sfactories
    grp_smgn.roles << @grp_smgn
  end
end
