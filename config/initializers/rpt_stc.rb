stc_logfile = File.open("#{Rails.root}/log/day_stc_error.log", 'a')
stc_logfile.sync = true
RPT_STC_LOGGER = StatLogger.new(stc_logfile)
