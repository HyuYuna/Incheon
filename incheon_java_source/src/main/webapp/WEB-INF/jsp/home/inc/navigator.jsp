<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map  reqMap      = (Map)  request.getAttribute( "reqMap" );  
	Map  menuInfo	= (Map)  request.getAttribute( "menuInfo" );
	Map  subMenuMap  = (Map)  request.getAttribute( "subMenuInfo" ); // 서브메뉴 정보
	Map userMap = (Map) SessionUtil.getSessionAttribute(request, "USER");
	if(userMap == null) userMap = new HashMap();
	List subMenuList = (List)  request.getAttribute( "subMenuList" ); // 서브메뉴 목록

	String mainMenuTitle = CommonUtil.nvl(subMenuMap.get("MENU_NM"));
	String menuTitle = CommonUtil.nvl(menuInfo.get("MENU_NM"));
%>
			<div id="navigator">
				<ul>
			    	<li><a href="javascript:rootLocation();"><i class="fa fa-home"></i></a></li>
			    	
			    	<li class="d1">
			    		<input type="hidden" name="onedept1" id="onedept1" value="<a href='<%=CommonUtil.getHomeMenuUrl(subMenuMap)%>'><%=mainMenuTitle%></a>"/>
			    		<a href="#"><%=mainMenuTitle%></a>
			    	</li>
			    	
			    	<li class="d2">
			    		<input type="hidden" name="onedept2" id="onedept2" t="<%=menuTitle%>" value="<a href='<%=CommonUtil.getHomeMenuUrl(menuInfo)%>'><%=menuTitle%></a>"/>
			    		<a href="#"><%=menuTitle %></a>
			    		<ul>
							<%
								String twoMenuLast = "";
						    	if(subMenuList != null) {
									
						       		for(int i=0; i<subMenuList.size(); i++) {	
						       			Map menuMap = (Map)subMenuList.get(i);
							       		if (CommonUtil.nvl(menuMap.get("LNB_SHOW_YN")).equals("Y")) {
							       			if (CommonUtil.nvl(menuMap.get("MENU_LVL")).equals("2")) { 
							       			String strUrl  = CommonUtil.getHomeMenuUrl(menuMap);
							       			String strUrlTarget = CommonUtil.nvl(menuMap.get("URL_TARGET"), "_self");
							%>
								<li><a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a></li>
							<%
					       				}
					       			}
					       		}
					    	}
							%>
			    		</ul>
			    	</li>
			    	
				</ul>
			</div>