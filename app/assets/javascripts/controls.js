$(".controls.index").ready(function() {
  if ($(".controls.index").length > 0) {
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
  }

});

function radarChartSet(that_chart) {
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var pos_type = that_chart.dataset['pos'];
  var factory_id = that_chart.dataset['fct'];

  chartRadar(that_chart, factory_id, search_type, pos_type, chart_type)
}

function chartRadar(that_chart, factory_id, search_type, pos_type, chart_type){
  var chart = echarts.init(that_chart);
  chart.showLoading();
  var obj = {factory_id: factory_id, search_type: search_type, pos_type: pos_type, chart_type: chart_type }
  var url = "/day_pdt_rpts/radar_chart";
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = radarOption(data.title, data.series, data.dimensions, data.datasets, data.indicator)
    chart.setOption(new_Option, true);
  });
}

