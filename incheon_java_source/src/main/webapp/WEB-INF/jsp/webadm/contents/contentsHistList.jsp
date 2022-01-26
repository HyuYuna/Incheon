<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map  reqMap  = (Map)  request.getAttribute( "reqMap" );
	List lstRs   = (List)  request.getAttribute( "histList" );
 
    String strMenuNo = CommonUtil.nvl( reqMap.get( "menu_no"));
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<script>
   function fView(strHistNo) {
	   vObj = document.getElementById("hist_" + strHistNo);
	   
	   if ( vObj.style.display == 'none' ) {
		   vObj.style.display = ''; 
	   } else {
		   vObj.style.display = 'none';
	   }
   }
</script>
<body>					
					<!-- 메뉴 선택하지 않았을 때 -->
				<span class="__cont_notice">컨텐츠관리 히스토리</span>
					
				<table class="__tbl-list __tbl-respond">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<thead>
					<tr>
	                  	<th scope="col">번호</th>
	                    <th scope="col">제목</th>
	                    <th scope="col">사용</th>
	                    <th scope="col">처리자</th>
	                    <th scope="col">처리상태</th>
	                    <th scope="col">처리일</th>          
					</tr>
				</thead>
				<tbody>
			<% 
			    if(lstRs != null && lstRs.size() > 0){
			    	
			       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
			            Map rsMap = ( Map ) lstRs.get( iLoop );
			    
			%>     
                           <tr>
                           	<td ><%=iLoop + 1%></td>
                               <td class="textLeft"><a href="javascript:fView(<%=CommonUtil.nvl(rsMap.get("HIST_NO"))%>)"><%=CommonUtil.nvl(rsMap.get("TTL")) %></a></td>
                               <td ><%=CommonUtil.getYNusetext((String)rsMap.get("USE_YN"))%></td>
                               <td ><%=CommonUtil.nvl(rsMap.get("REG_NM"))%>(<%=CommonUtil.nvl(rsMap.get("REG_ID"))%>)</td>
                               <td ><%=CommonUtil.nvl(rsMap.get("PROC_DESC"))%></td>
                               <td ><%=CommonUtil.getDateFormat(rsMap.get("REG_DT"), "-") %></td>                                                                
                           </tr>
                           <tr id="hist_<%=CommonUtil.nvl(rsMap.get("HIST_NO"))%>" style="display:none">
                           	<td colspan="6"><%=CommonUtil.recoveryLtGt(CommonUtil.nvl(rsMap.get("CTNT")))%></td>                                                                
                           </tr>			                            
			<%      
			       }
			    } else {
			%>              			 		
			          <tr >
			            <td align="center" colspan="6"><%=CommDef.Message.NO_DATA %> </td>
			          </tr>       
			<%  } %> 
				</tbody>
			</table>

</body>
</html>