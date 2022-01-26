//GNB 에서 LNB 자동으로 가져 옴
get_lnb = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
        $('#lnb').not('[no-load-gnb]').html($('#gnb > li.active > ul').html());
        $('#lnb > li').each(function(){
            var $this = $(this);
            var child = $(this).find('ul');
            if(child.length > 0){
                $this.addClass('have-child');
                $this.children('a').on({
                    'click' : function(e){
                        e.preventDefault();
                        var vis = child.is(':visible');
                        if(!vis){
                            $this.addClass('open');
                        }else{
                            $this.removeClass('open');
                        }
                    }
                })
                $('#lnb > li.active > a').click();
            }
        });

       if (getPageName() == "reservation.do") {
    	   $('.sub-tit > h3').text('시설 이용 예약'); //타이틀 출력
       } else if (getPageName() == "regList.do" || getPageName() == "regView.do" || getPageName() == "regCheck.do") {
    	   $('.sub-tit > h3').text('시설 예약 확인'); //타이틀 출력
       } else if (getPageName() == "programs.do" || getPageName() == "supportPrograms.do") {
    	   //타이틀 없음
       } else {
    	   $('.sub-tit > h3').text($('#menuTitle').val()); //타이틀 출력
       }

       $('.lnbWrap > h2').text($('#menuTitle').val()); //lnb 텍스트 출력

        //$('.lnbWrap > h2').text($('#gnb > li.active > a').text()); //lnb 텍스트 출력
        //$('.sub-tit > h3').text($('#gnb > li.active > ul > li.active > a').text()); //타이틀 출력
	}
}
$(function(){
    if($('#lnb').length>0){
        get_lnb.init();
    }
})