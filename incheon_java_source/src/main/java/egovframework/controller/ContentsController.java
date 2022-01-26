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

import egovframework.util.CommDef;
import egovframework.util.CommonUtil;
import egovframework.db.DbController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Class Name : ContentsController.java
 * @Description : EgovSample CommonController Class
 * @Modification Information
 * @author 김태균
 * @since 2019.08.10
 * @version 1.0
 * @see
 */

@Controller
public class ContentsController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ContentsController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	 /**
     * Method Summary. <br>
     * 컨텐츠 페이지 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @RequestMapping( value="/contents.do" )
    public String contents(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	contentsDetail(servletRequest,servletResponse);

    	return CommDef.HOME_PATH + "/contents/contents";
    }

    /**
     * Method Summary. <br>
     * Menu Header  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	public void contentsDetail(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

           reqMap.put("use_yn",  "Y" );
           reqMap.put("menu_no", reqMap.get("menuno"));
           CommonUtil.setNullVal(reqMap, "menu_no", "-1"); // 메뉴번호가 없는 경우

           if(reqMap.get("cts_no") != null) {
        	   reqMap.put("use_yn", null);
           }

           List ctsList = dbSvc.dbList( reqMap, "contents.contentsList");

           if ( ctsList == null || ctsList.isEmpty()){ // 메뉴번호에 해당하는 콘텐츠가 존재하지 않은 경우 Child의 첫번째를 찾아냄
        	   Map childMap =  dbSvc.dbDetail(reqMap, "menu.menuFirstChild");

        	   if ( childMap != null ) {
        		   reqMap.put("menu_no",  childMap.get("MENU_NO"));
        		   ctsList = dbSvc.dbList( reqMap, "contents.contentsList");
        	   }
           }

           servletRequest.setAttribute("menuMap", dbSvc.dbDetail(reqMap, "menu.menuPathDetail") );
           servletRequest.setAttribute("ctsList", ctsList);
           servletRequest.setAttribute("reqMap", reqMap );

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }
    }

    /**
     * 이용안내
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @RequestMapping( value="/guide.do" )
    public String guide(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	contentsDetail(servletRequest,servletResponse);

    	return CommDef.HOME_PATH + "/contents/guide";
    }


}
