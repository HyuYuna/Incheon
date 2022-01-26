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
 * Code 관리 class.
 * @since 1.00
 * @version
 * @author
 * @see
 */

@Controller
public class AdminCodeController   {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminCodeController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	 /**
     * Method Summary. <br>
     * 코드 목록 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/code/codeList.do" )
    public String codeList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        String strPageUrl  = CommDef.ADM_PATH +  "/code/codeList";

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	String strCdType = CommonUtil.nvl(reqMap.get("cd_type"));
        	String strCommCd = CommonUtil.nvl(reqMap.get("comm_cd"));

        	if ( "".equals(strCdType)) {
        		reqMap.put("comm_cd", "*");
        		reqMap.put("ord", "ord");
        	} else {
        		reqMap.remove("comm_cd");
        		reqMap.put("not_comm_cd", "*");
        	}

            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "code.codeCount" ) ) );
            servletRequest.setAttribute( "list",   dbSvc.dbList( reqMap, "code.codeList") );

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
     * 코드 등록/수정 화면 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/code/codeWrite.do" )
    public String codeWrite(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map detailMap = new HashMap();

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            String strCdType = CommonUtil.getNullTrans(reqMap.get("cd_type"));

            reqMap.put("iflag", CommDef.ReservedWord.INSERT);

            if ( !"".equals(strCdType)){

            	detailMap = dbSvc.dbDetail(reqMap, "code.codeDetail");
            	if ( detailMap != null)
            		reqMap.put("iflag", CommDef.ReservedWord.UPDATE);

             	servletRequest.setAttribute( "reqMap", reqMap);
            }
	  	  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

        servletRequest.setAttribute( "dbMap", detailMap);
        servletRequest.setAttribute( "reqMap", reqMap);

        return  CommDef.ADM_PATH +  "/code/codeWrite";
    }


    /**
     * Method Summary. <br>
     * 코드 입력&수정 처리 method
     * @param actionMapping
     * @param form
     * @param servletRequest
     * @param servletResponse
     * @return ActionForward
     * @throws Exception description
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/code/codeWork.do" )
    public String codeWork(HttpServletRequest servletRequest, 	HttpServletResponse servletResponse) throws Exception {

    	String strUrl = "";
    	String msg = "";

    	Map reqMap  = CommonUtil.getRequestMap( servletRequest );
        Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");

        if (sesMap == null ) {
        	CommonUtil.alertAdminLoginGoUrl(servletResponse, "/");
        	return null;
        }
        try {
        	String strFlag    = CommonUtil.nvl(reqMap.get("iflag"));

            if ( CommDef.ReservedWord.INSERT.equals(strFlag))
            {
            	dbSvc.dbInsert(reqMap, "code.codeInsert");
            	msg = "저장하였습니다.";
            } else if ( CommDef.ReservedWord.UPDATE.equals(strFlag)) {
            	dbSvc.dbUpdate(reqMap, "code.codeUpdate");
            	msg = "수정하였습니다.";
            } else if ( CommDef.ReservedWord.DELETE.equals(strFlag)) {

            	String strCommCd = CommonUtil.nvl(reqMap.get("comm_cd"));
            	if ( "*".equals(strCommCd)) {
            		reqMap.remove("comm_cd");
            	}

            	dbSvc.dbDelete(reqMap, "code.removeCode");
            	msg = "삭제하였습니다.";
            }

	  	  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

        CommonUtil.alertMsgOpenSelfClose(servletResponse, msg);

        return  null;
    }


}
