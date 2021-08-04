module DayPdtRptsHelper

  def options_for_my_factory(factories)
    str = ""
    factories.each do |f|
      str += "<option value='" + idencode(f.id).to_s + "'>" + f.name + "</option>"
    end

    raw(str)
  end
end  
