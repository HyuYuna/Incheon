/**************************************************

	Global.css ( ver 1.0.0 )

**************************************************/
//디바이스 체크
getdevice = function(){
	if($('#_device_pc').css('display')=='block'){
		return 'pc';
	}else if($('#_device_ta').css('display')=='block'){
		return 'ta';
	}else if($('#_device_mo').css('display')=='block'){
		return 'mo';
	}else{
		return null;
	}
}


$(document).ready(function(){
    $('a.fancybox').fancybox();
})

//전역변수 선언
VARS = {
	'ani' : {
		'speed' : 600,
		'easing' : 'easeInOutExpo'
	}
}

/**************************************************
	layout
**************************************************/
//AJAX POPUP
ajaxpop = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'btn' : $('*[data-ajaxpop]'),
			'pop' : $('<div id="popup"></div>'),
			'bg' : $('<div id="popupBG"></div>')
		}
        //open
		$ele.btn.on({
			'click' : function(e){
				e.preventDefault();
                var src = $(this).data('ajaxpop');
				$('body')
                .append($ele.bg)
                .append($ele.pop);
                $('#popup').load(src,function(){
                    $('#popup').addClass('on');
                    $('#popupBG').addClass('on');
                    $('html,body').css({
                        'overflow' : 'hidden'
                    })
                });
			}
		});
        //close
        $(document).on('click','#popup .close, #popupBG',function(e){
            e.preventDefault();
            $('#popup').removeClass('on').remove();
            $('#popupBG').removeClass('on').remove();
            $('html,body').css({
                'overflow' : 'auto'
            })
        })

	}
}
$(function(){
    ajaxpop.init();
})

//위로가기 버튼
gotop = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'btn' : $('#gotop')
		}
		$ele.btn.on({
			'click' : function(e){
				e.preventDefault();
				$('html,body').animate({
					'scrollTop' : 0
				},VARS.ani)
			}
		})
	}
}
$(function(){
    if($('#gotop').length>0){
        gotop.init();
    }
    $('#ft-fam > a').on({
        'click' : function(e){
            e.preventDefault();
        }
    })
})

//헤더 검색 버튼
hd_sch = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'box' : $('#hd-sch'),
			'btn' : $('#hd-sch .btn')
		}
		$ele.btn.on({
			'click' : function(e){
				e.preventDefault();
				$ele.box.toggleClass('on');
			}
		})
	}
}
$(function(){
    if($('#hd-sch').length>0){
        hd_sch.init();
    }
})

//LNB가 없는 페이지인 경우 full size로 맞춤 (left형 LNB 레이아웃인 경우)
full_layout = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		if($('#sub').length>0 && $('#gnb > li.active').length<1){
			$('#sub').addClass('fullsize');
		}
	}
}
$(function(){
    if($('#sub').length>0 && $('#gnb > li.active').length<1){
        full_layout.init();
    }
})

//dropdown menu
dropdown = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
        $('#gnb').on({
            'mouseenter' : function(){
                $('#drdw').addClass('on');
                $('#gnb').addClass('on');
            }
        })
        $('#gnb').on({
            'mouseleave' : function(){
                $('#drdw').removeClass('on');
                $('#gnb').removeClass('on');
            }
        })
	}
}
$(function(){
    if($('#drdw').length>0){
        dropdown.init();
    }
})

//slide menu
slidemenu = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'btn' : $('#slide-btn button'),
			'drdw' : $('#drdw')
		}
		//click
		$ele.btn.on({
			'click' : function(e){
				e.preventDefault();
				var vis = $ele.btn.hasClass('on');
				if(!vis){
					$ele.drdw.stop().slideDown();
					$ele.btn.addClass('on');
					$('#hd-sch').removeClass('on');
				}else{
					$ele.drdw.stop().slideUp();
					$ele.btn.removeClass('on');
				}
			}
		})
	}
}
$(function(){
    if($('#slide-btn').length>0){
        slidemenu.init();
    }
})

//GNB 에서 Navigator 자동으로 가져 옴
get_navigator = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
        //depth 1
    	var d1_txt = '<?=$_tit[0]?>';
    	var $d1 = '';
    	$('#navigator li.d1').append('<ul>'+$('#gnb').html()+'</ul>');
    	$('#navigator li.d1 > ul > li > ul').remove();
    	$('#navigator li.d1 > a').attr('href',$('#gnb > li.active > a').attr('href'));

    	//depth 2
    	var d2_txt = '<?=$_tit[1]?>';
    	var $d2 = '';
    	$('#navigator li.d2').append('<ul>'+$('#gnb > li.active > ul').html()+'</ul>');
    	$('#navigator li.d2 > a').attr('href',$('#gnb > li.active > ul > li.active > a').attr('href'));

        //click 2depth
        $(document).on('click','#navigator > ul > li > a',function(e){
            var $li = $(this).parent('li');
            var vis = $li.hasClass('on');
            if($li.find('ul').length>0){
                e.preventDefault();
            }
            if(!vis){
                $li.addClass('on').siblings().removeClass('on');
            }else{
                $li.removeClass('on');
            }
        });
	}
}
$(function(){
    if($('#navigator').length>0){
        get_navigator.init();
    }
})

//lnb auto width
lnb_autowidth = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
        $ele = {
            'li' : $('#lnb > li')
        }
        $ele.li.css({
            'width' : (100 / $ele.li.length) + '%'
        })
	}
}

//Datepicker
$(function(){
	$('*[datepicker]').datepicker();
})

/**************************************************
	main
**************************************************/
//visual
visual = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'roll' : $('.visual .roll')
		}
		var rolling = function(){
			$ele.roll.slick({
                'fade' : false, //Fade 롤링 효과
                'dots' : false, //하단 pager
                'arrows' : true, //next,prev 버튼
                'infinite' : true, //무한반복
                'slidesToShow' : 1, //슬라이드 갯수
                'slidesToScroll' : 1, //롤링시 슬라이드 갯수
                'autoplay' : true, //자동롤링
                'autoplaySpeed' : 4000, //자동롤링 딜레이
                'swipe' : false, //모바일 스와프 여부
                'centerMode' : false, //Center모드. 가운데 slide에 'slick-active' 클래스 부여.
                'centerPadding' : 0, //Center모드인 경우 좌/우 여백 설정
                'vertical' : false, //vertical 모드
                'zIndex' : 80 //z-index
			});
		}
		rolling();
	}
}

//media roll
media_roll = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'roll' : $('.mainlat .b1 .roll')
		}
		var rolling = function(){
			$ele.roll.slick({
                'fade' : false, //Fade 롤링 효과
                'dots' : false, //하단 pager
                'arrows' : true, //next,prev 버튼
                'infinite' : true, //무한반복
                'slidesToShow' : 1, //슬라이드 갯수
                'slidesToScroll' : 1, //롤링시 슬라이드 갯수
                'autoplay' : true, //자동롤링
                'autoplaySpeed' : 4000, //자동롤링 딜레이
                'swipe' : false, //모바일 스와프 여부
                'centerMode' : false, //Center모드. 가운데 slide에 'slick-active' 클래스 부여.
                'centerPadding' : 0, //Center모드인 경우 좌/우 여백 설정
                'vertical' : false, //vertical 모드
                'zIndex' : 80 //z-index
			});
		}
		rolling();
	}
}

//family site roll
family_roll = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'roll' : $('.main-fam .roll')
		}
		var rolling = function(){
			$ele.roll.slick({
                'fade' : false, //Fade 롤링 효과
                'dots' : false, //하단 pager
                'arrows' : true, //next,prev 버튼
                'infinite' : true, //무한반복
                'slidesToShow' : 7, //슬라이드 갯수
                'slidesToScroll' : 1, //롤링시 슬라이드 갯수
                'autoplay' : true, //자동롤링
                'autoplaySpeed' : 4000, //자동롤링 딜레이
                'swipe' : false, //모바일 스와프 여부
                'centerMode' : false, //Center모드. 가운데 slide에 'slick-active' 클래스 부여.
                'centerPadding' : 0, //Center모드인 경우 좌/우 여백 설정
                'vertical' : false, //vertical 모드
                'zIndex' : 80 //z-index
			});
		}
		rolling();
	}
}

/**************************************************
	sub
**************************************************/
