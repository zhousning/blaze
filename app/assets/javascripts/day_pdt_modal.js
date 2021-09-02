function day_pdt_modal() {
  var myChart = echarts.init(document.getElementById('chart-ctn'));

  $("#day-pdt-rpt-table").on('click', 'button', function(e) {
    myChart.showLoading();
    $('#newModal').modal();
    var that = e.target
    var data_fct = that.dataset['fct'];
    var data_rpt = that.dataset['rpt'];
    var url = "/factories/" + data_fct + "/day_pdt_rpts/" + data_rpt + "/produce_report";
    $.get(url).done(function (data) {
      myChart.hideLoading();
      var header = data.info.name + "&nbsp&nbsp<small class='text-success'>" + data.info.weather + " | " + data.info.temper + "℃</small>"
      $("#day-pdt-rpt-header").html(header);

      var rpt_table = "<table class='table table-bordered'>" +
        "<tr><td>进水量: " + data.info.inflow + "</td>" + 
        "    <td>出水量: " + data.info.outflow + "</td></tr>" + 
        "<tr><td>进泥量: " + data.info.inmud  + "</td>" + 
        "    <td>出泥量: " + data.info.outmud + "</td></tr>" + 
        "<tr><td>污泥含水率: " + data.info.mst + "</td>"  + 
        "    <td>耗电量: " + data.info.power  + "</td></tr>" + 
        "<tr><td>中水量: " + data.info.mdflow + "</td>" + 
        "    <td>中水回用量: " + data.info.mdrcy + "</td></tr>" +  
        "<tr><td>中水销售水量: " + data.info.mdsell + "</td>" + 
        "    <td></td></tr>" +  
        "</table>";
      $("#day-pdt-rpt-ctn").html(rpt_table);

      var title = '进出水水质';
      var series = [{type: 'bar', label: {show: true}}, {type: 'bar', label: {show: true}}];
      var dimensions = ['source', '进水', '出水'];

      var new_Option = newOption(title, series, dimensions, data.datasets)
      myChart.setOption(new_Option);
    });
  });

}
