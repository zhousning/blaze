$(".emp_infs").ready(function() {

  if ($(".analyses.compare").length > 0) {
    $(".sglfct-statistic-search").on('click', function(e) {
      monthCompareChartSet(e.target);
    })
  }
  if ($(".emp_infs.index").length > 0) {
    $(".area-time-search").on('click', function(e) {
      empInfChartSet(e.target);
    })
  }

});

function empInfChartSet(that_search) {
  var qcodes = $("#qcodes").val();
  var start = $("#start").val();
  var end = $("#end").val();
  var fct = that_chart.dataset['fct'];

  var url = "/analyses/area_time_compare";
  var chart_ctn = $('#chart-ctn')

  empInfChartConfig(url, that_chart, start, end, fct, qcodes)

}

function empInfChartConfig(url, that_chart, start, end, fct, quota) {

  var chart = echarts.init(that_chart);
  chart.showLoading();
  var obj = {start: start, end: end, fct: fct, quota: quota}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var rain_Option = rainOption(data)
    chart.setOption(rain_Option, true);
  });
}

function rainOption(data) {
  option = {
      title: {
          text: '水质流量关系图',
          subtext: '数据来自济宁市环境监测系统',
          left: 'center',
          align: 'right'
      },
      grid: {
          bottom: 80
      },
      toolbox: {
          feature: {
              dataZoom: {
                  yAxisIndex: 'none'
              },
              restore: {},
              saveAsImage: {}
          }
      },
      tooltip: {
          trigger: 'axis',
          axisPointer: {
              type: 'cross',
              animation: false,
              label: {
                  backgroundColor: '#505765'
              }
          }
      },
      legend: {
          data: ['流量', '降雨量'],
          left: 10
      },
      dataZoom: [
          {
              show: true,
              realtime: true,
              start: 65,
              end: 85
          },
          {
              type: 'inside',
              realtime: true,
              start: 65,
              end: 85
          }
      ],
      xAxis: [
          {
              type: 'category',
              boundaryGap: false,
              axisLine: {onZero: false},
              data: [
              ].map(function (str) {
                  return str.replace(' ', '\n');
              })
          }
      ],
      yAxis: [
          {
              name: '流量(m^3/s)',
              type: 'value',
              max: 500
          },
          {
              name: '降雨量(mm)',
              nameLocation: 'start',
              max: 5,
              type: 'value',
              inverse: true
          }
      ],
      series: [
          {
              name: '流量',
              type: 'line',
              areaStyle: {},
              lineStyle: {
                  width: 1
              },
              emphasis: {
                  focus: 'series'
              },
              markArea: {
                  silent: true,
                  itemStyle: {
                      opacity: 0.3
                  },
                  data: [[{
                      xAxis: '2009/9/12\n7:00'
                  }, {
                      xAxis: '2009/9/22\n7:00'
                  }]]
              },
              data: [
              ]
          },
          {
              name: '降雨量',
              type: 'line',
              yAxisIndex: 1,
              areaStyle: {},
              lineStyle: {
                  width: 1
              },
              emphasis: {
                  focus: 'series'
                    M
              },
              markArea: {
                  silent: true,
                  itemStyle: {
                      opacity: 0.3
                  },
                  data: [
                      [{
                          xAxis: '2009/9/10\n7:00'
                      }, {
                          xAxis: '2009/9/20\n7:00'
                      }]
                  ]
              },
              data: [
              ]
          }
      ]
  };
  return option
}
