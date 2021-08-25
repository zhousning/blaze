$(".mth_pdt_rpts").ready(function() {
  if ($(".mth_pdt_rpts").length > 0) {
    $('#mth-rpt-create').on('click', function(e) {
      var month = $("#months").val(); 
      var year = $("#year").val(); 
      var that = e.target
      var data_fct = that.dataset['fct'];
      var url = "/factories/" + data_fct + "/mth_pdt_rpts/mth_rpt_create?month=" + month + "&year=" + year;

      location.href = url; 
    });
  }
});
