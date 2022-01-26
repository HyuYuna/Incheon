<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map reqMap = (Map)request.getAttribute("reqMap");
	Map dbMap = (Map)request.getAttribute("dbMap");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title><%=CommonUtil.nvl(dbMap.get("TITLE")) %></title>
<script type="text/javascript">
function setCookie( name, value, expiredays ){
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}

function closeWin(){
	if ( document.forms[0].popup.checked )
	setCookie( "popup_<%=CommonUtil.nvl(dbMap.get("SEQ")) %>", "done" , 1);
	self.close();
}

function link(val){
	opener.document.location.href=val;
	self.close();
}
</script>
</head>
<body>
<table width="100%" height="<%=CommonUtil.nvl(dbMap.get("HEIGHT_SIZE")) %>" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><%=CommonUtil.recoveryLtGt((String)dbMap.get("CONTENT")) %></td>
	</tr>
</table>
<table width="100%" height="25" cellpadding="0" cellspacing="0" border="0" bgcolor="#181818">
	<form>
	<tr>
		<td>&nbsp;<a href="javascript:self.close()" style="color:#ffffff;">창닫기</a></td>
		<td align="right">
			<span style="color:#ffffff">오늘 하루 창 열지 않기</span>
			<input type="checkbox" name="popup" value="" onclick="closeWin()" />
			&nbsp;
		</td>
	</tr>
	</form>
</table>
</body>
</html>