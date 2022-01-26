package egovframework.controller;

import java.io.File;
import java.io.IOException;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import egovframework.db.DbController;
import egovframework.util.CommDef;
import egovframework.util.CommonUtil;
import egovframework.util.SHA256Encode;
import egovframework.util.SessionUtil;
import egovframework.util.UploadUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Class Summary. <br>
 * 관리자 게시판 class.
 * @since 1.00
 * @version 1.00 - 2019. 07. 28
 * @author 김태균
 * @see
 */

@Controller
public class AdminBoardController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminBoardController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	private final String mTableName = "TB_BOARD";	// 테이블 명

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
    @SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	@RequestMapping( value= CommDef.ADM_PATH + "/board/boardList.do" )
    public String boardList(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        Map brdMgrMap = new HashMap();

        String strBrdMgrno = CommonUtil.nvl(reqMap.get("brd_mgrno"));
        String order_cd = "";

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

        	Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"ADM");

        	int nPageRow     = dbSvc.getPageRowCount(reqMap, "page_row"); //사용자 스킨에서만 적용
            int nRowStartPos = nPageRow * ( dbSvc.getPageNow(reqMap, "page_now") - 1 );  // Row의 시작위치

            if ( !"".equals(strBrdMgrno))
            {
            	 brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail");
            	 order_cd = CommonUtil.nvl(brdMgrMap.get("ORDER_CD"));
            }

            //목록보기 권한 체크
            if (CommonUtil.getNullInt(brdMgrMap.get("LIST_LEVEL_CD"), 0) > CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 0)) {
	        	CommonUtil.alertMsgBack(servletResponse, "게시판 목록보기 권한이 없습니다.") ;
	        	return null;
            }

            if ( "".equals(strBrdMgrno))
            	reqMap.put("brd_mgrno", "-1");

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

            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "brdMgrMap", brdMgrMap);
            servletRequest.setAttribute( "noticeList", noticeList);

            reqMap.put("notice_yn", "N");
            servletRequest.setAttribute( "count",  Integer.toString(  dbSvc.dbCount( reqMap, "board.boardListCount" ) ) );
            servletRequest.setAttribute( "list",   dbSvc.dbPagingList( reqMap, "board.boardList", nRowStartPos ,nPageRow) );

	  	  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

        return  CommDef.ADM_PATH +  "/board/boardList";

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
	@RequestMapping( value= CommDef.ADM_PATH + "/board/boardWrite.do" )
    public String boardWrite(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map dbMap = new HashMap();
        Map brdMgrMap = new HashMap();
        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"ADM");

        String seq = CommonUtil.nvl(reqMap.get("seq"));
        String strBrdMgrno = CommonUtil.nvl(reqMap.get("brd_mgrno"));
        String strIFlag = CommonUtil.nvl(reqMap.get("iflag"));

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return "";
        	}

            if ( !"".equals(strBrdMgrno)) { //게시판 세팅 정보
            	 brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail");
            }

            //게시글 작성 권한 체크
            if (CommonUtil.getNullInt(brdMgrMap.get("WRITE_LEVEL_CD"), 0) > CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 0)) {
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
	            	dbMap = dbSvc.dbDetail(reqMap, "board.boardDetail");
	            	if ( dbMap != null)
	            		reqMap.put("iflag", CommDef.ReservedWord.UPDATE);

	            	//첨부파일 가져오기
	                reqMap.put("rel_tbl", mTableName);
	                reqMap.put("rel_key", seq);

	            	servletRequest.setAttribute( "lstFile",   dbSvc.dbList(reqMap, "common.getUploadFile") );
	            }
            }

	  	  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

        servletRequest.setAttribute( "reqMap", reqMap);
        servletRequest.setAttribute( "brdMgrMap", brdMgrMap);
        servletRequest.setAttribute( "dbMap", dbMap);

        return  CommDef.ADM_PATH +  "/board/boardWrite";
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
	@SuppressWarnings({ "rawtypes", "unused", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/board/boardWork.do" )
	public String boardWork(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

		String strUrl = "";
	    HttpSession session = servletRequest.getSession( false );
	    Map reqMap = CommonUtil.getRequestMap( servletRequest );

    	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
    		return "";
    	}

	    try {

		    Map paramMap = new HashMap();
		    Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"ADM");
		    int seq = CommonUtil.getNullInt(reqMap.get("seq"), 0); //시퀀스 초기화
		    String pwd = SHA256Encode.Encode(CommonUtil.shufflePasswd(10)); //패스워드 랜덤 생성 (SHA256 Encode 로 암호화)
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
		    String reg_dt = CommonUtil.nvl(reqMap.get("reg_dt")).replace("-", "") + CommonUtil.nvl(reqMap.get("reg_dt_time"));

		    Map brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail"); //게시판 설정 조회

		    //해당 게시판 폴더 생성
		    String BRD_UPLOADPATH =  "/upload/board/" + CommonUtil.nvl(brdMgrMap.get("BRD_MGRNO")) + "/";
		   	File folder = new File(BRD_UPLOADPATH);

		   	if (!folder.exists()) { //폴더 생성
		   		try { folder.mkdir(); } catch (Exception e) { e.getStackTrace(); }
		   	}

		    //REPLY 처리일 경우 기본 체크
	    	if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.REPLY)) {

	    		reqMap.put("brd_no", seq);
	    		Map boardViewMap = dbSvc.dbDetail(reqMap, "board.boardDetail"); //게시판 내용 조회

	    		if (CommonUtil.nvl(boardViewMap.get("NOTICE_YN")).equals("Y")) { //공지사항인지 체크
		        	CommonUtil.alertMsgBack(servletResponse, "공지에는 답변을 달수 없습니다.") ;
		        	return null;
	    		}

	    		if (CommonUtil.getNullInt(brdMgrMap.get("REPLY_LEVEL_CD"), 0) > CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 0)) { //답변 권한 레벨 체크
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
		    paramMap.put("reg_dt", reg_dt);

		    if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.INSERT) || CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.REPLY)) { //INSERT, REPLY 처리일 경우

		    	seq = dbSvc.dbInt("board.boardNextValue"); //게시판 시퀀스 가져오기

		    	if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.INSERT)) {
		    		paramMap.put("ori_reg_id", userMap.get("USER_ID")); //원글작성자 아이디
		    		board_num = dbSvc.dbInt(reqMap, "board.boardNum"); //board_num
		    	}

			    paramMap.put("reg_id", CommonUtil.nvl(userMap.get("USER_ID"))); //작성자(회원) ID
			    paramMap.put("reg_id_seq", CommonUtil.nvl(userMap.get("SEQ"))); //작성자(회원) 시퀀스
			    paramMap.put("reg_pwd", pwd); //패스워드
			    paramMap.put("user_di", user_di); //본인확인 인증 DI 값
			    paramMap.put("board_num", board_num); //게시판 번호 설정
			    paramMap.put("board_parent", seq); //게시판 부모계층 확인
			    paramMap.put("board_reply", board_reply); //게시판 번호 계층
			    paramMap.put("comment_cnt", 0); //코멘트 갯수
			    paramMap.put("brd_no", seq); //게시판 시퀀스 번호
			    dbSvc.dbInsert(paramMap, "board.boardInsert"); //최종 INSERT

		    } else if (CommonUtil.nvl(reqMap.get("iflag")).equals(CommDef.ReservedWord.UPDATE)) { //UPDATE 처리일 경우

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

		  } catch (IOException e) {
			  LOGGER.error(e.getMessage());
		  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

	    servletRequest.setAttribute( "reqMap", reqMap);
        strUrl = CommonUtil.nvl(reqMap.get("returl"));
        strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

	    return  "redirect:" + strUrl;
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
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping( value= CommDef.ADM_PATH + "/board/boardDelete.do" )
    public String boardDelete(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        String strUrl = CommonUtil.getNullTrans(reqMap.get("returl"), "/");

        try {
            servletRequest.setAttribute("reqMap", reqMap);
            Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");

            if (sesMap == null ) {

            	strUrl = CommonUtil.nvl(reqMap.get("listpage"), "/");
            	strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

            	CommonUtil.alertLoginGoUrl(servletResponse, strUrl);
            	return null;
            } else {

                UploadUtil upUtil = new UploadUtil(servletRequest);
                upUtil.setDbDao(dbSvc.m_dao); //DB연결자

            	if (CommonUtil.nvl(reqMap.get("mode")).equals("del")) {

            		reqMap.put("brd_no", reqMap.get("seq"));
            		dbSvc.dbDelete(reqMap, "board.boardDelete");
            		dbSvc.dbDelete(reqMap, "board.boardCommentDelete"); //코멘트 삭제

            		Map paramMap = new HashMap();
                	paramMap.put("rel_tbl", mTableName);
                	paramMap.put("rel_key", CommonUtil.nvl(reqMap.get("brd_no")));
                	upUtil.removeFile(paramMap);

            	} else if (CommonUtil.nvl(reqMap.get("mode")).equals("multidel")) { //다중 삭제일 경우


                	if(servletRequest.getParameterValues("seqno").length > 1){

                		String[] seqNo = (String[])reqMap.get("seqno");

                		for (String seq : seqNo) {
        	        		Map paramMap = new HashMap();
        	        		paramMap.put("brd_no", seq);

        	        		dbSvc.dbDelete(paramMap, "board.boardDelete");
        	        		dbSvc.dbDelete(paramMap, "board.boardCommentDelete"); //코멘트 삭제

                    		Map paramFileMap = new HashMap();
                    		paramFileMap.put("rel_tbl", mTableName);
                    		paramFileMap.put("rel_key", seq);
                        	upUtil.removeFile(paramFileMap);

                		}
                	} else {
                		reqMap.put("brd_no", reqMap.get("seqno"));
                		dbSvc.dbDelete(reqMap, "board.boardDelete");
                		dbSvc.dbDelete(reqMap, "board.boardCommentDelete"); //코멘트 삭제

                		Map paramMap = new HashMap();
                    	paramMap.put("rel_tbl", mTableName);
                    	paramMap.put("rel_key", CommonUtil.nvl(reqMap.get("brd_no")));
                    	upUtil.removeFile(paramMap);

                	}

            	}
            }

            String strParam = CommonUtil.nvl( reqMap.get( "param" ), "" );

            strUrl = CommonUtil.nvl(reqMap.get("returl"));
            strUrl += "?" + strParam;

	  	  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

        return "redirect:" + strUrl;

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
	@RequestMapping( value= CommDef.ADM_PATH + "/board/boardView.do" )
    public String boardView( HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );
        Map brdMgrMap = new HashMap();
        Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"ADM");
        List commentList = null;

        int seq = CommonUtil.getNullInt(reqMap.get("seq"), 0); //시퀀스 초기화
        String strBrdMgrno = CommonUtil.nvl(reqMap.get("brd_mgrno"));

        try {

        	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
        		return null;
        	}

            if ( !"".equals(strBrdMgrno))  // 게시판 설정 불러오기
            	brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail");

            //게시글 보기 권한 체크
            if (CommonUtil.getNullInt(brdMgrMap.get("READ_LEVEL_CD"), 0) > CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 0)) {
	        	CommonUtil.alertMsgBack(servletResponse, "게시글 읽기 권한이 없습니다.") ;
	        	return null;
            }

            reqMap.put("brd_no", seq);

            dbSvc.dbUpdate(reqMap, "board.boardHitUpdate"); //게시판 조회수 업데이트
        	Map detailMap = dbSvc.dbDetail(reqMap, "board.boardDetail");

        	//댓글 리스트 확인
        	if (CommonUtil.nvl(brdMgrMap.get("CMT_USE_YN")).equals("Y")) {
        		commentList = dbSvc.dbList(reqMap, "board.boardCommentList");
        	}

            servletRequest.setAttribute( "brdMgrMap", brdMgrMap);
            servletRequest.setAttribute( "reqMap", reqMap);
            servletRequest.setAttribute( "dbMap", detailMap);
            servletRequest.setAttribute("commentList", commentList);

            reqMap.put("rel_tbl", mTableName);
            reqMap.put("rel_key", seq);

            servletRequest.setAttribute( "lstFile",   dbSvc.dbList(reqMap, "common.getUploadFile") );

	  	  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

        return  CommDef.ADM_PATH +  "/board/boardView";
    }


  /**
  * Method Summary. <br>
  * 게시판 강제순번 업데이트 처리 method.
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
@RequestMapping( value= CommDef.ADM_PATH + "/board/boardUpdate.do" )
 public String boardUpdate(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

     Map reqMap = CommonUtil.getRequestMap( servletRequest );
     String strUrl = CommonUtil.getNullTrans(reqMap.get("returl"), "/");

     try {
         servletRequest.setAttribute("reqMap", reqMap);
         Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");

         if (sesMap == null ) {

         	strUrl = CommonUtil.nvl(reqMap.get("listpage"), "/");
         	strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

         	CommonUtil.alertLoginGoUrl(servletResponse, strUrl);
         	return null;
         } else {

         	if(servletRequest.getParameterValues("seqno").length > 1){

         		String[] seqNo = (String[])reqMap.get("seqno");

         		for (String seq : seqNo) {
 	        		Map paramMap = new HashMap();
 	        		paramMap.put("brd_no", seq);
 	        		paramMap.put("board_sort", reqMap.get("board_sort" + seq));

 	        		dbSvc.dbUpdate(paramMap, "board.boardSortUpdate");
         		}

         	} else {
         		reqMap.put("brd_no", reqMap.get("seqno"));
         		reqMap.put("board_sort", reqMap.get("board_sort" + reqMap.get("seqno").toString()));
         		dbSvc.dbUpdate(reqMap, "board.boardSortUpdate");
         	}
         }

         String strParam = CommonUtil.nvl( reqMap.get( "param" ), "" );

         strUrl = CommonUtil.nvl(reqMap.get("returl"));
         strUrl += "?" + strParam;

	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
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
	@SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	@RequestMapping( value= CommDef.ADM_PATH + "/board/commentUpdate.do" )
	public String commentUpdate(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

		String strUrl = "";
	    HttpSession session = servletRequest.getSession( false );
	    Map reqMap = CommonUtil.getRequestMap( servletRequest );

	 	if ( !CommonUtil.isAdminLogin(servletRequest, servletResponse)) {
	 		return "";
	 	}

	    try {

		    Map paramMap = new HashMap();
		    Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,"ADM");
		    int seq = CommonUtil.getNullInt(reqMap.get("seq"), 0); //시퀀스 초기화
		    int comment_id = CommonUtil.getNullInt(reqMap.get("comment_id"), 0); //코멘트 시퀀스 초기화
		    String pwd = SHA256Encode.Encode(CommonUtil.shufflePasswd(10)); //패스워드 랜덤 생성 (SHA256 Encode 로 암호화)
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


		    Map brdMgrMap = dbSvc.dbDetail(reqMap,  "boardMgr.boardMgrDetail"); //게시판 설정 조회
    		reqMap.put("brd_no", seq);
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

			    paramMap.put("reg_id", CommonUtil.nvl(userMap.get("USER_ID"))); //작성자(회원) ID
			    paramMap.put("reg_id_seq", CommonUtil.nvl(userMap.get("SEQ"))); //작성자(회원) 시퀀스
			    paramMap.put("reg_name", CommonUtil.nvl(userMap.get("USER_NM"))); //작성자
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

		    //민원 게시판일 경우 상태 업데이트
		    if (CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("61")) {
		    	Map uparamMap = new HashMap();

		    	uparamMap.put("brd_no", seq); //게시판 시퀀스 번호
		    	uparamMap.put("etc_field2", "003"); //답변완료
		    	dbSvc.dbUpdate(uparamMap, "board.boardStateUpdate");
		    }

		  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

		servletRequest.setAttribute( "reqMap", reqMap);
		strUrl = CommonUtil.nvl(reqMap.get("returl"));
		strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" ) + "&seq=" + CommonUtil.nvl(reqMap.get("seq"));

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
	 @RequestMapping( value= CommDef.ADM_PATH + "/board/commentDelete.do" )
	 public String commentDelete(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

	     Map reqMap = CommonUtil.getRequestMap( servletRequest );
	     String strUrl = CommonUtil.getNullTrans(reqMap.get("returl"), "/");

	     try {
	         servletRequest.setAttribute("reqMap", reqMap);
	         Map sesMap = (Map)SessionUtil.getSessionAttribute(servletRequest, "ADM");

	         if (sesMap == null ) {

	         	strUrl = CommonUtil.nvl(reqMap.get("listpage"), "/");
	         	strUrl += "?" + CommonUtil.nvl( reqMap.get( "param" ), "" );

	         	CommonUtil.alertLoginGoUrl(servletResponse, strUrl);
	         	return null;
	         } else {

	         	if (CommonUtil.nvl(reqMap.get("mode")).equals("d")) {
	         		reqMap.put("brd_no", reqMap.get("comment_id"));
	         		dbSvc.dbDelete(reqMap, "board.boardDelete"); //코멘트 삭제

	         		Map paramMap = new HashMap();
	         		paramMap.put("comment_cnt_value", " COMMENT_CNT - 1 ");
	         		paramMap.put("brd_no", reqMap.get("seq"));
	         		dbSvc.dbDelete(paramMap, "board.boardCommentCntUpdate"); //원글 코멘트 -1;
	         	}

	         }

	         String strParam = CommonUtil.nvl( reqMap.get( "param" ), "" );

	         strUrl = CommonUtil.nvl(reqMap.get("returl"));
	         strUrl += "?" + strParam + "&seq=" + CommonUtil.nvl(reqMap.get("seq"));

		  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

	     return "redirect:" + strUrl;
	}

	@SuppressWarnings("rawtypes")
	@ResponseBody
	@RequestMapping( value= CommDef.ADM_PATH + "/board/boardStateUpdate.do" )
	public String boardStateUpdate(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {

		Map reqMap = CommonUtil.getRequestMap( servletRequest );
    	String jsonList = "";

    	try {

    		int state = dbSvc.dbUpdate(reqMap, "board.boardStateUpdate");

        	Gson gsonObj = new Gson();
        	jsonList = gsonObj.toJson(state);

  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

    	return jsonList;

	}

}

