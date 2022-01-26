
var ajaxbtn = {
	init : function(){
		if($('._ajax-btn').length > 0){
			this.action();
		}
	},
	action : function(){
		var spd = 500;

		$(document).on('click','._ajax-btn',function(){
			var href = $(this).attr('href');
			var idx = $(this).data('idx');
			var type = $(this).data('type');

			if(type == undefined){
				type = 'GET';
			}

			$.ajax({
				type: type,
				url: href,
				data : idx,
				success : function(data) {
					$('body').find('._pop-ajax').remove().end().append(data).find('._pop-ajax').fadeIn(spd);
				}
			});
			return false;
		});

		$(document).on('click','._pop-ajax ._bg, ._pop-ajax ._close',function(){
			$('._pop-ajax').fadeOut(spd, function(){$(this).remove()});
			return false;
		});
	}
}



var nav = {
	init : function(){
		this.action();
	},
	action : function(){
		var wrap = $('#wrap');
		var a = $('#nav');
		var b = $('#header');
		var menu = b.find('.btn');
		var gnb = a.find('.gnb > li > a');
		var close = a.find('._close');

		menu.on('click',function(){
			wrap.addClass('nav-on');
		});

		close.on('click',function(){
			wrap.removeClass('nav-on');
		});

		gnb.on('click',function(){
			var par = $(this).closest('li');
			if($(this).next('ul').length > 0){
				par.toggleClass('active').siblings().removeClass('active');
				return false;
			}
		});
	}
}


$(document).ready(function(){
	ajaxbtn.init();
	nav.init();
});