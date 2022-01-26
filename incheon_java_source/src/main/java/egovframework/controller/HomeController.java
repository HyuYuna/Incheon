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

import egovframework.util.CommDef;
import egovframework.util.CommonUtil;
import egovframework.db.DbController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Class Name : HomeController.java
 * @Description : EgovSample CommonController Class
 * @Modification Information
 * @author 김태균
 * @since 2019.08.10
 * @version 1.0
 * @see
 */

@Controller
public class HomeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(HomeController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	 /**
     * Method Summary. <br>
     * 메인 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	@RequestMapping( value="/index.do" )
    public String homeIndex(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        //메인 배너 불러오기
        List bannerMain = bannerList("Y", "MAIN", "IMAGE", CommDef.MENU_HOME);
        List bannerMidea = bannerList("Y", "MIDEA", "IMAGE", CommDef.MENU_HOME);
        List bannerBottom = bannerList("Y", "BOTTOM", "IMAGE", CommDef.MENU_HOME);
        servletRequest.setAttribute("bannerMain", bannerMain);
        servletRequest.setAttribute("bannerMidea", bannerMidea);
        servletRequest.setAttribute("bannerBottom", bannerBottom);

        //메인 공지사항 불러오기
		Map boardMap = new HashMap();
		boardMap.put("toppage", 4); //게시글 수
		boardMap.put("brd_mgrno", 24); //게시판 번호
		boardMap.put("order_cd", "BOARD_NUM, BOARD_REPLY");
		List noticeMainList = dbSvc.dbList(boardMap, "board.adminMainBoardList");

        servletRequest.setAttribute("noticeMainList", noticeMainList);

        //메인 자료실 불러오기
		Map boardPdsMap = new HashMap();
		boardPdsMap.put("toppage", 4); //게시글 수
		boardPdsMap.put("brd_mgrno", 45); //게시판 번호
		boardPdsMap.put("order_cd", "BOARD_NUM, BOARD_REPLY");
		List pdsMainList = dbSvc.dbList(boardPdsMap, "board.adminMainBoardList");

        servletRequest.setAttribute("pdsMainList", pdsMainList);

    	return CommDef.HOME_PATH + "/index";
    }


    /**
     * 배너리스트 반환
     * @param servletRequest
     * @param servletResponse
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
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
