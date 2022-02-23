Rails.application.routes.draw do
  root :to => 'controls#index'

  #mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'forget', to: 'admin/dashboard#index'
  #devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do
    #get 'forget', to: 'users/passwords#forget'
    #patch 'update_password', to: 'users/passwords#update_password'
    #post '/login_validate', to: 'users/sessions#user_validate'
    #
    #unauthenticated :user do
    #  root to: "devise/sessions#new",as: :unauthenticated_root #设定登录页为系统默认首页
    #end
    #authenticated :user do
    #  root to: "homes#index",as: :authenticated_root #设定系统登录后首页
    #end
  end

  #resources :users, :only => []  do
  #  get :center, :on => :collection
  #  get :alipay_return, :on => :collection
  #  post :alipay_notify, :on => :collection
  #  get :mobile_authc_new, :on => :member
  #  post :mobile_authc_create, :on => :member
  #  get :mobile_authc_status, :on => :member
  #end

  resources :roles

  #resources :accounts, :only => [:edit, :update] do
  #  get :recharge, :on => :collection 
  #  get :info, :on => :collection
  #  get :status, :on => :collection
  #end

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :properties
  resources :nests 
  resources :domains 

  resources :controls, :only => [:index]
  resources :templates do
    get :produce, :on => :member
  end

  #resources :nlps do
  #  collection do
  #    post 'analyze'
  #  end
  #end
  #resources :ocrs do
  #  post :analyze, :on => :collection
  #end

  resources :notices
  #resources :articles do
  #  get :export, :on => :collection
  #  get :main_image, :on => :member
  #  get :detail_image, :on => :member
  #end

  #resources :systems, :only => [] do
  #  get :send_confirm_code, :on => :collection
  #end
  #
  #resources :orders, :only => [:new, :create] do
  #  get :pay, :on => :collection
  #  get :alipay_return, :on => :collection
  #  post :alipay_notify, :on => :collection
  #end

  #resources :tasks, :only => [] do
  #  get :invite, :on => :collection
  #end

  resources :spiders do
    get :start, :on => :member
  end

  resources :selectors
 
  resources :factories, :only => [:edit, :update] do
    get :bigscreen, :on => :member
    resources :day_pdts, :only => [:index, :show, :edit, :update] do
      get :upreport, :on => :member
      get :verifying, :on => :member
      get :rejected, :on => :member
      get :verify_index, :on => :collection
      get :verify_show, :on => :member
      get :cmp_verifying, :on => :member
      get :cmp_rejected, :on => :member
      get :cmp_verify_index, :on => :collection
      get :cmp_verify_show, :on => :member
      get :emp_sync, :on => :member
      get :only_emp_sync, :on => :collection
    end
    resources :day_pdt_rpts, :only => [:index, :show] do
      get :produce_report, :on => :member
      get :xls_day_download, :on => :member
    end
    resources :analyses, :only => [] do
      get :month_compare, :on => :collection
    end
    resources :mth_pdt_rpts, :only => [:index, :edit, :update, :show] do
      get :mth_rpt_sync, :on => :member
      get :produce_report, :on => :member
      get :mth_rpt_create, :on => :collection
      get :download_report, :on => :member
      get :upreport, :on => :member
      get :verifying, :on => :member
      get :rejected, :on => :member
      get :verify_index, :on => :collection
      get :verify_show, :on => :member
      get :cmp_verifying, :on => :member
      get :cmp_rejected, :on => :member
      get :cmp_verify_index, :on => :collection
      get :cmp_verify_show, :on => :member
      get :mth_report_finish_index, :on => :collection
      get :mth_report_finish_show, :on => :member
      get :xls_mth_download, :on => :member
      get :download_append, :on => :member
      get :mth_rpt_sync, :on => :member
    end
    resources :emp_infs, :only => [:index, :create]  do
      get :watercms_flow, :on => :collection
      post :parse_fct_excel, :on => :collection
      get :fct_edit, :on => :member
      patch :fct_update, :on => :member
      delete :fct_destroy, :on => :member
    end
    resources :emp_effs, :only => [:index, :create] do
      get :watercms_flow, :on => :collection
      post :parse_fct_excel, :on => :collection
      get :fct_edit, :on => :member
      patch :fct_update, :on => :member
      delete :fct_destroy, :on => :member
    end
  end

  resources :emp_infs do
    post :parse_excel, :on => :collection
    get :xls_download, :on => :collection
    get :watercms_flow, :on => :collection
    get :grp_index, :on => :collection
    #get :query_list, :on => :collection
  end

  resources :emp_effs do
    post :parse_excel, :on => :collection
    get :xls_download, :on => :collection
    get :watercms_flow, :on => :collection
    get :grp_index, :on => :collection
    #get :query_list, :on => :collection
  end

  resources :day_pdt_rpts, :only => [] do
    get :sglfct_statistic, :on => :collection
    get :emq_cau, :on => :collection
    get :emr_cau, :on => :collection
    get :power_cau, :on => :collection
    get :bom_cau, :on => :collection
    get :sglfct_stc_cau, :on => :collection
    get :static_pool, :on => :collection
    get :radar_chart, :on => :collection
    get :new_quota_chart, :on => :collection
  end
  resources :analyses, :only => [] do
    get :compare, :on => :collection
    get :area_time, :on => :collection
    get :area_time_compare, :on => :collection
    get :power_bom, :on => :collection
    get :tpcost, :on => :collection
    get :tncost, :on => :collection
    get :tputcost, :on => :collection
    get :tnutcost, :on => :collection
    get :ctputcost, :on => :collection
    get :ctnutcost, :on => :collection
    get :percost, :on => :collection
    get :zbdblv, :on => :collection
    get :cms_qes_report, :on => :collection
    get :online_qes_report, :on => :collection
  end
  resources :reports, :only => [:index] do
    get :day_report, :on => :collection
    get :mth_report, :on => :collection
    get :mth_report_show, :on => :member
    get :xls_day_download, :on => :collection
    get :xls_mth_download, :on => :collection
    get :query_day_reports, :on => :collection
    get :query_mth_reports, :on => :collection
  end
  resources :sreports, :only => [:index] do
    get :day_report, :on => :collection
    get :mth_report, :on => :collection
    get :mth_report_show, :on => :member
    get :xls_day_download, :on => :collection
    get :xls_mth_download, :on => :collection
    get :query_day_reports, :on => :collection
    get :query_mth_reports, :on => :collection
  end
  #resources :departments do
  #  get :download_append, :on => :member
  #  post :parse_excel, :on => :collection
  #  get :xls_download, :on => :collection
  #end
  resources :day_rpt_stcs do
  end
  resources :sday_pdts, :only => [:index] do
    get :verify_index, :on => :collection
    get :cmp_verify_index, :on => :collection
  end
  resources :sday_pdt_rpts, :only => [:index] do
    get :query_all, :on => :collection
  end
  resources :smth_pdt_rpts, :only => [:index] do
    get :verify_index, :on => :collection
    get :cmp_verify_index, :on => :collection
    get :smth_report_finish_index, :on => :collection
  end
  resources :sfactories, :only => [:edit, :update] do
    resources :sday_pdts, :only => [:show, :edit, :update] do
      get :upreport, :on => :member
      get :verifying, :on => :member
      get :rejected, :on => :member
      get :verify_show, :on => :member
      get :cmp_verifying, :on => :member
      get :cmp_rejected, :on => :member
      get :cmp_verify_show, :on => :member
      get :emp_sync, :on => :member
      get :only_emp_sync, :on => :collection
    end
    resources :sday_pdt_rpts, :only => [:show] do
      get :produce_report, :on => :member
      get :xls_day_download, :on => :member
    end
    resources :sanalyses, :only => [] do
      get :month_compare, :on => :collection
    end
    resources :smth_pdt_rpts, :only => [:edit, :update, :show] do
      get :mth_rpt_sync, :on => :member
      get :produce_report, :on => :member
      get :mth_rpt_create, :on => :collection
      get :download_report, :on => :member
      get :upreport, :on => :member
      get :verifying, :on => :member
      get :rejected, :on => :member
      get :verify_show, :on => :member
      get :cmp_verifying, :on => :member
      get :cmp_rejected, :on => :member
      get :cmp_verify_show, :on => :member
      get :mth_report_finish_show, :on => :member
      get :xls_mth_download, :on => :member
      get :download_append, :on => :member
      get :mth_rpt_sync, :on => :member
    end
  end
  #resources :companies, :only => [] do
  #  resources :sday_rpts do
  #    get :download_append, :on => :member
  #  end
  #end
  resources :flower

end
