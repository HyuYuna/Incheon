/**************************************************
	
	SUPERBOARD :: BOARD
	
**************************************************/
/**************************
	파일첨부 인풋 추가/제거
**************************/
/* 일단 보류 
sb_addFileFunc = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'orgInput' : '<tr><th>파일<em></em><div class="addFile"><a href="#" class="plus">첨부파일 인풋 추가</a> <a href="#" class="minus">첨부파일 인풋 제거</a></div></th><td><input type="file" name="" id="" /></td></tr>',
			'fileWrap' : $('#sb-write tbody.fileWrap'),
			'pBtn' : '#sb-write .addFile .plus',
			'mBtn' : '#sb-write .addFile .minus'
		}
		//추가
		var plusInput = function(e){
			e.preventDefault();
			if($ele.fileWrap.find('tr').length<10){
				$ele.fileWrap.append($ele.orgInput);
				resetFunc();
			}
		}
		$(document).on('click',$ele.pBtn,function(e){
			plusInput(e);
		});
		//제거
		var minusInput = function(e){
			e.preventDefault();
			if($ele.fileWrap.find('tr').length>1){
				$ele.fileWrap.find('tr:last-child').remove();
				resetFunc();
			}
		}
		$(document).on('click',$ele.mBtn,function(e){
			minusInput(e);
		});
		//초기화
		var resetFunc = function(){
			$ele.fileWrap.find('tr:last-child .addFile').show().parents('tr').siblings().find('.addFile').hide();
			$ele.fileWrap.find('th em').each(function(i){
				$(this).text(i + 1);
			});
		}
		resetFunc();
	}
}
$(function(){ sb_addFileFunc.init(); })
*/
/**************************
	FAQ
**************************/
sb_faq = {
	'init' : function(){
		this.action();
	},
	'action' : function(){
		var $ele = {
			'ques' : $('#sb-faq .ques a.sbj')
		}
		var togglebox = function($this){
			var $ans = $this.parents('li').find('.ans');
			var vis = $ans.is(':visible');
			if(!vis){
				$ans.stop().slideDown()
				.parents('li').addClass('active')
				.siblings().removeClass('active')
				.find('.ans').slideUp();
			}else{
				$ans.stop().slideUp()
				.parents('li').removeClass('active');
			}
		}
		$ele.ques.on({
			'click' : function(e){
				e.preventDefault();
				togglebox($(this));
			}
		})
	}
}
$(function(){ sb_faq.init(); })

