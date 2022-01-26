/**
 * Class Summary. <br>
 * CommDef class.
 * @since 1.00
 * @version 1.00 - 2019. 09. 20
 * @author 김태균
 * @see
 */
package egovframework.util;
import java.util.Calendar;

public class CommDef {
	//--------------------------------------- 도메인 설정 설정 --------------------------------------------------------------------
	public static final String SITE_DOMAIN = "----------"; // SSL 도메인 -> SSL 이용시 필요

	//--------------------------------------- 경로 설정 --------------------------------------------------------------------
	public static final String ADM_PATH = "/webadm";							//관리자 최상위 경로
	public static final String ADM_CONTENTS = "/webContents/webadm";			//관리자  컨텐츠 경로
	public static final String APP_CONTENTS = "/webContents/app";				//app js 컨텐츠 경로

	//--------------------------------------- HOME 경로 설정 --------------------------------------------------------------
	public static final String HOME_CONTENTS = "/webContents/home";				//홈 컨텐츠 경로
	public static final String HOME_PATH = "/home";								//HOME 최상위 경로
	public static final String APP_PATH = "/app";								//APP 최상위 경로
	public static final String CONTENTS_PATH = "/webContents";					//CONTENTS 최상위 경로


	//--------------------------------------- 사이트명 및 기타정보 설정 --------------------------------------------------------
	public static final String MASTER_KEY = "webmaker21";												//Aria 마스터 키
	public static final String CONFIG_COOKIE = "incheon";												//회사명
	public static final String CONFIG_LOGO_IMG = "/webContents/webadm/images/login_tit.jpg";			//관리자 로고 이미지 경로
	public static final String CONFIG_COMPANY = "인천광역시 장애인복지 플랫폼";							//회사명
	public static final String CONFIG_COMPANY_CEO = "";													//대표자
	public static final String CONFIG_COMPANY_EMAIL = "kcore@webmaker21.net";							//대표 이메일
	public static final String CONFIG_COMPANY_NO = "";													//사업자번호
	public static final String CONFIG_ADDR1 = "21554";													//주소1
	public static final String CONFIG_ADDR2 = "인천광역시 남동구 정각로 29(구월동)";					//주소2
	public static final String CONFIG_TEL = "(032)120";													//연락처
	public static final String CONFIG_FAX = "";															//팩스
	public static final String CONFIG_YEAR = "2020";													//카피라이터 년도
	public static final String CONFIG_EMAIL_SERVER = "106.241.17.236";									//이메일서버 아이피
	public static final String CONFIG_IMG_UTL = "https://jangbokmoa.incheon.go.kr";						//이미지서버 주소

	public static final String SEARCH_START_YEAR = 	Integer.toString(Calendar.getInstance().get(Calendar.YEAR) -3);				//검색 시작 년도
	public static final String SEARCH_END_YEAR = 	Integer.toString(Calendar.getInstance().get(Calendar.YEAR) +3);					//검색 종료 년도
	public static final String SEARCH_YEAR = 	Integer.toString(Calendar.getInstance().get(Calendar.YEAR));					//검색 년도

	//--------------------------------------- UPLOAD PATH ----------------------------------------------------------------
	public static final String BRD_UPLOADPATH		= "/upload/board/";		// 게시판 업로드 폴더
	//--------------------------------------------------------------------------------------------------------------------

	//--------------------------------------- Paging ---------------------------------------------------------------------
	public static final int TOP_MENU_LIMIT 					= 7; // 상단 1차메뉴 리미티드 갯수
	public static final int	PAGE_ROWCOUNT					= 10; // 페이지당  표시할 갯수
	public static final int	PAGE_PER_BLOCK					= 10; // 하단 페이지 번호 부여 갯수
	public static final int	PAGE_PHOTOROWCOUNT				=  9; // 하단 페이지 번호 부여 갯수

	public static final int	M_PAGE_ROWCOUNT					= 8; // 모바일 페이지당  표시할 갯수
	public static final int	M_PAGE_PER_BLOCK				= 5; // 모바일 하단 페이지 번호 부여 갯수
	//--------------------------------------------------------------------------------------------------------------------


	public static final String SESREALNAME				       = "REALNAME";

	public static final String TOP_MENU_NO				       = "0";   // 메뉴구조 중 최상위
	public static final String ADMIN_MENU_GB		           = "ADMIN";   // 관리자 메뉴 코드

	public static final String COOKIE_ADMIN_TOP_MENU_NO        = "admin_top_menu_no";
	public static final String COOKIE_ADMIN_SUB_MENU_NO        = "admin_sub_menu_no";
	public static final String COOKIE_ADMIN_CUR_MENU_NO        = "admin_cur_menu_no";

	public static final String MENU_HOME                       = "HOME";  //홈
	public static final String MENU_HOME_ENG                = "HOME_ENG"; //영문 홈
	public static final String MENU_ADMIN                      = "ADMIN";  //관리자메뉴
	public static final String MENU_COMMON                  = "COMMON";  //공통메뉴

	public static final String IMG_VISUAL                 		  = "IMG_VISUAL";  //서브 비주얼 이미지

	/**
	 * iflag 구분자
	 * @author rokihoon
	 */
	public static class ReservedWord {
		public static final String INSERT  = "INSERT";
		public static final String UPDATE  = "UPDATE";
		public static final String DELETE  = "DELETE";
		public static final String REPLY   = "REPLY";
		public static final String EXCEL   = "EXCEL";

		public static final String NOTLOGIN		= "NOTLOGIN";
		public static final String ERROR		= "ERROR";
		public static final String ADMIN		= "ADMIN";
		public static final String USER			= "USER";
		public static final String EXIST		= "EXIST";
		public static final String OVERMAXCNT	= "OVERMAXCNT";
		public static final String SUCCESS		= "SUCCESS";

		public static final String BTN_HIDE     = "HIDE";
		public static final String BTN_SHOW     = "SHOW";
	}

	/**
	 * 컨텐츠관리 게시판 상세보기 없는 값 메세지
	 * @author rokihoon
	 */
	public static class Message	{
		public static final String NO_DATA = "검색된 자료가 없습니다.";
	}
}
