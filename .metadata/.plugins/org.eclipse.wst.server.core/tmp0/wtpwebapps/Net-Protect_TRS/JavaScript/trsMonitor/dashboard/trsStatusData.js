var detail5Timer = null;
var reloadTime5 = 60;

var jqgrid_manager = new jqGridManager();
$(document).ready(function() {
	jqgrid_manager.setting("dashboard");
	jqgrid_manager.init(jqgridModel,formVal);
	initAbnormalList();
	
});
//이상 파일 전송 현황 interval setting
function initAbnormalList(){
	if(detail5Timer) clearInterval(detail5Timer);
	detail5Timer = setInterval(jqgrid_manager.reload, reloadTime5 * 1000, jqgridModel, formVal);
}
