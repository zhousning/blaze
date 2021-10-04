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
      var that = e.target
      var data_fct = that.dataset['fct'];
      var data_mth = that.dataset['mth'];
      var url = "/factories/" + data_fct + "/mth_pdt_rpts/" + data_mth + "/mth_rpt_sync";

      $.get(url).done(function (data) {
        var cms = data.cms;
        var flow = data.flow;

        $.each(flow, function(item_k, item_v) {
          var item = item_k;
          var val = item_v;
          var id = "#mth_pdt_rpt_" + item;
          $(id).val(val);
        })

        $.each(cms, function(k, v) {
          var attr = k;
          $.each(v, function(item_k, item_v) {
            var item = item_k;
            var val = item_v;
            var id = "#mth_pdt_rpt_month_" + attr + "_attributes_" + item;
            $(id).val(val);
          })
        })
      });
    });
  }
});
