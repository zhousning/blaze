$(".equipments").ready(function() {
  if ($(".equipments.index").length > 0) {
    equipment_upholds_modal();
    $("#report-search").click(function() {
      getDeviceItems('devices');
    });
  }
});

function getDeviceItems(method) {
  var $table = $('#day-pdt-rpt-table')
  var data = [];
  var data_fct = $('#fct').val();
  var url = "/equipments/query_all?factory_id=" + data_fct;

  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var search = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + item.id + "' data-fct = '" + item.factory +"'>维保记录</button>"; 
      data.push({
        'id' : index + 1,
        'idno' : item.idno,
        'name' : item.name,
        'mdno' : item.mdno,
        'unit' : item.unit,
        'pos' : item.pos,
        'state' : item.state,
        'search' : search 
      });
    });
    $table.bootstrapTable('load', data);
  })
}

function equipment_upholds_modal() {
  $("#day-pdt-rpt-table").on('click', 'button', function(e) {
    $('#newModal').modal();
    var that = e.target
    var data_fct = that.dataset['fct'];
    var data_rpt = that.dataset['rpt'];
    var html = '';
 
    var url = "/equipments/upholds?fct=" + data_fct + "&id=" + data_rpt;
    $.get(url).done(function (data) {

      html += '<tr><td>日期</td><td>维保原因</td><td>维保内容</td><td>费用</td><td>附图</td></tr>'; 
      $.each(data, function(k, v) {
        html += "<tr>";
        html += "<td>" + v.date + "</td>"; 
        html += "<td>" + v.reason + "</td>"; 
        html += "<td>" + v.content + "</td>"; 
        html += "<td>" + v.cost + "</td>"; 
        if (v.img != null){
          html += "<td><img class='img-fluid' src='" + v.img + "'/></td>"; 
        } else {
          html += "<td></td>"; 
        }
        html += '</tr>'; 
      })

      $("#mth-flow-ctn").html(html);
    });
  });

}
//var button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + item.id + "' data-fct = '" + item.factory +"'>查看</button>"; 
//var factory = item.factory;
//var id = item.id;
//var search = "<a class='button button-primary button-small mr-1' href='/factories/" + factory + "/" + method + "/" + id + "/'>查看</a><a class='button button-royal button-small mr-1' href='/factories/" + factory + "/" + method + "/" + id + "/edit'>编辑</a><a class='button button-inverse button-small mr-1' href='/factories/" + factory + "/" + method + "/" + id + "/uphold'>维保记录</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/factories/" + factory + "/" + method + "/" + id + "'>删除</a>"
