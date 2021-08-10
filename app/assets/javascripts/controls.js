$(".controls.index").ready(function() {
  if ($(".controls.index").length > 0) {
    $(".chart-statistic-ctn").each(function(index, e) {
      radarChartSet(e);
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

function radarOption(my_title, my_series, my_dimensions, my_datasets, my_indicator) {
  option = {
    title: {
      text: my_title 
    },
    legend: {
      //data: [ '2015', '2016', '2017']
    },
    tooltip: {
      show: true
    },
    radar: {
      shape: 'circle',
      indicator: my_indicator
      //axisLabel:{ show:true, color:'#232', showMaxLabel: true},
    },
    label: {
      show: true
    },
    series: my_series,
    dataset: {
      dimensions: my_dimensions,
      source: my_datasets
    }
  }
  console.log(option);
  return option;
}
