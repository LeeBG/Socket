<%@ page contentType="text/html; charset=utf-8"%>
<script type="text/javascript">
	$('input[placeholder], textarea[placeholder]').each(function(index,item){
		if( ! item.id ) return;
		
		$(item).before('<label for="'+item.id+'"></label>');
	});
</script>
<script src="/JavaScript/placeholder_polyfill.jquery.min.combo.js" charset="utf-8"></script>
<script src="/JavaScript/jquery.ba-resize.min.js" charset="utf-8"></script>