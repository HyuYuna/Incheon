package egovframework.controller;

import java.io.IOException;
import java.io.PrintWriter;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import egovframework.db.DbController;
import egovframework.util.CommDef;
import egovframework.util.CommonUtil;
import egovframework.util.SHA256Encode;
import egovframework.util.ScriptUtil;
import egovframework.util.SessionUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class FacilityController {

	private static final Logger LOGGER = LoggerFactory.getLogger(FacilityController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	/**
	 * 복지시설 메인 페이지
	 * @param servletRequest
	 * @param servletResponse
	 * @return
	 * @throws Exception
	 */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value="/facility.do" )
    public String facility(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	List areaList = new ArrayList<>();

    	//지역 카테고리 리스트
    	areaList = dbSvc.dbList(reqMap, "facility.areaList");

    	servletRequest.setAttribute( "areaList", areaList);
    	servletRequest.setAttribute( "reqMap", reqMap);

    	return  CommDef.APP_PATH +  "/facility/facility";
    }

    /**
     * 복지시설 카테고리 검색 JSON
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
	@ResponseBody
    @RequestMapping( value="/category1json.do", method = RequestMethod.POST)
    public String facilityArea(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	List ca1List = new ArrayList<>();
    	String jsonList = "";

    	//전체지역 검색
    	if (CommonUtil.nvl(reqMap.get("gu"), "").equals("")) {
	    	//1차 카테고리
	    	ca1List = dbSvc.dbList(reqMap, "facility.ca1List");

    	} else { //지역검색

	    	//1차 카테고리
	    	ca1List = dbSvc.dbList(reqMap, "facility.ca1AreaList");
    	}

    	Gson gsonObj = new Gson();
    	jsonList = gsonObj.toJson(ca1List);


    	return jsonList;
    }

    /**
     * 복지시설 카테고리 UL 리스트 검색 JSON
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unused" })
	@ResponseBody
    @RequestMapping( value="/category1uljson.do", method = RequestMethod.POST)
    public String category1uljson(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	List ca1List = new ArrayList<>();
    	List ca2List = new ArrayList<>();
    	String jsonList = "";

    	//전체지역 검색
    	if (CommonUtil.nvl(reqMap.get("gu"), "").equals("")) {
	    	//1차 카테고리
	    	ca1List = dbSvc.dbList(reqMap, "facility.ca1List");

	    	//1차 카테고리가 있다면 2차 카테고리 출력
	    	if (!CommonUtil.nvl(reqMap.get("ca1"), "").equals("")) {
	    		ca2List = dbSvc.dbList(reqMap, "facility.ca2List");
	    	}
    	} else { //지역검색

	    	//1차 카테고리
	    	ca1List = dbSvc.dbList(reqMap, "facility.ca1AreaList");

	    	//1차 카테고리가 있다면 2차 카테고리 출력
	    	if (!CommonUtil.nvl(reqMap.get("ca1"), "").equals("")) {
	    		ca2List = dbSvc.dbList(reqMap, "facility.ca2AreaList");
	    	}
    	}

    	Gson gsonObj = new Gson();
    	jsonList = gsonObj.toJson(ca1List);

    	return jsonList;
    }

    /**
     * 복지시설 카테고리 검색
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value="/facilityList.do" )
    public String facilityList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	List ca1List = new ArrayList<>();
    	List ca2List = new ArrayList<>();
    	List areaList = new ArrayList<>();
    	List facilityList = new ArrayList<>();

    	//전체지역 검색
    	if (CommonUtil.nvl(reqMap.get("gu"), "").equals("")) {
	    	//1차 카테고리
	    	ca1List = dbSvc.dbList(reqMap, "facility.ca1List");

	    	if (ca1List != null) {
	    		for (int i = 0; i < ca1List.size(); i++) {
	    			
	    			Map rsMap = ( Map ) ca1List.get( i );
	    			if (!CommonUtil.nvl(rsMap.get("CA1")).equals("")) {
		    			Map catedMap = new HashMap();
		    			catedMap.put("ca1", rsMap.get("CA1"));
		    			List cate2List = dbSvc.dbList(catedMap, "facility.ca2List");
		    			
		    			servletRequest.setAttribute("cate2List" + i, cate2List);
	    			}
	    			
	    		}
	    	}

	    	//1차 카테고리가 있다면 2차 카테고리 출력
	    	if (!CommonUtil.nvl(reqMap.get("ca1"), "").equals("")) {
	    		ca2List = dbSvc.dbList(reqMap, "facility.ca2List");
	    	}

    	} else { //지역검색

	    	//1차 카테고리
	    	ca1List = dbSvc.dbList(reqMap, "facility.ca1AreaList");

	    	if (ca1List != null) {
	    		for (int i = 0; i < ca1List.size(); i++) {

	    			Map rsMap = ( Map ) ca1List.get( i );
	    			if (!CommonUtil.nvl(rsMap.get("CA1")).equals("")) {
		    			Map catedMap = new HashMap();
		    			catedMap.put("ca1", rsMap.get("CA1"));
		    			catedMap.put("gu", reqMap.get("gu"));
		    			List cate2List = dbSvc.dbList(catedMap, "facility.ca2AreaList");
	
		    			servletRequest.setAttribute("cate2List" + i, cate2List);
	    			}
	    		}
	    	}

	    	//1차 카테고리가 있다면 2차 카테고리 출력
	    	if (!CommonUtil.nvl(reqMap.get("ca1"), "").equals("")) {
	    		ca2List = dbSvc.dbList(reqMap, "facility.ca2AreaList");
	    	}
    	}

    	//지역 카테고리 리스트
    	areaList = dbSvc.dbList(reqMap, "facility.areaList");

    	//리스트 시작
    	int per_page = 5; 	   //기본 페이지 레코딩수
    	int page_now = 1;	   //시작 페이징

    	if (!CommonUtil.nvl(reqMap.get("page_now"), "").equals("")) {
    		page_now = Integer.parseInt(reqMap.get("page_now").toString());
    	}

    	reqMap.put("per_page", per_page);
    	reqMap.put("page_now", page_now);
    	facilityList = dbSvc.dbList(reqMap, "facility.facilityList");


        servletRequest.setAttribute( "reqMap", reqMap);
        servletRequest.setAttribute( "ca1List", ca1List);
        servletRequest.setAttribute( "ca2List", ca2List);
        servletRequest.setAttribute( "areaList", areaList);
        servletRequest.setAttribute( "count",  Integer.toString(dbSvc.dbCount( reqMap, "facility.facilityListCount" )));
        servletRequest.setAttribute( "facilityList", facilityList);

    	return  CommDef.APP_PATH +  "/facility/facilityList";
    }

    /**
     * 시설 팝업
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value="/sisul.do" )
    public String sisul(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	Map facilityDetail = dbSvc.dbDetail(reqMap, "facility.facilityDetail");
    	List facilityPicList = dbSvc.dbList(reqMap, "facility.facilityPicList");


    	servletRequest.setAttribute( "facilityDetail", facilityDetail);
    	servletRequest.setAttribute("facilityPicList", facilityPicList);
    	servletRequest.setAttribute( "reqMap", reqMap);

    	return  CommDef.APP_PATH +  "/facility/sisul";
    }

    /**
     * 활동지원 서비스 시설 팝업
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value="/supportSisul.do" )
    public String supportSisul(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	Map facilityDetail = dbSvc.dbDetail(reqMap, "facility.facilityDetail");
    	List facilityPicList = dbSvc.dbList(reqMap, "facility.facilityPicList");


    	servletRequest.setAttribute( "facilityDetail", facilityDetail);
    	servletRequest.setAttribute("facilityPicList", facilityPicList);
    	servletRequest.setAttribute( "reqMap", reqMap);

    	return  CommDef.APP_PATH +  "/support/supportSisul";
    }

	/**
	 * 시설 예약 리스트
	 * @param servletRequest
	 * @param servletResponse
	 * @return
	 * @throws Exception
	 */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value="/regList.do" )
    public String regList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	//리스트 시작
    	int per_page = 10; 	   //기본 페이지 레코딩수
    	int page_now = 1;	   //시작 페이징

    	if (!CommonUtil.nvl(reqMap.get("page_now"), "").equals("")) {
    		page_now = Integer.parseInt(reqMap.get("page_now").toString());
    	}

    	reqMap.put("per_page", per_page);
    	reqMap.put("page_now", page_now);
    	List regList = dbSvc.dbList(reqMap, "facility.regList");

    	servletRequest.setAttribute( "reqMap", reqMap);
    	servletRequest.setAttribute( "regList", regList);
    	servletRequest.setAttribute( "count",  Integer.toString(dbSvc.dbCount( reqMap, "facility.regListCount" )));

    	return  CommDef.APP_PATH +  "/facility/regList";
    }

	/**
	 * 시설 예약 뷰
	 * @param servletRequest
	 * @param servletResponse
	 * @return
	 * @throws Exception
	 */
    @SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@RequestMapping( value="/regView.do" )
    public String regView(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");

        int userLevel = 1; //기본 레벨
        String userid = "guest"; //기본 아이디
        String viewpass = "N"; //비밀글 열람시 설정값

        if (userMap != null) {
        	userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
        	userid = CommonUtil.nvl(userMap.get("USER_ID"));
        }

    	if (userLevel < 10) { //관리자가 아닐 경우 검증시작

        	if (!CommonUtil.nvl(reqMap.get("req_pwd")).equals("")) {

			    int checkCount = dbSvc.dbCount(reqMap, "facility.regCheckBoard"); //게시판 비번 확인
			    if (checkCount < 1) { //비밀번호가 맞지 않으면
		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치하지 않습니다.") ;
		        	return null;
			    }

			    viewpass = CommonUtil.nvl(reqMap.get("req_pwd"));
			    reqMap.put("viewpass", viewpass);

        	} else { //비밀번호 없이 들어온 경우

        		CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 글만 열람할수 있습니다.");
	        	return null;
        	}

    	}

    	//게시글 조회
    	Map detailMap = dbSvc.dbDetail(reqMap, "facility.regDetail"); //게시판 내용 조회
    	servletRequest.setAttribute( "reqMap", reqMap);
    	servletRequest.setAttribute( "dbMap", detailMap);

    	return  CommDef.APP_PATH +  "/facility/regView";
    }

	/**
	 * 시설 예약 비밀번호 확인
	 * @param servletRequest
	 * @param servletResponse
	 * @return
	 * @throws Exception
	 */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value="/regCheck.do" )
    public String regCheck(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	String mode = CommonUtil.nvl(reqMap.get("mode"));
    	String returl = "";
    	if (mode.equals("pwmodify")) { //게시판 수정
    		returl = "reservation.do";
    	} else if (mode.equals("pwdelete")) { //게시판 삭제
    		returl = "regDelete.do";
    	} else if (mode.equals("pwview")) { //게시판 뷰 (비밀글)
    		returl = "regView.do";
    	} else if (mode.equals("list")) { //게시판 리스트
    		returl = "regList.do";
    	}

    	reqMap.put("returl", returl);
    	servletRequest.setAttribute("reqMap", reqMap);

    	return  CommDef.APP_PATH +  "/facility/regCheck";
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping( value="/regCheckProc.do" )
    public String regCheckProc(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	if (!reqMap.get("mode").equals("list")) {

	        	//비밀번호 검수 후 URL 리턴
			    reqMap.put("req_pwd", CommonUtil.nvl(reqMap.get("pwd")));

			    int checkCount = dbSvc.dbCount(reqMap, "facility.regCheckBoard"); //게시판 비번 확인

			    if (checkCount < 1) { //비밀번호가 맞지 않으면
		        	CommonUtil.alertMsgBack(servletResponse, "입력하신 내용이 일치 하지 않습니다.") ;
		        	return null;
			    }

			    reqMap.put("passok", "Y");
        	}

        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());
    	}

        regCheckformSubmit(servletResponse, reqMap); //form 전송

        return null;
    }

	@SuppressWarnings("rawtypes")
	private void regCheckformSubmit(HttpServletResponse response,  Map reqMap) {
        try {
		   		response.setContentType("text/html;charset=utf-8");

				PrintWriter output = response.getWriter();

				output.println("<html>");
				output.println("<head>");
				output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
				output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

				output.println("<form name='frm' method='post' action='/" + CommonUtil.nvl(reqMap.get("returl")) +"'>");
				if (reqMap.get("mode").equals("list")) {
					output.println("<input type='hidden' name='menuno' value='" + CommonUtil.nvl(reqMap.get("menuno")) + "'>");
					output.println("<input type='hidden' name='page_now' value='" + CommonUtil.nvl(reqMap.get("page_now")) + "'>");
					output.println("<input type='hidden' name='name' value='" + CommonUtil.nvl(reqMap.get("name")) + "'>");
					output.println("<input type='hidden' name='tel' value='" + CommonUtil.nvl(reqMap.get("tel")) + "'>");
				} else {
					output.println("<input type='hidden' name='menuno' value='" + CommonUtil.nvl(reqMap.get("menuno")) + "'>");
					output.println("<input type='hidden' name='param' value='" + CommonUtil.nvl(reqMap.get("param")) + "'>");
					output.println("<input type='hidden' name='page_now' value='" + CommonUtil.nvl(reqMap.get("page_now")) + "'>");
					output.println("<input type='hidden' name='req_pwd' value='" + CommonUtil.nvl(reqMap.get("req_pwd")) + "'>");
					output.println("<input type='hidden' name='name' value='" + CommonUtil.nvl(reqMap.get("name")) + "'>");
					output.println("<input type='hidden' name='tel' value='" + CommonUtil.nvl(reqMap.get("tel")) + "'>");
					output.println("<input type='hidden' name='dd' value='" + CommonUtil.nvl(reqMap.get("dd")) + "'>");
					output.println("<input type='hidden' name='seq' value='" + CommonUtil.nvl(reqMap.get("seq")) + "'>");
				}
				output.println("</form>");
				output.println("<script type='text/javascript' >");
				output.println("   frm.submit(); ");
				output.println("</script>");

				output.println("</head>");
				output.println("</html>");

				output.flush();
				output.close();

        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());
    	}
	}

	/**
	 * 시설 예약 취소
	 * @param servletRequest
	 * @param servletResponse
	 * @return
	 * @throws Exception
	 */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value="/regDelete.do" )
    public String regDelete(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	servletRequest.setAttribute( "reqMap", reqMap);

    	dbSvc.dbUpdate(reqMap, "facility.regCancel"); //접수 취소 실행

    	String strUrl = "";
        strUrl = "regList.do?" + CommonUtil.nvl(reqMap.get("param"));

        ScriptUtil.alertMsgGoUrl(servletResponse, "정상적으로 접수가 취소되었습니다..", strUrl);
        return null;
    }

	/**
	 * 시설 예약
	 * @param servletRequest
	 * @param servletResponse
	 * @return
	 * @throws Exception
	 */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value="/reservation.do" )
    public String reservation(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	servletRequest.setAttribute( "reqMap", reqMap);

    	List codeList1 = new ArrayList<>();
    	List codeList2 = new ArrayList<>();
    	reqMap.put("cg", "TP05");
    	codeList1 = dbSvc.dbList(reqMap, "facility.codeList");	//장애유형 리스트

    	reqMap.put("cg", "FG12");
    	codeList2 = dbSvc.dbList(reqMap, "facility.codeList");	//장애정도 리스트

    	int awitCount = dbSvc.dbInt(reqMap, "facility.selectAwaiterCount"); //대기자 현황카운터
    	Map detailMap = new HashMap();

    	if (!CommonUtil.nvl(reqMap.get("seq")).equals("")) {
        	if (!CommonUtil.nvl(reqMap.get("req_pwd")).equals("")) {

			    int checkCount = dbSvc.dbCount(reqMap, "facility.regCheckBoard"); //게시판 비번 확인
			    if (checkCount < 1) { //비밀번호가 맞지 않으면
		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치하지 않습니다.") ;
		        	return null;
			    }

        	} else { //비밀번호 없이 들어온 경우

        		CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 글만 수정할수 있습니다.");
	        	return null;
        	}

        	detailMap = dbSvc.dbDetail(reqMap, "facility.regDetail"); //게시판 내용 조회
    	}


    	servletRequest.setAttribute( "awitCount", Integer.toString(awitCount));
    	servletRequest.setAttribute( "codeList1", codeList1);
    	servletRequest.setAttribute( "codeList2", codeList2);
    	servletRequest.setAttribute( "dbMap", detailMap);

    	return  CommDef.APP_PATH +  "/facility/reservation";
    }

    /**
     * 시설 예약 접수
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value= "/reservationWork.do" )
    public String inquiryWork(HttpServletRequest servletRequest, 	HttpServletResponse servletResponse) throws Exception {

    	String strUrl = "";
    	String msg = "";
    	Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {

        	String email = CommonUtil.nvl(reqMap.get("email1")) + "@" + CommonUtil.nvl(reqMap.get("email2"));
        	String tel = CommonUtil.nvl(reqMap.get("tel1")) + CommonUtil.nvl(reqMap.get("tel2")) + CommonUtil.nvl(reqMap.get("tel3"));

        	reqMap.put("receive_dd", CommonUtil.getCurrentDate("","YYYYMMDD"));
        	reqMap.put("receive_tm", CommonUtil.getCurrentDate("","HHMISS"));
        	reqMap.put("reg_ip", servletRequest.getRemoteAddr());
        	reqMap.put("progress_sts", "0");
        	reqMap.put("email", email);
        	reqMap.put("enc_phone_num", tel);

        	reqMap.put("enc_password", CommonUtil.nvl(reqMap.get("reg_pwd")));

        	reqMap.put("process_dt", CommonUtil.getCurrentDate("","YYYY-MM-DD"));
        	reqMap.put("disposer", "C2000021");
        	reqMap.put("wffclty_cd", reqMap.get("wcd"));

        	reqMap.put("use_fg", "1");
        	reqMap.put("regist_dt", CommonUtil.getCurrentDate("","YYYY-MM-DD"));
        	reqMap.put("registerer", "test");
        	reqMap.put("update_dt", CommonUtil.getCurrentDate("","YYYY-MM-DD"));
        	reqMap.put("updater", "test");

        	if (!CommonUtil.nvl(reqMap.get("seq")).equals("")) {	//업데이트일 경우
        		msg = "정상적으로 수정되었습니다.";
        		dbSvc.dbUpdate(reqMap, "facility.updateAwaiter");
	            strUrl = CommonUtil.nvl(reqMap.get("returl"));
	            strUrl += "?menuno=" +  CommonUtil.nvl(reqMap.get("menuno"));
        	} else {	//신규 접수일 경우

        		Map awaiterCheck = dbSvc.dbDetail(reqMap, "facility.selectAwaiterCheck");

	        	if (awaiterCheck != null) { //중복으로 접수가 되면 접수 안되게
		        	if (CommonUtil.nvl(awaiterCheck.get("PROGRESS_STS") ,"").equals("0")) {
		                ScriptUtil.alertMsgBack(servletResponse, "시설 접수대기 상태입니다.");
		                return null;
		        	} else if (CommonUtil.nvl(awaiterCheck.get("PROGRESS_STS") ,"").equals("1")) {
		                ScriptUtil.alertMsgBack(servletResponse, "시설 접수 되었습니다.");
		                return null;
		        	}
	        	}
	        	msg = "정상적으로 접수되었습니다.";
	        	dbSvc.dbInsert(reqMap, "facility.insertAwaiter");
	            strUrl = CommonUtil.nvl(reqMap.get("returl"));
	            strUrl += "?menuno=" +  CommonUtil.nvl(reqMap.get("menuno")) + "&wcd=" +  CommonUtil.nvl(reqMap.get("wcd"));
        	}

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

        ScriptUtil.alertMsgGoUrl(servletResponse, msg, strUrl);
        return null;
    }

    /**
     * 시설 프로그램 리스트
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value="/programs.do" )
    public String programs(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	List programsList = new ArrayList<>();
    	Map facilityTitle = dbSvc.dbDetail(reqMap, "facility.facilityDetailTitle");

    	//리스트 시작
    	int per_page = 4; 	   //기본 페이지 레코딩수
    	int page_now = 1;	   //시작 페이징

    	if (!CommonUtil.nvl(reqMap.get("page_now"), "").equals("")) {
    		page_now = Integer.parseInt(reqMap.get("page_now").toString());
    	}

    	reqMap.put("per_page", per_page);
    	reqMap.put("page_now", page_now);

    	programsList = dbSvc.dbList(reqMap, "facility.facilityProgramsList");

    	servletRequest.setAttribute( "reqMap", reqMap);
    	servletRequest.setAttribute( "count",  Integer.toString(dbSvc.dbCount( reqMap, "facility.facilityProgramsListCount" )));
    	servletRequest.setAttribute( "programsList", programsList);
    	servletRequest.setAttribute( "facilityTitle", facilityTitle);

    	return  CommDef.APP_PATH +  "/facility/programs";
    }

    /**
     * 활동지원 시설 프로그램 리스트
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value="/supportPrograms.do" )
    public String supportPrograms(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	List programsList = new ArrayList<>();
    	Map facilityTitle = dbSvc.dbDetail(reqMap, "facility.facilityDetailTitle");

    	//리스트 시작
    	int per_page = 4; 	   //기본 페이지 레코딩수
    	int page_now = 1;	   //시작 페이징

    	if (!CommonUtil.nvl(reqMap.get("page_now"), "").equals("")) {
    		page_now = Integer.parseInt(reqMap.get("page_now").toString());
    	}

    	reqMap.put("per_page", per_page);
    	reqMap.put("page_now", page_now);

    	programsList = dbSvc.dbList(reqMap, "facility.facilityProgramsList");

    	servletRequest.setAttribute( "reqMap", reqMap);
    	servletRequest.setAttribute( "count",  Integer.toString(dbSvc.dbCount( reqMap, "facility.facilityProgramsListCount" )));
    	servletRequest.setAttribute( "programsList", programsList);
    	servletRequest.setAttribute( "facilityTitle", facilityTitle);

    	return  CommDef.APP_PATH +  "/support/supportPrograms";
    }


    /**
     * 활동지원서비스 메인
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
	@RequestMapping( value="/support.do" )
    public String support(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	List areaList = new ArrayList<>();

    	//지역 카테고리 리스트
    	areaList = dbSvc.dbList(reqMap, "facility.areaList");

    	servletRequest.setAttribute( "areaList", areaList);
    	servletRequest.setAttribute( "reqMap", reqMap);

    	return  CommDef.APP_PATH +  "/support/support";
    }

    /**
     * 활동지원서비스 검색
     * @param servletRequest
     * @param servletResponse
     * @return
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value="/supportList.do" )
    public String supportList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

    	Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	List areaList = new ArrayList<>();
    	List facilityList = new ArrayList<>();

    	//지역 카테고리 리스트
    	areaList = dbSvc.dbList(reqMap, "facility.areaList");

    	//리스트 시작
    	int per_page = 5; 	   //기본 페이지 레코딩수
    	int page_now = 1;	   //시작 페이징

    	if (!CommonUtil.nvl(reqMap.get("page_now"), "").equals("")) {
    		page_now = Integer.parseInt(reqMap.get("page_now").toString());
    	}

    	reqMap.put("ca1", "WF05");	//1차 카테고리
    	reqMap.put("ca2", "D01");	//2차 카테고리
    	reqMap.put("per_page", per_page);
    	reqMap.put("page_now", page_now);
    	facilityList = dbSvc.dbList(reqMap, "facility.facilityList");


        servletRequest.setAttribute( "reqMap", reqMap);
        servletRequest.setAttribute( "areaList", areaList);
        servletRequest.setAttribute( "count",  Integer.toString(dbSvc.dbCount( reqMap, "facility.facilityListCount" )));
        servletRequest.setAttribute( "facilityList", facilityList);

    	return  CommDef.APP_PATH +  "/support/supportList";
    }
}
