<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List lstRs     = (List) request.getAttribute( "list" );
  	
  	String menu_gb = CommonUtil.nvl(reqMap.get("menu_gb"));
  	int  nRowCount = CommonUtil.getNullInt( (String )request.getAttribute( "count" ), 0);

 	String strLinkPage   = CommDef.ADM_PATH + "/menu/menuList.do"; // request.getRequestURL().toString(); // 현재 페이지
  	
  	String strParam      = CommonUtil.getRequestQueryString( request );
  	int    nPageNow      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
  	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "page_row" ), CommDef.PAGE_ROWCOUNT ) ;
  	
	int nCols = 7;
	if (!menu_gb.equals("ADMIN")) nCols = 9;
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
				<button type="button" class="__btn1 type2" onclick="javascript:location.href='<%=strLinkPage%>?up_menu_no=<%=CommonUtil.nvl(reqMap.get("parent_menu_no"))%>&menu_gb=<%=CommonUtil.nvl(reqMap.get("menu_gb"))%>&menu_no=<%=CommonUtil.nvl(reqMap.get("menu_no")) %>';">상위메뉴</button>
				<button type="button" class="__btn1 type3" onclick="javascript:fWrite('<%=CommonUtil.nvl(reqMap.get("up_menu_no"), CommDef.TOP_MENU_NO) %>');">메뉴등록</button>
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
						<th scope="col">메뉴번호</th>
						<th class="subject" scope="col">메뉴명</th>
						<th scope="col">Depth</th>
						<th scope="col">순서</th>
						<th scope="col">사용여부</th>
					<% if (!menu_gb.equals("ADMIN")) { %>
						<th scope="col">GNB노출여부</th>
						<th scope="col">LNB노출여부</th>
					<% } %>
						<th scope="col">관리</th>
					</tr>
				</thead>
				<tbody>
					<form name="listform" method="post">
						 <input name="param" type="hidden" value="<%=strParam %>"/>
	                     <input name="page_now"        	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now")) %>"/>
	                     <input name="up_menu_no"     	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("up_menu_no")) %>"/>
	                     <input name="parent_menu_no" type="hidden" value="<%=CommonUtil.nvl(reqMap.get("parent_menu_no")) %>"/>
	                     <input name="menu_gb"         	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_gb")) %>"/>
	                     <input name="returl"          		type="hidden" value="<%=strLinkPage%>"/>
	                     <input name="menu_no"         	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>"/>
	                     <input name="strregno"			type="hidden" value=""/>
	                     
<% 
    if(lstRs != null && lstRs.size() > 0){
       
    	ServiceUtil sUtil = new ServiceUtil();
    	
       int iSeqNo = nRowCount - ( nPageNow - 1 ) * nPerPage;
       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
            Map rsMap = ( Map ) lstRs.get( iLoop );
    
%>     
                            <tr>
                            	<td class="__p"><%=iLoop+1%></td>
                            	<td ><%=CommonUtil.nvl(rsMap.get("MENU_NO")) %></td>
                                <td class="subject"><%=CommonUtil.nvl(rsMap.get("MENU_NM"))%></td>
                                <td ><%=CommonUtil.nvl(rsMap.get("MENU_LVL")) %></td>
                                <td ><%=CommonUtil.nvl(rsMap.get("ORD")) %></td>
                                <td ><%=CommonUtil.getYNusetext((String)rsMap.get("USE_YN")) %></td>
                            <% if (!menu_gb.equals("ADMIN")) { %>
                                <td ><%=CommonUtil.getYNshowtext((String)rsMap.get("GNB_SHOW_YN")) %></td> 
                                <td ><%=CommonUtil.getYNshowtext((String)rsMap.get("LNB_SHOW_YN")) %></td>
                            <% } %>                            
                                <td >
                                <% if (!("ADMIN".equals(CommonUtil.nvl(reqMap.get("menu_gb"))) && "2".equals(CommonUtil.nvl(rsMap.get("MENU_LVL"))))) { %>
                                	<a href="<%=strLinkPage%>?up_menu_no=<%=CommonUtil.nvl(rsMap.get("MENU_NO"))%>&parent_menu_no=<%=CommonUtil.nvl(rsMap.get("UP_MENU_NO"))%>&menu_gb=<%=CommonUtil.nvl(rsMap.get("MENU_GB"))%>&menu_no=<%=CommonUtil.nvl(reqMap.get("menu_no")) %>" class="__btn1 type1">하위메뉴</a>
                                <%} %>    
                                     <a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("MENU_NO"))%>','<%=CommonUtil.nvl(rsMap.get("UP_MENU_NO"))%>')" class="__btn1 type2">수정</a>
                                     <a href="javascript:fDelete('<%=CommonUtil.nvl(rsMap.get("MENU_NO"))%>','<%=CommonUtil.nvl(rsMap.get("UP_MENU_NO"))%>')" class="__btn1 type3">삭제</a>
                                </td>
                            </tr>
<%       iSeqNo--;
       }
    } else {
%>              
 

          <tr>
            <td colspan="<%=nCols%>"><%=CommDef.Message.NO_DATA %> </td>
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
 
   function fWrite(strUpMenuId)
   {
	  vObj = document.listform;   
	
	  vObj.up_menu_no.value = strUpMenuId;
	  vObj.action = "<%=CommDef.ADM_PATH %>/menu/menuWrite.do";
	  
	  vObj.submit();
   }   
   function fModify(strMenuId, strUpMenuId)
   {
	  vObj = document.listform;   
	
	  vObj.strregno.value = strMenuId; 
	  vObj.up_menu_no.value = strUpMenuId;
	  vObj.action = "<%=CommDef.ADM_PATH %>/menu/menuWrite.do";
	  
	  vObj.submit();
   }
   
   function fDelete(strMenuId, strUpMenuId)
   {
	  vObj = document.listform;   
	
	  if (!confirm("삭제하시겠습니까?"))
		  return;
	  
	  vObj.strregno.value = strMenuId; 
	  vObj.up_menu_no.value = strUpMenuId;
	  vObj.action = "<%=CommDef.ADM_PATH %>/menu/menuDelete.do";
	  
	  vObj.submit();
   }   
   
</script>
</body>
</html>
