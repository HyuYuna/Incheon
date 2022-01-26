package egovframework.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.common.InitServletContextListener;
import egovframework.db.DbController;
import egovframework.util.CommDef;
import egovframework.util.CommonUtil;
import egovframework.util.SessionUtil;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 * Class Summary. <br>
 * 컨텐츠 관리 class.
 * @since 1.00
 * @version 1.00
 * @author 김태균
 * @see
 */

@Controller
public class AdminContentsController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminContentsController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	@SuppressWarnings("unused")
	private final String mTableName = "TB_CONTENTS";	// 테이블 명
    @SuppressWarnings("unused")
	private final String BRD_UPLOADPATH = "/upload/contents/";


    /**
     * Method Summary. <br>
     * 이력 목록 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping( value = CommDef.ADM_PATH + "/contents/contentsHistList.do" )
    public String contentsHistList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            servletRequest.setAttribute( "reqMap", reqMap);
   		    servletRequest.setAttribute("histList", dbSvc.dbList(reqMap, "contents.contentsHistList"));


  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return CommDef.ADM_PATH + "/contents/contentsHistList";

    }


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
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value = CommDef.ADM_PATH + "/contents/contentsList.do" )
    public String contentsList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"ADM");

            servletRequest.setAttribute( "reqMap", reqMap);
           // servletRequest.setAttribute( "list",   dbList( reqMap, "contents.contentsList") );

            String strUserType= CommonUtil.nvl(sesMap.get("USER_TYPE"));

            reqMap.put("sort_ord", " A.top_menu_no, A.menu_lvl, A.ord, A.full_menu_no " );
            List rsList;

            if (!"ADMIN".equals(strUserType)) {
            	reqMap.put("cont_user_id", CommonUtil.nvl(sesMap.get("USER_ID")) );

            	rsList = dbSvc.dbList(reqMap, "adminMember.menuContentList"); // 전체 메뉴 목록 조회

            } else {
            	rsList = dbSvc.dbList(reqMap, "adminMember.menuList"); // 전체 메뉴 목록 조회
            }

   		    servletRequest.setAttribute("treeMenu", CommonUtil.makeMenuXml(servletRequest, rsList)); // 메뉴 구조 XML 생성


  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH + "/contents/contentsList";
    }

    /**
	 *  ajax를 통하여 목록을 조회한다.
	 * @param response -  HttpServletResponse
	 * @param request -   HttpServletRequest
	 * @return result -   Jsp 페이지
	 * @exception Exception
	 */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value = CommDef.ADM_PATH + "/contents/contensAjexList.do" )
	public String menuAjexList(HttpServletRequest request , HttpServletResponse response) throws Exception {

    	try {

    		 Map reqMap =  CommonUtil.getRequestMap(request);

    		 CommonUtil.setNullVal(reqMap, "menu_no", "0");  // 상위 코드가 없는 경우 초기값을 세팅함
    		 request.setAttribute("rsList", dbSvc.dbList(reqMap, "contents.contentsList" ));


  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return CommDef.ADM_PATH + "/contents/contentsAjaxListXml";
    }

    /**
     * Method Summary. <br>
     * 콘텐츠 등록/수정 화면 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/contents/contentsWrite.do" )
    public String contentsWrite(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestAdmMap( servletRequest );
        Map detailMap = new HashMap();

        String strRegNo = CommonUtil.nvl(reqMap.get("cts_no"));
        String strIFlag = CommonUtil.nvl(reqMap.get("iflag"));

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            reqMap.put("iflag", CommDef.ReservedWord.INSERT);

            if ( !"".equals(strRegNo)){

            	detailMap = dbSvc.dbDetail(reqMap, "contents.contentsDetail");
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

        return CommDef.ADM_PATH + "/contents/contentsWrite";
    }

    /**
     * Method Summary. <br>
     * 콘텐츠 입력&수정 처리 method
     * @param actionMapping
     * @param form
     * @param servletRequest
     * @param servletResponse
     * @return ActionForward
     * @throws Exception description
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@RequestMapping( value = CommDef.ADM_PATH + "/contents/contentsWork.do" )
    public String contentsWork(HttpServletRequest servletRequest, 	HttpServletResponse servletResponse) throws Exception {

    	String strBrdNo = "";
    	String strUrl = "";

    	Map reqMap = CommonUtil.getRequestAdmMap( servletRequest );

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
        	reqMap.put("reg_id", CommonUtil.nvl(sesMap.get("USER_ID")));
        	reqMap.put("reg_nm", CommonUtil.nvl(sesMap.get("USER_NM")));

            if ( CommDef.ReservedWord.INSERT.equals(strFlag))
            {
            	int nSeqNo = dbSvc.dbInt("contents.contentsNextValue");
            	reqMap.put("cts_no", Integer.toString(nSeqNo));

            	dbSvc.dbInsert(reqMap, "contents.contentsInsert");
                reqMap.put("proc_desc", "INSERT");

            } else if ( CommDef.ReservedWord.UPDATE.equals(strFlag))
            {
            	dbSvc.dbUpdate(reqMap, "contents.contentsUpdate");
            	reqMap.put("proc_desc", "UPDATE");
            }

            dbSvc.dbInsert(reqMap, "contents.contentsHistInsert");

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        //입력 및 수정 시 공통으로 사용하는 topMenuList변수에 업데이트
        InitServletContextListener.updateTopMenuList(servletRequest);

        CommonUtil.alertMsgGoParentFunc(servletResponse, "저장되었습니다.", "fReload()");

        return null;
    }

    /**
	 *  ajax를 통하여 내용을 삭제합니다.
	 * @param response -  HttpServletResponse
	 * @param request -   HttpServletRequest
	 * @return result -   Jsp 페이지
	 * @exception Exception
	 */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value = CommDef.ADM_PATH + "/contents/contensAjexDelete" )
	public String menuAjexDelete(HttpServletRequest request , HttpServletResponse response) throws Exception {
        String strMsg ="SUCCESS";
    	try {

    		 Map reqMap =  CommonUtil.getRequestMap(request);

	         Map sesMap = (Map)SessionUtil.getSessionAttribute(request, "ADM");

	         if (sesMap == null ) {
	        	return null;
	         }

         	 Map detailMap = dbSvc.dbDetail(reqMap, "contents.contentsDetail");

         	dbSvc.dbDelete(reqMap, "contents.contentsDelete" );

         	 if ( detailMap != null) {
        		reqMap.put("ttl",     CommonUtil.nvl(detailMap.get("TTL")));
        		reqMap.put("ctnt",    CommonUtil.nvl(detailMap.get("CTNT")));
        		reqMap.put("use_yn",  CommonUtil.nvl(detailMap.get("USE_YN")));
        		reqMap.put("menu_no", CommonUtil.nvl(detailMap.get("MENU_NO")));
        	 }

   		     reqMap.put("reg_id", CommonUtil.nvl(sesMap.get("USER_ID")));
   		     reqMap.put("reg_nm", CommonUtil.nvl(sesMap.get("USER_NM")));

    		 reqMap.put("proc_desc", "DELETE");
    		 dbSvc.dbInsert(reqMap, "contents.contentsHistInsert");

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
		  strMsg ="FAIL";
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
		  strMsg ="FAIL";
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
		  strMsg ="FAIL";
	  }

    	CommonUtil.displayText(response, strMsg);

        return null;
    }

	 /**
     * Method Summary. <br>
     * 콘텐츠 미리보기  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */

    @SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/contents/contentsPreview.do" )
    public String contentsPreview(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        String strMenuGb = CommonUtil.nvl(reqMap.get("menu_gb"), "home");
        try {

           reqMap.put("use_yn",  "Y" );
           reqMap.put("menu_no", reqMap.get("menuno"));
           CommonUtil.setNullVal(reqMap, "menu_no", "-1"); // 메뉴번호가 없는 경우


           List ctsList = dbSvc.dbList( reqMap, "contents.contentsList");

           if ( ctsList == null || ctsList.isEmpty()){ // 메뉴번호에 해당하는 콘텐츠가 존재하지 않은 경우 Child의 첫번째를 찾아냄
        	   Map childMap =  dbSvc.dbDetail(reqMap, "menu.menuFirstChild");

        	   if ( childMap != null ) {
        		   reqMap.put("menu_no",  childMap.get("MENU_NO") );

        		   ctsList = dbSvc.dbList( reqMap, "contents.contentsList");
        	   }
           }

           servletRequest.setAttribute( "ctsList",   ctsList  );
           servletRequest.setAttribute( "reqMap",        reqMap );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  strMenuGb.toLowerCase() + "/contents/contents";
    }

}
