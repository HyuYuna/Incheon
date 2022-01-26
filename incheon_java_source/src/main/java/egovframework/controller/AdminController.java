package egovframework.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.util.ClientInfo;
import egovframework.util.CommDef;
import egovframework.util.SessionUtil;
import egovframework.util.CommonUtil;
import egovframework.util.SHA256Encode;
import egovframework.db.DbController;

import egovframework.util.Aria;

import org.apache.commons.lang3.StringUtils;
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
public class AdminController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	 /**
     * Method Summary. <br>
     * 관리자 로그인 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */

	//변수 설정
    @Value("${admin.ip}")
	private String adminIP; //관리자 아이피

    @SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/index.do" )
    public String index(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	boolean check = false;
    	String myIp = servletRequest.getRemoteAddr();

    	//관리자 IP 인지 확인
    	if (StringUtils.isNotEmpty(adminIP)) {

    		String[] adminip = adminIP.split("\\|");
    		for (String ip : adminip) {
    			if (ip.trim().equals(myIp) || ip.trim().equals("all")) {
    				check = true;
    				break;
    			}
    		}

    	} else {
    		check = true;
    	}

    	if (!check) {
    		return (String) CommonUtil.alertMsgGoUrl(servletResponse, "접근 권한이 없습니다.", "/index.do");
    	}

    	return CommDef.ADM_PATH + "/index";
    }

	 /**
     * Method Summary. <br>
     * 관리자 메인 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/main.do" )
    public String main(HttpServletRequest servletRequest,
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

	    	txt_sdate = CommonUtil.getCurrentDate("", "firstWeek");
	    	txt_edate = CommonUtil.getCurrentDate("","YYYY-MM-DD");

	    	param.put("txt_sdate", txt_sdate);
	    	param.put("txt_edate", txt_edate);

	    	List dbList = dbSvc.dbList(param, "statistics.staticsDayList");
	    	int count = dbList.toArray().length;

	    	reqMap.put("listRowCount", count);
	    	reqMap.put("txt_sdate", txt_sdate);
	    	reqMap.put("txt_edate", txt_edate);

	    	//메인 게시판 설정 불러오기
	    	List boardMgrList = dbSvc.dbList("board.adminMainBoardmgr");

	    	if (boardMgrList != null) {
	    		for (int i = 0; i < boardMgrList.size(); i++) {

	    			Map rsMap = ( Map ) boardMgrList.get( i );
	    			Map boardMap = new HashMap();
	    			boardMap.put("toppage", 6);
	    			boardMap.put("brd_mgrno", rsMap.get("BRD_MGRNO"));
	    			boardMap.put("order_cd", rsMap.get("ORDER_CD"));
	    			List boardMainList = dbSvc.dbList(boardMap, "board.adminMainBoardList");

	    			servletRequest.setAttribute("boardMainList" + i, boardMainList);
	    		}
	    	}

	    	servletRequest.setAttribute("dbList", dbList);
	    	servletRequest.setAttribute( "reqMap", reqMap);
	    	servletRequest.setAttribute("boardMgrList", boardMgrList);
  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

    	return CommDef.ADM_PATH + "/main";
    }

	 /**
     * Method Summary. <br>
     * 로그인 처리 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@RequestMapping(value = CommDef.ADM_PATH + "/login.proc.do")
    public String loginproc(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

		String strMenuUrl = CommDef.ADM_PATH + "/menu/menuList.do";


        try {

        	String userIp = ClientInfo.getClntIP(servletRequest); // 접속IP
        	reqMap.put("user_id", reqMap.get("memberid"));
        	reqMap.put("user_pw", SHA256Encode.Encode(CommonUtil.nvl(reqMap.get("passwd")))); //비밀번호를 SHA256으로 암호화 처리

			Map userMap = dbSvc.dbDetail(reqMap, "adminMember.adminLogin");

	        if (userMap != null) {

				Aria aria = new Aria(CommDef.MASTER_KEY); //복호화 시작

				userMap.put("USER_NM", aria.Decrypt(CommonUtil.nvl(userMap.get("USER_NM"))));
				userMap.put("TEL", aria.Decrypt(CommonUtil.nvl(userMap.get("TEL"))));
				userMap.put("HP", aria.Decrypt(CommonUtil.nvl(userMap.get("HP"))));
				userMap.put("EMAIL", aria.Decrypt(CommonUtil.nvl(userMap.get("EMAIL"))));
				userMap.put("BIRTHDAY", aria.Decrypt(CommonUtil.nvl(userMap.get("BIRTHDAY"))));

    			Map menuMap = dbSvc.dbDetail(userMap, "adminMember.userFirstMenu");

    			if (menuMap != null) {

    				String strMenuNo = CommonUtil.nvl(menuMap.get("TOP_MENU_NO"));
    				CommonUtil.setCookieObject(servletResponse, CommDef.COOKIE_ADMIN_TOP_MENU_NO, strMenuNo, 999);

    				strMenuUrl = CommonUtil.getMenuUrl(menuMap);

    				SessionUtil.setSessionAttribute(servletRequest,"ADM",userMap);
    				SessionUtil.setSessionAttribute(servletRequest,"USER",userMap);

    				try {
    					dbSvc.dbUpdate(reqMap, "adminMember.adminVisit");

    				} catch (Exception e) {
    					LOGGER.error(e.getMessage());
    				}

    			} else {
    	        	SessionUtil.removeSessionAttribute(servletRequest,"USER");
    				SessionUtil.removeSessionAttribute(servletRequest,"ADM");
    	        	return (String) CommonUtil.alertMsgGoUrl(servletResponse, "설정된 메뉴가 없습니다. 관리자에게 문의하여 주세요", CommDef.ADM_PATH + "/index.do");
    			}

    			if ( "ADMIN".equals(CommonUtil.nvl(userMap.get("USER_TYPE")))) {
    				//strMenuUrl= "/webadm/member/memberList.do?menu_no=31";
    				strMenuUrl= CommDef.ADM_PATH + "/main.do";
    				CommonUtil.setCookieObject(servletResponse, CommDef.COOKIE_ADMIN_TOP_MENU_NO, "22", 999);
    			}

	        } else {
	        	SessionUtil.removeSessionAttribute(servletRequest,"USER");
				SessionUtil.removeSessionAttribute(servletRequest,"ADM");
	        	return (String) CommonUtil.alertMsgGoUrl(servletResponse, "로그인을 실패했습니다. 다시 로그인해주세요", CommDef.ADM_PATH + "/index.do");
	        }
    		//}
  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        return "redirect:" + strMenuUrl;   // 메뉴관리
    }

	 /**
     * Method Summary. <br>
     * 관리자 header 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value= CommDef.ADM_PATH + "/inc/header.do" )
    public String header(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	return CommDef.ADM_PATH + "/inc/header";
    }

	 /**
     * Method Summary. <br>
     * 관리자 top 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @RequestMapping( value= CommDef.ADM_PATH + "/inc/top.do" )
    public String top(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	return CommDef.ADM_PATH + "/inc/top";
    }

	 /**
     * Method Summary. <br>
     * 관리자 nav 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/inc/nav.do" )
    public String nav(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"ADM");

        reqMap.put("user_id",   userMap.get("USER_ID"));
        reqMap.put("user_type", userMap.get("USER_TYPE"));
        reqMap.put("menu_gb",   CommDef.ADMIN_MENU_GB);

    	List list = dbSvc.dbList(reqMap,"adminMenu.adminLeftmenuList");
    	servletRequest.setAttribute("list", list);
    	servletRequest.setAttribute("reqMap", reqMap);

    	return CommDef.ADM_PATH + "/inc/nav";
    }

	 /**
     * Method Summary. <br>
     * 관리자 foot 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	@RequestMapping( value= CommDef.ADM_PATH + "/inc/foot.do" )
    public String foot(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	return CommDef.ADM_PATH + "/inc/foot";
    }

	 /**
     * Method Summary. <br>
     * 관리자 tit 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value= CommDef.ADM_PATH + "/inc/tit.do" )
    public String tit(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	Map detailMap = dbSvc.dbDetail(reqMap,"adminMenu.adminMenuTitle");

    	servletRequest.setAttribute("detailMap", detailMap);

    	return CommDef.ADM_PATH + "/inc/tit";
    }

	 /**
     * Method Summary. <br>
     * 관리자 search 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/inc/search.do" )
    public String search(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	Map brdMgrMap = new HashMap();
    	String strBrdMgrno = CommonUtil.nvl(reqMap.get("brd_mgrno"));

        if ( !"".equals(strBrdMgrno))
        {
        	 brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail");

             //카테고리를 사용한다면
             if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) {
             	reqMap.put("catecd", brdMgrMap.get("CATE_CD"));
             }
        }

        servletRequest.setAttribute("reqMap", reqMap);

    	return CommDef.ADM_PATH + "/inc/search";
    }

}
