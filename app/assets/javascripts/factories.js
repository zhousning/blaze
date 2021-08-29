$(".factories.index").ready(function() {
  if ($(".factories.bigscreen").length > 0) {
    var charts = []
    $(".chart-statistic-ctn").each(function(index, e) {
      var chart = radarChartSet(e);
      charts.push(chart);
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
        chart.resize(); //没有初始宽高 resize初始化父容器的宽高
      });
      charts.push(chart);
    });
    chartResize(charts);
  }

});

function chartResize(charts) {
  //浏览器窗口大小变化时，重置报表大小
  $(window).resize(function() {
    for (var i =0; i <charts.length; i++ ) {
      charts[i].resize();
    }
  });
}

function radarChartSet(that_chart) {
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var pos_type = that_chart.dataset['pos'];
  var factory_id = that_chart.dataset['fct'];

  var chart = chartRadar(that_chart, factory_id, search_type, pos_type, chart_type)
  return chart;
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
    chart.resize();
  });
  return chart;
}

