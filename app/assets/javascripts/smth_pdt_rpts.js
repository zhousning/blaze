$(".smth_pdt_rpts").ready(function() {
  if ($(".smth_pdt_rpts.smth_report_finish_index").length > 0) {
    var table = "#mth-pdt-rpt-table";
    var url = '/smth_pdt_rpts/query_mth_reports';

    fct_date_event(table, url)
  }

  if ($(".smth_pdt_rpts.index").length > 0) {
    $('#mth-rpt-create').on('click', function(e) {
      var month = $("#months").val(); 
      var year = $("#year").val(); 
      var that = e.target
      var data_fct = that.dataset['fct'];
      var url = "/factories/" + data_fct + "/mth_pdt_rpts/mth_rpt_create?month=" + month + "&year=" + year;

      location.href = url; 
    });
  }

  if ($(".smth_pdt_rpts.edit").length > 0) {
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
            var id = "#mth_pdt_rpt_" + attr + "_attributes_" + item;
            $(id).val(val);
          })
        })
      });
    });
  }

});
