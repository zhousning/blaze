$(".controls.index").ready(function() {
  if ($(".controls.index").length > 0) {
    $(".area-time-search").on('click', function(e) {
      mainQuotaChartSet(e.target);
    })
  }
});

function mainQuotaChartSet(that_search) {
  //var qcodes = $("#qcodes").val();
  var start = $("#start").val();
  var end = $("#end").val();
  var fcts = "";
  var charts = [];
  var check_boxes = $("input[name='fcts']:checked");

  $.each(check_boxes, function(){
    fcts += $(this).val() + ","
  });

  var power_chart = $(".power-chart")[0]
  var tpcost_chart = $(".tpcost-chart")[0]
  var tncost_chart = $(".tncost-chart")[0]
  var tputcost_chart = $(".tputcost-chart")[0]
  var tnutcost_chart = $(".tnutcost-chart")[0]
  var percost_chart = $(".percost-chart")[0]

  var power_url = '/analyses/power_bom';
  var tpcost_url = '/analyses/tpcost';
  var tncost_url = '/analyses/tncost';
  var tputcost_url = '/analyses/tputcost';
  var tnutcost_url = '/analyses/tnutcost';
  var percost_url = '/analyses/percost';

  charts.push(controlChartConfig(power_url, power_chart, start, end, fcts));
  charts.push(controlChartConfig(tpcost_url, tpcost_chart, start, end, fcts));
  charts.push(controlChartConfig(tncost_url, tncost_chart, start, end, fcts));
  charts.push(controlChartConfig(tputcost_url, tputcost_chart, start, end, fcts));
  charts.push(controlChartConfig(tnutcost_url, tnutcost_chart, start, end, fcts));
  charts.push(controlChartConfig(percost_url, percost_chart, start, end, fcts));

  chartResize(charts);
}

function controlChartConfig(url, that_chart, start, end, fcts) {
  var chart = echarts.init(that_chart);
  chart.showLoading();
  var obj = {start: start, end: end, fcts: fcts}
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
