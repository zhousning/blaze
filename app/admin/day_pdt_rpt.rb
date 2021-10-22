ActiveAdmin.register DayPdtRpt  do

  permit_params :name, :pdt_date, :weather, :min_temper,  :max_temper,
      :inf_qlty_bod, :inf_qlty_cod, :inf_qlty_ss, :inf_qlty_nhn, :inf_qlty_tn, :inf_qlty_tp, :inf_qlty_ph, 
      :eff_qlty_bod, :eff_qlty_cod, :eff_qlty_ss, :eff_qlty_nhn, :eff_qlty_tn, :eff_qlty_tp, :eff_qlty_ph, :eff_qlty_fecal,  
      :sed_qlty_bod, :sed_qlty_cod, :sed_qlty_ss, :sed_qlty_nhn, :sed_qlty_tn, :sed_qlty_tp, :sed_qlty_ph, 
      :inflow, :outflow, :inmud, :outmud, :mst, :power, :mdflow, :mdrcy, :mdsell

  menu label: Setting.day_pdt_rpts.label
  config.per_page = 20
  config.sort_order = "pdt_date_desc"

  actions :all, :except => [:destroy]

  
  filter :name, :label => Setting.day_pdt_rpts.name
  filter :pdt_date, :label => Setting.day_pdt_rpts.pdt_date
  filter :created_at

  action_item :only => [:show, :edit] do
  end

  index :title=>Setting.day_pdt_rpts.label + "管理" do
    selectable_column
    id_column
    
    column Setting.day_pdt_rpts.name, :name
    column Setting.day_pdt_rpts.pdt_date, :pdt_date, :sortable=> :pdt_date do |f|
      f.pdt_date.strftime('%Y-%m-%d')
    end
    column "创建时间", :created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end

    column "状态" do |f|
      if f.day_pdt
        day_pdt = f.day_pdt 
        if day_pdt.state == Setting.day_pdts.complete
          Setting.day_pdts.complete_t
        elsif day_pdt.state == Setting.day_pdts.ongoing
          Setting.day_pdts.ongoing_t
        elsif day_pdt.state == Setting.day_pdts.verifying
          Setting.day_pdts.verifying_t
        elsif day_pdt.state == Setting.day_pdts.rejected
          Setting.day_pdts.rejected_t
        elsif day_pdt.state == Setting.day_pdts.cmp_verifying
          Setting.day_pdts.cmp_verifying_t
        elsif day_pdt.state == Setting.day_pdts.cmp_rejected
          Setting.day_pdts.cmp_rejected_t
        end
      end
    end
    #column "更新时间", :updated_at do |f|
    #  f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    #end
    actions do |day_pdt_rpt|
      #link_to(Setting.users.passed_title, pass_admin_user_path(user.id)) + "  " +
      if day_pdt_rpt.day_pdt
       link_to('重报', reject_jackadmin_day_pdt_rpt_path(day_pdt_rpt.id))
      end
    end
  end

  member_action :reject do
    day_pdt_rpt = DayPdtRpt.find(params[:id])
    day_pdt = day_pdt_rpt.day_pdt
    day_pdt.onging
    redirect_to jackadmin_day_pdt_rpts_path
  end


  form do |f|
    f.inputs "添加" + Setting.day_pdt_rpts.label do
      
      #f.input :name, :label => Setting.day_pdt_rpts.name 
      #f.input :pdt_date, :label => Setting.day_pdt_rpts.pdt_date 
      f.input :weather, :label => Setting.day_pdt_rpts.weather 
      f.input :min_temper, :label => Setting.day_pdt_rpts.min_temper 
      f.input :max_temper, :label => Setting.day_pdt_rpts.max_temper 
      f.input :inf_qlty_bod, :label => Setting.day_pdt_rpts.inf_qlty_bod 
      f.input :inf_qlty_cod, :label => Setting.day_pdt_rpts.inf_qlty_cod 
      f.input :inf_qlty_ss, :label => Setting.day_pdt_rpts.inf_qlty_ss 
      f.input :inf_qlty_nhn, :label => Setting.day_pdt_rpts.inf_qlty_nhn 
      f.input :inf_qlty_tn, :label => Setting.day_pdt_rpts.inf_qlty_tn 
      f.input :inf_qlty_tp, :label => Setting.day_pdt_rpts.inf_qlty_tp 
      f.input :inf_qlty_ph, :label => Setting.day_pdt_rpts.inf_qlty_ph 
      f.input :eff_qlty_bod, :label => Setting.day_pdt_rpts.eff_qlty_bod 
      f.input :eff_qlty_cod, :label => Setting.day_pdt_rpts.eff_qlty_cod 
      f.input :eff_qlty_ss, :label => Setting.day_pdt_rpts.eff_qlty_ss 
      f.input :eff_qlty_nhn, :label => Setting.day_pdt_rpts.eff_qlty_nhn 
      f.input :eff_qlty_tn, :label => Setting.day_pdt_rpts.eff_qlty_tn 
      f.input :eff_qlty_tp, :label => Setting.day_pdt_rpts.eff_qlty_tp 
      f.input :eff_qlty_ph, :label => Setting.day_pdt_rpts.eff_qlty_ph 
      f.input :eff_qlty_fecal, :label => Setting.day_pdt_rpts.eff_qlty_fecal 
      f.input :sed_qlty_bod, :label => Setting.day_pdt_rpts.sed_qlty_bod 
      f.input :sed_qlty_cod, :label => Setting.day_pdt_rpts.sed_qlty_cod 
      f.input :sed_qlty_ss, :label => Setting.day_pdt_rpts.sed_qlty_ss 
      f.input :sed_qlty_nhn, :label => Setting.day_pdt_rpts.sed_qlty_nhn 
      f.input :sed_qlty_tn, :label => Setting.day_pdt_rpts.sed_qlty_tn 
      f.input :sed_qlty_tp, :label => Setting.day_pdt_rpts.sed_qlty_tp 
      f.input :sed_qlty_ph, :label => Setting.day_pdt_rpts.sed_qlty_ph 
      f.input :inflow, :label => Setting.day_pdt_rpts.inflow 
      f.input :outflow, :label => Setting.day_pdt_rpts.outflow 
      f.input :inmud, :label => Setting.day_pdt_rpts.inmud 
      f.input :outmud, :label => Setting.day_pdt_rpts.outmud 
      f.input :mst, :label => Setting.day_pdt_rpts.mst 
      f.input :power, :label => Setting.day_pdt_rpts.power 
      f.input :mdflow, :label => Setting.day_pdt_rpts.mdflow 
      f.input :mdrcy, :label => Setting.day_pdt_rpts.mdrcy 
      f.input :mdsell, :label => Setting.day_pdt_rpts.mdsell 
    end
    f.actions
  end

  show :title=>Setting.day_pdt_rpts.label + "信息" do
    attributes_table do
      row "ID" do
        day_pdt_rpt.id
      end
      
      row Setting.day_pdt_rpts.name do
        day_pdt_rpt.name
      end
      #row Setting.day_pdt_rpts.pdt_date do
      #  day_pdt_rpt.pdt_date
      #end
      row Setting.day_pdt_rpts.weather do
        day_pdt_rpt.weather
      end
      row Setting.day_pdt_rpts.min_temper do
        day_pdt_rpt.min_temper
      end
      row Setting.day_pdt_rpts.max_temper do
        day_pdt_rpt.max_temper
      end
      row Setting.day_pdt_rpts.inf_qlty_bod do
        day_pdt_rpt.inf_qlty_bod
      end
      row Setting.day_pdt_rpts.inf_qlty_cod do
        day_pdt_rpt.inf_qlty_cod
      end
      row Setting.day_pdt_rpts.inf_qlty_ss do
        day_pdt_rpt.inf_qlty_ss
      end
      row Setting.day_pdt_rpts.inf_qlty_nhn do
        day_pdt_rpt.inf_qlty_nhn
      end
      row Setting.day_pdt_rpts.inf_qlty_tn do
        day_pdt_rpt.inf_qlty_tn
      end
      row Setting.day_pdt_rpts.inf_qlty_tp do
        day_pdt_rpt.inf_qlty_tp
      end
      row Setting.day_pdt_rpts.inf_qlty_ph do
        day_pdt_rpt.inf_qlty_ph
      end
      row Setting.day_pdt_rpts.eff_qlty_bod do
        day_pdt_rpt.eff_qlty_bod
      end
      row Setting.day_pdt_rpts.eff_qlty_cod do
        day_pdt_rpt.eff_qlty_cod
      end
      row Setting.day_pdt_rpts.eff_qlty_ss do
        day_pdt_rpt.eff_qlty_ss
      end
      row Setting.day_pdt_rpts.eff_qlty_nhn do
        day_pdt_rpt.eff_qlty_nhn
      end
      row Setting.day_pdt_rpts.eff_qlty_tn do
        day_pdt_rpt.eff_qlty_tn
      end
      row Setting.day_pdt_rpts.eff_qlty_tp do
        day_pdt_rpt.eff_qlty_tp
      end
      row Setting.day_pdt_rpts.eff_qlty_ph do
        day_pdt_rpt.eff_qlty_ph
      end
      row Setting.day_pdt_rpts.eff_qlty_fecal do
        day_pdt_rpt.eff_qlty_fecal
      end
      row Setting.day_pdt_rpts.sed_qlty_bod do
        day_pdt_rpt.sed_qlty_bod
      end
      row Setting.day_pdt_rpts.sed_qlty_cod do
        day_pdt_rpt.sed_qlty_cod
      end
      row Setting.day_pdt_rpts.sed_qlty_ss do
        day_pdt_rpt.sed_qlty_ss
      end
      row Setting.day_pdt_rpts.sed_qlty_nhn do
        day_pdt_rpt.sed_qlty_nhn
      end
      row Setting.day_pdt_rpts.sed_qlty_tn do
        day_pdt_rpt.sed_qlty_tn
      end
      row Setting.day_pdt_rpts.sed_qlty_tp do
        day_pdt_rpt.sed_qlty_tp
      end
      row Setting.day_pdt_rpts.sed_qlty_ph do
        day_pdt_rpt.sed_qlty_ph
      end
      row Setting.day_pdt_rpts.inflow do
        day_pdt_rpt.inflow
      end
      row Setting.day_pdt_rpts.outflow do
        day_pdt_rpt.outflow
      end
      row Setting.day_pdt_rpts.inmud do
        day_pdt_rpt.inmud
      end
      row Setting.day_pdt_rpts.outmud do
        day_pdt_rpt.outmud
      end
      row Setting.day_pdt_rpts.mst do
        day_pdt_rpt.mst
      end
      row Setting.day_pdt_rpts.power do
        day_pdt_rpt.power
      end
      row Setting.day_pdt_rpts.mdflow do
        day_pdt_rpt.mdflow
      end
      row Setting.day_pdt_rpts.mdrcy do
        day_pdt_rpt.mdrcy
      end
      row Setting.day_pdt_rpts.mdsell do
        day_pdt_rpt.mdsell
      end

      row "创建时间" do
        day_pdt_rpt.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        day_pdt_rpt.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end

#filter :weather, :label => Setting.day_pdt_rpts.weather
#filter :min_temper, :label => Setting.day_pdt_rpts.min_temper
#filter :max_temper, :label => Setting.day_pdt_rpts.max_temper
#filter :inf_qlty_bod, :label => Setting.day_pdt_rpts.inf_qlty_bod
#filter :inf_qlty_cod, :label => Setting.day_pdt_rpts.inf_qlty_cod
#filter :inf_qlty_ss, :label => Setting.day_pdt_rpts.inf_qlty_ss
#filter :inf_qlty_nhn, :label => Setting.day_pdt_rpts.inf_qlty_nhn
#filter :inf_qlty_tn, :label => Setting.day_pdt_rpts.inf_qlty_tn
#filter :inf_qlty_tp, :label => Setting.day_pdt_rpts.inf_qlty_tp
#filter :inf_qlty_ph, :label => Setting.day_pdt_rpts.inf_qlty_ph
#filter :eff_qlty_cod, :label => Setting.day_pdt_rpts.eff_qlty_cod
#filter :eff_qlty_ss, :label => Setting.day_pdt_rpts.eff_qlty_ss
#filter :eff_qlty_nhn, :label => Setting.day_pdt_rpts.eff_qlty_nhn
#filter :eff_qlty_tn, :label => Setting.day_pdt_rpts.eff_qlty_tn
#filter :eff_qlty_tp, :label => Setting.day_pdt_rpts.eff_qlty_tp
#filter :eff_qlty_ph, :label => Setting.day_pdt_rpts.eff_qlty_ph
#filter :eff_qlty_fecal, :label => Setting.day_pdt_rpts.eff_qlty_fecal
#filter :eff_qlty_bod, :label => Setting.day_pdt_rpts.eff_qlty_bod
#filter :sed_qlty_bod, :label => Setting.day_pdt_rpts.sed_qlty_bod
#filter :sed_qlty_cod, :label => Setting.day_pdt_rpts.sed_qlty_cod
#filter :sed_qlty_ss, :label => Setting.day_pdt_rpts.sed_qlty_ss
#filter :sed_qlty_nhn, :label => Setting.day_pdt_rpts.sed_qlty_nhn
#filter :sed_qlty_tn, :label => Setting.day_pdt_rpts.sed_qlty_tn
#filter :sed_qlty_tp, :label => Setting.day_pdt_rpts.sed_qlty_tp
#filter :sed_qlty_ph, :label => Setting.day_pdt_rpts.sed_qlty_ph
#filter :inflow, :label => Setting.day_pdt_rpts.inflow
#filter :outflow, :label => Setting.day_pdt_rpts.outflow
#filter :inmud, :label => Setting.day_pdt_rpts.inmud
#filter :outmud, :label => Setting.day_pdt_rpts.outmud
#filter :mst, :label => Setting.day_pdt_rpts.mst
#filter :power, :label => Setting.day_pdt_rpts.power
#filter :mdflow, :label => Setting.day_pdt_rpts.mdflow
#filter :mdrcy, :label => Setting.day_pdt_rpts.mdrcy
#filter :mdsell, :label => Setting.day_pdt_rpts.mdsell
#column Setting.day_pdt_rpts.weather, :weather
#column Setting.day_pdt_rpts.min_temper, :min_temper
#column Setting.day_pdt_rpts.max_temper, :max_temper
#column Setting.day_pdt_rpts.inf_qlty_bod, :inf_qlty_bod
#column Setting.day_pdt_rpts.inf_qlty_cod, :inf_qlty_cod
#column Setting.day_pdt_rpts.inf_qlty_ss, :inf_qlty_ss
#column Setting.day_pdt_rpts.inf_qlty_nhn, :inf_qlty_nhn
#column Setting.day_pdt_rpts.inf_qlty_tn, :inf_qlty_tn
#column Setting.day_pdt_rpts.inf_qlty_tp, :inf_qlty_tp
#column Setting.day_pdt_rpts.inf_qlty_ph, :inf_qlty_ph
#column Setting.day_pdt_rpts.eff_qlty_bod, :efff_qlty_bod
#column Setting.day_pdt_rpts.eff_qlty_cod, :eff_qlty_cod
#column Setting.day_pdt_rpts.eff_qlty_ss, :eff_qlty_ss
#column Setting.day_pdt_rpts.eff_qlty_nhn, :eff_qlty_nhn
#column Setting.day_pdt_rpts.eff_qlty_tn, :eff_qlty_tn
#column Setting.day_pdt_rpts.eff_qlty_tp, :eff_qlty_tp
#column Setting.day_pdt_rpts.eff_qlty_ph, :eff_qlty_ph
#column Setting.day_pdt_rpts.eff_qlty_fecal, :efff_qlty_fecal
#column Setting.day_pdt_rpts.sed_qlty_bod, :sed_qlty_bod
#column Setting.day_pdt_rpts.sed_qlty_cod, :sed_qlty_cod
#column Setting.day_pdt_rpts.sed_qlty_ss, :sed_qlty_ss
#column Setting.day_pdt_rpts.sed_qlty_nhn, :sed_qlty_nhn
#column Setting.day_pdt_rpts.sed_qlty_tn, :sed_qlty_tn
#column Setting.day_pdt_rpts.sed_qlty_tp, :sed_qlty_tp
#column Setting.day_pdt_rpts.sed_qlty_ph, :sed_qlty_ph
#column Setting.day_pdt_rpts.inflow, :inflow
#column Setting.day_pdt_rpts.outflow, :outflow
#column Setting.day_pdt_rpts.inmud, :inmud
#column Setting.day_pdt_rpts.outmud, :outmud
#column Setting.day_pdt_rpts.mst, :mst
#column Setting.day_pdt_rpts.power, :power
#column Setting.day_pdt_rpts.mdflow, :mdflow
#column Setting.day_pdt_rpts.mdrcy, :mdrcy
#column Setting.day_pdt_rpts.mdsell, :mdsell

