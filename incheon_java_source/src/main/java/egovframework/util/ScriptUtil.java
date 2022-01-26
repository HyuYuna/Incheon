package egovframework.util;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ScriptUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScriptUtil.class);

   	public static Object showText(HttpServletResponse response, String strText) throws IOException{

   		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();
		output.println(strText);

		output.flush();
		output.close();

		return null;
	}


   	public static Object showTextPrint(HttpServletResponse response, String strText) throws IOException{

   		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();
		output.print(strText);

		output.flush();
		output.close();

		return null;
	}

	public static Object alertMsg(HttpServletResponse response, String msg) throws IOException{

   		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<script type='text/javascript' >");
		output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
		output.println("</script>");


		output.flush();
		output.close();

		return null;
	}
   	public static Object alertGoParentUrl(HttpServletResponse response, String returnUrl) throws IOException{

   		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<script type='text/javascript' >");
		output.println("window.opener.location.href='" + returnUrl+"';");
		output.println("window.close();");
		output.println("</script>");

		output.flush();
		output.close();

		return null;
	}

   	public static Object alertGoParentScript(HttpServletResponse response, String targetNm, String returnFunc) throws IOException{

		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<script type='text/javascript' >");
		output.println("window.opener.name='"+targetNm+"';");
		output.println("window.opener.location.href='javascript:"+returnFunc+";';");
		output.println("window.opener.name='';");
		output.println("window.close();");
		output.println("</script>");


		output.flush();
		output.close();

		return null;
	}


	public static Object alertMsgGoParentUrl(HttpServletResponse response, String msg, String returnUrl) throws IOException{

   		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<script type='text/javascript' >");
		output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
		//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
		output.println("window.opener.location.href='" + returnUrl+"';");
		output.println("window.close();");
		output.println("</script>");


		output.flush();
		output.close();

		return null;
	}


	public static Object alertMsgGoParentFunc(HttpServletResponse response, String msg, String strFunc) throws IOException{

   		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<script type='text/javascript' >");

		if (!"".equals(msg))
		{
		   output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
		}
		//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
		output.println("window.parent." + strFunc+";");
		output.println("window.close();");
		output.println("</script>");

		output.flush();
		output.close();

		return null;
	}

	public static String alertPageLoginGoUrl(HttpServletResponse response, String strUrl) {
		StringBuffer sbBuf = new StringBuffer();

		try {
		   		sbBuf.append("<form name='frmLogin' method='post' action='/'>");
		   		sbBuf.append("<input type='hidden' name='returnurl' value='" + strUrl + "'>");
		   		sbBuf.append("</form>");
		   		sbBuf.append("<script type='text/javascript' >");
		   		sbBuf.append("alert('로그인 하여 주십시오');");
				//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
		   		sbBuf.append("   frmLogin.submit(); ");
		   		sbBuf.append("</script>");
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(Exception e) {
    		LOGGER.error(e.getMessage());

    	}
		return sbBuf.toString();
	}

	public static Object alertFrontLoginGoUrl(HttpServletResponse response) {
		alertLoginGoUrl( response, "/index.do");

		return null;
	}


	public static Object alertLoginGoUrl(HttpServletResponse response,  String returnUrl) {
        try {
		   		response.setContentType("text/html;charset=utf-8");

				PrintWriter output = response.getWriter();
				output.println("<form name='frmLogin' method='post' action='/'>");
				output.println("<input type='hidden' name='returnurl' value='" + returnUrl + "'>");
				output.println("</form>");
				output.println("<script type='text/javascript' >");
				output.println("alert('로그인 하여 주십시오');");
				//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
				output.println("   frmLogin.submit(); ");
				output.println("</script>");
				output.flush();
				output.close();
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());

    	}

		return null;
	}

	public static Object alertMsgGoUrl(HttpServletResponse response, String msg, String returnUrl) throws IOException{
        try {
		   		response.setContentType("text/html;charset=utf-8");

				PrintWriter output = response.getWriter();

				output.println("<script type='text/javascript' >");
				output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
				//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
				output.println("window.location.href='" + returnUrl+"';");
				output.println("</script>");

				output.flush();
				output.close();
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());

    	}

		return null;
	}


	public static Object alertMsgFunc(HttpServletResponse response, String msg, String strFuncNm ) throws IOException{
        try {
		   		response.setContentType("text/html;charset=utf-8");

				PrintWriter output = response.getWriter();

				output.println("<script type='text/javascript' >");
				output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
				//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
				output.println(strFuncNm);
				output.println("</script>");


				output.flush();
				output.close();
  	  } catch (NullPointerException e) {
		  LOGGER.error(e.getMessage());
	  } catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

		return null;
	}

	public static Object alertMsgConfirmUrl(HttpServletResponse response, String msg, String yesUrl, String cancelUrl) throws IOException{

   		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<script type='text/javascript' >");
		output.println("if(confirm('"+msg.replaceAll("\\'", "\\\"")+"')) {");
		//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
		output.println("window.location.href='" + yesUrl+"';");
		output.println("} else { ");
		output.println("window.location.href='" + cancelUrl+"';");
		output.println("}</script>");


		output.flush();
		output.close();

		return null;
	}

	public static Object alertMsgClose(HttpServletResponse response, String msg) throws IOException{

		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<script type='text/javascript'>");
		output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
		//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
		output.println("window.close();");
		output.println("</script>");


		output.flush();
		output.close();

		return null;
	}

	public static Object alertMsgBack(HttpServletResponse response, String msg) throws IOException{

		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();
		output.println("<script type='text/javascript' charset='utf-8'>");
		output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
		//output.println("alert('"+kscToAsc1(msg).replaceAll("\\'", "\\\"")+"');");
		output.println("window.history.back();");
		output.println("</script>");
		output.flush();
		output.close();

		return null;
	}
}

