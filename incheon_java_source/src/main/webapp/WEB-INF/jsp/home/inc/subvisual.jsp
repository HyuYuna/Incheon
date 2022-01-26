<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map topMenuDt = (Map) request.getAttribute("topMenuDt");
%>

<% if (topMenuDt != null) { %>
<%-- 	<div class="sub-vis" <% if (!CommonUtil.nvl(topMenuDt.get("FILE_REALNM")).equals("")) { %> style="background-image: url('<%=CommonUtil.nvl(topMenuDt.get("FILE_REALNM")) %>');" <% } %>>
		<h2>
			<%=CommonUtil.nvl(topMenuDt.get("MENU_NM")) %> 
			<% if (topMenuDt.get("MENU_DESC") != null) { %>
				<%=CommonUtil.recoveryLtGt((String)topMenuDt.get("MENU_DESC")) %>
			<% } %>
		</h2>
	</div> --%>
	
	<div class="sub-vis" <% if (!CommonUtil.nvl(topMenuDt.get("FILE_REALNM")).equals("")) { %> style="background-image: url('<%=CommonUtil.nvl(topMenuDt.get("FILE_REALNM")) %>');" <% } %>></div>
<% } %>