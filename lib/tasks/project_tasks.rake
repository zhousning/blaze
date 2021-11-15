# coding: utf-8

namespace :project do
  desc "project tasks"
  task :tasks do
    Rake::Task["db:create_folders"].invoke
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:add_permissions"].invoke
    Rake::Task["db:add_roles_permissions"].invoke #在data/role_permissions中设置默认角色和对应权限,这一步要在add_permission之后
    Rake::Task["db:seed"].invoke
    
    #导入历史化验数据和在线数据
    Rake::Task["db:import_lishicms"].invoke
    #Rake::Task["db:update_lishionline"].invoke

    #导入月历史数据
    Rake::Task["db:create_mth_rpts"].invoke
    Rake::Task["db:update_mth_power_chemicals"].invoke

    #如果是删除了月报表，又重新导入数据，执行完以上两步，再更新下本月止电数据
    #Rake::Task["db:update_mth_powers"].invoke

    #Rake::Task["db:import_daywatercms"].invoke
    #Rake::Task["db:import_emps"].invoke
    #Rake::Task["db:create_day_pdt_rpts"].invoke
    #Rake::Task["db:create_mth_rpts"].invoke
    
    #Rake::Task["db:import_users"].invoke
    #Rake::Task["assets:precompile"].invoke
    #Rake::Task["kindeditor:assets"].invoke
  end
end
