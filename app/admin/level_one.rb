ActiveAdmin.register LevelOne  do

  permit_params  :cod, :bod, :nhn, :tn, :tp, :ss, :fecal

  menu label: Setting.level_ones.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :cod, :label => Setting.level_ones.cod
  filter :bod, :label => Setting.level_ones.bod
  filter :nhn, :label => Setting.level_ones.nhn
  filter :tn, :label => Setting.level_ones.tn
  filter :tp, :label => Setting.level_ones.tp
  filter :ss, :label => Setting.level_ones.ss
  filter :fecal, :label => Setting.level_ones.fecal
  filter :created_at

  index :title=>Setting.level_ones.label + "管理" do
    selectable_column
    id_column
    
    column Setting.level_ones.cod, :cod
    column Setting.level_ones.bod, :bod
    column Setting.level_ones.nhn, :nhn
    column Setting.level_ones.tn, :tn
    column Setting.level_ones.tp, :tp
    column Setting.level_ones.ss, :ss
    column Setting.level_ones.fecal, :fecal

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.level_ones.label do
      
      f.input :cod, :label => Setting.level_ones.cod 
      f.input :bod, :label => Setting.level_ones.bod 
      f.input :nhn, :label => Setting.level_ones.nhn 
      f.input :tn, :label => Setting.level_ones.tn 
      f.input :tp, :label => Setting.level_ones.tp 
      f.input :ss, :label => Setting.level_ones.ss 
      f.input :fecal, :label => Setting.level_ones.fecal 
    end
    f.actions
  end

  show :title=>Setting.level_ones.label + "信息" do
    attributes_table do
      row "ID" do
        level_one.id
      end
      
      row Setting.level_ones.cod do
        level_one.cod
      end
      row Setting.level_ones.bod do
        level_one.bod
      end
      row Setting.level_ones.nhn do
        level_one.nhn
      end
      row Setting.level_ones.tn do
        level_one.tn
      end
      row Setting.level_ones.tp do
        level_one.tp
      end
      row Setting.level_ones.ss do
        level_one.ss
      end
      row Setting.level_ones.fecal do
        level_one.fecal
      end

      row "创建时间" do
        level_one.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        level_one.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
