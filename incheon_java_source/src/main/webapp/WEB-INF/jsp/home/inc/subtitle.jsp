<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
%>
<script>
	var rootPath = "/";

	function rootLocation() {
		location.href = rootPath;
	}
</script>
        <div class="sub-tit">
            <h3></h3>
			<% if (CommonUtil.nvl(reqMap.get("boardno"), "").equals("61")) { %>
            	<a href="/minwon.do?boardno=61&menuno=76&mode=list" class="btn2 abs-btn">내 답변보기</a>
			<% } %>
			<% if (CommonUtil.nvl(reqMap.get("menuno"), "").equals("61") || CommonUtil.nvl(reqMap.get("menuno"), "").equals("274")) { %>
            	<a href="/regList.do?menuno=274" class="btn2 abs-btn">이용예약확인</a>
			<% } %>
        </div>
