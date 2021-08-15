$(".day_pdts").ready(function() {
  if ($(".day_pdts").length > 0) {
    $('.day-pdt-date-picker').datepicker({
      language: 'zh-CN',
      autoclose: true,
      todayHighlight: true
    })
  }
});
