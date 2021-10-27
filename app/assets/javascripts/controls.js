$(".controls.index").ready(function() {
  if ($(".controls.index").length > 0) {
    $(".area-time-search").on('click', function(e) {
      mainQuotaChartSet(e.target);
    })
  }
});

function mainQuotaChartSet(that_search) {
  var qcodes = $("#qcodes").val();
  var start = $("#start").val();
  var end = $("#end").val();
  var fcts = "";
  var url = "/analyses/main_quota";
  var charts = [];

  var check_boxes = $("input[name='fcts']:checked");

  $.each(check_boxes, function(){
    fcts += $(this).val() + ","
  });

  var that_chart = $(".chart-statistic-ctn")[0]
  charts.push(mainQuotaChartConfig(url, that_chart, start, end, fcts, qcodes));
  chartResize(charts);
}

function mainQuotaChartConfig(url, that_chart, start, end, fcts, quota) {
  var chart = echarts.init(that_chart);
  chart.showLoading();
  var obj = {start: start, end: end, fcts: fcts, quota: quota}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = newOption(data.title, data.series, data.dimensions, data.datasets)
    chart.setOption(new_Option, true);
  });
  return chart;
}

/*
$(".chart-statistic-ctn").each(function(index, e) {
  radarChartSet(e);
});

$(".chart-gauge-ctn").each(function(index, that_chart) {
  var qcode = that_chart.dataset['code'];
  var factory_id = that_chart.dataset['fct'];
  var chart = echarts.init(that_chart);
  chart.showLoading();

  var obj = {factory_id: factory_id, qcode: qcode }
  var url = "/day_pdt_rpts/new_quota_chart";
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = gaugeOption(data.name, data.value, data.min, data.max, data.color)
    chart.setOption(new_Option, true);
  });
});
*/
