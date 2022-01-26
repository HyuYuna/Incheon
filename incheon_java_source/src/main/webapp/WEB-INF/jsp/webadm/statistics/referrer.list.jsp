<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map reqMap = (Map)request.getAttribute("reqMap");
	List lstRs     = (List) request.getAttribute( "list" );
	ServiceUtil sUtil = new ServiceUtil();
	
	int  nRowCount = CommonUtil.getNullInt( (String )request.getAttribute( "count" ), 0);
	
	String strLinkPage   = CommDef.ADM_PATH + "/statistics/referrer.list.do"; // request.getRequestURL().toString(); // 현재 페이지
	
	String strParam      = CommonUtil.getRequestQueryString( request );
	String strKeykind    = CommonUtil.nvl( request.getAttribute( "keykind" ) , "");
	int    nPageNow      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "page_row" ), CommDef.PAGE_ROWCOUNT ) ;
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
	
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>
	
		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">

			<jsp:include page="/webadm/inc/search.do"  flush="false"/>

			<div style="text-align:right;">
				<button type="button" class="__btn1 type2" onclick="fExcel();">엑셀 다운로드</button>
			</div>
			
			<br/>
			<table class="__tbl-list __tbl-respond">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<thead>
					<tr>
						<th scope="col" class="__p">순번</th>
						<th scope="col">접속날짜</th>
						<th scope="col">접속경로</th>
						<th scope="col">접속페이지</th>
						<th scope="col">접속아이피</th>
						<th scope="col">접속브라우저</th>
					</tr>
				</thead>
				<tbody>
					<form name="listform" method="post" >
                     <input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
                     <input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword")) %>"/>
                     <input name="page_now"    type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now")) %>"/>
                     <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>"/>

<% 
    if(lstRs != null && lstRs.size() > 0){
    	
       int iSeqNo = nRowCount - ( nPageNow - 1 ) * nPerPage;
       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
            Map rsMap = ( Map ) lstRs.get( iLoop );
    
%>     
                            <tr>
                            	<td class="__p"><%=iSeqNo%></td>
                                <td><%=CommonUtil.getDateFormat(rsMap.get("REG_DT"),"-") %></td>
                                <td><a href="<%=CommonUtil.nvl(rsMap.get("JOIN_ROUTE")) %>" target="_blank" title="<%=CommonUtil.nvl(rsMap.get("JOIN_ROUTE")) %>" alt="<%=CommonUtil.nvl(rsMap.get("JOIN_ROUTE")) %>"><%=CommonUtil.getStrCut(CommonUtil.nvl(rsMap.get("JOIN_ROUTE")),50) %></a></td>
                                <td><span title="<%=CommonUtil.nvl(rsMap.get("JOIN_PAGE")) %>" alt="<%=CommonUtil.nvl(rsMap.get("JOIN_PAGE")) %>"><%=CommonUtil.getStrCut(CommonUtil.nvl(rsMap.get("JOIN_PAGE")), 50) %></span></td>
                                <td><%=CommonUtil.nvl(rsMap.get("JOIN_IP")) %></td>
                                <td><%=CommonUtil.nvl(rsMap.get("JOIN_BROWSER")) %></td>                        
                            </tr>
<%       iSeqNo--;
       }
    } else {
%>              
          <tr>
            <td colspan="6"><%=CommDef.Message.NO_DATA %> </td>
          </tr>       
<%  } %> 
	                  
					</form>
				</tbody>
			</table>

			<div class="__botarea">
				
				<div class="cen">
					<div class="__paging">
              			 <%=CommonUtil.getAdmPageNavi( strLinkPage, nRowCount ,nPageNow, strParam, CommDef.PAGE_PER_BLOCK, nPerPage ) %>
					</div>
				</div>

			</div>
		</div>
	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script>
function fExcel()
{
	  vObj = document.listform;
	  vObj.action = "<%=CommDef.ADM_PATH%>/statistics/referrer.list.Excel.do";
	  vObj.submit();
}  
</script>
</body>
</html>
