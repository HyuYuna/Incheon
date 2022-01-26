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

        $('.lnbWrap > h2').text($('#gnb > li.active > a').text()); //lnb 텍스트 출력
        $('.sub-tit > h3').text($('#gnb > li.active > ul > li.active > a').text()); //타이틀 출력
	}
}
$(function(){	
    if($('#lnb').length>0){
        get_lnb.init();
    }
})