function mth_pdt_modal() {
  var myChart = echarts.init(document.getElementById('chart-ctn'));
  $("#mth-pdt-rpt-table").on('click', 'button', function(e) {
    myChart.showLoading();
    $('#newModal').modal();
    var that = e.target
    var data_fct = that.dataset['fct'];
    var data_rpt = that.dataset['rpt'];
    var url = "/factories/" + data_fct + "/mth_pdt_rpts/" + data_rpt + "/produce_report";
    $.get(url).done(function (data) {
      myChart.hideLoading();
      var header = data.header.name + "&nbsp&nbsp<small class='text-success'>" + data.header.weather + " | " + data.header.min_temper + "一" + data.header.max_temper + "摄氏度 </small>"
      $("#mth-pdt-rpt-header").html(header);

      var flow = data.flow;
      var emq = data.cms_emq;
      var emr = data.cms_emr;
      var mud = data.mud;
      var power = data.power;
      var md = data.md;
      var tspmuds = data.tspmuds;
      var chemicals = data.chemicals.chemicals_data;
      var chemical_per_cost = data.chemicals.per_cost;
      var fct_id = data.fct_id;
      var mth_rpt_id = data.mth_rpt_id;
      
      var xls_download = "/factories/" + fct_id + "/mth_pdt_rpts/" + mth_rpt_id + "/xls_mth_download";
      $("#xls-download").attr("href", xls_download);

      var mth_flow_ctn = ''; 
      $.each(flow, function(k, v) {
        mth_flow_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#mth-flow-ctn").html(mth_flow_ctn);

      var emq_table = '<tr><th></th><th>COD</th><th>BOD</th><th>NH3-N</th><th>TP</th><th>TN</th><th>SS</th></tr>';
      emq_table += '<tr><td>削减量</td>'; 
      $.each(emq, function(k, v) {
        emq_table += "<td>" + v + "</td>"; 
      })
      emq_table += '</tr>'; 

      emq_table += '<tr><td>削减率</td>'; 
      $.each(emr, function(k, v) {
        emq_table += "<td>" + v + "</td>"; 
      })
      emq_table += '</tr>'; 

      $("#mth-emq-ctn").html(emq_table);


      var mth_power_ctn = ''; 
      $.each(power, function(k, v) {
        mth_power_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#mth-power-ctn").html(mth_power_ctn);


      var chemical_table = '<tr><th></th><th>单价(元/吨)</th><th>药剂浓度(%)</th><th>投加量(吨)</th><th>药剂投加浓度</th><th>吨水药剂成本</th></tr>';
      for (var i=0; i<chemicals.length; i++){
        chemical_table += '<tr>';
        $.each(chemicals[i], function(k, v) {
          chemical_table += "<td>" + v + "</td>"; 
        })
        chemical_table += '</tr>';
      }
      $("#mth-chemical-ctn").html(chemical_table);

      $("#mth-chemical-per-cost").html(chemical_per_cost);


      var mth_mud_ctn = ''; 
      $.each(mud, function(k, v) {
        mth_mud_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#mth-mud-ctn").html(mth_mud_ctn);

      var tspmud_table = '<tr><th>处置单位</th><th>转运泥量</th><th>处置单位接收量</th><th>价格(元/吨)</th><th>处置方式</th><th>后续产品走向</th></tr>';
      for (var i=0; i<tspmuds.length; i++){
        tspmud_table += '<tr>';
        $.each(tspmuds[i], function(k, v) {
          tspmud_table += "<td>" + v + "</td>"; 
        })
        tspmud_table += '</tr>';
      }
      $("#mth-tspmud-ctn").html(tspmud_table);


      var mth_md_ctn = ''; 
      $.each(md, function(k, v) {
        mth_md_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#mth-md-ctn").html(mth_md_ctn);

      var title = '进水水质';
      var series = [{type: 'bar', label: {show: true}}, {type: 'bar', label: {show: true}}];
      var dimensions = ['source', '进水', '出水'];
      var new_Option = newOption(title, series, dimensions, data.datasets)
      myChart.setOption(new_Option);
    });
  });

}
