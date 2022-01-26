package egovframework.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.util.CommDef;
import egovframework.util.SessionUtil;
import egovframework.util.UploadUtil;
import egovframework.util.CommonUtil;
import egovframework.common.InitServletContextListener;
import egovframework.db.DbController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Class Name : AdminController.java
 * @Description : AdminController Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2019.07.16           최초생성
 *
 * @author 김태균
 * @since 2019.07.16
 * @version 1.0
 * @see

 */

@Controller
public class AdminMenuController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminMenuController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	private final String mTableName = "TB_MENU";	// 테이블 명
    private final String BRD_UPLOADPATH = "/upload/menu/";

	 /**
     * Method Summary. <br>
     * 관리자 메뉴 리스트 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */

    @SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/menu/menuList.do" )
    public String menuList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        String strPageUrl  = CommDef.ADM_PATH + "/menu/menuList";

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	//int nPageRow     = dbSvc.getPageRowCount(reqMap, "page_row");
        	int nPageRow     = 20;
            int nRowStartPos = nPageRow * ( dbSvc.getPageNow(reqMap, "page_now") - 1 );  // Row의 시작위치

            reqMap.put("page_row", nPageRow);                                      // 현재 페이지

            String strUpMenuNo = CommonUtil.nvl(reqMap.get("up_menu_no"), CommDef.TOP_MENU_NO);
            reqMap.put("up_menu_no", strUpMenuNo);

            //상위메뉴로 올라가기위해 부모 menu_no 가져오기
            if("".equals(CommonUtil.nvl(reqMap.get("parent_menu_no")))) {
            	Map paramMap = new HashMap();
            	paramMap.put("menu_no", CommonUtil.nvl(reqMap.get("up_menu_no")));

                Map mapDt = dbSvc.dbDetail(paramMap, "adminMenu.menuDetail");

                if(mapDt != null) {
                	reqMap.put("parent_menu_no", CommonUtil.nvl(mapDt.get("UP_MENU_NO")));
                }
            }

            CommonUtil.setNullVal(reqMap, "menu_gb", CommDef.ADMIN_MENU_GB);

            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "adminMenu.menuCount" ) ) );
            servletRequest.setAttribute( "list",   dbSvc.dbList( reqMap, "adminMenu.menuList", nRowStartPos ,nPageRow) );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return strPageUrl;
    }

    /**
     * Method Summary. <br>
     * 메뉴 등록/수정 화면 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/menu/menuWrite.do" )
    public String menuWrite(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map detailMap = new HashMap();
        String menu_no = CommonUtil.getNullTrans(reqMap.get("menu_no"));

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            String strRegNo = CommonUtil.getNullTrans(reqMap.get("strregno"));


            reqMap.put("iflag", CommDef.ReservedWord.INSERT);

            if ( !"".equals(strRegNo)){

            	reqMap.put("menu_no", strRegNo);
                reqMap.put("rel_tbl", mTableName);
                reqMap.put("rel_key", strRegNo);

                servletRequest.setAttribute( "lstFile", dbSvc.dbList(reqMap, "common.getUploadFile"));

            	detailMap = dbSvc.dbDetail(reqMap, "adminMenu.menuDetail");
            	if ( detailMap != null)
            		reqMap.put("iflag", CommDef.ReservedWord.UPDATE);

            }

            Map mapParam = new HashMap();
            mapParam.put("sort_ord", "brd_nm");

            servletRequest.setAttribute( "mrgList",   dbSvc.dbList( mapParam, "boardMgr.boardMgrList") );
            servletRequest.setAttribute( "userList",   dbSvc.dbList( mapParam, "adminMember.userSelBoxList") );


  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        reqMap.put("menu_no", menu_no);
        servletRequest.setAttribute( "dbMap", detailMap);
        servletRequest.setAttribute( "reqMap", reqMap);

        return CommDef.ADM_PATH + "/menu/menuWrite";
    }

    /**
     * Method Summary. <br>
     * Menu 입력&수정 처리 method
     * @param actionMapping
     * @param form
     * @param servletRequest
     * @param servletResponse
     * @return ActionForward
     * @throws Exception description
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/menu/menuWork.do" )
    public String menuWork(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	String strMenuNo = "";
    	String strUrl = "";

        Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");

        if (sesMap == null ) {
        	strUrl = CommonUtil.nvl(reqMap.get("listpage"), CommDef.ADM_PATH + "/menu/menuList.do");
        	strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

        	CommonUtil.alertAdminLoginGoUrl(servletResponse, strUrl);
        	return null;
        }
        try {

        	//파일첨부영역
        	UploadUtil uploadUtil = new UploadUtil(servletRequest, BRD_UPLOADPATH );
        	uploadUtil.setDbDao(dbSvc.m_dao); //DB연결자
            String strContentType =  CommonUtil.getNullTrans(servletRequest.getHeader("Content-Type"));
            boolean isFileUp = (strContentType.indexOf("multipart/form-data") > -1) ? true :false;  // 첨부파일이 존재하는지 확인

            reqMap = ( isFileUp ) ? uploadUtil.getRequestMap(servletRequest):CommonUtil.getRequestMap( servletRequest );

            String strFileOverSize = CommonUtil.nvl(reqMap.get("FILE_OVER_SIZE"));

            if ( !"".equals(strFileOverSize)) {
            	CommonUtil.alertMsgBack(servletResponse, strFileOverSize) ;
            	return null;
            }

            reqMap.put("rel_tbl", mTableName);
            //파일첨부영역

        	String strFlag    = CommonUtil.setNullVal(reqMap.get("iflag"), "");

            if ( CommDef.ReservedWord.INSERT.equals(strFlag))
            {
            	strMenuNo = Long.toString(dbSvc.dbLong("adminMenu.menuNextValue"));
            	fillInsertMap(reqMap, strMenuNo);
            	reqMap.put("menu_no", strMenuNo);
        	    dbSvc.dbInsert(reqMap, "adminMenu.menuInsert");

            } else if ( CommDef.ReservedWord.UPDATE.equals(strFlag))
            {
            	strMenuNo = CommonUtil.getNullTrans(reqMap.get("strregno"));
            	reqMap.put("menu_no", strMenuNo);
            	dbSvc.dbUpdate(reqMap, "adminMenu.menuUpdate");
            }

            // 파일처리
            reqMap.put("rel_key", strMenuNo);
            reqMap.put("thumTip", "Y"); //썸네일 처리
            reqMap.put("thumWidth", 600); //썸네일 가로 사이즈
            reqMap.put("thumHeight", 500); //썸네일 세로 사이즈

            if ( isFileUp )
            	uploadUtil.uploadProcess(reqMap, servletRequest);
            // 파일처리

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        //입력 및 수정 시 공통으로 사용하는 topMenuList변수에 업데이트
        InitServletContextListener.updateTopMenuList(servletRequest);

        String strParam = CommonUtil.nvl(reqMap.get( "param" ));

        strParam = CommonUtil.removeParam(strParam, "parent_menu_no");
        strParam = CommonUtil.removeParam(strParam, "up_menu_no");
        strParam = CommonUtil.removeParam(strParam, "menu_gb");

        strParam += "&up_menu_no="     + CommonUtil.nvl(reqMap.get("up_menu_no"));
        strParam += "&parent_menu_no=" + CommonUtil.nvl(reqMap.get("parent_menu_no"));
        strParam += "&menu_gb="        + CommonUtil.nvl(reqMap.get("menu_gb"), CommDef.ADMIN_MENU_GB);

        strUrl = CommonUtil.nvl(reqMap.get("returl")) + "?" + strParam;

        return "redirect:" + strUrl;

    }

    /**
     * Method Summary. <br>
     *  메뉴 삭제 처리 method.
     * @param actionMapping 액션맵핑 객체
     * @param actionForm 액션폼 객체
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/menu/menuDelete.do" )
    public String menuDelete(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        String strUrl = CommonUtil.getNullTrans(reqMap.get("returl"), "/");

        try {
            servletRequest.setAttribute("reqMap", reqMap);
            Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");
            String strBrdNo = CommonUtil.getNullTrans(reqMap.get("strregno"));

            reqMap.put("menu_no", strBrdNo);

            if (sesMap == null ) {
            	strUrl = CommonUtil.nvl(reqMap.get("listpage"), CommDef.ADM_PATH + "/menu/menuList.do");
            	strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

            	CommonUtil.alertAdminLoginGoUrl(servletResponse, strUrl);
            	return null;
            }

           int nExists = dbSvc.dbCount( reqMap, "adminMenu.menuDownCount");
           if ( nExists > 0 )
           {
        	   CommonUtil.alertMsgBack(servletResponse, "하위 메뉴가 존재합니다. 하위메뉴를 먼저 삭제하여 주십시오");
        	   return "";
           }


            String[] arrBrdNo = strBrdNo.split(",");

            for(int nLoop=0; nLoop < arrBrdNo.length; nLoop++)
            {
            	Map paramMap = new HashMap();
            	paramMap.put("menu_no", arrBrdNo[nLoop]);
            	dbSvc.dbDelete(paramMap, "adminMenu.menuDelete");
            }

            //삭제 시 공통으로 사용하는 topMenuList변수에 업데이트
            InitServletContextListener.updateTopMenuList(servletRequest);

            String strParam = CommonUtil.nvl(reqMap.get( "param" ));

            strParam = CommonUtil.removeParam(strParam, "parent_menu_no");
            strParam = CommonUtil.removeParam(strParam, "up_menu_no");
            strParam += "&up_menu_no=" + CommonUtil.nvl(reqMap.get("up_menu_no"));
            strParam += "&parent_menu_no=" + CommonUtil.nvl(reqMap.get("parent_menu_no"));

            strUrl = CommonUtil.nvl(reqMap.get("returl")) + "?" + strParam;

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return "redirect:" + strUrl;

    }

    /**
     * Method Summary. <br>
     * 관리자 게시판 입력 파리미터 처리 method
     * @param reqMap 파라미터
     * @param strFlag 처리 flag
     * @param strNextVal
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	private void fillInsertMap(Map reqMap, String strNextVal)
    {
    	int    nDepth      = 1;
    	String strAllBrdNo = "";
    	String strTopMenuNo= "";

    	reqMap.put("menu_no", strNextVal);

    	String strUpMenuNo = CommonUtil.nvl(reqMap.get("up_menu_no"), CommDef.TOP_MENU_NO);

		Map paramMap = new HashMap();
		paramMap.put("menu_no", reqMap.get("up_menu_no"));
		Map viewMap  = dbSvc.dbDetail(paramMap, "adminMenu.menuDetail");

		if ( viewMap != null ) {
		   nDepth       = Integer.parseInt(CommonUtil.nvl(viewMap.get("MENU_LVL"), "0")) + 1;
		   strAllBrdNo  = CommonUtil.nvl(viewMap.get("FULL_MENU_NO")) + strNextVal + ",";
		   strTopMenuNo = CommonUtil.nvl(viewMap.get("TOP_MENU_NO"));
		} else {
			strAllBrdNo = strNextVal + ",";
			strTopMenuNo= strNextVal;
		}

		reqMap.put("menu_lvl",     nDepth);
		reqMap.put("full_menu_no", strAllBrdNo);
		reqMap.put("top_menu_no",  strTopMenuNo);
		reqMap.put("up_menu_no",   strUpMenuNo);

    }

}
