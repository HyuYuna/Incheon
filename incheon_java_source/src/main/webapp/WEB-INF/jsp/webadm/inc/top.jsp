<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map sesMap     = (Map)SessionUtil.getSessionAttribute(request,"ADM");
%>
	<header id="header">
		<h1 class="logo"><a href="/webadm/main.do"><i class="axi axi-account-box"></i> <span>Administrator</span></a></h1>
		<ul class="tnb">
			<li><a href="/" target="_blank"><i class="axi axi-home"></i> 홈페이지</a></li>
			<li class="my"><a href="<%=CommDef.ADM_PATH %>/member/memberWrite.do?menu_no=10&user_id=<%=CommonUtil.nvl(sesMap.get("USER_ID"))%>"><strong><%=CommonUtil.nvl(sesMap.get("USER_NM")) %></strong> 님이 로그인 하셨습니다.</a></li>
			<li class="out"><a href="/common/admlogout.jsp"><span>로그아웃</span></a></li>
		</ul>
		<button type="button" class="btn"><i class="axi axi-bars"></i></button>
	</header>