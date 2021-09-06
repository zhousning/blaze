$(".day_pdts").ready(function() {
  if ($(".day_pdts.new, .day_pdts.edit, .day_pdts.update").length > 0) {
    $("#day-pdt-date").blur(function() {
      var that = this;
      var date = $(that).val();
      var form = $(that).parents("form")[0];
      var action = $(form).attr('action').match(/\/[\s\S]+\//);
      var url = action  +  "only_emp_sync";
      var inf_cod = $("#day_pdt_inf_qlty_attributes_cod");
      var inf_nhn = $("#day_pdt_inf_qlty_attributes_nhn");
      var inf_tp = $("#day_pdt_inf_qlty_attributes_tp");
      var inf_tn = $("#day_pdt_inf_qlty_attributes_tn");
      var eff_cod = $("#day_pdt_eff_qlty_attributes_cod");
      var eff_nhn = $("#day_pdt_eff_qlty_attributes_nhn");
      var eff_tp = $("#day_pdt_eff_qlty_attributes_tp");
      var eff_tn = $("#day_pdt_eff_qlty_attributes_tn");
      var inflow = $("#day_pdt_pdt_sum_attributes_inflow");
      var outflow = $("#day_pdt_pdt_sum_attributes_outflow");

      if ($.trim(date) != '') {
        $.get(url, {search_date: date}).done(function (data) {
          if (data.state == 'success') {
            $("#flash_explanation").html("");
            inf_cod.val(data.inf.cod);
            inf_nhn.val(data.inf.nhn);
            inf_tp.val(data.inf.tp);
            inf_tn.val(data.inf.tn);
            eff_cod.val(data.eff.cod);
            eff_nhn.val(data.eff.nhn);
            eff_tp.val(data.eff.tp);
            eff_tn.val(data.eff.tn);
            inflow .val(data.inf.inflow);
            outflow.val(data.eff.outflow);
          } else if (data.state == 'error') {
            $("#flash_explanation").html("<div class='alert alert-danger text-left'>当前日期暂无环境监测系统数据，请先上传数据, 上传后系统自动计算在线数据</div>");
          }
        })
      }
    });
  }
});

/*$('.day-pdt-date-picker').datepicker({
  language: 'zh-CN',
  autoclose: true,
  todayHighlight: true
})*/
