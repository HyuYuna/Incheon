<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
   SessionUtil.removeSessionAttribute(request,"USER");
   SessionUtil.removeSessionAttribute(request,"ADM");
   session.invalidate();
%>
<script type="text/javascript">
	alert("로그아웃 되었습니다.");
	window.location.href="/webadm/index.do";
</script>