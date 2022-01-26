<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, egovframework.common.*" %>
<%
	Map reqMap = (Map) request.getAttribute("reqMap");
	List menuList = InitServletContextListener.getTopMenuList(request);

	String strMenuNo = CommonUtil.nvl(reqMap.get("menuno"));
	String menuTitlePath = "";

	//타이틀 메뉴 얻기
	if(menuList != null && menuList.size() > 0) {
		for(int i=0; i<menuList.size(); i++) {
			Map menuMap = (Map)menuList.get(i);
			String menuNo = CommonUtil.nvl(menuMap.get("MENU_NO"));

			if(strMenuNo.equals(menuNo)) {
				menuTitlePath = CommonUtil.nvl(menuMap.get("MENU_TITLE_PATH"));
				String[] ctsTtls = CommonUtil.nvl(menuMap.get("FULL_CTS_TTL")).split(",");
				int ctsCnt = CommonUtil.getNullInt(menuMap.get("CTS_CNT"), 0);

				//Contents Tab 메뉴 얻기
				if(ctsTtls != null && ctsTtls.length > 1) {
					int tabNo = CommonUtil.getNullInt(reqMap.get("tabno"), 0);
					String ctsNo = CommonUtil.nvl(reqMap.get("cts_no"), "");

					for(int j=0; j<ctsTtls.length; j++) {
						String[] ctsTtl = ctsTtls[j].split(":");

						if(ctsTtl != null && ctsTtl.length > 1) {
							if((tabNo == j && ctsCnt > 1) ||
									(!"".equals(ctsNo) && ctsNo.equals(ctsTtl[0]))) {

								menuTitlePath += " &gt " +ctsTtl[1]; break;
							}
						}
					}
				}
				break;
			}
		}
	}

	//페이지명 읽어오기
	String pageTitle = "";
	String pagename = request.getAttribute("javax.servlet.forward.request_uri").toString();

	if (pagename.equals("/main.do")) {
		pageTitle = "> 메인";
	}
%>

<!DOCTYPE html>
<html class="kor">
<head>
<title><%=CommDef.CONFIG_COMPANY %> <%=menuTitlePath%> <%=pageTitle%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=1400px,user-scalable=yes"/>
<meta name="description" content="인천광역시 소재 장애인복지시설 정보, 장애복지 혜택, 장애인복지 새소식 수록" />
<meta property="og:type" content="website" />
<meta property="og:title" content="인천광역시 장애인복지 플랫폼" />
<meta property="og:description" content="인천광역시 소재 장애인복지시설 정보, 장애복지 혜택, 장애인복지 새소식 수록" />
<meta property="og:image" content="https://jangbokmoa.incheon.go.kr/webContents/home/images/main/logo.jpg" />
<meta property="og:url" content="https://jangbokmoa.incheon.go.kr/" />
<meta name="naver-site-verification" content="4040ba716519d33585e87af3bf2bb5f3b08a1b41">
<link rel="stylesheet" type="text/css" href="<%=CommDef.HOME_CONTENTS %>/css/common.css" />
<link rel="stylesheet" type="text/css" href="<%=CommDef.HOME_CONTENTS %>/css/global.css" />
<script type="text/javascript" src="<%=CommDef.HOME_CONTENTS %>/js/html5.js"></script>
<script type="text/javascript" src="<%=CommDef.HOME_CONTENTS %>/js/jquery.min.js"></script>
<script type="text/javascript" src="<%=CommDef.HOME_CONTENTS %>/js/global.js"></script>
<script type="text/javascript" src="<%=CommDef.HOME_CONTENTS %>/js/java.js"></script>
<!--[if lt IE 10]>
<script type="text/javascript" src="<%=CommDef.HOME_CONTENTS %>/js/placeholder.js"></script>
<![endif]-->
<script type="text/javascript" src="<%=CommDef.APP_CONTENTS %>/js/sb_board.js"></script>
<script type="text/javascript" src="<%=CommDef.APP_CONTENTS %>/js/web.util.js"></script>
</head>
