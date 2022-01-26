<%@ page language="java" contentType="application/vnd.ms-excel; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
    response.setHeader("Content-Disposition", "inline; filename=memberList.xls");
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List lstRs     = (List) request.getAttribute( "list" );
  	Aria aria = new Aria(CommDef.MASTER_KEY);
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
  <td style='width:99px;height:22px;'>회원아이디</td>
  <td style='width:108px;'>이름</td>
  <td style='width:95px;'>생년월일</td>
  <td style='width:95px;'>회원등급</td>
  <td style='width:95px;'>회원레벨</td>
  <td style='width:104px;'>연락처</td>
  <td style='width:104px;'>휴대전화</td>
  <td style='width:218px;'>이메일</td>
  <td style='width:500px;'>주소</td>
  <td style='width:136px;'>가입일</td>
  <td style='width:131px;'>마지막로그인</td>
  <td style='width:74px;'>회원여부</td>
 </tr>
 
 <% 
    if(lstRs != null && lstRs.size() > 0){
       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
            Map rsMap = ( Map ) lstRs.get( iLoop );
    
%>
	 <tr>
			  <td style='height:22px;'><%=CommonUtil.nvl(rsMap.get("USER_ID")) %></td>
			  <td style='border-top:none;border-left:none'><%=aria.Decrypt(CommonUtil.nvl(rsMap.get("USER_NM"))) %></td>
			  <td style='border-top:none;border-left:none'><%=aria.Decrypt(CommonUtil.nvl(rsMap.get("BIRTHDAY"))) %></td>
			  <td style='border-top:none;border-left:none'><%=CommonUtil.nvl(rsMap.get("USER_TYPE_NM"))%></td>
			  <td style='border-top:none;border-left:none'><%=CommonUtil.nvl(rsMap.get("USER_LEVEL"))%></td>
			  <td style='border-top:none;border-left:none'><%=aria.Decrypt(CommonUtil.nvl(rsMap.get("TEL"))) %></td>
			  <td style='border-top:none;border-left:none'><%=aria.Decrypt(CommonUtil.nvl(rsMap.get("HP"))) %></td>
			  <td style='border-top:none;border-left:none'><%=aria.Decrypt(CommonUtil.nvl(rsMap.get("EMAIL"))) %></td>
			  <td style='border-top:none;border-left:none'>[<%=CommonUtil.nvl(rsMap.get("ZIPCODE")) %>] <%=CommonUtil.nvl(rsMap.get("ADDR1")) %> <%=CommonUtil.nvl(rsMap.get("ADDR2")) %></td>
			  <td style='border-top:none;border-left:none'><%=CommonUtil.getDateFormat(CommonUtil.nvl(rsMap.get("REG_DT")), "-") %>&nbsp;</td>
			  <td style='border-top:none;border-left:none'><%=CommonUtil.getDateFormat(CommonUtil.nvl(rsMap.get("LAST_LOGIN")), "-") %>&nbsp;</td>
			  <td style='border-top:none;border-left:none'><%=CommonUtil.getMemberType(rsMap.get("USE_YN")) %></td>
	 </tr>
<%       
       }
    } else {
%>               
          <tr>
            <td align="center" colspan="12"><%=CommDef.Message.NO_DATA %></td>
          </tr>       
<%  } %> 
</table>
</div>
</body>
</html>