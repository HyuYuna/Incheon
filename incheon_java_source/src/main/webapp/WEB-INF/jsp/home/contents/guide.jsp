<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
   List ctsList = (List)request.getAttribute("ctsList");  // 콘텐츠 목록
   Map  reqMap = (Map) request.getAttribute("reqMap");

   String strMenuNo = CommonUtil.nvl(reqMap.get("menuno"));
   int tabNo = CommonUtil.getNullInt(reqMap.get("tabno"), 0);
%>
<jsp:include page="/home/inc/header.do"></jsp:include>

<body>
<div id="wrap">

	<jsp:include page="/home/inc/topmenu.do"></jsp:include>

		<section id="sub">

			<!-- subvisual -->
			<jsp:include page="/home/inc/subvisual.do"></jsp:include>
			<!-- subvisual -->

			<!-- navigator -->
			<%-- <jsp:include page="/home/inc/navigator.do"></jsp:include> --%>
			<!-- navigator -->

            <!-- start content -->
			<div id="content">

				<!-- lnb -->
				<jsp:include page="/home/inc/lnb2.do"></jsp:include>
				<!-- lnb -->

				<div id="subCont">

				<!-- subtitle -->
				<jsp:include page="/home/inc/subtitle.do"></jsp:include>
				<!-- subtitle -->

				<!-- 탭메뉴 시작 -->
				<% if (ctsList != null && !ctsList.isEmpty())
				    {
					   if (ctsList.size() > 1 )  // 여러건인 경우 텝 메뉴로 만든다.
					   {
				%>
							<!-- PC 출력 시작 -->
							<div class="contents_tab">
								<ul class="tab">
				<%
					       for (int nLoop=0; nLoop < ctsList.size(); nLoop++)
					       {
					    	   Map rsMap = (Map)ctsList.get(nLoop);

					    	   String strCompCtgNo = CommonUtil.nvl(rsMap.get("CTS_NO"));
					    	   String urlUseYn = CommonUtil.nvl(rsMap.get("URL_USE_YN"));
					    	   String ctsUrl = CommonUtil.nvl(rsMap.get("CTS_URL"));
					    	   String urlTarget = CommonUtil.nvl(rsMap.get("URL_TARGET"));
					    	   String strUrl = "";

					    	   if("Y".equals(urlUseYn)) {
					    		   strUrl = ctsUrl;
						  	       strUrl += (strUrl.indexOf("?") >= 0 ) ? "&menuno="   + strMenuNo : "?menuno=" + strMenuNo;
						  	       strUrl += (strUrl.indexOf("?") >= 0 ) ? "&tabno=" + nLoop : "?tabno=" + nLoop;
					    	   }
				%>
				               <li class="<%=(tabNo == nLoop) ? "active" : "" %>">
				               		<a href="<%= ("Y".equals(urlUseYn)) ? strUrl : "/contents.do?menuno=" +strMenuNo +"&tabno=" + nLoop %>" target="<%= ("Y".equals(urlUseYn)) ? urlTarget : "" %>"><%=CommonUtil.nvl(rsMap.get("TTL"))%></a>
				               </li>
				<%
					       }
				%>
									</ul>
								</div>
								<!-- PC 출력 끝 -->
				<script>
					function urlLocation(urlValue) {
						location.href = urlValue;
					}
				</script>
				<%
				    	}
				    }
				%>
				<!-- 탭메뉴 끝 -->

				<!-- 컨텐츠 내용 -->
				 <% if (ctsList != null && !ctsList.isEmpty())
				    {
					    for (int nLoop=0; nLoop < ctsList.size(); nLoop++)
					    {
					    	Map rsMap = (Map)ctsList.get(nLoop);

					    	if (tabNo == nLoop) {
				%>
					           <%=CommonUtil.recoveryLtGt((String)rsMap.get("CTNT")) %>
				<%
				            }
					    }
				    }
				%>
				<!-- 컨텐츠 내용 -->
				</div>

			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>

</body>
</html>