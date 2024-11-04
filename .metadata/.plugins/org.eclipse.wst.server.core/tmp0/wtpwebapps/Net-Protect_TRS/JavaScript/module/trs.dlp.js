function dlpDetail(){
	var img_count = 0;
	var text_count = 0;
	$(".dlp_img_cd").each(function(){
		if($(this).val() == 'Y'){
			img_count++;
		}else{
			text_count++;
		}
	});
	if(img_count>0){
		$(".dlp_img_cd").eq(text_count).parent().parent().prepend("<td class='t_center Rborder' rowspan='"+img_count+"'>이미지 검출</td>");
	}
	if(text_count>0){
		$(".dlp_img_cd").eq(0).parent().parent().prepend("<td class='t_center Rborder' rowspan='"+text_count+"'>텍스트 검출</td>");
	}
}