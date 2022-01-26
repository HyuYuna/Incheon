package egovframework.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import egovframework.util.ScriptUtil;
import egovframework.db.DbController;
import egovframework.util.CommonUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Class Summary. <br>
 * 공통 class.
 * @since 1.00
 * @version 1.00 - 2011. 01. 20
 * @author 정소선
 * @see
 */

@Controller
public class CommonController  {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonController.class);

	@Resource(name="dbSvc")
	private DbController dbSvc;

	 /**
     * Method Summary. <br>
     * 파일 다운로드  method.
     * @param servletRequest HttpServletRequest 객체
     * @param servletResponse HttpServletResponse 객체
     * @return ActionForward 객체 -  정보
     * @throws e Exception
     * @since 1.00
     * @see
     */
	@SuppressWarnings({ "unused", "rawtypes", "deprecation" })
	@RequestMapping( value="/common/download.do" )
    public void download(HttpServletRequest servletRequest,
            HttpServletResponse servletResponse) throws Exception {

        HttpSession session = servletRequest.getSession( false );
        Map reqMap = CommonUtil.getRequestMap( servletRequest );

        try {
        	dbSvc.dbUpdate(reqMap, "common.updateFileDownCnt"); //다운로드 조회수 업데이트
    		Map fileMap = dbSvc.dbDetail(reqMap, "common.getUploadFile");

            String strFileName     = CommonUtil.nvl(fileMap.get("FILE_NM"));
            String strFileRealName = CommonUtil.nvl(fileMap.get("FILE_REALNM"));
            String strPath     = servletRequest.getRealPath("/");

            PrintStream printstream = new PrintStream(servletResponse.getOutputStream(), true);

		    File file = new File(strPath,strFileRealName);
		    String fileName = CommonUtil.getFileName(strFileName);

		    String header = servletRequest.getHeader("User-Agent");

		    if (header.contains("MSIE") || header.contains("Trident")) {
		        fileName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
		        servletResponse.setHeader("Content-Disposition", "attachment;filename=" + fileName + ";");
		    } else {
		        fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
		        servletResponse.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		    }

		    servletResponse.setContentType(servletRequest.getContentType());
		    servletResponse.setContentLength((int) file.length());
		    servletResponse.setHeader("Content-Type", "application/octet-stream");
		    servletResponse.setContentLength((int)file.length());
		    servletResponse.setHeader("Content-Transfer-Encoding", "binary;");
		    servletResponse.setHeader("Pragma", "no-cache;");
		    servletResponse.setHeader("Expires", "-1;");

		    OutputStream out = servletResponse.getOutputStream();
		    FileInputStream fis = null;

		    try {
		        fis = new FileInputStream(file);
		        FileCopyUtils.copy(fis, out);
	      	  } catch (IOException e) {
	    		  LOGGER.error(e.getMessage());
	    	  } catch (RuntimeException e) {
	    		  LOGGER.error(e.getMessage());
	    	  } catch (Exception e) {
	    		  LOGGER.error(e.getMessage());
	    	  } finally {
		        if (fis != null) {
		            try {
		                fis.close();
			      	  } catch (IOException e) {
			    		  LOGGER.error(e.getMessage());
			    	  } catch (RuntimeException e) {
			    		  LOGGER.error(e.getMessage());
			    	  } catch (Exception e) {
			    		  LOGGER.error(e.getMessage());
			    	  }
		        }
		    }

		    out.flush();

        } catch (Exception e) {
        	LOGGER.error(e.getMessage());
        }

    }

	/**
     * 이미지 업로드
     * @param request
     * @param response
     * @param upload
     */
    @SuppressWarnings("unused")
	@RequestMapping(value = "/common/ckeditorUpload.do")
    public void ckeditorUpload(HttpServletRequest request, HttpServletResponse response, @RequestParam MultipartFile upload) {

        OutputStream out = null;
        PrintWriter printWriter = null;
        response.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");

        try{
        	String strRealPath = request.getSession().getServletContext().getRealPath("/");
            String fileName = upload.getOriginalFilename();
            String strRealName = CommonUtil.getUniqueValue() + "." + CommonUtil.getFileExt(fileName);

            byte[] bytes = upload.getBytes();
            String uploadPath = strRealPath + "/upload/ckeditor/" + strRealName;  //저장경로

            out = new FileOutputStream(new File(uploadPath));
            out.write(bytes);
            String callback = request.getParameter("CKEditorFuncNum");

            printWriter = response.getWriter();
            String fileUrl =  "/upload/ckeditor/" + strRealName;  //url경로

/*            printWriter.println("<script type='text/javascript'>window.parent.CKEDITOR.tools.callFunction("
                    + callback
                    + ",'"
                    + fileUrl
                    + "','이미지를 업로드 하였습니다.'"
                    + ")</script>");*/

            printWriter.println("{"
            		+ "\"uploaded\": 1,"
            		+ "\"fileName\": \"" + strRealName + "\","
            		+ "\"url\": \""+ fileUrl +"\""
            		+ "}");
            printWriter.flush();

        }catch(IOException e){
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
                if (printWriter != null) {
                    printWriter.close();
                }
      	  } catch (NullPointerException e) {
    		  LOGGER.error(e.getMessage());
    	  } catch (IOException e) {
    		  LOGGER.error(e.getMessage());
    	  } catch (RuntimeException e) {
    		  LOGGER.error(e.getMessage());
    	  } catch (Exception e) {
    		  LOGGER.error(e.getMessage());
    	  }
        }
        return;
    }

    //아이디 중복 체크
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping( value="/common/idcheck.do" )
	public void idcheck(HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws Exception {
		Map mapRlt = new HashMap();
		Map reqMap = CommonUtil.getRequestMap( servletRequest );
		reqMap.get("user_id");
		int cnt = 0;
		cnt = dbSvc.dbCount(reqMap, "member.userIdCheck");

		try{
			if (cnt== 0) {
				mapRlt.put("cnt", '0');
			}else if(cnt == 1)
				mapRlt.put("cnt", '1');
		  } catch (NullPointerException e) {
			  LOGGER.error(e.getMessage());
		  } catch (RuntimeException e) {
			  LOGGER.error(e.getMessage());
		  } catch (Exception e) {
			  LOGGER.error(e.getMessage());
		  }

		ScriptUtil.showText(servletResponse, CommonUtil.mapToJson(mapRlt));

	}


  }
