<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	int totalCount = CommonUtil.getNullInt((String)request.getAttribute( "count" ), 0);
	List programsList = (List)request.getAttribute("programsList");
	Map facilityTitle = (Map)request.getAttribute("facilityTitle");

	int page_now      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
	String strParam      = CommonUtil.getRequestQueryString( request );
	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "per_page" ),4) ;

	String strLinkPage   = "/programs.do"; //링크 페이지
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
<body>

<div id="wrap">

	<!-- topmenu -->
	<jsp:include page="/home/inc/topmenu.do"></jsp:include>
	<!-- topmenu -->

		<section id="sub">

			<!-- subvisual -->
			<jsp:include page="/home/inc/subvisual.do"></jsp:include>
			<!-- subvisual -->

			<!-- navigator -->
			<%-- <jsp:include page="/home/inc/navigator.do"></jsp:include> --%>
			<!-- navigator -->

            <!-- start content -->
			<div id="content">

				<!-- facilitylnb -->
				<jsp:include page="/home/inc/lnb2.do"></jsp:include>
				<!-- facilitylnb -->
                <div id="subCont">

                    <div class="sub-tit">
                        <h3>장애인 복지시설</h3>
                    </div>

                    <div class="listsch">
                    	<h3><%=CommonUtil.nvl(facilityTitle.get("WFFCLTY_NM")) %></h3>
                        <span class="lec-total">
                            <strong class="blue"><%=CommonUtil.number_format(totalCount) %></strong> 개의 프로그램을 운영중입니다.
                        </span>
                    </div>

                    <ul class="sisullist">
					<%
					    if(programsList != null && programsList.size() > 0){

					       for( int i = 0; i < programsList.size(); i++ ) {
					            Map programsMap = ( Map ) programsList.get(i);
					%>
                        <li>
                            <span class="tit"><%=CommonUtil.nvl(programsMap.get("PROGRAM_NM")) %></span>
                            <div class="info">
                                <p><%=CommonUtil.nvl(programsMap.get("PROGRAM_DETAIL")) %></p>
                            </div>
                            <div class="info mt10">
                              	<p><strong>운영시간</strong><%=CommonUtil.nvl(programsMap.get("TIME_DETAIL"), "-") %></p>
                                <p><strong>대상자</strong><%=CommonUtil.nvl(programsMap.get("TRGTER_DETAIL"), "-") %></p>
                                <p><strong>이용료</strong><%=CommonUtil.nvl(programsMap.get("FEE_DETAIL"), "-") %></p>
                            </div>
                        <% if (!CommonUtil.nvl(programsMap.get("PIC"), "").equals("")) { %>
                        <%
                        	String[] picArray = CommonUtil.nvl(programsMap.get("PIC"), "").split("§§");
                        %>
                            <ul class="tmb">

                            	<% for (int k = 0; k < picArray.length; k++) { %>
                                <li style="background-image: url('https://webjangbok.incheon.go.kr<%=picArray[k]%>');"><a href="https://webjangbok.incheon.go.kr<%=picArray[k]%>" class="fancybox"></a></li>
                                <% } %>

                            </ul>
                        <% } %>
                        </li>
					<% 		}
					    }
					%>
                    </ul>

                    <script type="text/javascript">
                    $(document).ready(function(){
                        $('a.fancybox').fancybox();
                    })
                    </script>

                    <!-- s:paging -->
					<div class='paging'>
						<%=CommonUtil.getFrontPageNavi( strLinkPage, totalCount ,page_now, strParam, CommDef.PAGE_PER_BLOCK, nPerPage ) %>
					</div>
                    <!-- e:paging -->


                </div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>
</body>

</html>
