package egovframework.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
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
 * 게시판 관리 class.
 * @since 1.00
 * @version 1.00 - 2011. 01. 20
 * @author 정소선
 * @see
 */

@Controller
public class AdminBoardMgrController  {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminBoardMgrController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	@SuppressWarnings("unused")
	private final String mTableName = "TB_BOARDMGR";	// 테이블 명
    @SuppressWarnings("unused")
	private final String BRD_UPLOADPATH = "/upload/board/";

	 /**
     * Method Summary. <br>
     * 게시판 목록 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/boardmgr/boardMgrList.do" )
    public String boardMgrList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	int nPageRow     = dbSvc.getPageRowCount(reqMap, "page_row");
            int nRowStartPos = nPageRow * ( dbSvc.getPageNow(reqMap, "page_now") - 1 );  // Row의 시작위치

            reqMap.put("page_row", nPageRow);                                      // 현재 페이지

            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "boardMgr.boardMgrCount" )) );
            servletRequest.setAttribute( "list",   dbSvc.dbList( reqMap, "boardMgr.boardMgrList", nRowStartPos ,nPageRow) );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH +  "/boardmgr/boardMgrList";

    }

    /**
     * Method Summary. <br>
     * 게시판 등록/수정 화면 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/boardmgr/boardMgrWrite.do" )
    public String boardMgrWrite(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map detailMap = new HashMap();

        String strRegNo = CommonUtil.nvl(reqMap.get("brd_mgrno"));
        String strIFlag = CommonUtil.nvl(reqMap.get("iflag"));

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            reqMap.put("iflag", CommDef.ReservedWord.INSERT);

            if ( !"".equals(strRegNo)){

            	detailMap = dbSvc.dbDetail(reqMap, "boardMgr.boardMgrDetail");
            	if ( detailMap != null)
            		reqMap.put("iflag", CommDef.ReservedWord.UPDATE);
            }
	  	  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

        Map  paramMap = new HashMap();
        paramMap.put("cd_type"    , "USEYN");
        paramMap.put("not_comm_cd", "*");

        servletRequest.setAttribute( "lstUseYn",   dbSvc.dbList(paramMap, "code.codeList") );

        servletRequest.setAttribute( "dbMap", detailMap);
        servletRequest.setAttribute( "reqMap", reqMap);

        return  CommDef.ADM_PATH +  "/boardmgr/boardMgrWrite";
    }


    /**
     * Method Summary. <br>
     * 게시판 입력&수정 처리 method
     * @param actionMapping
     * @param form
     * @param servletRequest
     * @param servletResponse
     * @return ActionForward
     * @throws Exception description
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/boardmgr/boardMgrWork.do" )
    public String boardMgrWork(HttpServletRequest servletRequest, 	HttpServletResponse servletResponse) throws Exception {

    	String strUrl = "";

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");

        if (sesMap == null ) {
        	strUrl = CommonUtil.nvl(reqMap.get("listpage"), "/");
        	strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

        	CommonUtil.alertAdminLoginGoUrl(servletResponse, strUrl);
        	return null;
        }
        try {

        	String strFlag    = CommonUtil.setNullVal(reqMap.get("iflag"), "");
        	reqMap.put("reg_ip", servletRequest.getRemoteAddr());

            if ( CommDef.ReservedWord.INSERT.equals(strFlag))
            {
            	dbSvc.dbInsert(reqMap, "boardMgr.boardMgrInsert");
            } else if (CommDef.ReservedWord.UPDATE.equals(strFlag) && !CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("")) {
            	dbSvc.dbUpdate(reqMap, "boardMgr.boardMgrUpdate");
            }

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        strUrl = CommonUtil.nvl(reqMap.get("returl"));
        strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

        return "redirect:" + strUrl;
    }


    /**
     * Method Summary. <br>
     *  게시판 삭제 처리 method.
     * @param actionMapping 액션맵핑 객체
     * @param actionForm 액션폼 객체
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @RequestMapping( value= CommDef.ADM_PATH + "/boardmgr/boardMgrDelete.do" )
    public String boardMgrDelete(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        String strUrl = CommonUtil.getNullTrans(reqMap.get("returl"), "/");

        try {
            servletRequest.setAttribute("reqMap", reqMap);
            Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");

            if (sesMap == null ) {

            	strUrl = CommonUtil.nvl(reqMap.get("listpage"), "/");
            	strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

            	CommonUtil.alertLoginGoUrl(servletResponse, strUrl);
            	return null;
            } else {
            	dbSvc.dbDelete(reqMap, "boardMgr.boardAllDelete");
            	dbSvc.dbDelete(reqMap, "boardMgr.boardMgrDelete");
            }

            String strParam = CommonUtil.nvl( reqMap.get( "param" ), "" );

            strUrl = CommonUtil.nvl(reqMap.get("returl"));
            strUrl += "?" + strParam;

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return "redirect:" + strUrl;

    }


}
