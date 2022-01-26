<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	List lstRs = (List)request.getAttribute("list");
	Map reqMap = (Map)request.getAttribute("reqMap");
	String menu_no = CommonUtil.nvl(reqMap.get("menu_no"));
%>
		<nav id="nav">
			<h2><span>홈페이지관리</span></h2>
			<div class="inner">
				<div class="top">
				</div>
				<ul class="gnb">
				<% 
					int childcnt = 0; //1차 메뉴 자식 카운터
					int menucnt = 0; //2차 메뉴 카운터 초기화
					String twoDepthUse = "N";
					
					//1차 메뉴 루트'
				    if(lstRs != null && lstRs.size() > 0){
				    	
				       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
				            Map rsMap = ( Map ) lstRs.get( iLoop );

						String menu_no_value  = "";
							
				    	if (CommonUtil.nvl(rsMap.get("MENU_LVL")).equals("1")) {
				    		childcnt = CommonUtil.getNullInt(CommonUtil.nvl(rsMap.get("CHILD_CNT")), 0); 
				    		menucnt = 0;	
				    		twoDepthUse = "Y";
				    		
				    	if (childcnt > 0) { //2뎁스메뉴가 있을 경우에만 노출
				%> 
						<li>
							<a href="#"><i class="<%=CommonUtil.nvl(rsMap.get("ICON_VALUE")) %>"></i><%=CommonUtil.nvl(rsMap.get("MENU_NM")) %></a>
							<ul>
				<% } } %>
					
					<%
						//2차 메뉴 
						if (CommonUtil.nvl(rsMap.get("MENU_LVL")).equals("2") && twoDepthUse.equals("Y")) { 
							menucnt = menucnt + 1;
					%>
					
						<li <% if (menu_no.equals(CommonUtil.nvl(rsMap.get("MENU_NO")))) { %> class="active"  id="menuselect"<% } %>><a href="<%=CommonUtil.getMenuUrl(rsMap) %>" target="<%=CommonUtil.nvl(rsMap.get("URL_TARGET"))%>"><%=CommonUtil.nvl(rsMap.get("MENU_NM")) %></a></li>
					 
				  		<%  if (childcnt == menucnt) { %>
								</ul>
							</li>
						<% twoDepthUse = "N"; } %>
						
					<% } %>
					
				<%      
				      }
				    } else {
				%>              
					<li>
					</li>   
				<%  } %> 
				</ul>
			</div>
			<button type="button" class="close _close"><i class="axi axi-ion-close-round"></i></button>
			<div class="bg _close"></div>
		</nav>
		
<script>
$(document).ready(function() {
	//1차 메뉴 고정 
	$('#menuselect').parents('li').attr('class','active');
});
</script>
				