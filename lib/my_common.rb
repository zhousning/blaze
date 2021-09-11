module MyCommon
  def MyCommon.quota_hash 
    quota_hash = Hash.new
    quotas = Quota.all
    quotas.each do |q|
      quota_hash[q.code.strip] = {:name => q.name.gsub(/在线-|化验-/, ''), :max => q.max }
    end
    quota_hash
  end

  def MyCommon.cms_sub_pref(title)
    title = title.gsub(/在线-|化验-/, '')
    title
  end
end
