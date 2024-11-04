$(document).ready(function(){
		// GNB MENU (fontColor)
		var preUrl = "";
		var colorType=$(".btn_logout").css('background-color');
		var list01=$("ul.list01");
		var list02=$("ul.list02");
		
		$('.navType li.theme').css('background-color',colorType);
		$('.navType ul li').click(function(){
			$('.navType ul li').removeAttr('style');
			$('.navType ul li').removeClass('theme');
			$(this).css('background-color',colorType).addClass('theme');

		});

		$('.list01>li').click(function(){
			if (this.id < eval(5)) {
				$('.list02').hide();
				$('.list01>li').children('a').css({'font-weight':'normal'});
				$(this).children('.list02').show();
				$(this).children('a').css({'font-weight':'bold'});
			}
		});

		// GNB MENU (animate)
		$('.leftArea_display').click(function(){
			if($('.leftArea').css('left')!="0px"){
				$('.leftArea').animate({'left':'+=240px'});
				$('.rightAreaTop').animate({'margin-left':'+=240px'});
				$('.rightArea').animate({'margin-left':'+=240px'});
				$(this).addClass('hide');
				$(this).removeClass('show');
			 }else{
				$('.leftArea').animate({'left':'-=240px'});
				$('.rightAreaTop').animate({'margin-left':'-=240px'});
				$('.rightArea').animate({'margin-left':'-=240px'});
				$(this).removeClass('hide');
				$(this).addClass('show');
			}
		});
	
		// table tr hover 
		$('.hoverTable table tr').hover(function(){
			$(this).addClass('hoverColor');
		},function(){
			$(this).removeClass('hoverColor');
		});

		//tab선택 action
			$('.tab').click(function(){
				$('.tab').removeClass('on');
				$(this).addClass('on');
			});
	});