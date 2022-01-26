<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	List areaList = (List)request.getAttribute("areaList");

	String strLinkPage   = "/supportList.do"; //링크 페이지
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

				<!-- subtitle -->
				<jsp:include page="/home/inc/subtitle.do"></jsp:include>
				<!-- subtitle -->


			       <!-- 지도선택 -->
			        <dl class="sisulbox">
			            <dt>
			                <div class="mapbox">
			                    <img src="<%=CommDef.HOME_CONTENTS %>/images/sub/map/map-blank.png" usemap="#Map" class="blank" />
			                    <img src="<%=CommDef.HOME_CONTENTS %>/images/sub/map/map-blank.png" usemap="#Map" class="codemap" />
			                    <img src="<%=CommDef.HOME_CONTENTS %>/images/sub/map/map-bg.jpg" />
			                </div>
			                <map name="Map">
			                    <!-- 남동구 --><area shape="poly" coords="504,387,500,409,512,416,513,434,494,451,487,473,529,486,543,471,560,453,560,437,568,435,572,426,574,410,586,400,578,379,564,375,562,381,553,387,534,380,524,378,512,381" href="<%=strLinkPage %>?gu=05&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="namdong" />
			                    <!-- 옹진군 --><area shape="poly" coords="285,476,264,489,252,505,260,525,286,535,306,532,301,512,310,501,320,516,328,510,320,499,324,491,315,480" href="<%=strLinkPage %>?gu=10&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="ongjin" />
			                    <!-- 연수구 --><area shape="poly" coords="506,415,496,424,482,423,465,419,452,425,447,433,452,447,488,473,494,450,513,433,512,415" href="<%=strLinkPage %>?gu=04&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="yeonsu" />
			                    <!-- 미추홀구 --><area shape="poly" coords="469,363,464,380,454,383,457,391,448,398,444,410,450,417,446,426,451,427,465,419,497,423,508,413,500,409,503,387" href="<%=strLinkPage %>?gu=03&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="michu" />
			                    <!-- 중구 --><area shape="poly" coords="454,385,429,360,393,338,321,293,306,311,302,327,294,332,274,336,206,366,230,435,248,469,274,471,280,459,258,431,258,419,280,417,312,393,329,372,350,363,359,367,394,344,425,365,415,373,408,389,412,412,421,421,433,426,448,425,450,417,444,410,446,399,457,391" href="<%=strLinkPage %>?gu=01&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="junggu" />
			                    <!-- 동구 --><area shape="poly" coords="429,360,454,385,464,379,469,364,456,353" href="<%=strLinkPage %>?gu=02&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="donggu" />
			                    <!-- 부평구 --><area shape="poly" coords="492,325,493,340,506,359,505,365,500,375,498,383,504,387,514,379,525,377,553,386,563,381,564,373,560,366,546,364,551,356,551,336,562,331,562,323,540,329,524,322" href="<%=strLinkPage %>?gu=06&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="bupyeong" />
			                    <!-- 계양구 --><area shape="poly" coords="494,262,508,280,518,292,515,299,509,303,496,308,492,325,527,322,542,329,563,323,574,275,590,267,594,258,587,248,557,255,546,247,529,241,527,251,523,262,504,257" href="<%=strLinkPage %>?gu=07&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="gyeyang" />
			                    <!-- 서구 --><area shape="poly" coords="472,192,395,255,405,286,387,308,399,333,410,325,408,308,424,316,464,313,448,323,438,321,433,333,440,345,456,344,458,353,498,382,505,359,493,341,491,323,495,307,514,299,517,291,494,262,503,257,522,261,528,239,500,209" href="<%=strLinkPage %>?gu=08&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="seogu" />
			                    <!-- 강화군 --><area shape="poly" coords="384,271,349,67,284,8,212,49,154,28,94,32,89,88,114,111,64,139,29,167,77,209,152,247,252,274,382,272" href="<%=strLinkPage %>?gu=09&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>" data-map-code="ganghwa" />
			                </map>
			                <script type="text/javascript">
			                $(function(){
			                    var $img = $('.sisulbox .mapbox img.codemap');
			                    var $area = $('.sisulbox map[name=Map] > area');

			                    $area.on({
			                        'mouseenter' : function(e){
			                            e.preventDefault();
			                            var code = $(this).data('map-code');
			                            $img.attr({
			                                'src' : '<%=CommDef.HOME_CONTENTS %>/images/sub/map/map-' + code + '.png'
			                            })
			                        },
			                        'mouseleave' : function(e){
			                            e.preventDefault();
			                            $img.attr({
			                                'src' : '<%=CommDef.HOME_CONTENTS %>/images/sub/map/map-blank.png'
			                            })
			                        }
			                    })
			                })
			                </script>
			            </dt>
			            <dd>
			                <form action="<%=strLinkPage %>" method="get">
			                	<input type="hidden" name="menuno" id="menuno" value=""/>
			                    <div class="titWrap">
			                        <i class="axi axi-ion-android-search"></i>
			                        <h4>지역별 활동지원서비스 검색</h4>
			                        <em>원하시는 지역을 선택해주세요</em>
			                    </div>

			                    <fieldset>
						            <select name="gu" id="gu">
						                <option value="">지역을 선택해주세요.</option>
									<%
									    if(areaList != null && areaList.size() > 0){

									       for( int areaLoop = 0; areaLoop < areaList.size(); areaLoop++ ) {
									            Map areaListMap = ( Map ) areaList.get( areaLoop );
									%>
										<option value="<%=CommonUtil.nvl(areaListMap.get("GU")) %>"><%=CommonUtil.nvl(areaListMap.get("GU_NM")) %></option>
									<% 		}
									    }
									%>
			                        </select>

			                        <input type="text" name="shtext" id="shtext" class="inp" placeholder="시설명을 입력해주세요." />
			                        <div class="tac mt20">
			                            <button type="submit" class="sbm bbtn1" id="searchBtn">활동지원서비스 검색</button>
			                        </div>
			                    </fieldset>
			                </form>
			            </dd>
			        </dl>

			        <!-- 지역 탭 -->
			        <ul class="tab1">
						<%
						    if(areaList != null && areaList.size() > 0){

						       for( int areaLoop = 0; areaLoop < areaList.size(); areaLoop++ ) {
						            Map areaListMap = ( Map ) areaList.get( areaLoop );
						%>
							<li><a href="<%=strLinkPage %>?gu=<%=CommonUtil.nvl(areaListMap.get("GU")) %>&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>"><%=CommonUtil.nvl(areaListMap.get("GU_NM")) %></a></li>
						<% 		}
						    }
						%>
			        </ul>


				</div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>
<script>

$(function(){
	//app 실행
	app.init();
});

var app = {

	init : function() {
		this.btnEvent();
	},

	btnEvent : function() {

		//검색
		$('#searchBtn').on('click', function() {
			var ca1value = $("#ca1 option:selected").val();

			$('#menuno').val(<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>);

			return true;

		});
	}
};
</script>
</body>
</html>