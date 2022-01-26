<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	List bannerMain = (List)request.getAttribute("bannerMain"); //메인 배너 리스트
	List bannerMidea = (List)request.getAttribute("bannerMidea"); //미디어 배너 리스트
	List bannerBottom = (List)request.getAttribute("bannerBottom"); //하단 배너 리스트

	List noticeMainList = (List)request.getAttribute("noticeMainList"); //공지사항 리스트
	List pdsMainList = (List)request.getAttribute("pdsMainList"); //자료실 리스트
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
<body>
<div id="wrap">

	<!-- topmenu -->
	<jsp:include page="/home/inc/topmenu.do"></jsp:include>
	<!-- topmenu -->

	<!-- s:Content start -->
	<section id="main">
	<div id="content">

	    <div class="mainbox">
	        <div class="inner">
	            <div class="lef">

	                <div class="box b1">
	                    <h4>장애복지 안내</h4>
	                    <p>21년도 달라진 인천시 <br>장애인복지정책 등 소개</p>
	                    <div class="btns">
	                        <a href="/contents.do?menuno=65">장애복지정책</a>
	                    </div>
	                </div>

	                <div class="box b2">
	                    <h4>활동지원서비스</h4>
	                    <p>일생생활, 사회생활, <br>가사지원 등의 서비스 제공</p>
	                    <div class="btns">
	                        <a href="/support.do?menuno=62">시설안내</a>
	                    </div>
	                </div>
	            </div>

	            <div class="mid">
	                <div class="visual">
	                    <ul class="roll">
						<%
						 	if (bannerMain != null && !bannerMain.isEmpty()) {
							    for (int nLoop=0; nLoop < bannerMain.size(); nLoop++) {
							    	Map rsMap = (Map)bannerMain.get(nLoop);

							    	String strUrl = "#";
							    	String strTarget = "";
							    	if (!CommonUtil.nvl(rsMap.get("LINK_TEXT")).equals("")) {
							    		strUrl = CommonUtil.nvl(rsMap.get("LINK_TEXT"));
							    		strTarget = "target='" + CommonUtil.nvl(rsMap.get("LINK_TARGET")) + "'";
							    	}
						%>
							<li class="item"><a href="<%=strUrl %>" title="<%=CommonUtil.nvl(rsMap.get("TITLE")) %>" <%=strTarget %>><img src="<%=CommonUtil.nvl(rsMap.get("IMG_PC")) %>" alt="<%=CommonUtil.nvl(rsMap.get("TITLE")) %>" /></a></li>
						<%
							    }
						 	}
						%>
	                    </ul>
	                </div>

	                <div class="box b5">
	                    <h4>장애인복지시설</em></h4>
                        <p>장애인직업재활시설·주간보호시설은 이용신청 가능</p>
	                    <div class="btns mt10">
	                        <a href="/facility.do?menuno=61">시설안내</a>
	                        <%-- <a href="/facilityList.do?menuno=61">시설입소대기자 예약</a> --%>
	                    </div>
	                </div>
	            </div>

	            <div class="rig">
	                <div class="box b3">
	                    <h4>참여소통</h4>
	                    <p>온라인 소통창구 <br>장애인복지 새소식</p>
	                    <div class="btns">
	                        <a href="/board.do?boardno=24&menuno=75">온라인소통</a><br />
	                        <a href="/board.do?boardno=61&menuno=76">궁금하신 사항</a>
	                    </div>
	                </div>

	                <div class="box b4">
	                    <h4>사이버일자리센터</h4>
	                    <p>구인·구직 등록 및 <br />정보제공</p>
	                    <div class="btns">
	                        <a href="/board.do?boardno=62&menuno=207">구인정보</a>
	                        <a href="/board.do?boardno=63&menuno=208">구직신청</a>
	                    </div>
	                </div>
	            </div>

	            <!-- quick menu -->
	            <ul class="main-qk">
	                <li>
	                    <a href="https://www.incheon.go.kr/" target="_blank">인천시청</a>
	                    <img src="<%=CommDef.HOME_CONTENTS %>/images/main/mid-qk-ico1.png" />
	                    <p>인천시청</p>
	                </li>
	                <li>
	                    <a href="http://www.nrc.go.kr/nrc/main.do" target="_blank">국립재활원</a>
	                    <img src="<%=CommDef.HOME_CONTENTS %>/images/main/mid-qk-ico2.png" />
	                    <p>국립재활원</p>
	                </li>
	                <li>
	                    <a href="http://www.mohw.go.kr" target="_blank">보건복지부</a>
	                    <img src="<%=CommDef.HOME_CONTENTS %>/images/main/mid-qk-ico4.png" />
	                    <p>보건복지부</p>
	                </li>
                    <li>
	                    <a href="https://www.koddi.or.kr/" target="_blank">한국장애인개발원</a>
	                    <img src="<%=CommDef.HOME_CONTENTS %>/images/main/mid-qk-ico6.png" />
	                    <p>한국장애인개발원</p>
	                </li>
	                <li>
	                    <a href="https://www.kead.or.kr/" target="_blank">한국장애인고용공단</a>
	                    <img src="<%=CommDef.HOME_CONTENTS %>/images/main/mid-qk-ico5.png" />
	                    <p>한국장애인고용공단</p>
	                </li>
	                <li>
	                    <a href="http://www.imedialife.co.kr" target="_blank">장애인재활정보신문</a>
	                    <img src="<%=CommDef.HOME_CONTENTS %>/images/main/mid-qk-ico7.png" />
	                    <p>장애인재활정보신문</p>
	                </li>
	            </ul>
	        </div>
	    </div>

	    <div class="mainlat">
	        <div class="box b1">
	            <div class="titWrap">
	                <h4>언택트 코너</h4>
	            </div>
	            <ul class="roll">
				<%
				 	if (bannerMidea != null && !bannerMidea.isEmpty()) {
					    for (int nLoop=0; nLoop < bannerMidea.size(); nLoop++) {
					    	Map rsMap = (Map)bannerMidea.get(nLoop);

					    	String strUrl = "#";
					    	String strTarget = "";
					    	if (!CommonUtil.nvl(rsMap.get("LINK_TEXT")).equals("")) {
					    		strUrl = CommonUtil.nvl(rsMap.get("LINK_TEXT"));
					    		strTarget = "target='" + CommonUtil.nvl(rsMap.get("LINK_TARGET")) + "'";
					    	}
				%>
					<li><a href="<%=strUrl %>" title="<%=CommonUtil.nvl(rsMap.get("TITLE")) %>" <%=strTarget %>><img src="<%=CommonUtil.nvl(rsMap.get("IMG_PC")) %>" alt="<%=CommonUtil.nvl(rsMap.get("TITLE")) %>" /></a></li>
				<%
					    }
				 	}
				%>
	            </ul>
	        </div>

	        <div class="box">


	            <div class="titWrap2">
	                <h4>허브코너</h4>
	                <a href="/board.do?boardno=24&menuno=75" class="more">더 보기</a>
	            </div>
				<%
					int noticeFirst = 0;

				 	if (noticeMainList != null && !noticeMainList.isEmpty()) {
					    for (int nLoop=0; nLoop < noticeMainList.size(); nLoop++) {
					    	Map boardMap = (Map)noticeMainList.get(nLoop);

					  if (noticeFirst == nLoop) {
				%>
	            <div class="lat-top">
	                <div class="date">
	                    <em><%=CommonUtil.nvl(boardMap.get("REG_DT")).substring(0,4) %></em>
	                    <strong><%=CommonUtil.nvl(boardMap.get("REG_DT")).substring(4,6) %>-<%=CommonUtil.nvl(boardMap.get("REG_DT")).substring(6,8) %></strong>
	                </div>
	                <a href="/view.do?boardno=<%=CommonUtil.nvl(boardMap.get("BRD_MGRNO"))%>&menuno=75&seq=<%=CommonUtil.nvl(boardMap.get("BRD_NO"))%>"  title="<%=CommonUtil.nvl(boardMap.get("TITLE")) %>" class="sbj"><p><%=CommonUtil.getStrCut(CommonUtil.nvl(boardMap.get("TITLE")),80) %></p></a>
	            </div>
	            <ul class="list">
				<%
					  } else {
				%>
	                <li>
	                    <a href="/view.do?boardno=<%=CommonUtil.nvl(boardMap.get("BRD_MGRNO"))%>&menuno=75&seq=<%=CommonUtil.nvl(boardMap.get("BRD_NO"))%>" class="sbj"><%=CommonUtil.getStrCut(CommonUtil.nvl(boardMap.get("TITLE")),50) %></a>
	                    <span class="date"><%=CommonUtil.getDateFormat(boardMap.get("REG_DT"), "ymd") %></span>
	                </li>
				<%
					  		}
					    }
				%>
					</ul>
				<%
				 	}
				%>
	        </div>

	        <div class="box">
	            <div class="titWrap2">
	                <h4>자료실</h4>
	                <a href="/board.do?boardno=45&menuno=77" class="more">더 보기</a>
	            </div>

				<%
					int pdsFirst = 0;

				 	if (pdsMainList != null && !pdsMainList.isEmpty()) {
					    for (int nLoop=0; nLoop < pdsMainList.size(); nLoop++) {
					    	Map boardMap = (Map)pdsMainList.get(nLoop);

					  if (pdsFirst == nLoop) {
				%>
	            <div class="lat-top">
	                <div class="date">
	                    <em><%=CommonUtil.nvl(boardMap.get("REG_DT")).substring(0,4) %></em>
	                    <strong><%=CommonUtil.nvl(boardMap.get("REG_DT")).substring(4,6) %>-<%=CommonUtil.nvl(boardMap.get("REG_DT")).substring(6,8) %></strong>
	                </div>
	                <a href="/view.do?boardno=<%=CommonUtil.nvl(boardMap.get("BRD_MGRNO"))%>&menuno=77&seq=<%=CommonUtil.nvl(boardMap.get("BRD_NO"))%>"  title="<%=CommonUtil.nvl(boardMap.get("TITLE")) %>" class="sbj"><p><%=CommonUtil.getStrCut(CommonUtil.nvl(boardMap.get("TITLE")),80) %></p></a>
	            </div>
	            <ul class="list">
				<%
					  } else {
				%>
	                <li>
	                    <a href="/view.do?boardno=<%=CommonUtil.nvl(boardMap.get("BRD_MGRNO"))%>&menuno=77&seq=<%=CommonUtil.nvl(boardMap.get("BRD_NO"))%>" class="sbj"><%=CommonUtil.getStrCut(CommonUtil.nvl(boardMap.get("TITLE")),50) %></a>
	                    <span class="date"><%=CommonUtil.getDateFormat(boardMap.get("REG_DT"), "ymd") %></span>
	                </li>
				<%
					  		}
					    }
				%>
					</ul>
				<%
				 	}
				%>

	        </div>
	    </div>

	    <div class="main-fam">
	        <div class="inner">
	            <ul class="roll">
				<%
				 	if (bannerBottom != null && !bannerBottom.isEmpty()) {
					    for (int nLoop=0; nLoop < bannerBottom.size(); nLoop++) {
					    	Map rsMap = (Map)bannerBottom.get(nLoop);

					    	String strUrl = "#";
					    	String strTarget = "";
					    	if (!CommonUtil.nvl(rsMap.get("LINK_TEXT")).equals("")) {
					    		strUrl = CommonUtil.nvl(rsMap.get("LINK_TEXT"));
					    		strTarget = "target='" + CommonUtil.nvl(rsMap.get("LINK_TARGET")) + "'";
					    	}
				%>
					<li class="item"><a href="<%=strUrl %>" title="<%=CommonUtil.nvl(rsMap.get("TITLE")) %>" <%=strTarget %>><img src="<%=CommonUtil.nvl(rsMap.get("IMG_PC")) %>" alt="<%=CommonUtil.nvl(rsMap.get("TITLE")) %>" /></a></li>
				<%
					    }
				 	}
				%>
<!-- 	                <li class="item"><a href="#"><img src="http://wimg.kr/160x65&l=false" /></a></li> -->

	            </ul>
	        </div>
	    </div>



	    <script type="text/javascript">
	    visual.init();
	    media_roll.init();
	    family_roll.init();
	    </script>


	</div>
	</section>
	<!-- e:Content end -->

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

	</div>

<!-- popup -->
<jsp:include page="/popup.do">
	<jsp:param name="menu_gb" value="HOME"/>
</jsp:include>
<!-- popup -->


</body>
</html>
