<%@ page language="java" contentType="application/vnd.ms-excel; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
    response.setHeader("Content-Disposition", "inline; filename=referrerList.xls");
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List lstRs     = (List) request.getAttribute( "list" );
%>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 12">
</head>
<body>
<div align=center x:publishsource="Excel">

<table border='1' cellpadding='0' cellspacing='0'>
 
 <tr bgcolor='#f5f5f5'>
	<td style='width:200px;height:22px;'>접속날짜</td>
	<td style='width:200px;'>접속경로</td>
	<td style='width:300px;'>접속페이지</td>
	<td style='width:150px;'>접속아이피</td>
	<td style='width:150px;'>접속브라우져</td>
</tr>

<% 
    if(lstRs != null && lstRs.size() > 0){
       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
            Map rsMap = ( Map ) lstRs.get( iLoop );
%>
	 <tr>
		  <td style='height:22px;border-top:none'><%=CommonUtil.getDateFormat(rsMap.get("JOIN_DATE")) %>&nbsp;<%=CommonUtil.getDateFormat(rsMap.get("JOIN_TIME"), "HHmmss2") %></td>
		  <td style='border-top:none;border-left:none'><%=CommonUtil.nvl(rsMap.get("JOIN_ROUTE")) %></td>
		  <td style='border-top:none;border-left:none'><%=CommonUtil.nvl(rsMap.get("JOIN_PAGE")) %></td>
		  <td style='border-top:none;border-left:none'><%=CommonUtil.nvl(rsMap.get("JOIN_IP"))%></td>
		  <td style='border-top:none;border-left:none'><%=CommonUtil.nvl(rsMap.get("JOIN_BROWSER"))%></td>
	 </tr>
<%       
       }
    } else {
%>
          <tr>
            <td align="center" colspan="5"><%=CommDef.Message.NO_DATA %></td>
          </tr>       
<%  } %> 
</table>
</div>
</body>
</html>