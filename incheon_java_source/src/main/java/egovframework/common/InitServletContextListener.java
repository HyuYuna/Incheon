package egovframework.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpServletRequest;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import egovframework.db.DbController;
import egovframework.util.CommDef;


public class InitServletContextListener implements ServletContextListener{
	
	private static DbController dbSvc = null;
	
	@SuppressWarnings("rawtypes")
	private static List topMenuList = null;
	//private static List ipsiTopMenuList = null;
	
	private ApplicationContext ac;
	@Override
	public void contextDestroyed(ServletContextEvent event) {
		
	}
	
	private void contextFlag(){
		if(ac== null) ac = new ClassPathXmlApplicationContext("classpath*:/egovframework/spring/context-*.xml");
	}
	
	@Override
	public void contextInitialized(ServletContextEvent event) {
		contextFlag();
		dbSvc = (DbController) ac.getBean("dbSvc");
		
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("use_yn", "Y");
    	paramMap.put("menu_gb", CommDef.MENU_HOME);
    	
    	//홈페이지 메뉴 가져오기
    	topMenuList = dbSvc.dbList(paramMap, "menu.menuAllDepthList");

    	//영문 홈페이지 메뉴 가져오기
    	//paramMap.put("menu_gb", CommDef.MENU_IPSI);
    	//ipsiTopMenuList = dbSvc.dbList(paramMap, "menu.menuAllDepthList");
	}
	
	public static void updateTopMenuList(HttpServletRequest request) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("use_yn", "Y");
    	paramMap.put("menu_gb", CommDef.MENU_HOME);
    	
    	// 홈페이지 메뉴 가져오기
    	topMenuList = dbSvc.dbList(paramMap, "menu.menuAllDepthList");

    	//영문 홈페이지 메뉴 가져오기
    	//paramMap.put("menu_gb", CommDef.MENU_HOME_ENG);
    	//ipsiTopMenuList = dbSvc.dbList(paramMap, "menu.menuAllDepthList");
	}
	
	@SuppressWarnings("rawtypes")
	public static List getTopMenuList(HttpServletRequest request) {
		
		if(topMenuList == null) {
			updateTopMenuList(request);
		}
		
		return topMenuList;
	}
	
	//영문홈페이지
/*	public static List getIpsiTopMenuList(HttpServletRequest request) {
		
		if(ipsiTopMenuList == null) {
			updateTopMenuList(request);
		}
		
		return ipsiTopMenuList;
	}*/

}
