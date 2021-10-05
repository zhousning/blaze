$(".mth_pdt_rpts").ready(function() {
  if ($(".mth_pdt_rpts.index").length > 0) {
    $('#mth-rpt-create').on('click', function(e) {
      var month = $("#months").val(); 
      var year = $("#year").val(); 
      var that = e.target
      var data_fct = that.dataset['fct'];
      var url = "/factories/" + data_fct + "/mth_pdt_rpts/mth_rpt_create?month=" + month + "&year=" + year;

      location.href = url; 
    });
  }

  if ($(".mth_pdt_rpts.edit").length > 0) {
    $('#mth-pdt-sync-btn').on('click', function(e) {
      var data_fct = $("#fct").val();
      var data_mth = $("#mth").val();
      var url = "/factories/" + data_fct + "/mth_pdt_rpts/" + data_mth + "/mth_rpt_sync";

      $.get(url).done(function (data) {
        var flow = data.flow;
        var chemicals = data.chemicals;
        var cms = data.cms;

        $.each(flow, function(item_k, item_v) {
          var item = item_k;
          var val = item_v;
          var id = "#mth_pdt_rpt_" + item;
          $(id).val(val);
        })

        for (var i=0; i<chemicals.length; i++) {
          var chemical_code = chemicals[i].chemical_code;
          var chemical_title = chemicals[i].chemical_title;
          var id = '#' + chemical_code + '_name'; 

          if ($(id).length == 0) {
            var chemical_item = chemical_item_str(chemical_code, chemical_title);
            $("#mth-chemical-ctn").append(chemical_item);
          }
        }

        for (var i=0; i<chemicals.length; i++) {
          var chemical_code = chemicals[i].chemical_code;
          var dosage = chemicals[i].dosage;
          var avg_dosage = chemicals[i].avg_dosage;
          var id = '#' + chemical_code + '_name'; 

          var dosage_node = '#' + chemical_code + '_dosage'; 
          var avg_dosage_node = '#' + chemical_code + '_avg_dosage'; 

          $(dosage_node).val(dosage);
          $(avg_dosage_node).val(avg_dosage);
        }

        $.each(cms, function(k, v) {
          var attr = k;
          $.each(v, function(item_k, item_v) {
            var item = item_k;
            var val = item_v;
            var id = "#mth_pdt_rpt_month_" + attr + "_attributes_" + item;
          })
        })
      });
    });
  }

  function chemical_item_str(code, title) {
    var number = Math.round(Math.random()*90000+10000);
    var str = "<div class='nested-fields'><div class='form-group mb-0'><div class='field d-inline'><table class='w-100 table-bordered day-pdt-table ml-2'><tbody><tr><td class='p-2 text-center' colspan='2'>" + title + "<input type='hidden' value='" + code + "' name='mth_pdt_rpt[mth_chemicals_attributes][" + number + "][name]' id='" + code + "_name'></td>"
  
    str += "<td class='p-2 text-center'><label class='text-center' for='mth_pdt_rpt_mth_chemicals_attributes_" + number + "_累计投加量(吨)'>累计投加量(吨)</label></td><td class='p-2 text-center'><input class='form-control rounded-0' step='any'  required='required' type='number' name='mth_pdt_rpt[mth_chemicals_attributes][" + number + "][dosage]' id='" + code + "_dosage'></td><td class='p-2 text-center'><label class='text-center' for='mth_pdt_rpt_mth_chemicals_attributes_" + number + "_平均每日投加量(吨/天)'>平均每日投加量(吨/天)</label></td><td class='p-2 text-center'><input class='form-control rounded-0' step='any'  required='required' type='number' name='mth_pdt_rpt[mth_chemicals_attributes][" + number + "][avg_dosage]' id='" + code + "_avg_dosage'></td></tr><tr><td class='p-2 text-center'><label class='text-center' for='mth_pdt_rpt_mth_chemicals_attributes_" + number + "_单价(元/吨)'>单价(元/吨)</label></td><td class='p-2 text-center'><input class='form-control rounded-0 border-danger' step='any' required='required' type='number' name='mth_pdt_rpt[mth_chemicals_attributes][" + number + "][unprice]' id='mth_pdt_rpt_mth_chemicals_attributes_" + number + "_unprice'></td><td class='p-2 text-center'<label class='text-center' for='mth_pdt_rpt_mth_chemicals_attributes_" + number + "_药剂浓度(%)'>药剂浓度(%)</label></td><td class='p-2 text-center'><input class='form-control rounded-0 border-danger' step='any' required='required' type='number' name='mth_pdt_rpt[mth_chemicals_attributes][" + number + "][cmptc]' id='mth_pdt_rpt_mth_chemicals_attributes_" + number + "_cmptc'></td><td class='p-2 text-center'><label class='text-center' for='mth_pdt_rpt_mth_chemicals_attributes_" + number + "_修正累计投加量(吨)'>修正累计投加量(吨)</label></td><td class='p-2 text-center'><input class='form-control rounded-0 border-danger' step='any' required='required' type='number' name='mth_pdt_rpt[mth_chemicals_attributes][" + number + "][act_dosage]' id='mth_pdt_rpt_mth_chemicals_attributes_" + number + "_act_dosage'></td></tr></tbody></table></div></div></div>"
    return str;
  }
});
