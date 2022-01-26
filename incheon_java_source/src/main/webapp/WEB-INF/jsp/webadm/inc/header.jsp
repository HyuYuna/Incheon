<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
   response.setHeader("Pragma", "No-cache");
   response.setDateHeader("Expires", 0);
   response.setHeader("Cache-Control", "no-cache");
   
	if ( !CommonUtil.isAdminLogin(request, response)) {
		return ;
	}  
   
	Map userMap = (Map)SessionUtil.getSessionAttribute(request,"ADM");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
<title><%=CommDef.CONFIG_COMPANY%> 관리자</title>
<link rel="stylesheet" type="text/css" href="<%=CommDef.ADM_CONTENTS%>/css/common.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.ADM_CONTENTS%>/css/global.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.ADM_CONTENTS%>/css/respond.css"/>
<script src="<%=CommDef.APP_CONTENTS%>/js/jquery.min.js"></script>
<script src="<%=CommDef.APP_CONTENTS%>/js/global.js"></script>
<script src="<%=CommDef.APP_CONTENTS%>/js/web.util.js"></script>
<!--[if lt IE 9]>
<script src="<%=CommDef.APP_CONTENTS%>/js/html5.js"></script>
<![endif]-->
<script type="text/javascript">
	$(document).ready(function() {

		//리스트 체크 박스 공통 스크립트
		$("#allCheck").click(function () { 
			 if ($("#allCheck").is(":checked")== true) {
				 $("input[id=seqno]:checkbox").each(function () {
					 $(this).prop("checked", true)
				 });
			 }
			 else if ($("#allCheck").is(":checked") == false) {
				 $("input[id=seqno]:checkbox").each(function () {
					 $(this).prop("checked", false)
				 });
			 }
		 }); 	
	
	});
</script>
</head>
