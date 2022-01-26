<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, egovframework.common.InitServletContextListener" %>
<%
	Map sesMap = (Map)SessionUtil.getSessionAttribute(request, "USER");
	Map reqMap = (Map)request.getAttribute("reqMap");
	List topMenuList = InitServletContextListener.getTopMenuList(request);
	String onedepth = "";
	String hiddenMenu = "";
%>
<script>var activeMenu = "";</script>
<header id="header">

	<div class="inner">
		<!-- logo -->
		<a href="/" class="logo"><h1><img src="<%=CommDef.HOME_CONTENTS %>/images/main/logo.jpg" alt="인천광역시 장애인복지 플랫폼" /></h1></a>

        <div id="tsch">
            <form action="/facilityList.do" method="get">
            	<input type="hidden" name="menuno" id="searchmenuno" value="274"/>
                <legend>전체검색</legend>
                <input type="text" name="shtext" id="searchshtext" class="inp" placeholder="시설명을 입력하세요." />
                <button type="submit" class="sbm"><i class="axi axi-search"></i></button>
            </form>
        </div>

		<ul id="tsns">
            <li><a href=""><img src="<%=CommDef.HOME_CONTENTS %>/images/main/tsns-f.jpg" />페이스북</a></li>
            <li><a href=""><img src="<%=CommDef.HOME_CONTENTS %>/images/main/tsns-b.jpg" />블로그</a></li>
            <li><a href=""><img src="<%=CommDef.HOME_CONTENTS %>/images/main/tsns-y.jpg" />유튜브</a></li>
        </ul>
	</div>


    <div class="gnbWrap">
        <!-- gnb -->
		<ul id="gnb">

   <%
    	if(topMenuList != null) {
   			String menuLvl = "";
   			String preMenuLvl = "";

   			int limitCnt = CommDef.TOP_MENU_LIMIT; //1Depth 나오는 갯수
   			int count = 0;

       		for(int i=0; i<topMenuList.size(); i++) {
       			Map menuMap = (Map)topMenuList.get(i);
       			menuLvl = CommonUtil.nvl(menuMap.get("MENU_LVL"));

       			String strUrl  = CommonUtil.getHomeMenuUrl(menuMap);
       			String strUrlTarget = CommonUtil.nvl(menuMap.get("URL_TARGET"), "_self");
       			hiddenMenu = "";

       			if("1".equals(menuLvl)) {
       				if(count >= limitCnt) break;
       		%>
       			<% if("1".equals(preMenuLvl)) { %>
       					</ul>
       				</li>
       			<% } else if("2".equals(preMenuLvl)) { %>
            			</ul>
       				</li>
            	<%
            		}
       				if (CommonUtil.nvl(reqMap.get("menuno")).equals(CommonUtil.nvl(menuMap.get("TOP_MENU_NO")))) {
       					onedepth = CommonUtil.nvl(menuMap.get("TOP_MENU_NO"));
       				}
       				if (CommonUtil.nvl(menuMap.get("GNB_SHOW_YN")).equals("N")) hiddenMenu = "hidden-gnb";
            	%>
	         		<li class="<%=hiddenMenu %>" id="menu_<%=CommonUtil.nvl(menuMap.get("TOP_MENU_NO"))%>">
	            		<a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a>
       					<ul>
            <%
            		count++;
            	} else if("2".equals(menuLvl)) {
            %>
            		<% if (CommonUtil.nvl(menuMap.get("MENU_NO")).equals(CommonUtil.nvl(reqMap.get("menuno")))) {%>
            			<% if (CommonUtil.nvl(menuMap.get("GNB_SHOW_YN")).equals("Y")) { %>
            			<li class="active" id="<%=CommonUtil.nvl(menuMap.get("TOP_MENU_NO"))%>"><a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a></li>
	            			<script> activeMenu = "<%=CommonUtil.nvl(menuMap.get("TOP_MENU_NO"))%>";</script>
	            		<% } %>
            		<% } else { %>
            			<% if (onedepth.equals(CommonUtil.nvl(menuMap.get("UP_MENU_NO"))) && CommonUtil.getNullInt(menuMap.get("ORD"), 0) == 1) { %>
            				<% if (CommonUtil.nvl(menuMap.get("GNB_SHOW_YN")).equals("Y")) { %>
	            			<li class="active" id="<%=CommonUtil.nvl(menuMap.get("TOP_MENU_NO"))%>"><a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a></li>
		            		<script> activeMenu = "<%=CommonUtil.nvl(menuMap.get("TOP_MENU_NO"))%>";</script>
		            		<% } %>
            			<% } else { %>
            				<% if (CommonUtil.nvl(menuMap.get("GNB_SHOW_YN")).equals("Y")) { %>
						<li class=""><a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a></li>
							<% } %>
						<% } %>
            		<% } %>
            <% } %>
    	<%
    			preMenuLvl = menuLvl;
       		}
       	%>
       					</ul>
       				</li>
    <%  } %>



        <!-- dropdown menu -->
        <div id="drdw"></div>

		</ul>
    </div>

</header>

<!-- 1차 메뉴 active -->
<script>
$(document).ready(function() {
	if (activeMenu != "") {
		$('#menu_' + activeMenu).attr("class","active");
	}
});
</script>
