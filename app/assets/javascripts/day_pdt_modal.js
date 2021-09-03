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
      var header = data.header.name + "&nbsp&nbsp<small class='text-success'>" + data.header.weather + " | " + data.header.temper + "%u2103</small>"
      $("#day-pdt-rpt-header").html(header);

      var cms = data.cms;
      var mud = data.mud;
      var power = data.power;
      var md = data.md;
      var tspmuds = data.tspmuds;
      var chemicals = data.chemicals;

      var day_pdt_rpt_ctn = ''; 
      $.each(cms, function(k, v) {
        day_pdt_rpt_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#day-pdt-rpt-ctn").html(day_pdt_rpt_ctn);

      var title = '进水水质';
      var series = [{type: 'bar', label: {show: true}}, {type: 'bar', label: {show: true}}];
      var dimensions = ['source', '进水', '出水'];
      var new_Option = newOption(title, series, dimensions, data.datasets)
      myChart.setOption(new_Option);
    });
  });

}
