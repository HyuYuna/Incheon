package egovframework.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.db.DbController;
import egovframework.util.CommDef;
import egovframework.util.CommonUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class PopupController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PopupController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	@SuppressWarnings("unused")
	private final String mTableName = "TB_POPUP";	// 테이블 명
    @SuppressWarnings("unused")
	private final String BRD_UPLOADPATH = "/upload/popup/";

	 /**
     * Method Summary. <br>
     * 팝업 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value="/popup.do" )
    public String popup(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	try {
	    	Map param = new HashMap();
	    	param.put("search_ymd", CommonUtil.getCurrentDate("","YYYY-MM-DD"));
	    	param.put("menu_gb", reqMap.get("menu_gb"));
	    	List popuplist = dbSvc.dbList(param, "popup.popupOpen");

	    	Device device = DeviceUtils.getCurrentDevice(servletRequest); //접속 디바이스 체크

	        String devicetype = "pc";
	        if (device.isNormal()) {
	        	devicetype = "pc";
	        } else if (device.isMobile()) {
	        	devicetype = "mobile";
	        } else if (device.isTablet()) {
	        	devicetype = "mobile";
	        }

	        reqMap.put("devicetype", devicetype);
	    	servletRequest.setAttribute("reqMap", reqMap);
	    	servletRequest.setAttribute("popuplist", popuplist);
  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

    	return CommDef.APP_PATH + "/popup/popup";
    }


	 /**
     * Method Summary. <br>
     * 윈도우 팝업 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value="/popupwin.do" )
    public String popupwin(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	try {
	    	Map dbMap = dbSvc.dbDetail(reqMap, "popup.popupDetail");

	    	servletRequest.setAttribute("reqMap", reqMap);
	    	servletRequest.setAttribute("dbMap", dbMap);
  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

    	return CommDef.APP_PATH + "/popup/popupwin";
    }

}
