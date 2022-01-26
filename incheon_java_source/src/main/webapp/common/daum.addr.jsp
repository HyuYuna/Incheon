<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
function openDaumPostcode(wm_zip, wm_addr1, wm_addr2) { 
	new daum.Postcode({ 
		oncomplete: function(data) { 
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분. 

			// 도로명 주소의 노출 규칙에 따라 주소를 조합한다. 
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다. 
			var fullRoadAddr = data.roadAddress; // 도로명 주소 변수 
			var extraRoadAddr = ''; // 도로명 조합형 주소 변수 

			// 법정동명이 있을 경우 추가한다. (법정리는 제외) 
			// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다. 
			if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){ 
			extraRoadAddr += data.bname; 
			} 
			// 건물명이 있고, 공동주택일 경우 추가한다. 
			if(data.buildingName !== '' && data.apartment === 'Y'){ 
			extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName); 
			} 
			// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다. 
			if(extraRoadAddr !== ''){ 
			extraRoadAddr = ' (' + extraRoadAddr + ')'; 
			} 
			// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다. 
			if(fullRoadAddr !== ''){ 
			fullRoadAddr += extraRoadAddr; 
			} 

			// 우편번호와 주소 정보를 해당 필드에 넣는다. 
			document.getElementById(wm_zip).value = data.zonecode; //5자리 새우편번호 사용 
			document.getElementById(wm_addr1).value = fullRoadAddr; 
			document.getElementById(wm_addr2).focus(); 
			//document.getElementById('sample4_jibunAddress').value = data.jibunAddress; 

			} 
		}).open(); 
	} 

//다음 주소 검색을 레이어로 넣습니다.
var win_zip = function(frm_name, frm_zip, frm_addr1, frm_addr2) {
	
    if(typeof daum === 'undefined'){
        alert("다음 우편번호 postcode.v2.js 파일이 로드되지 않았습니다.");
        return false;
    }

    var complete_fn = function(data){
        // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

        // 각 주소의 노출 규칙에 따라 주소를 조합한다.
        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
        var fullAddr = ''; // 최종 주소 변수
        var extraAddr = ''; // 조합형 주소 변수

        // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
            fullAddr = data.roadAddress;

        } else { // 사용자가 지번 주소를 선택했을 경우(J)
            fullAddr = data.jibunAddress;
        }

        // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
        if(data.userSelectedType === 'R'){
            //법정동명이 있을 경우 추가한다.
            if(data.bname !== ''){
                extraAddr += data.bname;
            }
            // 건물명이 있을 경우 추가한다.
            if(data.buildingName !== ''){
                extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
            extraAddr = (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
        }

        // 우편번호와 주소 정보를 해당 필드에 넣고, 커서를 상세주소 필드로 이동한다.
        var of = document[frm_name];

        of[frm_zip].value = data.zonecode;

        of[frm_addr1].value = fullAddr;
        of[frm_addr2].value = extraAddr;

        of[frm_addr2].focus();
    };

	//iframe을 이용하여 페이지에 끼워 넣기
	var daum_pape_id = 'daum_juso_page'+frm_zip,
		element_wrap = document.getElementById(daum_pape_id),
		currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
	if (element_wrap == null) {
		element_wrap = document.createElement("div");
		element_wrap.setAttribute("id", daum_pape_id);
		element_wrap.style.cssText = 'display:none;border:1px solid;left:0;width:100%;height:300px;margin:5px 0;position:relative;-webkit-overflow-scrolling:touch;';
		element_wrap.innerHTML = '<img src="//i1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-21px;z-index:1" class="close_daum_juso" alt="접기 버튼">';
		jQuery('form[name="'+frm_name+'"]').find('input[name="'+frm_addr1+'"]').before(element_wrap);
		jQuery("#"+daum_pape_id).off("click", ".close_daum_juso").on("click", ".close_daum_juso", function(e){
			e.preventDefault();
			jQuery(this).parent().hide();
		});
	}

	new daum.Postcode({
		oncomplete: function(data) {
			complete_fn(data);
			// iframe을 넣은 element를 안보이게 한다.
			element_wrap.style.display = 'none';
			// 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
			document.body.scrollTop = currentScroll;
		},
		// 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분.
		// iframe을 넣은 element의 높이값을 조정한다.
		onresize : function(size) {
			element_wrap.style.height = size.height + "px";
		},
		width : '100%',
		height : '100%'
	}).embed(element_wrap);

	// iframe을 넣은 element를 보이게 한다.
	element_wrap.style.display = 'block';
  
}
</script>