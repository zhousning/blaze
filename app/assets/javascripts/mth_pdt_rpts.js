$(".mth_pdt_rpts").ready(function() {
  if ($(".mth_pdt_rpts").length > 0) {
    $('#mth-rpt-create').on('click', function(e) {
      var month = $("#months").val(); 
      var that = e.target
      var data_fct = that.dataset['fct'];
      var url = "/factories/" + data_fct + "/mth_pdt_rpts/mth_rpt_create?month=" + month;

      location.href = url; 
    });

    $('#download-mth-pdt-rpt').on('click', function(e) {
      var that = e.target
      var data_fct = that.dataset['fct'];
      var data_mthrpt = that.dataset['mthrpt'];
      var url = "/factories/" + data_fct + "/mth_pdt_rpts/" + data_mthrpt + "/download_report";

      location.href = url; 
    })
  }
});
