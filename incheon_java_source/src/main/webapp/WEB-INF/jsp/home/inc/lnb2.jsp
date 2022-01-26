<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	List subMenuList = (List)  request.getAttribute( "subMenuList" ); // 서브메뉴 목록
	Map menuTitle = (Map)request.getAttribute("menuTitle"); //1차 메뉴 타이틀
	Map reqMap = (Map)request.getAttribute("reqMap");
	String onedepth = "";
%>
<script type="text/javascript" src="<%=CommDef.HOME_CONTENTS %>/js/lnb2.js"></script>
	<input type="hidden" id="menuTitle" value="<%=menuTitle.get("MENU_NM")%>"/>
	<input type="hidden" id="menuTopMenu" value="<%=menuTitle.get("TOP_MENU_NO")%>"/>
    <div class="lnbWrap left">
        <h2>복지시설</h2>
        <ul id="lnb" no-load-gnb>
            <!-- no-load-gnb 가 있는 경우 gnb에서 자동으로 가져오지 않음. -->
   <%
    	if(subMenuList != null) {
   			String menuLvl = "";
   			String preMenuLvl = "";

       		for(int i=0; i<subMenuList.size(); i++) {
       			Map menuMap = (Map)subMenuList.get(i);
       			menuLvl = CommonUtil.nvl(menuMap.get("MENU_LVL"));

       			String strUrl  = CommonUtil.getHomeMenuUrl(menuMap);
       			String strUrlTarget = CommonUtil.nvl(menuMap.get("URL_TARGET"), "_self");
       			String menuNo = CommonUtil.nvl(menuMap.get("MENU_NO"));

       		if (CommonUtil.nvl(menuMap.get("LNB_SHOW_YN")).equals("Y")) {

       			if("2".equals(menuLvl)) {
       		%>
       			<% if("2".equals(preMenuLvl)) { %>
       				</li>
       			<% } else if("3".equals(preMenuLvl)) { %>
            			</ul>
       				</li>
            	<%
            		}
       				if (CommonUtil.nvl(reqMap.get("menuno")).equals(CommonUtil.nvl(menuMap.get("TOP_MENU_NO")))) {
       					onedepth = CommonUtil.nvl(menuMap.get("TOP_MENU_NO"));
       				}
            	%>
	         		<li <% if (CommonUtil.nvl(reqMap.get("menuno")).equals(menuNo)) { %>class="active"<% } %>><a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a>
            <%
            	} else if("3".equals(menuLvl)) {
            %>
                    <% if (CommonUtil.getNullInt(menuMap.get("ORD"), 0) == 1) { %>
            				<ul>
            		<% } %>
            			<li <% if (CommonUtil.nvl(reqMap.get("menuno")).equals(menuNo)) { %>class="active"<% } %>><a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a></li>
            <% } %>
    	<%
    			preMenuLvl = menuLvl;
       			}

       		}
       	%>
       				</li>
    <%  } %>
        </ul>
    </div>