<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map detailMap = (Map)request.getAttribute("detailMap");
	Map reqMap = (Map)request.getAttribute("reqMap");
%>
		<div id="tit">
			<h2><i class="axi axi-menu2"></i> <%=CommonUtil.nvl(detailMap.get("MENU_NM")) %></h2>
			<p class="navi">
				<i class="axi axi-home"></i> <em><i class="axi axi-angle-right"></i></em><span><%=CommonUtil.nvl(detailMap.get("ONE_MENU_NM")) %></span><em><i class="axi axi-angle-right"></i></em><span><%=CommonUtil.nvl(detailMap.get("MENU_NM")) %></span>
			</p>
		</div>