package egovframework.controller;

import java.io.File;
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

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


import egovframework.util.CommDef;
import egovframework.util.CommonUtil;
import egovframework.util.SHA256Encode;
import egovframework.util.ScriptUtil;
import egovframework.util.SendMail;
import egovframework.util.SessionUtil;
import egovframework.util.UploadUtil;
import egovframework.db.DbController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Class Name : BoardController.java
 * @Description : EgovSample CommonController Class
 * @Modification Information
 * @author 김태균
 * @since 2019.08.10
 * @version 1.0
 * @see
 */

@Controller
public class BoardController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	private String mTableName = "TB_BOARD";	// 테이블 명

	 /**
     * Method Summary. <br>
     * 게시판 리스트 컨트롤러  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value="/board.do" )
    public String boardList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        Map brdMgrMap = new HashMap();

        String strBrdMgrno = CommonUtil.nvl(reqMap.get("boardno"));
        String order_cd = "";
        int userLevel = 1; //기본 유저레벨
        int list_cnt = 10; //기본 페이징 수

        try {

        	Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "USER");
        	if (userMap != null) userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1); //유저레벨 체크

            if ( !"".equals(strBrdMgrno))
            {
            	 reqMap.put("brd_mgrno", strBrdMgrno);
            	 brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail");
            	 order_cd = CommonUtil.nvl(brdMgrMap.get("ORDER_CD"));
            	 list_cnt = CommonUtil.getNullInt(brdMgrMap.get("LIST_CNT"), 0);
            } else {
            	ScriptUtil.alertMsgGoUrl(servletResponse, "잘못된 경로로 접속하셨습니다.", "/");
            	return null;
            }

            //게시판 사용 체크
            if (CommonUtil.nvl(brdMgrMap.get("USE_YN")).equals("N")) {
	        	CommonUtil.alertMsgBack(servletResponse, "게시판 사용이 제한되었습니다.") ;
	        	return null;
            }

            //목록보기 권한 체크
            if (CommonUtil.getNullInt(brdMgrMap.get("LIST_LEVEL_CD"), 0) > userLevel) {
	        	CommonUtil.alertMsgBack(servletResponse, "게시판 목록보기 권한이 없습니다.") ;
	        	return null;
            }

        	int nPageRow = dbSvc.getPageRowCount(reqMap, "page_row" , list_cnt); //사용자 스킨에서만 적용
            int nRowStartPos = nPageRow * ( dbSvc.getPageNow(reqMap, "page_now") - 1 );  // Row의 시작위치


            //카테고리를 사용한다면
            if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) {
            	reqMap.put("cate_cd", brdMgrMap.get("CATE_CD"));
            }

            reqMap.put("page_row", nPageRow);  //현재 페이지
            reqMap.put("sort_ord", order_cd); //정렬순번

            //공지글을 사용한다면
            List noticeList = new ArrayList<>();
            if (CommonUtil.nvl(brdMgrMap.get("NOTICE_YN")).equals("Y")) {
            	noticeList = dbSvc.dbList(reqMap, "board.boardNoticeList");
            }

            servletRequest.setAttribute("userMap", userMap);
            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "brdMgrMap", brdMgrMap);
            servletRequest.setAttribute( "noticeList", noticeList);

            reqMap.put("notice_yn", "N");
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "board.boardListCount" ) ) );
            servletRequest.setAttribute( "list",   dbSvc.dbPagingList( reqMap, "board.boardList", nRowStartPos ,nPageRow) );

        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());
    	}

        return  CommDef.APP_PATH +  "/board/" + CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).toLowerCase() + "/boardList";
    }

    /**
     * Method Summary. <br>
     * 게시판 등록/수정 화면 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= "/write.do" )
    public String boardWrite(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map dbMap = new HashMap();
        Map brdMgrMap = new HashMap();

        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");
        int userLevel = 1; //기본 유저레벨
        String userid = "guest"; //기본 아이디

        if (userMap != null) {
        	userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
        	userid = CommonUtil.nvl(userMap.get("USER_ID"));
        }

        String seq = CommonUtil.nvl(reqMap.get("seq"));
        String strBrdMgrno = CommonUtil.nvl(reqMap.get("boardno"));

        reqMap.put("brd_mgrno", strBrdMgrno);
        String strIFlag = CommonUtil.nvl(reqMap.get("iflag"));

        try {

            if ( !"".equals(strBrdMgrno)) { //게시판 세팅 정보
            	 brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail");
            }

            //게시글 작성 권한 체크
            if (CommonUtil.getNullInt(brdMgrMap.get("WRITE_LEVEL_CD"), 0) > userLevel) {
	        	CommonUtil.alertMsgBack(servletResponse, "게시글 작성 권한이 없습니다.") ;
	        	return null;
            }

            if (strIFlag.equals(CommDef.ReservedWord.REPLY)) { //게시글 답변일 경우

            	reqMap.put("brd_no", seq);
            	dbMap = dbSvc.dbDetail(reqMap, "board.boardDetail");

            } else { //수정, 글쓰기 경우

            	reqMap.put("iflag", CommDef.ReservedWord.INSERT); //게시글 쓰기 초기화

	            if (!"".equals(seq)) { //게시글 수정일경우

	            	reqMap.put("brd_no", seq);
	            	if (!CommonUtil.nvl(reqMap.get("req_pwd")).equals("")) { //비밀번호가 같이 넘어왔을 경우 검증
	    			    int checkCount = dbSvc.dbCount(reqMap, "board.guestCheckBoard"); //게시판 비번 확인
	    			    if (checkCount < 1) { //비밀번호가 맞지 않으면
	    		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치 하지 않습니다.") ;
	    		        	return null;
	    			    }
	            	} else { //회원으로 넘어왔을경우 자신의 게시물인지 검증
	            		if (userLevel < 10) {  //관리자가 아닐경우 체크
	            			reqMap.put("user_id", userid);
	            			
		            		 if (userid.equals("guest")) { //비로그인시 
			     	        	CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 게시물만 수정 할수 있습니다.");
			    	        	return null;
		            		 } else {
		            			int usercheckCount = dbSvc.dbCount(reqMap, "board.userCheckBoard"); //게시판 작성자 확인
			    			    if (usercheckCount < 1) { //작성자가 맞지 않으면
			    		        	CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 게시물만 수정 할수 있습니다.") ;
			    		        	return null;
			    			    }
		            		 }
		            		 
	            		}
	            	}

	            	dbMap = dbSvc.dbDetail(reqMap, "board.boardDetail"); //게시판 정보 조회
	            	if ( dbMap != null)
	            		reqMap.put("iflag", CommDef.ReservedWord.UPDATE);

	            	//첨부파일 가져오기
	                reqMap.put("rel_tbl", mTableName);
	                reqMap.put("rel_key", seq);

	            	servletRequest.setAttribute( "lstFile",   dbSvc.dbList(reqMap, "common.getUploadFile") );
	            }
            }

        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());
    	}

        servletRequest.setAttribute( "userMap", userMap);
        servletRequest.setAttribute( "reqMap", reqMap);
        servletRequest.setAttribute( "brdMgrMap", brdMgrMap);
        servletRequest.setAttribute( "dbMap", dbMap);

        return  CommDef.APP_PATH +  "/board/" + CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).toLowerCase() + "/boardWrite";
    }

	/**
	 * Method Summary. <br>
	 * 게시판 등록/수정 화면 method.
	 * @param servletRequest HttpServletRequest 객체
	 * @param servletResponse HttpServletResponse 객체
	 * @return ActionForward 객체 - 리턴 페이지 정보
	 * @throws e Exception
	 * @since 1.00
	 * @see
	 */
	@SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	@RequestMapping( value= "/boardWork.do" )
	public String boardWork(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

		String strUrl = "";
	    HttpSession session = servletRequest.getSession( false );
	    Map reqMap = CommonUtil.getRequestMap( servletRequest );

	    try {

		    //해당 게시판 폴더 생성
		    String BRD_UPLOADPATH =  "/upload/board/" + CommonUtil.nvl(reqMap.get("boardno")) + "/";
		   	File folder = new File(BRD_UPLOADPATH);

		   	if (!folder.exists()) { //폴더 생성
		   		try { folder.mkdir(); } catch (Exception e) { e.getStackTrace(); }
		   	}

	    	UploadUtil uploadUtil = new UploadUtil(servletRequest, BRD_UPLOADPATH);
	    	uploadUtil.setDbDao(dbSvc.m_dao); //DB연결자

	        String strContentType =  CommonUtil.getNullTrans(servletRequest.getHeader("Content-Type"));
	        boolean isFileUp = (strContentType.indexOf("multipart/form-data") > -1) ? true :false;  // 첨부파일이 존재하는지 확인

	        reqMap = ( isFileUp ) ? uploadUtil.getRequestMap(servletRequest):CommonUtil.getRequestMap( servletRequest );

	        String strFileOverSize = CommonUtil.nvl(reqMap.get("FILE_OVER_SIZE"));

	        if ( !"".equals(strFileOverSize)) {
	        	CommonUtil.alertMsgBack(servletResponse, strFileOverSize) ;
	        	return null;
	        }

		    String brd_mgrno = CommonUtil.nvl(reqMap.get("boardno"));
		    reqMap.put("brd_mgrno", brd_mgrno);

		    //비회원, 회원관련 변수 초기화
		    String pwd = "";
		    String userid = "guest";
		    String userseq = "0";
		    int userLevel = 1;

		    Map paramMap = new HashMap();
		    Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");
		    int seq = CommonUtil.getNullInt(reqMap.get("seq"), 0); //시퀀스 초기화

		    if (userMap != null) {
		    	pwd = SHA256Encode.Encode(CommonUtil.shufflePasswd(10)); //패스워드 랜덤 생성 (SHA256 Encode 로 암호화)
		    	userid = CommonUtil.nvl(userMap.get("USER_ID"));
		    	userseq = CommonUtil.nvl(userMap.get("SEQ"));
		    	userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
		    } else {
		    	pwd = SHA256Encode.Encode(CommonUtil.nvl(reqMap.get("reg_pwd")));
		    }
		    String user_di = SHA256Encode.Encode(CommonUtil.shufflePasswd(10)); //랜덤 생성 (SHA256 Encode 로 암호화)

		    int is_comment = 0;
		    int board_num = 0;
		    int board_sort = 0;
		    int view_cnt = 0;
		    String board_reply = " ";
		    String notice_yn = "N";
		    String secret_yn = "N";
		    String youtube_code1 = "";
		    String youtube_code2 = "";
		    String youtube_code3 = "";

		    Map brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail"); //게시판 설정 조회

		    //REPLY 처리일 경우 기본 체크
	    	if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.REPLY)) {

	    		reqMap.put("brd_no", seq);
	    		Map boardViewMap = dbSvc.dbDetail(reqMap, "board.boardDetail"); //게시판 내용 조회

	    		if (CommonUtil.nvl(boardViewMap.get("NOTICE_YN")).equals("Y")) { //공지사항인지 체크
		        	CommonUtil.alertMsgBack(servletResponse, "공지에는 답변을 달수 없습니다.") ;
		        	return null;
	    		}

	    		if (CommonUtil.getNullInt(brdMgrMap.get("REPLY_LEVEL_CD"), 0) > userLevel) { //답변 권한 레벨 체크
		        	CommonUtil.alertMsgBack(servletResponse, "답변을 작성할 권한이 없습니다.") ;
		        	return null;
	    		}

	    		if (CommonUtil.nvl(boardViewMap.get("BOARD_REPLY")).length() > 9) {
		        	CommonUtil.alertMsgBack(servletResponse, "더 이상 답변하실 수 없습니다.\\n답변은 10단계 까지만 가능합니다.") ;
		        	return null;
	    		}

	    		int replyLen = CommonUtil.nvl(boardViewMap.get("BOARD_REPLY")).length() + 1;
	    		String begin_reply_char = "A";
	    		String end_reply_char = "Z";

	    		Map replyMap = new HashMap();
	    		replyMap.put("replyLen", replyLen);
	    		replyMap.put("board_num", boardViewMap.get("BOARD_NUM"));
	    		replyMap.put("boardreply", CommonUtil.nvl(boardViewMap.get("BOARD_REPLY")));
	    		Map reply = dbSvc.dbDetail(replyMap, "board.boardReplyGet");

	    		String reply_char = "";

	    		if (reply == null) {
	    			reply_char = begin_reply_char;
	    		} else if (CommonUtil.nvl(reply.get("REPLY")).equals(end_reply_char)) {
		        	CommonUtil.alertMsgBack(servletResponse, "더 이상 답변하실 수 없습니다.\\n답변은 10단계 까지만 가능합니다.") ;
		        	return null;
	    		} else {
	    			reply_char = CommonUtil.nextAlphabet(CommonUtil.nvl(reply.get("REPLY")));
	    		}

	    		board_num = CommonUtil.getNullInt(boardViewMap.get("BOARD_NUM"), 0);
	    		board_reply = CommonUtil.nvl(boardViewMap.get("BOARD_REPLY")) + reply_char;

	    		//답변의 원글이 비밀글일경우 비밀번호를 동일하게 처리
	    		if (CommonUtil.nvl(boardViewMap.get("SECRET_YN")).equals("Y")) {
	    			pwd = CommonUtil.nvl(boardViewMap.get("REG_PWD"));
	    		}

	    		//원글작성자 ID 삽입
	    		paramMap.put("ori_reg_id", boardViewMap.get("ORI_REG_ID"));

	    	}  //REPLY 처리일 경우 기본 체크 끝

		    if (!CommonUtil.nvl(reqMap.get("notice_yn")).equals("")) notice_yn = CommonUtil.nvl(reqMap.get("notice_yn"), "N");  //공지사항 여부 초기화
		    if (!CommonUtil.nvl(reqMap.get("secret_yn")).equals("")) secret_yn = CommonUtil.nvl(reqMap.get("secret_yn"), "N");  //비밀글 여부 초기화
		    if (!CommonUtil.nvl(reqMap.get("board_sort")).equals("")) board_sort = CommonUtil.getNullInt(CommonUtil.nvl(reqMap.get("board_sort")), 0);  //강제번호 초기화
		    if (!CommonUtil.nvl(reqMap.get("view_cnt")).equals("")) view_cnt = CommonUtil.getNullInt(CommonUtil.nvl(reqMap.get("view_cnt")), 0);  //조회수 초기화
		    if (!CommonUtil.nvl(reqMap.get("youtube_code1")).equals("")) youtube_code1 = CommonUtil.nvl(reqMap.get("youtube_code1"));  //유튜브 코드1 초기화
		    if (!CommonUtil.nvl(reqMap.get("youtube_code2")).equals("")) youtube_code2 = CommonUtil.nvl(reqMap.get("youtube_code2"));  //유튜브 코드2 초기화
		    if (!CommonUtil.nvl(reqMap.get("youtube_code3")).equals("")) youtube_code3 = CommonUtil.nvl(reqMap.get("youtube_code3"));  //유튜브 코드3 초기화

		    paramMap.put("brd_no", seq); //게시판 시퀀스 번호
		    paramMap.put("title", CommonUtil.nvl(reqMap.get("title"))); //게시판 제목
		    paramMap.put("brd_mgrno", CommonUtil.nvl(reqMap.get("brd_mgrno"))); //게시판 관리 참조 키
		    paramMap.put("category_cd", CommonUtil.nvl(reqMap.get("category_cd"))); //카테고리 코드
		    paramMap.put("notice_yn", notice_yn); //공지여부
		    paramMap.put("secret_yn", secret_yn); //비밀글 여부
		    paramMap.put("content", CommonUtil.nvl(reqMap.get("content"))); //게시판 내용
		    paramMap.put("email", CommonUtil.nvl(reqMap.get("email"))); //이메일 주소
		    paramMap.put("reg_name", CommonUtil.nvl(reqMap.get("reg_name"))); //작성자
		    paramMap.put("url_text", CommonUtil.nvl(reqMap.get("url_text"))); //URL 링크 내용
		    paramMap.put("board_sort", board_sort); //게시판 강제순번
		    paramMap.put("view_cnt", view_cnt); //조회수

		    paramMap.put("is_comment", is_comment); //코멘트 여부
		    paramMap.put("comment_reply", CommonUtil.nvl(reqMap.get("comment_reply"))); //코멘트 답변 여부

		    paramMap.put("etc_field1", CommonUtil.nvl(reqMap.get("etc_field1"))); //추가항목1
		    paramMap.put("etc_field2", CommonUtil.nvl(reqMap.get("etc_field2"))); //추가항목2
		    paramMap.put("etc_field3", CommonUtil.nvl(reqMap.get("etc_field3"))); //추가항목3
		    paramMap.put("etc_field4", CommonUtil.nvl(reqMap.get("etc_field4"))); //추가항목4
		    paramMap.put("etc_field5", CommonUtil.nvl(reqMap.get("etc_field5"))); //추가항목5

		    paramMap.put("youtube_code1", youtube_code1); //유투브 코드1
		    paramMap.put("youtube_code2", youtube_code2); //유투브 코드2
		    paramMap.put("youtube_code3", youtube_code3); //유투브 코드3

		    paramMap.put("reg_ip", servletRequest.getRemoteAddr()); //등록자 IP

		    if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.INSERT) || CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.REPLY)) { //INSERT, REPLY 처리일 경우

		    	seq = dbSvc.dbInt("board.boardNextValue"); //게시판 시퀀스 가져오기

		    	if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.INSERT)) {
		    		paramMap.put("ori_reg_id", userid); //원글작성자 아이디
		    		board_num = dbSvc.dbInt(reqMap, "board.boardNum"); //board_num
		    	}

			    paramMap.put("reg_id", userid); //작성자(회원) ID
			    paramMap.put("reg_id_seq", userseq); //작성자(회원) 시퀀스
			    paramMap.put("reg_pwd", pwd); //패스워드
			    paramMap.put("user_di", user_di); //본인확인 인증 DI 값
			    paramMap.put("board_num", board_num); //게시판 번호 설정
			    paramMap.put("board_parent", seq); //게시판 부모계층 확인
			    paramMap.put("board_reply", board_reply); //게시판 번호 계층
			    paramMap.put("comment_cnt", 0); //코멘트 갯수
			    paramMap.put("brd_no", seq); //게시판 시퀀스 번호
			    dbSvc.dbInsert(paramMap, "board.boardInsert"); //최종 INSERT

			    if (paramMap.get("brd_mgrno").equals("61")) {  //민원신고일 경우 메일 발송 로직 추가
			    	this.userSendMail(servletRequest, paramMap);
			    }

		    } else if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.UPDATE)) { //UPDATE 처리일 경우

		    	if (reqMap.get("brd_mgrno").equals("61")) { //민원신고 게시판일 경우 기존 비밀번호 확인

		    		paramMap.put("req_pwd", pwd); //패스워드 검증값
		    		
    			    int checkCount = dbSvc.dbCount(paramMap, "board.guestCheckBoard"); //게시판 비번 확인
    			    if (checkCount < 1) { //비밀번호가 맞지 않으면
    		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치하지 않습니다.") ;
    		        	return null;
    			    }
    			    
    			    paramMap.put("reg_pwd", pwd); //패스워드 입력
		    	}

		    	dbSvc.dbInsert(paramMap, "board.boardUpdate"); //최종 UPDATE
		    }

		    //파일업로드 시작
		    reqMap.put("rel_tbl", mTableName);
		    reqMap.put("rel_key", seq);
            reqMap.put("thumTip", "Y"); //썸네일 처리
            reqMap.put("thumWidth", brdMgrMap.get("THM_WIDTH_SIZE")); //썸네일 가로 사이즈
            reqMap.put("thumHeight", brdMgrMap.get("THM_HEIGHT_SIZE")); //썸네일 세로 사이즈

            if ( isFileUp ) // 파일처리
            	uploadUtil.uploadProcess(reqMap, servletRequest);

        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());
    	}

	    servletRequest.setAttribute( "reqMap", reqMap);
        strUrl = CommonUtil.nvl(reqMap.get("returl"));
        strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

	    return  "redirect:" + strUrl;
	}

    /**
     * Method Summary. <br>
     * 게시판 내용 보기 method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 - 리턴 페이지 정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping( value= "/view.do" )
    public String boardView( HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        Map brdMgrMap = new HashMap();
        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");
        List commentList = null;
        int userLevel = 1; //기본 레벨
        String userid = "guest"; //기본 아이디
        String viewpass = "N"; //비밀글 열람시 설정값

        if (userMap != null) {
        	userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
        	userid = CommonUtil.nvl(userMap.get("USER_ID"));
        }

        int seq = CommonUtil.getNullInt(reqMap.get("seq"), 0); //시퀀스 초기화
        reqMap.put("brd_mgrno", reqMap.get("boardno"));
        String strBrdMgrno = CommonUtil.nvl(reqMap.get("boardno"));

        try {

            if ( !"".equals(strBrdMgrno))  // 게시판 설정 불러오기
            	brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail");

            //게시글 보기 권한 체크
            if (CommonUtil.getNullInt(brdMgrMap.get("READ_LEVEL_CD"), 0) > userLevel) {
	        	CommonUtil.alertMsgBack(servletResponse, "게시글 읽기 권한이 없습니다.");
	        	return null;
            }

            reqMap.put("brd_no", seq);
            Map detailMap = dbSvc.dbDetail(reqMap, "board.boardDetail"); //게시판 내용 조회

            if (CommonUtil.nvl(detailMap.get("SECRET_YN")).equals("Y")) {  //게시글이 비밀글일 경우

            	if (userLevel < 10) { //관리자가 아닐 경우 검증시작

            		if (!CommonUtil.nvl(reqMap.get("viewpass")).equals("")) { //뷰패스가 있다면

            			reqMap.put("req_pwd", reqMap.get("viewpass"));
	    			    int checkCount = dbSvc.dbCount(reqMap, "board.guestCheckBoard"); //게시판 비번 확인
	    			    if (checkCount < 1) { //비밀번호가 맞지 않으면
	    		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치하지 않습니다.") ;
	    		        	return null;
	    			    }

            		} else {
		            	if (!CommonUtil.nvl(reqMap.get("req_pwd")).equals("")) {

		    			    int checkCount = dbSvc.dbCount(reqMap, "board.guestCheckBoard"); //게시판 비번 확인
		    			    if (checkCount < 1) { //비밀번호가 맞지 않으면
		    		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치하지 않습니다.") ;
		    		        	return null;
		    			    }

		    			    viewpass = CommonUtil.nvl(reqMap.get("req_pwd"));
		    			    reqMap.put("viewpass", viewpass);

		            	} else { //비밀번호 없이 인증으로 들어온 경우

		            		 if (userid.equals("guest")) { //비로그인시 
				     	        	CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 글만 열람할수 있습니다.");
				    	        	return null;
		            		 } else {
				        		 Map paramMap = new HashMap();
				        		 paramMap.put("brd_no", reqMap.get("brd_no"));
				        		 paramMap.put("user_id", userid);
				        		 int checkCount = dbSvc.dbCount(paramMap,"board.userOriCheckBoard");
	
				        		 if (checkCount == 0) {
				     	        	CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 글만 열람할수 있습니다.");
				    	        	return null;
				        		 }
			            	}
		            		 
		            	}
            		}

            	}

            }

            dbSvc.dbUpdate(reqMap, "board.boardHitUpdate"); //게시판 조회수 업데이트

        	//댓글 리스트 확인
        	if (CommonUtil.nvl(brdMgrMap.get("CMT_USE_YN")).equals("Y")) {
        		commentList = dbSvc.dbList(reqMap, "board.boardCommentList");
        	}

        	Map prevMap = new HashMap();
        	Map nextMap = new HashMap();

        	if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_NUM, BOARD_REPLY")) { //기본 정렬일 경우

        		//윗글 불러오기
        		reqMap.put("where", "AND BOARD_NUM = " + detailMap.get("BOARD_NUM") + " AND BOARD_REPLY < '" +  detailMap.get("BOARD_REPLY") + "'");
        		reqMap.put("orderby", " board_num desc, board_reply desc");
        		prevMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");

        		if (prevMap == null) { //위의 값으로 못 얻으면
        			reqMap.put("where", "AND BOARD_NUM < " + detailMap.get("BOARD_NUM"));
        			prevMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");
        		}

        		//아랫글 불러오기
        		reqMap.put("where", "AND BOARD_NUM = " + detailMap.get("BOARD_NUM") + " AND BOARD_REPLY > '" +  detailMap.get("BOARD_REPLY") + "'");
        		reqMap.put("orderby", " board_num, board_reply");
        		nextMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");

        		if (nextMap == null) { //위의 값으로 못 얻으면
            		reqMap.put("where", "AND BOARD_NUM >" + detailMap.get("BOARD_NUM"));
            		reqMap.put("orderby", " board_num, board_reply");
            		nextMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");
        		}

        	} else if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_SORT ASC")) { //강제순번일 경우

        		//윗글 불러오기
        		reqMap.put("where", " AND BOARD_SORT <= (" + detailMap.get("BOARD_SORT") + " - 1)");
        		reqMap.put("orderby", " board_sort desc, board_num desc");
        		prevMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");

        		//아랫글 불러오기
        		reqMap.put("where", " AND BOARD_SORT >= (" +  detailMap.get("BOARD_SORT") + " + 1)");
        		reqMap.put("orderby", " board_sort asc, board_num asc");
        		nextMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");
        	} else if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("REG_DT DESC")) { //날짜 최근일 DESC 경우

        		//윗글 불러오기
        		reqMap.put("where", " AND REG_DT > '" + detailMap.get("REG_DT") + "'");
        		reqMap.put("orderby", " reg_dt asc");
        		prevMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");

        		//아랫글 불러오기
        		reqMap.put("where", " AND REG_DT < '" +  detailMap.get("REG_DT") + "'");
        		reqMap.put("orderby", " reg_dt desc");
        		nextMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");

        	} else if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("REG_DT ASC")) { //날짜 예전날짜 ASC 경우

        		//윗글 불러오기
        		reqMap.put("where", " AND REG_DT < '" + detailMap.get("REG_DT") + "'");
        		reqMap.put("orderby", " reg_dt asc");
        		prevMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");

        		//아랫글 불러오기
        		reqMap.put("where", " AND REG_DT > '" +  detailMap.get("REG_DT") + "'");
        		reqMap.put("orderby", " reg_dt desc");
        		nextMap = dbSvc.dbDetail(reqMap, "board.prevnextBoardDetail");

        	}

        	servletRequest.setAttribute("userMap", userMap);
            servletRequest.setAttribute( "brdMgrMap", brdMgrMap);
            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "dbMap", detailMap);
            servletRequest.setAttribute("commentList", commentList);
            servletRequest.setAttribute("prevMap", prevMap); //윗글
            servletRequest.setAttribute("nextMap", nextMap); //아랫글

            reqMap.put("rel_tbl", mTableName);
            reqMap.put("rel_key", seq);

            servletRequest.setAttribute( "lstFile",   dbSvc.dbList(reqMap, "common.getUploadFile") );

        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());
    	}

        return  CommDef.APP_PATH +  "/board/" + CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).toLowerCase() + "/boardView";
    }

	 /**
	  * Method Summary. <br>
	  * 게시판 삭제 처리 method.
	  * @param actionMapping 액션맵핑 객체
	  * @param actionForm 액션폼 객체
	  * @param servletRequest HttpServletRequest 객체
	  * @param servletResponse HttpServletResponse 객체
	  * @return ActionForward 객체 - 리턴 페이지 정보
	  * @throws e Exception
	  * @since 1.00
	  * @see
	  */
	 @SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping( value= "/boardDelete.do" )
	 public String boardDelete(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

	     Map reqMap = CommonUtil.getRequestMap( servletRequest );
	     String strUrl = CommonUtil.getNullTrans(reqMap.get("returl"), "/");
	     Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "USER");

	     try {

				int userLevel = 1; //기본 레벨
				String userid = "guest"; //기본 아이디

				if (userMap != null) {
					userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
					userid = CommonUtil.nvl(userMap.get("USER_ID"));
				}

	    	 	reqMap.put("brd_no", reqMap.get("seq"));

            	if (userLevel < 10) { //관리자가 아닐 경우 검증시작
	            	if (!CommonUtil.nvl(reqMap.get("req_pwd")).equals("")) {

	    			    int checkCount = dbSvc.dbCount(reqMap, "board.guestCheckBoard"); //게시판 비번 확인
	    			    if (checkCount < 1) { //비밀번호가 맞지 않으면
	    		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치하지 않습니다.") ;
	    		        	return null;
	    			    }

	            	} else { //비밀번호 없이 인증으로 들어온 경우

	            		 if (userid.equals("guest")) { //비로그인시 
		     	        	CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 글만 삭제할수 있습니다.");
		    	        	return null;
	            		 } else {
			        		 Map paramMap = new HashMap();
			        		 paramMap.put("brd_no", reqMap.get("brd_no"));
			        		 paramMap.put("user_id", userid);
			        		 int checkCount = dbSvc.dbCount(paramMap,"board.userCheckBoard");
	
			        		 if (checkCount == 0) {
			     	        	CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 글만 삭제할수 있습니다.");
			    	        	return null;
			        		 }
	            		 }
	            	}
            	}

	             UploadUtil upUtil = new UploadUtil(servletRequest);
	             upUtil.setDbDao(dbSvc.m_dao); //DB연결자

         		dbSvc.dbDelete(reqMap, "board.boardDelete");
         		dbSvc.dbDelete(reqMap, "board.boardCommentDelete"); //코멘트 삭제

         		Map paramMap = new HashMap();
             	paramMap.put("rel_tbl", mTableName);
             	paramMap.put("rel_key", CommonUtil.nvl(reqMap.get("brd_no")));
             	upUtil.removeFile(paramMap);

	         String strParam = CommonUtil.nvl( reqMap.get( "param" ), "" );

	         strUrl = CommonUtil.nvl(reqMap.get("returl"));
	         if (strUrl.equals("")) strUrl = "/board.do";
	         strUrl += "?" + strParam;

	        } catch (RuntimeException e) {
	            LOGGER.error(e.getMessage());

	        } catch(IOException e) {
	    		LOGGER.error(e.getMessage());

	    	} catch(Exception e) {
	    		LOGGER.error(e.getMessage());
	    	}

	     return "redirect:" + strUrl;

	 }

		/**
		 * Method Summary. <br>
		 * 코멘트 등록/수정 화면 method.
		 * @param servletRequest HttpServletRequest 객체
		 * @param servletResponse HttpServletResponse 객체
		 * @return ActionForward 객체 - 리턴 페이지 정보
		 * @throws e Exception
		 * @since 1.00
		 * @see
		 */
		@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
		@RequestMapping( value= "/commentUpdate.do" )
		public String commentUpdate(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

			String strUrl = "";
		    HttpSession session = servletRequest.getSession( false );
		    Map reqMap = CommonUtil.getRequestMap( servletRequest );

		    try {

			    Map paramMap = new HashMap();
			    Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");

			    int seq = CommonUtil.getNullInt(reqMap.get("seq"), 0); //시퀀스 초기화
			    int comment_id = CommonUtil.getNullInt(reqMap.get("comment_id"), 0); //코멘트 시퀀스 초기화

			    //비회원, 회원관련 변수 초기화
			    String pwd = "";
			    String userid = "guest";
			    String userseq = "0";
			    String username = "";
			    int userLevel = 1;

			    if (userMap != null) {
			    	pwd = SHA256Encode.Encode(CommonUtil.shufflePasswd(10)); //패스워드 랜덤 생성 (SHA256 Encode 로 암호화)
			    	userid = CommonUtil.nvl(userMap.get("USER_ID"));
			    	userseq = CommonUtil.nvl(userMap.get("SEQ"));
			    	userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
			    	username = CommonUtil.nvl(userMap.get("USER_NM"));
			    } else {
			    	pwd = SHA256Encode.Encode(CommonUtil.nvl(reqMap.get("cm_pwd")));
			    	username = CommonUtil.nvl(reqMap.get("cm_name"));
			    }

			    String user_di = SHA256Encode.Encode(CommonUtil.shufflePasswd(10)); //랜덤 생성 (SHA256 Encode 로 암호화)

			    int is_comment = 1;
			    int board_num = 0;
			    int board_sort = 0;
			    int view_cnt = 0;
			    String board_reply = " ";
			    String notice_yn = "N";
			    String secret_yn = "N";
			    int tmp_comment = 0;
			    String tmp_comment_reply = " ";

			    reqMap.put("brd_no", seq);
			    reqMap.put("brd_mgrno", reqMap.get("boardno"));
			    Map brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail"); //게시판 설정 조회
	    		Map boardViewMap = dbSvc.dbDetail(reqMap, "board.boardDetail"); //게시판원글 내용 조회

		    	if (CommonUtil.nvl(reqMap.get("mode")).equals("r")) {  //REPLY 처리일 경우 기본 체크
		    		Map commentdbMap = dbSvc.dbDetail(reqMap,"board.boardCommentDetail"); //코멘트 내용 가져오기
		    		if (commentdbMap == null) {
			        	CommonUtil.alertMsgBack(servletResponse, "답변할 댓글이 없습니다.\\n답변하는 동안 댓글이 삭제되었을 수 있습니다") ;
			        	return null;
		    		}

		    		if (!CommonUtil.nvl(boardViewMap.get("BOARD_PARENT")).equals(CommonUtil.nvl(commentdbMap.get("BOARD_PARENT")))) {
			        	CommonUtil.alertMsgBack(servletResponse, "댓글을 등록할 수 없습니다") ;
			        	return null;
		    		}

		    		tmp_comment = CommonUtil.getNullInt(commentdbMap.get("COMMENT_CNT"), 0);

		    		if (CommonUtil.nvl(commentdbMap.get("COMMENT_REPLY")).length() > 4) {
			        	CommonUtil.alertMsgBack(servletResponse, "더 이상 답변하실 수 없습니다.\\n\\n답변은 5단계 까지만 가능합니다") ;
			        	return null;
		    		}

		    		int replyLen = CommonUtil.nvl(commentdbMap.get("COMMENT_REPLY")).length() + 1;
		    		String begin_reply_char = "A";
		    		String end_reply_char = "Z";

		    		Map replyMap = new HashMap();
		    		replyMap.put("replyLen", replyLen);
		    		replyMap.put("board_parent", boardViewMap.get("BRD_NO"));
		    		replyMap.put("tmp_comment", tmp_comment);
		    		replyMap.put("comment_reply", CommonUtil.nvl(commentdbMap.get("COMMENT_REPLY")));
		    		Map reply = dbSvc.dbDetail(replyMap, "board.boardCommentReplyGet");

		    		String reply_char = "";

		    		if (reply == null) {
		    			reply_char = begin_reply_char;
		    		} else if (CommonUtil.nvl(reply.get("REPLY")).equals(end_reply_char)) {
			        	CommonUtil.alertMsgBack(servletResponse, "더 이상 답변하실 수 없습니다.\\n답변은 10단계 까지만 가능합니다.") ;
			        	return null;
		    		} else {
		    			reply_char = CommonUtil.nextAlphabet(CommonUtil.nvl(reply.get("REPLY")));
		    		}

		    		tmp_comment_reply = CommonUtil.nvl(commentdbMap.get("COMMENT_REPLY")) + reply_char;

		    	}  else {
		    		tmp_comment = dbSvc.dbInt(reqMap, "board.boardCommentMax") + 1;
		    	}

			    if (!CommonUtil.nvl(reqMap.get("cm_secret")).equals("")) secret_yn = CommonUtil.nvl(reqMap.get("cm_secret"), "N");  //비밀글 여부 초기화

			    paramMap.put("brd_no", comment_id); //게시판 시퀀스 번호
			    paramMap.put("title", boardViewMap.get("TITLE")); //게시판 제목
			    paramMap.put("brd_mgrno", CommonUtil.nvl(reqMap.get("brd_mgrno"))); //게시판 관리 참조 키
			    paramMap.put("category_cd",boardViewMap.get("CATEGORY_CD")); //카테고리 코드
			    paramMap.put("notice_yn", notice_yn); //공지여부
			    paramMap.put("secret_yn", secret_yn); //비밀글 여부
			    paramMap.put("content", CommonUtil.nvl(reqMap.get("cmm_content"))); //게시판 내용
			    paramMap.put("email", CommonUtil.nvl(reqMap.get("email"))); //이메일 주소
			    paramMap.put("url_text", CommonUtil.nvl(reqMap.get("url_text"))); //URL 링크 내용
			    paramMap.put("board_sort", board_sort); //게시판 강제순번
			    paramMap.put("view_cnt", view_cnt); //조회수

			    paramMap.put("is_comment", is_comment); //코멘트 여부
			    paramMap.put("comment_reply", tmp_comment_reply); //코멘트 답변 여부

			    paramMap.put("etc_field1", CommonUtil.nvl(reqMap.get("etc_field1"))); //추가항목1
			    paramMap.put("etc_field2", CommonUtil.nvl(reqMap.get("etc_field2"))); //추가항목2
			    paramMap.put("etc_field3", CommonUtil.nvl(reqMap.get("etc_field3"))); //추가항목3
			    paramMap.put("etc_field4", CommonUtil.nvl(reqMap.get("etc_field4"))); //추가항목4
			    paramMap.put("etc_field5", CommonUtil.nvl(reqMap.get("etc_field5"))); //추가항목5
			    paramMap.put("reg_ip", servletRequest.getRemoteAddr()); //등록자 IP

			    if (CommonUtil.nvl(reqMap.get("mode")).equals("w") || CommonUtil.nvl(reqMap.get("mode")).equals("r")) { //INSERT, REPLY 처리일 경우

			    	comment_id = dbSvc.dbInt("board.boardNextValue"); //게시판 시퀀스 가져오기

			    	if (CommonUtil.nvl(reqMap.get("mode")).equals("w")) {
			    		board_num = dbSvc.dbInt(reqMap, "board.boardNum"); //board_num
			    	}

				    paramMap.put("reg_id", userid); //작성자(회원) ID
				    paramMap.put("reg_id_seq", userseq); //작성자(회원) 시퀀스
				    paramMap.put("reg_name", username); //작성자
				    paramMap.put("reg_pwd", pwd); //패스워드
				    paramMap.put("user_di", user_di); //본인확인 인증 DI 값
				    paramMap.put("board_num", boardViewMap.get("BOARD_NUM")); //게시판 번호 설정
				    paramMap.put("board_parent", seq); //게시판 부모계층 확인
				    paramMap.put("board_reply", board_reply); //게시판 번호 계층
				    paramMap.put("comment_cnt", tmp_comment); //코멘트 갯수
				    paramMap.put("brd_no", comment_id); //게시판 시퀀스 번호

				    dbSvc.dbInsert(paramMap, "board.boardInsert"); //최종 INSERT
				    reqMap.put("comment_cnt_value", " COMMENT_CNT + 1 "); //코멘트 + 1
				    dbSvc.dbUpdate(reqMap, "board.boardCommentCntUpdate"); //원글 코멘트 갯수 업데이트

			    } else if (CommonUtil.nvl(reqMap.get("mode")).equals("u")) { //UPDATE 처리일 경우

			    	Map commentdbMap = dbSvc.dbDetail(reqMap,"board.boardCommentDetail"); //코멘트 내용 가져오기
			    	tmp_comment = CommonUtil.getNullInt(commentdbMap.get("COMMENT_CNT"), 0);
			    	int len = CommonUtil.nvl(commentdbMap.get("COMMENT_REPLY")).length();
			    	if (len <= 0) len = 0;
			    	String comment_reply = CommonUtil.nvl(commentdbMap.get("COMMENT_REPLY")).substring(0, len);

			    	Map paramMapcheck = new HashMap();
			    	paramMapcheck.put("comment_reply", comment_reply);
			    	paramMapcheck.put("comment_id", comment_id);
			    	paramMapcheck.put("brd_no", seq);
			    	paramMapcheck.put("comment_cnt", tmp_comment);
			    	int checkCount = dbSvc.dbInt(paramMapcheck, "board.boardCommentCheck");

			    	if (checkCount > 1) {
			        	CommonUtil.alertMsgBack(servletResponse, "이 댓글와 관련된 답변댓글이 존재하므로 수정 할 수 없습니다.") ;
			        	return null;
			    	}

			    	dbSvc.dbInsert(paramMap, "board.boardUpdate"); //최종 UPDATE
			    }

	        } catch (RuntimeException e) {
	            LOGGER.error(e.getMessage());

	        } catch(IOException e) {
	    		LOGGER.error(e.getMessage());

	    	} catch(Exception e) {
	    		LOGGER.error(e.getMessage());
	    	}

			servletRequest.setAttribute( "reqMap", reqMap);
			strUrl = CommonUtil.nvl(reqMap.get("returl"));
			strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "") + "&seq=" + CommonUtil.nvl(reqMap.get("seq"));
			if (!CommonUtil.nvl(reqMap.get("viewpass")).equals("")) strUrl += "&viewpass=" + reqMap.get("viewpass");

		    return  "redirect:" + strUrl;
		}

			   /**
		  * Method Summary. <br>
		  * 댓글 삭제 처리 method.
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
		@RequestMapping( value= "/commentDelete.do" )
		 public String commentDelete(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

		     Map reqMap = CommonUtil.getRequestMap( servletRequest );
		     String strUrl = CommonUtil.getNullTrans(reqMap.get("returl"), "/");

		     try {
		         servletRequest.setAttribute("reqMap", reqMap);
		         Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "USER");

				int userLevel = 1; //기본 레벨
				String userid = "guest"; //기본 아이디

				if (userMap != null) {
					userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
					userid = CommonUtil.nvl(userMap.get("USER_ID"));
				}

            	if (userLevel < 10) { //관리자가 아닐 경우 검증시작

            		Map paramMap = new HashMap();
            		 paramMap.put("brd_no", reqMap.get("comment_id"));

	            	if (!CommonUtil.nvl(reqMap.get("req_pwd")).equals("")) {

	            		paramMap.put("req_pwd", reqMap.get("req_pwd"));
	    			    int checkCount = dbSvc.dbCount(paramMap, "board.guestCheckBoard"); //게시판 비번 확인
	    			    if (checkCount < 1) { //비밀번호가 맞지 않으면
	    		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치하지 않습니다.") ;
	    		        	return null;
	    			    }

	            	} else { //비밀번호 없이 인증으로 들어온 경우
	            		
	            		 if (userid.equals("guest")) { //비로그인시 
			     	        	CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 글만 삭제할수 있습니다.");
			    	        	return null;
	            		 } else {
			        		 paramMap.put("user_id", userid);
			        		 int checkCount = dbSvc.dbCount(paramMap,"board.userCheckBoard");
	
			        		 if (checkCount == 0) {
			     	        	CommonUtil.alertMsgBack(servletResponse, "본인이 작성한 글만 삭제할수 있습니다.");
			    	        	return null;
			        		 }
	            		 }
	            	}
            	}

				reqMap.put("brd_no", reqMap.get("comment_id"));
				dbSvc.dbDelete(reqMap, "board.boardDelete"); //코멘트 삭제

				Map paramMap = new HashMap();
				paramMap.put("comment_cnt_value", " COMMENT_CNT - 1 ");
				paramMap.put("brd_no", reqMap.get("seq"));
				dbSvc.dbDelete(paramMap, "board.boardCommentCntUpdate"); //원글 코멘트 -1;

				String strParam = CommonUtil.nvl( reqMap.get( "param" ), "");

		         strUrl = CommonUtil.nvl(reqMap.get("returl"));
		         if (strUrl.equals("")) strUrl = "/view.do";
		         strUrl += "?" + strParam + "&seq=" + CommonUtil.nvl(reqMap.get("seq"));
		         if (!CommonUtil.nvl(reqMap.get("viewpass")).equals("")) strUrl += "&viewpass=" + reqMap.get("viewpass");

	        } catch (RuntimeException e) {
	            LOGGER.error(e.getMessage());

	        } catch(IOException e) {
	    		LOGGER.error(e.getMessage());

	    	} catch(Exception e) {
	    		LOGGER.error(e.getMessage());
	    	}

		     return "redirect:" + strUrl;
		}


		 /**
	     * Method Summary. <br>
	     * 비밀번호 입력 페이지 컨트롤러  method.
	     * @param servletRequest HttpServletRequest 객체
	     * @param servletResponse HttpServletResponse 객체
	     * @return ActionForward 객체 -  정보
	     * @throws e Exception
	     * @since 1.00
	     * @see
	     */
	    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
		@RequestMapping( value="/password.do" )
	    public String password(HttpServletRequest servletRequest,
	            HttpServletResponse servletResponse) throws Exception {

	        HttpSession session = servletRequest.getSession( false );
	        Map reqMap = CommonUtil.getRequestMap( servletRequest );
	        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");

	        int userLevel = 1;
	        if (userMap != null) userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);

	        try {

	        	String mode = CommonUtil.nvl(reqMap.get("mode"));
	        	String returl = "";
	        	if (mode.equals("pwmodify")) { //게시판 수정
	        		returl = "write.do";
	        	} else if (mode.equals("pwdelete")) { //게시판 삭제
	        		returl = "boardDelete.do";
	        	} else if (mode.equals("pwview")) { //게시판 뷰 (비밀글)
	        		returl = "view.do";
	        	} else if (mode.equals("commentDelete")) { //코멘트 삭제
	        		returl = "commentDelete.do";
	        	}

	        	reqMap.put("returl", returl);
	        	servletRequest.setAttribute("reqMap", reqMap);

	        } catch (RuntimeException e) {
	            LOGGER.error(e.getMessage());

	    	} catch(Exception e) {
	    		LOGGER.error(e.getMessage());
	    	}

	        return  CommDef.APP_PATH +  "/board/common/password";
	    }

		 /**
	     * Method Summary. <br>
	     * 비밀번호 확인 컨트롤러  method.
	     * @param servletRequest HttpServletRequest 객체
	     * @param servletResponse HttpServletResponse 객체
	     * @return ActionForward 객체 -  정보
	     * @throws e Exception
	     * @since 1.00
	     * @see
	     */
	    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
		@RequestMapping( value="/passwordChk.do" )
	    public String passwordChk(HttpServletRequest servletRequest,
	            HttpServletResponse servletResponse) throws Exception {

	        HttpSession session = servletRequest.getSession( false );
	        Map reqMap = CommonUtil.getRequestMap( servletRequest );
	        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");
	        Map brdMgrMap = new HashMap();

	        String pwd = "";
	        int userLevel = 1;
	        if (userMap != null) userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);

	        try {

	        	//비밀번호 검수 후 URL 리턴
			    reqMap.put("brd_mgrno", reqMap.get("boardno"));
			    if (CommonUtil.nvl(reqMap.get("mode")).equals("commentDelete")) { //코멘트 로직일 경우
			    	reqMap.put("brd_no", reqMap.get("comment_id"));
			    } else {
			    	reqMap.put("brd_no", reqMap.get("seq"));
			    }
			    pwd = SHA256Encode.Encode(CommonUtil.nvl(reqMap.get("pwd"))); //비밀번호 암호화
			    reqMap.put("req_pwd", pwd);

			    int checkCount = dbSvc.dbCount(reqMap, "board.guestCheckBoard"); //게시판 비번 확인
			    if (checkCount < 1) { //비밀번호가 맞지 않으면
		        	CommonUtil.alertMsgBack(servletResponse, "비밀번호가 일치 하지 않습니다.") ;
		        	return null;
			    }

			    reqMap.put("passok", "Y");
			    brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail"); //게시판 설정 조회

	        } catch (RuntimeException e) {
	            LOGGER.error(e.getMessage());

	        } catch(IOException e) {
	    		LOGGER.error(e.getMessage());

	    	} catch(Exception e) {
	    		LOGGER.error(e.getMessage());
	    	}

	        formSubmit(servletResponse, reqMap); //form 전송

	        return null;
	    }

	    /**
	     * 비밀번호 확인 페이지에서 POST 전송
	     * @param response
	     * @param reqMap
	     * @return
	     */
		private void formSubmit(HttpServletResponse response,  Map reqMap) {
            try {
			   		response.setContentType("text/html;charset=utf-8");

					PrintWriter output = response.getWriter();

					output.println("<html>");
					output.println("<head>");
					output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
					output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

					output.println("<form name='frm' method='post' action='/" + CommonUtil.nvl(reqMap.get("returl")) +"'>");
					output.println("<input type='hidden' name='menuno' value='" + CommonUtil.nvl(reqMap.get("menuno")) + "'>");
					output.println("<input type='hidden' name='comment_id' value='" + CommonUtil.nvl(reqMap.get("comment_id")) + "'>");
					output.println("<input type='hidden' name='param' value='" + CommonUtil.nvl(reqMap.get("param")) + "'>");
					output.println("<input type='hidden' name='category' value='" + CommonUtil.nvl(reqMap.get("category")) + "'>");
					output.println("<input type='hidden' name='page_now' value='" + CommonUtil.nvl(reqMap.get("page_now")) + "'>");
					output.println("<input type='hidden' name='req_pwd' value='" + CommonUtil.nvl(reqMap.get("req_pwd")) + "'>");
					output.println("<input type='hidden' name='boardno' value='" + CommonUtil.nvl(reqMap.get("boardno")) + "'>");
					output.println("<input type='hidden' name='keykind' value='" + CommonUtil.nvl(reqMap.get("keykind")) + "'>");
					output.println("<input type='hidden' name='keyword' value='" + CommonUtil.nvl(reqMap.get("keyword")) + "'>");
					output.println("<input type='hidden' name='req_pwd' value='" + CommonUtil.nvl(reqMap.get("req_pwd")) + "'>");
					output.println("<input type='hidden' name='seq' value='" + CommonUtil.nvl(reqMap.get("seq")) + "'>");
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

	    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
		@RequestMapping( value="/minwon.do" )
	    public String minwon(HttpServletRequest servletRequest,
	            HttpServletResponse servletResponse) throws Exception {

	        HttpSession session = servletRequest.getSession( false );
	        Map reqMap = CommonUtil.getRequestMap( servletRequest );
	        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");

	        int userLevel = 1;
	        if (userMap != null) userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);

	        try {

	        	String mode = CommonUtil.nvl(reqMap.get("mode"));
	        	String returl = "";
	        	if (mode.equals("pwmodify")) { //게시판 수정
	        		returl = "write.do";
	        	} else if (mode.equals("pwdelete")) { //게시판 삭제
	        		returl = "boardDelete.do";
	        	} else if (mode.equals("pwview")) { //게시판 뷰 (비밀글)
	        		returl = "view.do";
	        	} else if (mode.equals("list")) { //게시판 리스트
	        		returl = "board.do";
	        	}

	        	reqMap.put("returl", returl);
	        	servletRequest.setAttribute("reqMap", reqMap);

	        } catch (RuntimeException e) {
	            LOGGER.error(e.getMessage());

	    	} catch(Exception e) {
	    		LOGGER.error(e.getMessage());
	    	}

	        return  CommDef.APP_PATH +  "/board/common/minwon";
	    }

	    @SuppressWarnings({ "unused", "rawtypes", "unchecked" })
		@RequestMapping( value="/minwonChk.do" )
	    public String minwonChk(HttpServletRequest servletRequest,
	            HttpServletResponse servletResponse) throws Exception {

	        HttpSession session = servletRequest.getSession( false );
	        Map reqMap = CommonUtil.getRequestMap( servletRequest );
	        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"USER");
	        Map brdMgrMap = new HashMap();

	        String pwd = "";
	        int userLevel = 1;
	        if (userMap != null) userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);

	        try {

	        	if (!reqMap.get("mode").equals("list")) {
		        	//비밀번호 검수 후 URL 리턴
				    reqMap.put("brd_mgrno", reqMap.get("boardno"));
				    reqMap.put("brd_no", reqMap.get("seq"));
				    pwd = SHA256Encode.Encode(CommonUtil.nvl(reqMap.get("pwd"))); //비밀번호 암호화
				    reqMap.put("req_pwd", pwd);

				    int checkCount = dbSvc.dbCount(reqMap, "board.guestCheckBoard"); //게시판 비번 확인
				    if (checkCount < 1) { //비밀번호가 맞지 않으면
			        	CommonUtil.alertMsgBack(servletResponse, "입력하신 내용이 일치 하지 않습니다.") ;
			        	return null;
				    }

				    reqMap.put("passok", "Y");
				    brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail"); //게시판 설정 조회
	        	}

	        } catch (RuntimeException e) {
	            LOGGER.error(e.getMessage());

	        } catch(IOException e) {
	    		LOGGER.error(e.getMessage());

	    	} catch(Exception e) {
	    		LOGGER.error(e.getMessage());
	    	}

	        minwonformSubmit(servletResponse, reqMap); //form 전송

	        return null;
	    }

		private void minwonformSubmit(HttpServletResponse response,  Map reqMap) {
            try {
			   		response.setContentType("text/html;charset=utf-8");

					PrintWriter output = response.getWriter();

					output.println("<html>");
					output.println("<head>");
					output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
					output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

					output.println("<form name='frm' method='post' action='/" + CommonUtil.nvl(reqMap.get("returl")) +"'>");
					if (reqMap.get("mode").equals("list")) {
						output.println("<input type='hidden' name='boardno' value='" + CommonUtil.nvl(reqMap.get("boardno")) + "'>");
						output.println("<input type='hidden' name='menuno' value='" + CommonUtil.nvl(reqMap.get("menuno")) + "'>");
						output.println("<input type='hidden' name='page_now' value='" + CommonUtil.nvl(reqMap.get("page_now")) + "'>");
						output.println("<input type='hidden' name='name' value='" + CommonUtil.nvl(reqMap.get("name")) + "'>");
						output.println("<input type='hidden' name='tel' value='" + CommonUtil.nvl(reqMap.get("tel")) + "'>");
					} else {
						output.println("<input type='hidden' name='menuno' value='" + CommonUtil.nvl(reqMap.get("menuno")) + "'>");
						output.println("<input type='hidden' name='param' value='" + CommonUtil.nvl(reqMap.get("param")) + "'>");
						output.println("<input type='hidden' name='page_now' value='" + CommonUtil.nvl(reqMap.get("page_now")) + "'>");
						output.println("<input type='hidden' name='req_pwd' value='" + CommonUtil.nvl(reqMap.get("req_pwd")) + "'>");
						output.println("<input type='hidden' name='boardno' value='" + CommonUtil.nvl(reqMap.get("boardno")) + "'>");
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

		//변수 설정
	    @Value("${smtp.toEmail}")
		private String smtpToEmail; //받는 사람 이메일

		@Value("${smtp.fromEmail}")
		private String smtpFromEmail; //보내는 사람 이메일

		@Value("${smtp.server}")
		private String smtpServer; //발송 smtp 서버

		@Value("${smtp.port}")
		private String smtpPort; //발송 포트

		@Value("${smtp.id}")
		private String smtpId; //발송 아이디

		@Value("${smtp.pw}")
		private String smtpPw;  //발송 아이디 비밀번호

		 /**
	     * Method Summary. <br>
	     * 이메일발송 실행  method.
	     * @param servletRequest HttpServletRequest 객체
	     * @param servletResponse HttpServletResponse 객체
	     * @return ActionForward 객체 -  정보
	     * @throws e Exception
	     * @since 1.00
	     * @see
	     */
	    @SuppressWarnings("deprecation")
		private void userSendMail(HttpServletRequest request, Map reqMap) {

	  	   String strFilePath = request.getRealPath("/");
	  	   String strDomainUrl = CommonUtil.getDomainSSLUrl(request);
	  	   String strCont = CommonUtil.getFileRead(strFilePath + "/common/online.html");

	  	   strCont = strCont.replaceAll("<!--domain_url-->", strDomainUrl);
	  	   strCont = strCont.replaceAll("<!-- content -->",  CommonUtil.recoveryLtGt(CommonUtil.nvl(reqMap.get("content")).replaceAll("\r\n", "<br/>")));
	  	   strCont = strCont.replaceAll("<!-- company_name -->", CommDef.CONFIG_COMPANY);
	  	   strCont = strCont.replaceAll("<!-- config_year -->", CommDef.CONFIG_YEAR);
	  	   strCont = strCont.replaceAll("<!-- today -->", CommonUtil.getCurrentDate("","YYYY-MM-DD"));
	  	   strCont = strCont.replaceAll("<!-- config_tel -->", CommDef.CONFIG_TEL);

	        Map<String, Object> param = new HashMap<String, Object>();
	        param.put("smtpSubject", "[" + CommDef.CONFIG_COMPANY + "] " + reqMap.get("reg_name") + "님의 민원신고 입니다.");
	        param.put("smtpContents", strCont);
	        param.put("smtpToEmail", smtpToEmail);
	        param.put("smtpFromEmail", smtpFromEmail);
	        param.put("smtpServer", smtpServer);
	        param.put("smtpPort", smtpPort);
	        param.put("smtpId", smtpId);
	        param.put("smtpPw", smtpPw);

	        SendMail.mailRun(param);
	     }

}
