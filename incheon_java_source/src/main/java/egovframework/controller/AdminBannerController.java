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
import egovframework.util.UploadUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class AdminBannerController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminBannerController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	private final String mTableName = "TB_BANNER";	// 테이블 명
    private final String BRD_UPLOADPATH = "/upload/banner/";

	 /**
     * Method Summary. <br>
     * 관리자 배너관리 리스트 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */

    @SuppressWarnings({ "unused", "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/banner/bannerList.do" )
    public String bannerList(HttpServletRequest servletRequest,
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
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "banner.bannerListCount" ) ) );
            servletRequest.setAttribute( "list",   dbSvc.dbList( reqMap, "banner.bannerList", nRowStartPos ,nPageRow) );

	  	  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

        return CommDef.ADM_PATH + "/banner/bannerList";
    }

    /**
     * Method Summary. <br>
     * 배너관리 등록/수정 화면 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/banner/bannerWrite.do" )
    public String bannerWrite(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

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

                reqMap.put("rel_tbl", mTableName);
                reqMap.put("rel_key", reqMap.get("seq"));

                servletRequest.setAttribute( "lstFile", dbSvc.dbList(reqMap, "common.getUploadFile"));

            	detailMap = dbSvc.dbDetail(reqMap, "banner.bannerDetail");

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

        servletRequest.setAttribute( "lstUseYn",   dbSvc.dbList(paramMap, "code.codeList"));

        servletRequest.setAttribute( "dbMap", detailMap);
        servletRequest.setAttribute( "reqMap", reqMap);

        return  CommDef.ADM_PATH +  "/banner/bannerWrite";
    }

    /**
     * Method Summary. <br>
     * 배너관리 입력&수정 처리 method
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
	@RequestMapping( value= CommDef.ADM_PATH + "/banner/bannerWork.do" )
    public String bannerWork(HttpServletRequest servletRequest, 	HttpServletResponse servletResponse) throws Exception {

    	String seq = "";
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
        	reqMap.put("reg_ip", servletRequest.getRemoteAddr());

            if ( CommDef.ReservedWord.INSERT.equals(strFlag))
            {
            	seq =  Integer.toString(dbSvc.dbInt("banner.bannerNextValue"));
            	reqMap.put("seq", seq);
            	dbSvc.dbInsert(reqMap, "banner.bannerInsert");

            } else if ( CommDef.ReservedWord.UPDATE.equals(strFlag) && !CommonUtil.nvl(reqMap.get("seq")).equals(""))
            {
            	seq = CommonUtil.nvl(reqMap.get("seq"));
            	dbSvc.dbUpdate(reqMap, "banner.bannerUpdate");
            }

            // 파일처리
            reqMap.put("rel_key", seq);
            reqMap.put("thumTip", "Y"); //썸네일 처리
            reqMap.put("thumWidth", 400); //썸네일 가로 사이즈
            reqMap.put("thumHeight", 300); //썸네일 세로 사이즈

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

        strUrl = CommonUtil.nvl(reqMap.get("returl"));
        strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

        return "redirect:" + strUrl;
    }

    /**
     * Method Summary. <br>
     *  배너관리 삭제 처리 method.
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
	@RequestMapping( value= CommDef.ADM_PATH + "/banner/bannerDelete.do" )
    public String bannerDelete(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

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

                UploadUtil upUtil = new UploadUtil(servletRequest);
                upUtil.setDbDao(dbSvc.m_dao); //DB연결자

            	if (CommonUtil.nvl(reqMap.get("mode")).equals("del")) {
            		dbSvc.dbDelete(reqMap, "banner.bannerDelete");

            		Map paramMap = new HashMap();
                	paramMap.put("rel_tbl", mTableName);
                	paramMap.put("rel_key", CommonUtil.nvl(reqMap.get("seq")));
                	upUtil.removeFile(paramMap);

            	} else if (CommonUtil.nvl(reqMap.get("mode")).equals("multidel")) { //다중 삭제일 경우


                	if(servletRequest.getParameterValues("seqno").length > 1){

                		String[] seqNo = (String[])reqMap.get("seqno");

                		for (String seq : seqNo) {
        	        		Map paramMap = new HashMap();
        	        		paramMap.put("seq", seq);

        	        		dbSvc.dbDelete(paramMap, "banner.bannerDelete");

                    		Map paramFileMap = new HashMap();
                    		paramFileMap.put("rel_tbl", mTableName);
                    		paramFileMap.put("rel_key", seq);
                        	upUtil.removeFile(paramFileMap);

                		}
                	} else {
                		reqMap.put("seq", reqMap.get("seqno"));
                		dbSvc.dbDelete(reqMap, "banner.bannerDelete");

                		Map paramMap = new HashMap();
                    	paramMap.put("rel_tbl", mTableName);
                    	paramMap.put("rel_key", CommonUtil.nvl(reqMap.get("seq")));
                    	upUtil.removeFile(paramMap);

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
