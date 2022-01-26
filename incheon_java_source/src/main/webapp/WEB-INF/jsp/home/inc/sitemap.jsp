<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, egovframework.common.InitServletContextListener" %>
<%
	Map reqMap = (Map)request.getAttribute("reqMap");
	List topMenuList = InitServletContextListener.getTopMenuList(request);
%>
<div class="pop-tit">
    <h3>사이트맵</h3>
    <a href="#" class="close"><i class="fa fa-remove"></i></a>
</div>
<div class="pop-wrap">

    <!-- 팝업 내용 -->
    <div class="sitemap">
 
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
       				if (CommonUtil.nvl(menuMap.get("LNB_SHOW_YN")).equals("Y")) {
            	%>
	         		<li class="">
	            		<a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a>
       					<ul>
            <% 
            			count++;
       				}
            	} else if("2".equals(menuLvl)) { 
            		if (CommonUtil.nvl(menuMap.get("LNB_SHOW_YN")).equals("Y")) {
            %>
            			<li class=""><a href="<%=strUrl%>" target="<%=strUrlTarget%>"><%=CommonUtil.nvl(menuMap.get("MENU_NM"))%></a></li>
            <% 
            			}
            		} %>
    	<%  
    			preMenuLvl = menuLvl;
       		} 
       	%>
       					</ul> 
       				</li>
    <%  
    		}
   %>
    </div>

</div>