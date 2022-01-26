package egovframework.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.util.Aria;
import egovframework.util.ClientInfo;
import egovframework.util.CommDef;
import egovframework.util.SessionUtil;
import egovframework.util.CommonUtil;
import egovframework.util.SHA256Encode;
import egovframework.util.ScriptUtil;
import egovframework.util.SendMail;
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
public class AdminMemberController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminMemberController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	@SuppressWarnings("unused")
	private final String mTableName = "TB_USER";	// 테이블 명
    @SuppressWarnings("unused")
	private final String BRD_UPLOADPATH = "/upload/user/";

	 /**
     * Method Summary. <br>
     * 회원 목록 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/member/memberList.do" )
    public String memberList(HttpServletRequest servletRequest,
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
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "adminMember.userListCount" )));
            servletRequest.setAttribute( "list",   dbSvc.dbList( reqMap, "adminMember.userList", nRowStartPos ,nPageRow) );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return CommDef.ADM_PATH + "/member/memberList";
    }

    /**
     * Method Summary. <br>
     * 회원정보 쓰기 화면  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */

    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/member/memberWrite.do" )
    public String memberWrite( HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        String strUserId = CommonUtil.nvl(reqMap.get("user_id"));

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            if ( !"".equals(strUserId)){

            	Map detailMap = new HashMap();
            	detailMap = dbSvc.dbDetail(reqMap, "member.userDetail");
            	if ( detailMap != null)
            		reqMap.put("iflag", CommDef.ReservedWord.UPDATE);

            	servletRequest.setAttribute("dbMap", detailMap);
            }

            servletRequest.setAttribute( "reqMap", reqMap);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH + "/member/memberWrite";
    }

	 /**
     * Method Summary. <br>
     * 회원 등록  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/member/memberWork.do" )
    public String memberWork(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");
        String strUrl = "";
        String tel = "";
        String hp = "";
        String email = "";
        String user_nm = "";
        String birthday = "";
        int emailCheck = 0;

        if (sesMap == null ) {
        	strUrl = CommonUtil.nvl(reqMap.get("listpage"), CommDef.ADM_PATH + "/member/memberList.do");
        	strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

        	CommonUtil.alertAdminLoginGoUrl(servletResponse, strUrl);
        	return null;
        }

        try {

        	Aria aria = new Aria(CommDef.MASTER_KEY);

        	tel = CommonUtil.nvl(reqMap.get("tel1")) + "-" + CommonUtil.nvl(reqMap.get("tel2")) + "-" + CommonUtil.nvl(reqMap.get("tel3"));
        	hp = CommonUtil.nvl(reqMap.get("hp1")) + "-" + CommonUtil.nvl(reqMap.get("hp2")) + "-" + CommonUtil.nvl(reqMap.get("hp3"));
        	email = CommonUtil.nvl(reqMap.get("email1")) + "@" + CommonUtil.nvl(reqMap.get("email2"));

        	tel = aria.Encrypt(tel);
        	hp = aria.Encrypt(hp);
        	email = aria.Encrypt(email);
        	birthday = aria.Encrypt(CommonUtil.nvl(reqMap.get("birthday")));
        	user_nm = aria.Encrypt(CommonUtil.nvl(reqMap.get("user_nm")));

    		reqMap.put("tel", tel);
    		reqMap.put("hp", hp);
    		reqMap.put("email", email);
    		reqMap.put("birthday", birthday);
    		reqMap.put("user_nm", user_nm);

    		emailCheck = dbSvc.dbCount(reqMap, "member.userEmailCheck"); //이메일 중복 체크
    		if (emailCheck > 0) {
            	ScriptUtil.alertMsgGoUrl(servletResponse, "중복되는 이메일 주소가 있습니다.", CommonUtil.nvl(reqMap.get("returl")) + "?menu_no=" + CommonUtil.nvl(reqMap.get("menu_no")));
            	return null;
    		}

        	if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.INSERT) || !CommonUtil.nvl(reqMap.get("pwd")).equals("")) {
        		reqMap.put("pwd", SHA256Encode.Encode(CommonUtil.nvl(reqMap.get("pwd"))));  // 비밀번호를 SHA256 로 암호화 해서 저장한다.
        	}

    		if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.INSERT)) {
            	String userIp = ClientInfo.getClntIP(servletRequest); // 접속IP
            	reqMap.put("reg_ip", userIp);
    			dbSvc.dbInsert(reqMap, "member.userInsert");
    		} else {
    			dbSvc.dbUpdate(reqMap, "member.userUpdate");
    		}

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        String strParam = CommonUtil.nvl(reqMap.get( "param" ));
        strUrl = CommonUtil.nvl(reqMap.get("returl")) + "?" + strParam;

        return "redirect:" + strUrl;
    }

	 /**
     * Method Summary. <br>
     * 회원 권한 등록  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/member/memberAuth.do" )
    public String memberAuth(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        Map brdMgrMap = new HashMap();

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	reqMap.put("menu_gb","ADMIN");

            servletRequest.setAttribute( "reqMap", reqMap);

            reqMap.put("sort_ord", " A.top_menu_no, A.menu_lvl, A.ord, A.full_menu_no " );
   		    List rsList = dbSvc.dbList(reqMap, "adminMember.menuList"); // 전체 메뉴 목록 조회
   		    servletRequest.setAttribute("treeMenu", CommonUtil.makeMenuXml(servletRequest, rsList)); // 메뉴 구조 XML 생성

   		    List rsMenuList = dbSvc.dbList(reqMap, "adminMember.menuAuthList"); // 전체 메뉴 목록 조회
   		    servletRequest.setAttribute( "menuList", rsMenuList);

   		    servletRequest.setAttribute( "userMap", dbSvc.dbDetail(reqMap, "member.userDetail"));

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  CommDef.ADM_PATH + "/member/memberAuth";
    }

	 /**
     * Method Summary. <br>
     * 회원 권한 등록 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/member/memberAuthWork.do " )
    public String memberAuthWork(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	dbSvc.dbDelete(reqMap, "adminMember.userMenuDelete");

        	Map paramMap = new HashMap();

        	try {
	        	String[] arrTree= (String[])reqMap.get("tree");

	        	for(int nLoop=0; nLoop < arrTree.length; nLoop++)
	        	{
	        		String strMenuNo = arrTree[nLoop].replace("menu_id_", "");

	        		paramMap.clear();
	        		paramMap.put("user_id", CommonUtil.nvl(reqMap.get("user_id")));
	        		paramMap.put("menu_no", strMenuNo);

	        		dbSvc.dbUpdate(paramMap, "adminMember.userMenuUpdate");
	        	}
        	} catch ( Exception e) {

        		String strTree= (String)reqMap.get("tree");
        		String strMenuNo = strTree.replace("menu_id_", "");

        		paramMap.clear();
        		paramMap.put("user_id", CommonUtil.nvl(reqMap.get("user_id")));
        		paramMap.put("menu_no", strMenuNo);

        		dbSvc.dbUpdate(paramMap, "adminMember.userMenuUpdate");

        	}

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return  null;
    }

	 /**
     * Method Summary. <br>
     * 회원 엑셀 다운로드  처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/member/memberListExcel.do" )
    public String memberListExcel(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        Map brdMgrMap = new HashMap();

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "list",   dbSvc.dbList( reqMap, "adminMember.userList") );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return CommDef.ADM_PATH + "/member/memberListExcel";
    }
    
}
