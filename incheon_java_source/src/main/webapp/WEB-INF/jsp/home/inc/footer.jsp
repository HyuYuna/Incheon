<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	List bannerLink = (List)request.getAttribute("bannerLink"); //배너 링크 리스트
%>

<footer id="footer">
	<div class="fnbWrap">
		<div class="inner">

			<!-- fnb -->
			<ul id="fnb">
				<li><a href="/guide.do?menuno=294">이용약관</a></li>
				<li><a href="/guide.do?menuno=103">개인정보처리방침</a></li>
				<li><a href="/guide.do?menuno=278">이메일무단수집거부</a></li>
			</ul>

		</div>
	</div>
	<div class="ftWrap">

		<!-- address -->
		<address>
			<%=CommDef.CONFIG_COMPANY%><hr /><%=CommDef.CONFIG_ADDR1%>&nbsp;<%=CommDef.CONFIG_ADDR2%><hr />TEL: <%=CommDef.CONFIG_TEL%>
			<span class="copyright">본 사이트에 게시된 자료를 무단 복제 및 배포 하는 경우 법적 처벌을 받을 수 있습니다.<br />Copyright © Incheon Metropolitan City. All rights reserved.</span>
		</address>

		<!-- family site -->
		<div id="ft-fam">
			<a href="#">관련 사이트</a>
			<ul>
			<%
			 	if (bannerLink != null && !bannerLink.isEmpty()) {
				    for (int nLoop=0; nLoop < bannerLink.size(); nLoop++) {
				    	Map rsMap = (Map)bannerLink.get(nLoop);

				    	String strUrl = "#";
				    	String strTarget = "";
				    	if (!CommonUtil.nvl(rsMap.get("LINK_TEXT")).equals("")) {
				    		strUrl = CommonUtil.nvl(rsMap.get("LINK_TEXT"));
				    		strTarget = "target='" + CommonUtil.nvl(rsMap.get("LINK_TARGET")) + "'";
				    	}
			%>
				<li><a href="<%=strUrl %>" title="<%=CommonUtil.nvl(rsMap.get("TITLE")) %>" <%=strTarget %>><%=CommonUtil.nvl(rsMap.get("TITLE")) %></a></li>
			<%
				    }
			 	}
			%>
			</ul>
		</div>
	</div>
</footer>
<!-- log save -->
<jsp:include page="/statistics/logSave.do">
	<jsp:param name="lang" value="kr"/>
</jsp:include>
