package egovframework.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.util.*;
import egovframework.db.DbController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Class Name : MenuController.java
 * @Description : EgovSample CommonController Class
 * @Modification Information
 * @author 김태균
 * @since 2019.08.10
 * @version 1.0
 * @see
 */

@Controller
public class MenuController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MenuController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;
	 /**
     * Method Summary. <br>
     * header 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/header.do" )
    public String header(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	servletRequest.setAttribute("reqMap", reqMap);

    	return CommDef.HOME_PATH + "/inc/header";
    }

	 /**
     * Method Summary. <br>
     * footer 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/footer.do" )
    public String footer(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
        //배너 불러오기
        List bannerLink = bannerList("Y", "SITEURL", "TEXTCODE", CommDef.MENU_HOME);
        servletRequest.setAttribute("bannerLink", bannerLink);

    	return CommDef.HOME_PATH + "/inc/footer";
    }

	 /**
     * Method Summary. <br>
     * topmenu 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/topmenu.do" )
    public String topmenu(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {
        	servletRequest.setAttribute("reqMap", reqMap);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

    	return CommDef.HOME_PATH + "/inc/topmenu";
    }

	 /**
     * Method Summary. <br>
     * navigator 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/navigator.do" )
    public String navigator(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        List ctsList = null;

        try {
           reqMap.put("menu_gb", CommDef.MENU_HOME );
           reqMap.put("use_yn",  "Y" );

           if(reqMap.get("cts_no") != null) {
        	   reqMap.put("use_yn", null);
           }

           reqMap.put("menu_no", reqMap.get("menuno"));
           CommonUtil.setNullVal(reqMap, "menu_no", "-1");

           ctsList = dbSvc.dbList( reqMap, "contents.contentsList");

           if ( ctsList == null || ctsList.isEmpty()){ // 메뉴번호에 해당하는 콘텐츠가 존재하지 않은 경우 Child의 첫번째를 찾아냄
        	   Map childMap =  dbSvc.dbDetail(reqMap, "menu.menuFirstChild");

        	   if ( childMap != null ) {  // 새로운 메뉴 번호를 부여한다.
        		   servletRequest.setAttribute("twoDepthMenuInfo", dbSvc.dbDetail(reqMap, "menu.menuDetail"));
        		   reqMap.put("menu_no",  childMap.get("MENU_NO") );
        	 }
           }

    	   reqMap.put("use_yn",  "Y" );
    	   Map  subMainMap  = dbSvc.dbDetail(reqMap, "menu.subMenuInfo"); // 서브메인 정보
    	   if ( subMainMap == null )
    	   subMainMap = new HashMap();

    	   servletRequest.setAttribute( "menuInfo",   dbSvc.dbDetail(reqMap, "menu.menuDetail") ); // 메뉴정보
    	   servletRequest.setAttribute( "subMenuInfo",   subMainMap ); // 서브 메인의 정보

    	   reqMap.put("menu_lvl", "2");
    	   servletRequest.setAttribute( "subMenuList",   dbSvc.dbList( reqMap, "menu.subLeftMenuList") );
    	   //reqMap.put("menu_lvl", "3");
    	   //servletRequest.setAttribute( "threeMenuList",   dbSvc.dbList( reqMap, "menu.subThreeLeftMenuList"));
    	   //servletRequest.setAttribute( "oneDepthMenuList",   dbSvc.dbList( reqMap, "menu.oneDepthLeftMenuList"));
    	   servletRequest.setAttribute( "reqMap",        reqMap );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

    	return CommDef.HOME_PATH + "/inc/navigator";
    }

	 /**
     * Method Summary. <br>
     * subtitle 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/subtitle.do" )
    public String subtitle(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	servletRequest.setAttribute("reqMap", reqMap);

    	return CommDef.HOME_PATH + "/inc/subtitle";
    }

	 /**
     * Method Summary. <br>
     * lnb 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/lnb.do" )
    public String lnb(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	return CommDef.HOME_PATH + "/inc/lnb";
    }

	 /**
     * Method Summary. <br>
     * facilitylnb 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/lnb2.do" )
    public String facilitylnb(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	reqMap.put("menu_gb", CommDef.MENU_HOME );
    	reqMap.put("menu_no", reqMap.get("menuno"));
    	reqMap.put("use_yn",  "Y" );
    	servletRequest.setAttribute( "subMenuList", dbSvc.dbList( reqMap, "menu.subNewLeftMenuList") );
    	servletRequest.setAttribute("menuTitle", dbSvc.dbDetail(reqMap, "menu.menuOneDepthTitle"));
    	servletRequest.setAttribute( "reqMap", reqMap);
    	return CommDef.HOME_PATH + "/inc/lnb2";
    }

	 /**
     * Method Summary. <br>
     * subvisual 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/subvisual.do" )
    public String subvisual(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	try {
    		reqMap.put("file_gbn", CommDef.IMG_VISUAL);
    		reqMap.put("menu_no", reqMap.get("menuno"));
    		Map topMenuDt = dbSvc.dbDetail(reqMap, "menu.topMenuDetail");

    		servletRequest.setAttribute("topMenuDt", topMenuDt);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

    	return CommDef.HOME_PATH + "/inc/subvisual";
    }

	 /**
     * Method Summary. <br>
     * sitemap 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
	@RequestMapping( value= CommDef.HOME_PATH + "/inc/sitemap.do" )
    public String sitemap(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	return CommDef.HOME_PATH + "/inc/sitemap";
    }

    /**
     * 배너리스트 반환
     * @param servletRequest
     * @param servletResponse
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	private List bannerList(String use_yn, String type_cd, String type2_cd, String menu_gb) throws Exception {

    	List bannerList = new ArrayList<>();

        try {

           Map paramMap = new HashMap();
           paramMap.put("use_yn",  use_yn );
           paramMap.put("type_cd", type_cd);
           paramMap.put("type2_cd", type2_cd);
           paramMap.put("menu_gb", menu_gb);

           bannerList = dbSvc.dbList( paramMap, "banner.bannerOpen");

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return bannerList;
    }


}
