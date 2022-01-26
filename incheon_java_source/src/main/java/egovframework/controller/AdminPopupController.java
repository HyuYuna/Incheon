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
import egovframework.util.CommonUtil;
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
public class AdminPopupController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminPopupController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	@SuppressWarnings("unused")
	private final String mTableName = "TB_POPUP";	// 테이블 명
    @SuppressWarnings("unused")
	private final String BRD_UPLOADPATH = "/upload/popup/";

	 /**
     * Method Summary. <br>
     * 관리자 팝업관리 리스트 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */

    @SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/popup/popupList.do" )
    public String popupList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	int nPageRow     = dbSvc.getPageRowCount(reqMap, "page_row");
            int nRowStartPos = nPageRow * ( dbSvc.getPageNow(reqMap, "page_now") - 1 );  // Row의 시작위치

            reqMap.put("page_row", nPageRow); // 현재 페이지

            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "popup.popupListCount" ) ) );
            servletRequest.setAttribute( "list",   dbSvc.dbList( reqMap, "popup.popupList", nRowStartPos ,nPageRow) );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return CommDef.ADM_PATH + "/popup/popupList";
    }

    /**
     * Method Summary. <br>
     * 팝업 등록/수정 화면 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/popup/popupWrite.do" )
    public String popupWrite(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map detailMap = new HashMap();

        String seq = CommonUtil.nvl(reqMap.get("seq"));
        String strIFlag = CommonUtil.nvl(reqMap.get("iflag"));

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            reqMap.put("iflag", CommDef.ReservedWord.INSERT);

            if ( !"".equals(seq)){

            	detailMap = dbSvc.dbDetail(reqMap, "popup.popupDetail");
            	if ( detailMap != null)
            		reqMap.put("iflag", CommDef.ReservedWord.UPDATE);
            }
        } catch (Exception e) {
            System.out.println(this.getClass().getName() + ".popupWrite() : "+ e.toString());
        }

        Map  paramMap = new HashMap();
        paramMap.put("cd_type"    , "USEYN");
        paramMap.put("not_comm_cd", "*");

        servletRequest.setAttribute( "lstUseYn",   dbSvc.dbList(paramMap, "code.codeList") );

        servletRequest.setAttribute( "dbMap", detailMap);
        servletRequest.setAttribute( "reqMap", reqMap);

        return  CommDef.ADM_PATH +  "/popup/popupWrite";
    }

    /**
     * Method Summary. <br>
     * 팝업 입력&수정 처리 method
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
	@RequestMapping( value= CommDef.ADM_PATH + "/popup/popupWork.do" )
    public String popupWork(HttpServletRequest servletRequest, 	HttpServletResponse servletResponse) throws Exception {

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
            	dbSvc.dbInsert(reqMap, "popup.popupInsert");

            } else if ( CommDef.ReservedWord.UPDATE.equals(strFlag) && !CommonUtil.nvl(reqMap.get("seq")).equals(""))
            {
            	dbSvc.dbUpdate(reqMap, "popup.popupUpdate");
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
     *  팝업 삭제 처리 method.
     * @param actionMapping 액션맵핑 객체
     * @param actionForm 액션폼 객체
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/popup/popupDelete.do" )
    public String popupDelete(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

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
            	if (CommonUtil.nvl(reqMap.get("mode")).equals("del")) {
            		dbSvc.dbDelete(reqMap, "popup.popupDelete");
            	} else if (CommonUtil.nvl(reqMap.get("mode")).equals("multidel")) { //다중 삭제일 경우

            		if(servletRequest.getParameterValues("seqno").length > 1){
                		String[] seqNo = (String[])reqMap.get("seqno");

                		for (String seq : seqNo) {
        	        		Map paramMap = new HashMap();
        	        		paramMap.put("seq", seq);

        	        		dbSvc.dbDelete(paramMap, "popup.popupDelete");
                		}
                	} else {
                		reqMap.put("seq", reqMap.get("seqno"));
                		dbSvc.dbDelete(reqMap, "popup.popupDelete");
                	}

            	}
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
