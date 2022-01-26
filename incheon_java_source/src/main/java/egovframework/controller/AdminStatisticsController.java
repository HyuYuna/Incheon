package egovframework.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.db.DbController;
import egovframework.util.CommDef;
import egovframework.util.CommonUtil;
import egovframework.util.SessionUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Class Summary. <br>
 * 관리자 게시판 class.
 * @since 1.00
 * @version 1.00 - 2019. 07. 28
 * @author 김태균
 * @see
 */

@Controller
public class AdminStatisticsController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminStatisticsController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	 /**
     * Method Summary. <br>
     * 접속로그 저장 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= "/statistics/logSave.do" )
    public String logSave(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {
	        //쿠키 확인
	       	Cookie[] cookies = servletRequest.getCookies();
	        Integer logSaveCount = 0;

	        if (cookies != null) {
	        	for (Cookie cookie:cookies) {
	        		if (cookie.getName().equals("JSESSIONID"))
	        			logSaveCount = 1;
	        	}
        	}

        	if(logSaveCount == 0){
            	String log_userId = ""; //회원 아이디
            	String log_userName = ""; //회원 이름

	        	String referer = CommonUtil.nvl((String)servletRequest.getHeader("REFERER"), "");

	        	Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER"); //회원 세션정보
	        	if (sesMap != null) {
	        		log_userId = CommonUtil.nvl(sesMap.get("user_id"));
	        		log_userName = CommonUtil.nvl(sesMap.get("user_nm"));
	        	}


	        	String lang = CommonUtil.getNullTrans(reqMap.get("lang"), "kr");

	        	reqMap.put("join_id", log_userId); //접속자 아이디
	        	reqMap.put("join_name", log_userName); //접속자 이름
	        	reqMap.put("join_route", referer); //접속 경로
	        	reqMap.put("join_ip", servletRequest.getRemoteAddr()); //접속 아이피
	        	reqMap.put("join_browser", CommonUtil.getBrowser(servletRequest)); //접속 브라우저
	        	reqMap.put("join_os", CommonUtil.getOs(servletRequest)); //접속 OS
	        	reqMap.put("join_agent", servletRequest.getHeader("User-Agent"));
	        	reqMap.put("join_page", servletRequest.getAttribute("javax.servlet.forward.request_uri")); //접속 페이지명
	        	reqMap.put("join_lang", lang); //접속 언어

	        	dbSvc.dbInsert(reqMap, "statistics.statisticsInsert");

	        	//쿠키 저장
	        	CommonUtil.setCookieObject(servletResponse, "logsave", "logsave", 60);
        	}


  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return null;
    }

	 /**
     * Method Summary. <br>
     * 관리자 검색폼 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/statistics/search.form.do" )
    public String searchform(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	servletRequest.setAttribute( "reqMap", reqMap);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/statistics/search.form";

    }

	 /**
     * Method Summary. <br>
     * 관리자 공통 통계 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/statistics/statics.do" )
    public String statics(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	Map param = new HashMap();
        	param.put("search_ym", CommonUtil.getCurrentDate("","YYYY-MM"));
        	param.put("search_ymd", CommonUtil.getCurrentDate("","YYYY-MM-DD"));
        	Map dbMap = dbSvc.dbDetail(param, "statistics.commonStaticsCount");

        	servletRequest.setAttribute( "reqMap", reqMap);
        	servletRequest.setAttribute("dbMap", dbMap);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/statistics/statics";

    }

	 /**
     * Method Summary. <br>
     * 관리자 시간별 통계 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/statistics/time.list.do" )
    public String timelist(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	Map param = new HashMap();
        	String txt_sdate = "";

        	if (CommonUtil.nvl(reqMap.get("txt_sdate")).equals("")) {
        		txt_sdate = CommonUtil.getCurrentDate("","YYYY-MM-DD");
        	} else {
        		txt_sdate = CommonUtil.nvl(reqMap.get("txt_sdate"));
        	}

        	param.put("txt_sdate", txt_sdate);

        	List dbList = dbSvc.dbList(param, "statistics.staticsTimeList");
        	int count = dbList.toArray().length;

        	reqMap.put("listRowCount", count);
        	reqMap.put("txt_sdate", txt_sdate);
        	servletRequest.setAttribute("dbList", dbList);
        	servletRequest.setAttribute( "reqMap", reqMap);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/statistics/time.list";

    }

	 /**
     * Method Summary. <br>
     * 관리자 날짜별 통계 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/statistics/day.list.do")
    public String daylist(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	Map param = new HashMap();
        	String txt_sdate = "";
        	String txt_edate = "";

        	if (CommonUtil.nvl(reqMap.get("txt_sdate")).equals("")) {
        		txt_sdate = CommonUtil.getCurrentDate("","YYYY-MM-DD");
        	} else {
        		txt_sdate = CommonUtil.nvl(reqMap.get("txt_sdate"));
        	}

        	if (CommonUtil.nvl(reqMap.get("txt_edate")).equals("")) {
        		txt_edate = CommonUtil.getCurrentDate("","YYYY-MM-DD");
        	} else {
        		txt_edate = CommonUtil.nvl(reqMap.get("txt_edate"));
        	}

        	param.put("txt_sdate", txt_sdate);
        	param.put("txt_edate", txt_edate);

        	List dbList = dbSvc.dbList(param, "statistics.staticsDayList");
        	int count = dbList.toArray().length;

        	reqMap.put("listRowCount", count);
        	reqMap.put("txt_sdate", txt_sdate);
        	reqMap.put("txt_edate", txt_edate);

        	servletRequest.setAttribute("dbList", dbList);
        	servletRequest.setAttribute( "reqMap", reqMap);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/statistics/day.list";

    }

	 /**
     * Method Summary. <br>
     * 관리자 월별 통계 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "rawtypes", "unused", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/statistics/month.list.do")
    public String monthlist(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	Map param = new HashMap();
        	String searchyeartext = "";

        	if (CommonUtil.nvl(reqMap.get("searchyeartext")).equals("")) {
        		searchyeartext = CommDef.SEARCH_YEAR;
        	} else {
        		searchyeartext = CommonUtil.nvl(reqMap.get("searchyeartext"));
        	}

        	param.put("searchyeartext", searchyeartext);

        	List dbList = dbSvc.dbList(param, "statistics.staticsMonthList");
        	int count = dbList.toArray().length;

        	reqMap.put("listRowCount", count);
        	reqMap.put("searchyeartext", searchyeartext);

        	servletRequest.setAttribute("dbList", dbList);
        	servletRequest.setAttribute( "reqMap", reqMap);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/statistics/month.list";

    }

	 /**
     * Method Summary. <br>
     * 관리자 년별 통계 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/statistics/year.list.do")
    public String yearlist(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	Map param = new HashMap();

        	List dbList = dbSvc.dbList("statistics.staticsYearList");
        	int count = dbList.toArray().length;

        	reqMap.put("listRowCount", count);

        	servletRequest.setAttribute("dbList", dbList);
        	servletRequest.setAttribute( "reqMap", reqMap);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/statistics/year.list";

    }

	 /**
     * Method Summary. <br>
     * 관리자 접속로그 리스트 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/statistics/referrer.list.do")
    public String referrerlist(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	int nPageRow     = CommonUtil.getNullInt(reqMap.get("page_row"), 0);
        	if(nPageRow == 0) nPageRow = 20;
            int nRowStartPos = nPageRow * ( dbSvc.getPageNow(reqMap, "page_now") - 1 );  // Row의 시작위치

            reqMap.put("page_row", nPageRow);  // 현재 페이지

        	servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "statistics.referrerListCount" ) ) );
            servletRequest.setAttribute( "list",   dbSvc.dbPagingList( reqMap, "statistics.referrerList", nRowStartPos ,nPageRow) );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/statistics/referrer.list";

    }

	 /**
     * Method Summary. <br>
     * 관리자 접속로그 엑셀 리스트 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/statistics/referrer.list.Excel.do")
    public String referrerlistExcel(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "list", dbSvc.dbList( reqMap, "statistics.referrerExcelList"));

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/statistics/referrer.list.Excel";

    }

}
