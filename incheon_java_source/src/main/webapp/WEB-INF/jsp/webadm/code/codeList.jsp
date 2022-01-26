<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List lstRs     = (List) request.getAttribute( "list" );
  	int  nRowCount = CommonUtil.getNullInt( (String )request.getAttribute( "count" ), 0);
     
  	String strLinkPage   = CommDef.ADM_PATH + "/code/codeList.do"; //request.getRequestURL().toString(); // 현재 페이지
  	String strParam      = CommonUtil.getRequestQueryString( request );

  	String strCommCd     = CommonUtil.nvl(reqMap.get("comm_cd"));
  	String strCdType     = CommonUtil.nvl(reqMap.get("cd_type"));
 %>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>

<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
	
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>
	
		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>
		
		<div id="content">

			<div style="text-align:right;">
				<% if (!CommonUtil.nvl(reqMap.get("cd_type")).equals("")) { %>
				<button type="button" class="__btn1 type2" onclick="javascript:location.href='<%=strLinkPage%>?menu_no=<%=CommonUtil.nvl(reqMap.get("menu_no")) %>';">상위메뉴</button>
				<% } %>
				<button type="button" class="__btn1 type3" onclick="javascript:fWrite('<%=CommonUtil.nvl(strCdType) %>','');">메뉴등록</button>
			</div>
			<br/>
			<table class="__tbl-list __tbl-respond">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<thead>
					<tr>
                  	  <th scope="col" class="__p">번호</th>
                      <th scope="col">대분류</th>
                      <th scope="col" scope="col">코드</th>
                      <th scope="col">코드명</th>
                      <th scope="col">순서</th>
                  <% if (!"".equals(strCommCd)) { %>                                
                      <th scope="col">하위코드관리</th>
                 <% }  %>
					</tr>
				</thead>
				<tbody>
					<form name="listform" method="post">

						<input name="page_now"        type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now")) %>"/>
						<input name="up_menu_no"      type="hidden" value="<%=CommonUtil.nvl(reqMap.get("up_menu_no")) %>"/>
						<input name="parent_menu_no"  type="hidden" value="<%=CommonUtil.nvl(reqMap.get("parent_menu_no")) %>"/>
						<input name="menu_gb"         type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_gb")) %>"/>
						<input name="returl"          type="hidden" value="<%=strLinkPage%>"/>
						<input name="menu_no"         type="hidden" value=""/>
			<% 
			    if(lstRs != null && lstRs.size() > 0){
			       
			    	ServiceUtil sUtil = new ServiceUtil();
			    	
			       int iSeqNo = 1;
			       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
			            Map rsMap = ( Map ) lstRs.get( iLoop );
			    
			%>     
                            <tr>
                            	<td class="__p"><%=iSeqNo%></td>
                                <td><a href="javascript:fWrite('<%=CommonUtil.nvl(rsMap.get("CD_TYPE")) %>','<%=CommonUtil.nvl(rsMap.get("COMM_CD")) %>')"><%=CommonUtil.nvl(rsMap.get("CD_TYPE"))%></a></td>
                                <td class="subject"><%=CommonUtil.nvl(rsMap.get("COMM_CD")) %></td>
                                <td><a href="javascript:fWrite('<%=CommonUtil.nvl(rsMap.get("CD_TYPE")) %>','<%=CommonUtil.nvl(rsMap.get("COMM_CD")) %>')"><%=CommonUtil.nvl(rsMap.get("CD_NM")) %></a></td>
                                <td><%=CommonUtil.nvl(rsMap.get("ORD")) %></td>
             <% if (!"".equals(strCommCd)) { %>                                 
                                <td><a href="<%=strLinkPage %>?cd_type=<%=CommonUtil.nvl(rsMap.get("CD_TYPE")) %>&menu_no=<%=CommonUtil.nvl(reqMap.get("menu_no")) %>" class="__btn1 type1">하위코드관리</a></td>
             <% }  %>                                   
                            </tr>
			<%       iSeqNo++;
			       }
			    } else {
			%>              
			           <tr>
			            <td align="center" colspan="<%=(!"".equals(strCommCd)) ? "6" : "5"%>"><%=CommDef.Message.NO_DATA %></td>
			          </tr>       
			<%  } %> 


					</form>
				</tbody>
			</table>

			<div class="__botarea">

			</div>
		</div>
	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script>
 
	function fWrite(cd_type, comm_cd)
	{
	   winURL = "<%=CommDef.ADM_PATH %>/code/codeWrite.do?cd_type=" + cd_type + "&comm_cd=" + comm_cd;
	   popupWin(winURL, 'CodeWrite', '490', '380', ' scrollbars=0,resizable=0 ');
	}   
   
</script>
</body>
</html>
