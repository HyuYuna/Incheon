<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map reqMap = (Map)request.getAttribute("reqMap");
	Map detail = (Map)request.getAttribute("facilityDetail");
	List facilityPicList = (List)request.getAttribute("facilityPicList");

	String jangName = "시설장";

	if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B01")) {
		jangName = "관장";
	} else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B04")) {
		jangName = "도서관장";
	} else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("A01") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("A02")
			|| CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("A03") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("A04")
			|| CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("C01") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("C02")
			|| CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("C03") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B02")) {
		jangName = "시설장";
	} else {
		jangName = "센터장";
	}
%>
<a href="#" class="close">Close popup</a>
<div class="pop-wrap">

    <!-- 팝업 내용 -->
    <div class="sisulpop">
    <% if (CommonUtil.getNullInt(detail.get("REGCNT"), 1) > 0) { %>
        <a href="javascript:;;" class="prgr-ico" id="prgrBtn" data-sn="<%=CommonUtil.nvl(detail.get("WFFCLTY_CD")) %>"><img src="<%=CommDef.HOME_CONTENTS %>/images/sub/sisul-prgr-ico.jpg" />예약하기</a>
	<% } %>
        <div class="types">
            <p><strong>시설종류</strong><%=CommonUtil.nvl(detail.get("CA1NM")) %></p>
            <p><strong>시설유형</strong><%=CommonUtil.nvl(detail.get("CA2NM")) %></p>
        </div>

        <span class="tit"><%=CommonUtil.nvl(detail.get("WFFCLTY_NM")) %></span>

		<%  if(facilityPicList != null && facilityPicList.size() > 0) { %>
        <ul class="tmb">
			<%
		       for( int picLoop = 0; picLoop < facilityPicList.size(); picLoop++ ) {
		            Map picListMap = ( Map ) facilityPicList.get( picLoop );
			%>
				<li style="background-image: url('https://webjangbok.incheon.go.kr<%=CommonUtil.nvl(picListMap.get("PICTURE_PATH"))%>/<%=CommonUtil.nvl(picListMap.get("PICTURE_NM"))%>');"></li>
			<%
				}
			%>
        </ul>
		<%
			}
		%>
		<a href="javascript:window.open('/supportPrograms.do?menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>&wcd=<%=CommonUtil.nvl(detail.get("WFFCLTY_CD")) %>','programpop','width=1000px,height=900px'); void(0);" class="prgr-btn">운영 프로그램 보기 <i class="axi axi-chevron-right"></i></a>
        <table class="table1 mt30">
            <colgroup>
                <col style="width: 120px;">
                <col style="width: auto;">
                <col style="width: 120px;">
                <col style="width: auto;">
            </colgroup>
            <tbody>
                <tr>
                    <th>시설명</th>
                    <td><%=CommonUtil.nvl(detail.get("WFFCLTY_NM")) %></td>
                    <th>운영주체</th>
                    <td><%=CommonUtil.nvl(detail.get("OPERATION")) %></td>
                </tr>
                <tr>
                    <th>시설분류</th>
                    <td><%=CommonUtil.nvl(detail.get("CA1NM")) %></td>
                    <th>시설유형</th>
                    <td><%=CommonUtil.nvl(detail.get("CA2NM")) %></td>
                </tr>
                <tr>
                    <th><%=jangName %></th>
                    <td><%=CommonUtil.nvl(detail.get("INTENDANT_NM")) %></td>
                    <th>주소</th>
                    <td><%=CommonUtil.nvl(detail.get("ADDR_BASE")) %> <%=CommonUtil.nvl(detail.get("ADDR_DETAIL")) %></td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td><%=CommonUtil.nvl(detail.get("PHONE_NUM")) %></td>
                    <th>팩스번호</th>
                    <td><%=CommonUtil.nvl(detail.get("FAX_NUM")) %></td>
                </tr>
                <tr>
                    <th>설립일</th>
                    <td><%=CommonUtil.getDateFormat(detail.get("ESTABLISH_DD"), "ymd") %></td>
                    <th>종사자</th>
                    <td><%=CommonUtil.nvl(detail.get("PRACTICIAN")) %></td>
                </tr>
                <tr>
                    <th>홈페이지</th>
                    <td>
                    <% if (!CommonUtil.nvl(detail.get("HOMEPAGE_URL"),"").equals("")) { %>
                    	<a href="http://<%=CommonUtil.nvl(detail.get("HOMEPAGE_URL")) %>" target="_blank"><%=CommonUtil.nvl(detail.get("HOMEPAGE_URL")) %></a>
                    <% } %>
                    </td>
                    <th>서비스장애유형</th>
                    <td><%=CommonUtil.nvl(detail.get("OBSTACLE")) %></td>
                </tr>
            <!-- 장애인거주시설 (A01) 공동생활가정 (A02) 단기거주시설 (A03) 개인운영시설 (A04)  -->
            <% if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("A01") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("A02") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("A03") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("A04")) { %>
                <tr>
                    <th>입소자정원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("CAPACITY"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("CAPACITY")) %>
                    	<% } %>
                    </td>
                    <th>현원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("HYUNWON"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("HYUNWON")) %>
                    	<% } %>
                    </td>
                </tr>
                <tr>
                    <th>면적</th>
                    <td><%=CommonUtil.nvl(detail.get("AREA")) %></td>
                    <th>중식제공</th>
                    <td>
		                <% if (!CommonUtil.nvl(detail.get("WFFCLTY_CLAS"), "").equals("E")) { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH_ETC_DETAIL")) %>
                    	<% } else { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH")) %>
                    	<% } %>
                    </td>
                </tr>
           <!--  장애인복지관  (B01) -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B01")) {  %>
                <tr>
                    <th>일평균인원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("ETC_DETAIL1"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("ETC_DETAIL1")) %>
                    	<% } %>
                    </td>
                    <th>월평균인원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("ETC_DETAIL2"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("ETC_DETAIL2")) %>
                    	<% } %>
                    </td>
                </tr>
                <tr>
                    <th>중식제공</th>
                    <td>
		                <% if (!CommonUtil.nvl(detail.get("WFFCLTY_CLAS"), "").equals("E")) { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH_ETC_DETAIL")) %>
                    	<% } else { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH")) %>
                    	<% } %>
                    </td>
                    <th></th>
                    <td></td>
                </tr>
           <!--  장애인 주간보호 시설 (B02) -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B02")) {  %>
                <tr>
                    <th>중식제공</th>
                    <td>
		                <% if (!CommonUtil.nvl(detail.get("WFFCLTY_CLAS"), "").equals("E")) { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH_ETC_DETAIL")) %>
                    	<% } else { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH")) %>
                    	<% } %>
                    </td>
                    <th>입소자정원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("CAPACITY"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("CAPACITY")) %>
                    	<% } %> 
                    </td>
                </tr>
                <tr>
                    <th>면적</th>
                    <td><%=CommonUtil.nvl(detail.get("AREA")) %></td>
                    <th>서비스공간</th>
                    <td><%=CommonUtil.nvl(detail.get("ETC_DETAIL1")) %></td>
                </tr>
           <!--  인천수어통역센터 (B03) -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B03")) {  %>
                <tr>
                    <th>일평균인원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("ETC_DETAIL1"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("ETC_DETAIL1")) %>
                    	<% } %>
                    </td>
                    <th>월평균인원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("ETC_DETAIL2"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("ETC_DETAIL2")) %>
                    	<% } %>
                    </td>
                </tr>
           <!--  점지도서관 (B04) -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B04")) {  %>
                <tr>
                    <th>이용자</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("ETC_DETAIL1"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("ETC_DETAIL1")) %>
                    	<% } %>
                    </td>
                    <th></th>
                    <td></td>
                </tr>
           <!-- 장애인 생활이동지원센터 (B05) -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B05")) {  %>
                <tr>
                    <th>이용자정원</th>
                    <td><%=CommonUtil.nvl(detail.get("CAPACITY")) %></td>
                    <th>차량보유</th>
                    <td><%=CommonUtil.nvl(detail.get("ETC_DETAIL1")) %></td>
                </tr>
           <!-- 장애인 재활지원센터 (B07) 지적장애인 자립지원센터 (B08) -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B07") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B08")) {  %>
                <tr>
                    <th>중식제공</th>
                    <td>
		                <% if (!CommonUtil.nvl(detail.get("WFFCLTY_CLAS"), "").equals("E")) { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH_ETC_DETAIL")) %>
                    	<% } else { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH")) %>
                    	<% } %>
                    </td>
                    <th>이용자정원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("CAPACITY"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("CAPACITY")) %>
                    	<% } %> 
                    </td>
                </tr>
                <tr>
                    <th>서비스공간</th>
                    <td><%=CommonUtil.nvl(detail.get("ETC_DETAIL1")) %></td>
                    <th></th>
                    <td></td>
                </tr>
           <!-- 장애인근로사업장 (C01) 장애인보호작업장 (C02) 장애인 생산품판매시설 (C03)  -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("C01") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("C02") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("C03")) {  %>
                <tr>
                    <th>중식제공</th>
                    <td>
		                <% if (!CommonUtil.nvl(detail.get("WFFCLTY_CLAS"), "").equals("E")) { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH_ETC_DETAIL")) %>
                    	<% } else { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH")) %>
                    	<% } %>
                    </td>
                    <th>이용자정원</th>
                    <td><%=CommonUtil.nvl(detail.get("CAPACITY")) %></td>
                </tr>
                <tr>
                    <th>현원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("HYUNWON"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("HYUNWON")) %>
                    	<% } %> 
                    </td>
                    <th>면적</th>
                    <td><%=CommonUtil.nvl(detail.get("AREA")) %></td>
                </tr>
                <tr>
                    <th>고용장려금</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("ETC_DETAIL1"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("ETC_DETAIL1")) %> 원
                    	<% } %>
                    </td>
                    <th></th>
                    <td></td>
                </tr>
           <!-- 장애인 자립생활센터 (D03) -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("D03")) {  %>
                <tr>
                    <th>중식제공</th>
                    <td>
		                <% if (!CommonUtil.nvl(detail.get("WFFCLTY_CLAS"), "").equals("E")) { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH_ETC_DETAIL")) %>
                    	<% } else { %>
                    		<%=CommonUtil.nvl(detail.get("LUNCH")) %>
                    	<% } %>
                    </td>
                    <th>이용자정원</th>
                    <td>
                    	<% if (!CommonUtil.nvl(detail.get("CAPACITY"), "").equals("")) { %>
                    		<%=CommonUtil.number_format(detail.get("CAPACITY")) %>
                    	<% } %> 
                    </td>
                </tr>
                <tr>
                    <th>서비스공간</th>
                    <td><%=CommonUtil.nvl(detail.get("ETC_DETAIL1")) %></td>
                    <th></th>
                    <td></td>
                </tr>
           <!-- 장애인보조기구 AS센터 (D04) -->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("D04")) {  %>
                <tr>
                    <th>이용대상</th>
                    <td><%=CommonUtil.nvl(detail.get("ETC_DETAIL1")) %></td>
                    <th>지원금액</th>
                    <td><%=CommonUtil.nvl(detail.get("ETC_DETAIL2")) %></td>
                </tr>
                 <tr>
                    <th>수리품목</th>
                    <td><%=CommonUtil.nvl(detail.get("ETC_DETAIL3")) %></td>
                    <th>제출서류</th>
                    <td><%=CommonUtil.nvl(detail.get("ETC_DETAIL4")) %></td>
                </tr>
           <!-- 장애인편의증진 기술지원센터 (D05)
			    장애인편의시설설치 시민촉진단 (D06)
			    장애인자립생활센터 (E01)
			    장애인가족지원센터 (E02)
			    장애인 권익옹호기관 (B06)
			    장애인 활동지원기관 (D01)
			    장애인 자세유지기구센터 (D02)
 			-->
           <% } else if (CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("D05") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("D06")
        	   || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("E01") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("E02") 
        	   || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("B06") || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("D01") 
        	   || CommonUtil.nvl(detail.get("WFFCLTY_TP")).equals("D02")) {  %>
           <% } %>
            </tbody>
        </table>
    </div>
</div>

<form name="sisulForm" method="post">
	<input type="hidden" name="wcd" id="wcd" value=""/>
	<input type="hidden" name="menuno" id="menuno" value="295"/>
</form>

<script>
$(document).ready(function() {
	$('#prgrBtn').on('click', function() {
		$('#wcd').val($(this).attr('data-sn'));

		document.sisulForm.action = "/reservation.do";
		document.sisulForm.submit();
	});
});
</script>
