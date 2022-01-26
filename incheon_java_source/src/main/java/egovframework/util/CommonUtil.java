/*
 * Copyright (c) 2008 sosunj. All rights reserved.
 */
package egovframework.util;

import java.awt.Image;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.regex.Pattern;

import javax.imageio.ImageIO;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.MultipartParser;
import com.oreilly.servlet.multipart.ParamPart;
import com.oreilly.servlet.multipart.Part;

import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 * Class Summary. <br>
 * CommonUtil class.
 * @since 1.00
 * @version 1.00 - 2011. 01. 20
 * @author 정소선
 * @see
 */
public class CommonUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonUtil.class);
    /**
     * Method Summary. <br>
     * 서블릿 리퀘스트를 Map으로 변환하여 리턴.
     * @param request 서블릿 리퀘스트
     * @return map map
     * @throws e Exception
     * @since 1.00
     * @see
     */
    private static Random random =  new Random();

    /**
     * Constructor Summary. <br>
     * Constructor Description.
     * @since 1.00
     * @see
     */
    public CommonUtil() { };

    public static boolean isLogin(HttpServletRequest servletRequest, HttpServletResponse servletResponse, String strUrl)
    {
    	return isLogin(servletRequest, servletResponse, strUrl, "USER");
    }

    public static boolean isAdminLogin(HttpServletRequest servletRequest, HttpServletResponse servletResponse)
    {
    	return isLogin(servletRequest, servletResponse, "", "ADM");
    }

    @SuppressWarnings("rawtypes")
	public static boolean isLogin(HttpServletRequest servletRequest, HttpServletResponse servletResponse, String strUrl, String strSesName)
    {
    	boolean bFlag = true;
    	try {
	    	Map userMap = (Map)SessionUtil.getSessionAttribute(servletRequest,strSesName);

	    	if (userMap == null) {
	    		bFlag = false;

	    		if ("ADM".equals(strSesName)) {
	    		    CommonUtil.alertAdminLoginGoUrl(servletResponse, strUrl);
	    		} else {
	    			CommonUtil.alertLoginGoUrl(servletResponse, strUrl);
	    		}
	    	}
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(IOException e) {
    		LOGGER.error(e.getMessage());

    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());

    	}
    	return bFlag;
    }

	public static void alertAdminLoginGoUrl(HttpServletResponse response,  String returnUrl) {
        try {
		   		response.setContentType("text/html;charset=utf-8");

				PrintWriter output = response.getWriter();

				output.println("<html>");
				output.println("<head>");
				output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
				output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

				output.println("<form name='frmLogin' method='post' action='/webadm/index.do'>");
				output.println("<input type='hidden' name='returnurl' value='" + returnUrl + "'>");
				output.println("</form>");
				output.println("<script type='text/javascript' >");
				output.println("alert('로그인 하여 주십시오');");
				//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
				output.println("   frmLogin.submit(); ");
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

	public static void alertLoginGoUrl(HttpServletResponse response,  String returnUrl) {
        try {
		   		response.setContentType("text/html;charset=utf-8");

				PrintWriter output = response.getWriter();

				output.println("<html>");
				output.println("<head>");
				output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
				output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

				output.println("<form name='frmLogin' method='post' action='/10_member/login.jsp'>");
				output.println("<input type='hidden' name='returnurl' value='" + returnUrl + "'>");
				output.println("</form>");
				output.println("<script type='text/javascript' >");
				output.println("alert('로그인 하여 주십시오');");
				//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
				output.println("   frmLogin.submit(); ");
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

	public static void alertLoginGoUrl(HttpServletResponse response,  String strUrl, String returnUrl) {
        try {
		   		response.setContentType("text/html;charset=utf-8");

				PrintWriter output = response.getWriter();

				output.println("<html>");
				output.println("<head>");
				output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
				output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

				output.println("<form name='frmLogin' method='post' action='" + strUrl +"'>");
				output.println("<input type='hidden' name='returnurl' value='" + returnUrl + "'>");
				output.println("</form>");
				output.println("<script type='text/javascript' >");
				output.println("alert('로그인 하여 주십시오');");
				//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
				output.println("   frmLogin.submit(); ");
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

	public static void alertMsgOpenSelfClose(HttpServletResponse response, String msg) throws IOException{
        try {
		   		response.setContentType("text/html;charset=utf-8");

				PrintWriter output = response.getWriter();

				output.println("<html>");
				output.println("<head>");
				output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
				output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

				output.println("<script type='text/javascript' >");
				output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
				//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
				output.println("window.opener.location.reload(true);");
				output.println("self.close()");
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

	public static void alertMsgGoParentFunc(HttpServletResponse response, String msg, String strFunc) throws IOException{

   		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<html>");
		output.println("<head>");
		output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
		output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

		output.println("<script type='text/javascript' >");
		output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
		output.println("window.opener." + strFunc+";");
		output.println("window.close();");
		output.println("</script>");

		output.println("</head>");
		output.println("</html>");

		output.flush();
		output.close();
	}

   	public static void displayText(HttpServletResponse response, String strTxt) throws IOException{

		response.setContentType("text/html;charset=utf-8");

		PrintWriter output = response.getWriter();

		output.println("<html>");
		output.println("<head>");
		output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
		output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

		output.print(strTxt);

		output.println("</head>");
		output.println("</html>");

		output.flush();
		output.close();
	}

    /**
     * Method Summary. <br>
     *  메뉴 구조 XML 생성 method
     * @param servletRequest
     * @param Map
     * @return String
     * @throws
     * @since 1.00
     * @see
     */
 @SuppressWarnings("rawtypes")
public static  String makeMenuXml(HttpServletRequest request, List rsLst) {

	  	 DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	     DocumentBuilder db = null;
	     String LI_TAG = "li";
	     String UL_TAG = "ul";
	     String strVal = "";
	     String ROOT_TAG = "root";

	     if ( rsLst == null || rsLst.isEmpty())
	    	 return "";

	     try{
	         db = dbf.newDocumentBuilder();
	     }catch(ParserConfigurationException e){
    		LOGGER.error(e.getMessage());

	    } catch(Exception e) {
    		LOGGER.error(e.getMessage());

	    }

        try {

            Document doc = db.newDocument();
            Element rootEle = doc.createElement(ROOT_TAG);
            doc.appendChild(rootEle);

            Element child = doc.createElement(LI_TAG);

            child.setAttribute("id", "menu_id_0");
            child.setTextContent("메뉴");
            child.setAttribute("class", "folder expanded");

            rootEle.appendChild(child);

            for (int nLoop=0; nLoop < rsLst.size(); nLoop++) {
            	Map rsMap = (Map)rsLst.get(nLoop);

            	String strTagId    = "menu_id_"     + CommonUtil.nvl(rsMap.get("MENU_NO"));
            	String strTagUId   = "menu_id_"     + CommonUtil.nvl(rsMap.get("UP_MENU_NO"));
            	String strTagGrpId = "grp_menu_id_" + CommonUtil.nvl(rsMap.get("UP_MENU_NO"));
            	String strMenuLvl  =  CommonUtil.nvl(rsMap.get("MENU_LVL"), "1");

            	Node pNode = getFindNode(rootEle, strTagGrpId); // 상위메뉴번호 찾는다.
            	if ( pNode == null ) {
            		pNode = getFindNode(rootEle, strTagUId); // UL 테그 상위메뉴번호 찾는다.
            	}

            	if ( pNode != null && pNode.getChildNodes().getLength() <= 1 ) { // 찾은 Node에 하위 노드가 없는 경우
            		if (LI_TAG.equals(pNode.getNodeName())) {
                        Element childLi = doc.createElement(UL_TAG);
                        childLi.setAttribute("id", strTagGrpId);
                        pNode.appendChild(childLi);

                        pNode = childLi;
            		}
            	}

            	String strMenuNm = CommonUtil.nvl(rsMap.get("MENU_NM"));
            	if ("TAB".equals(CommonUtil.nvl(rsMap.get("MENU_FMT_CD")))) {
            		strMenuNm = "[텝]" + strMenuNm;
            	}
                child = doc.createElement(LI_TAG);

                child.setAttribute("id", strTagId);

                child.setTextContent(strMenuNm);

                if (Integer.parseInt(strMenuLvl) <= 0) { // 처음에 펼치도록 처리함
                	child.setAttribute("class", "folder expanded");
                }

                if ( pNode == null ) {
            	   rootEle.appendChild(child);
                } else {
                	pNode.appendChild(child);
                }

            }

            // XML 구조를 String 구조로 반환
            TransformerFactory tf = TransformerFactory.newInstance( );
            Transformer t = null;
            try
            {
                t = tf.newTransformer( );
            }
            catch ( TransformerConfigurationException e )
            {
        		LOGGER.error(e.getMessage());

        	} catch(Exception e) {
        		LOGGER.error(e.getMessage());

        	}
            t.setOutputProperty( OutputKeys.ENCODING , "utf-8" );
            t.setOutputProperty( OutputKeys.METHOD , "xml" );
            t.setOutputProperty( OutputKeys.INDENT , "yes" );
            t.setOutputProperty( OutputKeys.CDATA_SECTION_ELEMENTS , "yes" );
            StringWriter sw = new StringWriter( );
            try
            {
                t.transform( new DOMSource( doc ) , new StreamResult( sw ) );
            }
            catch ( TransformerException e )
            {
        		LOGGER.error(e.getMessage());

        	} catch(Exception e) {
        		LOGGER.error(e.getMessage());

        	}

            strVal = sw.toString();

        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch ( Exception e) {
        	LOGGER.error(e.getMessage());
        }

        // 메뉴구조에 필요한 부분만 읽음
        String strSRoot = "<" +ROOT_TAG + ">";
        String strERoot = "</" + ROOT_TAG + ">";

        int nFirst = strVal.indexOf(strSRoot);
        int nLast  = strVal.indexOf(strERoot);

        strVal = strVal.substring(0, nLast);
        strVal = strVal.substring(nFirst + strSRoot.length());

        return strVal;

    }

	   /**
	    * Method Summary. <br>
	    * Node 찾기 method
	    * @param Element Root 노드
	    * @param String  찾고자 하는 키
	    * @return void
	    * @throws
	    * @since 1.00
	    * @see
	    */
	 public static  Node getFindNode(Element rootEle, String strFindKey) {
		  // NodeList nodeLst =  rootEle.getChildNodes();
		   Node nodeVal = null;
		   NodeList nodeLst = rootEle.getElementsByTagName("*");


		   for(int nLoop=0; nLoop < nodeLst.getLength(); nLoop++)
		   {
			   Node node = nodeLst.item(nLoop);

			   NamedNodeMap nodeMap = node.getAttributes();
			   Node attNode = nodeMap.getNamedItem("id");
			   if (strFindKey.equals(attNode.getNodeValue())) {
				   nodeVal = node;
				   break;
			   }
		   }

		   return nodeVal;
	}

    /**
     * <pre>
     * 맵 에 키값을 소문자로 변환한 새로운 맵을 반환한다
     * </pre>
     *
     * @param map 변환할 문자
		 * @return 키값을 소문자로 변환한 맵
     */

	 public static String mapToJson(Map<String, Object> map) {

			JSONObject json = new JSONObject();

			try {
				for (Map.Entry<String, Object> entry : map.entrySet()) {

					String key = entry.getKey();

					Object value = entry.getValue();

					// json.addProperty(key, value);

					json.put(key, value);

				}
			} catch (JSONException e) {
	            LOGGER.error(e.getMessage());

	        } catch (RuntimeException e) {
	            LOGGER.error(e.getMessage());

	        } catch(Exception e) {
	    		LOGGER.error(e.getMessage());

	    	}

			return json.toString();

		}


	 @SuppressWarnings("rawtypes")
	public static String getMenuUrl(Map rsMap) {
		String strUrl   = nvl(rsMap.get("MENU_URL"));
		String strMgrno = nvl(rsMap.get("BRD_MGRNO"));

		if ( strUrl.equals("#this"))
			strUrl = "";

		if ( strMgrno != null && !"".equals(strMgrno)) {

			strUrl  = CommonUtil.removeParam(strUrl, "brd_mgrno");
      		strUrl += (( strUrl.indexOf("?") > 0 ) ? "&" : "?" ) + "brd_mgrno=" + strMgrno;
      	}

		if(strUrl.indexOf("menu_no") < 1) {
			strUrl  = CommonUtil.removeParam(strUrl, "menu_no");
			strUrl += (( strUrl.indexOf("?") > 0 ) ? "&" : "?" ) + "menu_no=" + CommonUtil.nvl(rsMap.get("MENU_NO"));
		}

		if ("".equals(strUrl))
			strUrl = "#this";

     	return strUrl;
	 }

	 @SuppressWarnings("rawtypes")
	public static String getMenuUrl2(Map rsMap) {
		String strUrl   = nvl(rsMap.get("MENU_URL")).replaceAll("/webadm", "");
		String strMgrno = nvl(rsMap.get("BRD_MGRNO"));

		if ( strUrl.equals("#this"))
			strUrl = "";

		if ( strMgrno != null && !"".equals(strMgrno)) {

			strUrl  = CommonUtil.removeParam(strUrl, "brd_mgrno");
      		strUrl += (( strUrl.indexOf("?") > 0 ) ? "&" : "?" ) + "brd_mgrno=" + strMgrno;
      	}

		if(strUrl.indexOf("menu_no") < 1) {
			strUrl  = CommonUtil.removeParam(strUrl, "menu_no");
			strUrl += (( strUrl.indexOf("?") > 0 ) ? "&" : "?" ) + "menu_no=" + CommonUtil.nvl(rsMap.get("MENU_NO"));
		}

		if ("".equals(strUrl))
			strUrl = "#this";

     	return strUrl;
	 }


    public static String getDomainSSLUrl(HttpServletRequest request) {
    	String strUrl        = request.getRequestURL().toString();
    	String strServerName = request.getServerName();
    	String strHttp   = "http://";

    	try {
    		int nPos = strUrl.indexOf("://") + 3;

			strUrl = strUrl.substring(nPos);
			strUrl = strUrl.substring(0, strUrl.indexOf("/"));

			if ( strServerName.endsWith(CommDef.SITE_DOMAIN) ) {
				strHttp = "https://";
			}

        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());

        } catch(Exception e) {
    		LOGGER.error(e.getMessage());

    	}

    	return strHttp + strUrl;
    }

	 @SuppressWarnings("rawtypes")
	public static String getHomeMenuUrl(Map rsMap) {
		String strUrl   = nvl(rsMap.get("MENU_URL"));
		String strMgrno = nvl(rsMap.get("BRD_MGRNO"));

		if ( strUrl.equals("#this"))
			strUrl = "";

		if ( strMgrno != null && !"".equals(strMgrno)) {

			strUrl  = CommonUtil.removeParam(strUrl, "brd_mgrno");
     		strUrl += (( strUrl.indexOf("?") > 0 ) ? "&" : "?" ) + "boardno=" + strMgrno;
     	}

		if(strUrl.indexOf("menuno") < 1) {
			strUrl  = CommonUtil.removeParam(strUrl, "menuno");
			strUrl += (( strUrl.indexOf("?") > 0 ) ? "&" : "?" ) + "menuno=" + CommonUtil.nvl(rsMap.get("MENU_NO"));
		}

		if ("".equals(strUrl))
			strUrl = "#this";

    	return strUrl;

	 }

    /**
     * Throws :<br>
     * Parameters : HttpServletRequest request <br>
     * Parameters : String[] notParam 제외 파라미터 Return Value : String <br>
     * 내용 : HttpServletRequest를 이용하여 파라메터를 리턴함 <br>
     */
    @SuppressWarnings("rawtypes")
	public static String getRequestQueryString(HttpServletRequest request, String[] notParam) {
        String retQueryString = "";

        Map parameter = request.getParameterMap();
        Iterator it = parameter.keySet().iterator();
        Object paramKey = null;
        String[] paramValue = null;

        while (it.hasNext()) {
            paramKey = it.next();

            paramValue = (String[]) parameter.get(paramKey);

            boolean bParam = true;
            for (int i = 0; i < paramValue.length; i++) {
                for (int j = 0; j < notParam.length; j++) {
                    if (paramKey.equals(notParam[j])) {
                        bParam = false;
                    }
                }
                if(bParam){
                    retQueryString += "&" + paramKey + "=" + paramValue[i];
                }
            }
        }

        return retQueryString;
    }

    /**
     * Throws :<br>
     * Parameters : MultipartRequest request <br>
     * Return Value : String <br>
     * 내용 : HttpServletRequest를 이용하여 파라메터를 리턴함 <br>
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	public static String getRequestQueryString(MultipartRequest multiReq) {
        String retQueryString = "";
        String[] paramValue = null;

        Enumeration eParam = multiReq.getParameterNames();

        while (eParam.hasMoreElements()) {
            String strKey = (String) eParam.nextElement();

            paramValue = multiReq.getParameterValues(strKey);

            if (retQueryString.length() > 0)
                retQueryString = retQueryString + "&";

            retQueryString += retQueryString + strKey + "=" + multiReq.getParameterValues(strKey)[0];
        }

        return retQueryString;
    }

    /**
     * Throws :<br>
     * Parameters : HttpServletRequest request <br>
     * Return Value : String <br>
     * 내용 : HttpServletRequest를 이용하여 파라메터를 리턴함 <br>
     */
    @SuppressWarnings({ "rawtypes", "unused" })
	public static String getRequestQueryString(HttpServletRequest request) throws Exception{

        HashMap map = new HashMap();

        String retQueryString = "";
        String browser = getBrowser(request);

        Map parameter = request.getParameterMap();
        Iterator it = parameter.keySet().iterator();
        Object paramKey = null;
        String[] paramValue = null;

        while (it.hasNext()) {
            paramKey = it.next();

            paramValue = (String[]) parameter.get(paramKey);

            for (int i = 0; i < paramValue.length; i++) {
                if (retQueryString.length() > 0)
                    retQueryString = retQueryString + "&";

/*                if(browser.equals("MSIE")) {
                	retQueryString = retQueryString + paramKey + "=" + URLEncoder.encode(paramValue[i], "UTF-8").replaceAll("\\+", "%20");
                } else if(browser.equals("Trident")) {
                	retQueryString = retQueryString + paramKey + "=" + URLEncoder.encode(paramValue[i], "UTF-8").replaceAll("\\+", "%20");
                } else {
                	retQueryString = retQueryString + paramKey + "=" + paramValue[i];
                }*/

                retQueryString = retQueryString + paramKey + "=" + URLEncoder.encode(paramValue[i], "UTF-8").replaceAll("\\+", "%20");
            }
        }

        return retQueryString;

    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map getRequestMap(HttpServletRequest request) {

        HashMap map = new HashMap();
        try {
            Map parameter = request.getParameterMap();

            if (parameter == null)
                return null;

            Iterator it = parameter.keySet().iterator();
            Object paramKey = null;
            String[] paramValue = null;

            while (it.hasNext()) {
                paramKey = it.next();
                paramValue = (String[]) parameter.get(paramKey);

                String strKey = paramKey.toString().toLowerCase();

                if (paramValue.length > 1) {
                	String[] arrVal = request.getParameterValues(paramKey.toString());

                	for (int nLoop = 0; nLoop < arrVal.length; nLoop ++)
                	{
                		//if (!strKey.equals("ctnt")) {
                		//	arrVal[nLoop] = removeXSS(arrVal[nLoop]);
                		//} else {
                			arrVal[nLoop] = removeXSS(arrVal[nLoop],true);
                		//}
                	}

                    map.put(strKey, arrVal);
                } else {
                    map.put(strKey, (paramValue[0] == null) ? "" : removeXSS(paramValue[0].trim(), true));
                }
            }
            return map;
        } catch (NullPointerException e) {
            LOGGER.error(e.getMessage());
            return null;
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());
            return null;
        } catch(Exception e) {
    		LOGGER.error(e.getMessage());
    		return null;
    	}
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map getRequestAdmMap(HttpServletRequest request) {

        HashMap map = new HashMap();
        try {
            Map parameter = request.getParameterMap();

            if (parameter == null)
                return null;

            Iterator it = parameter.keySet().iterator();
            Object paramKey = null;
            String[] paramValue = null;

            while (it.hasNext()) {
                paramKey = it.next();
                paramValue = (String[]) parameter.get(paramKey);

                String strKey = paramKey.toString().toLowerCase();

                if (paramValue.length > 1) {
                	String[] arrVal = request.getParameterValues(paramKey.toString());

                	for (int nLoop = 0; nLoop < arrVal.length; nLoop ++)
                	{
                		//if (!strKey.equals("ctnt")) {
                		//	arrVal[nLoop] = removeXSS(arrVal[nLoop]);
                		//} else {
                			arrVal[nLoop] = arrVal[nLoop];
                		//}
                	}

                    map.put(strKey, arrVal);
                } else {
                    map.put(strKey, (paramValue[0] == null) ? "" : paramValue[0].trim());
                }
            }
            return map;
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());
            return null;
        } catch(Exception e) {
    		LOGGER.error(e.getMessage());
    		return null;
    	}
    }

    public static String removeXSS(String strData)
    {
    	String[] arrSrcCode = {"<script", "</script>","<", ">"};
    	String[] arrTgtCode = {"&ltscript_", "&lt/script_&gt", "&lt", "&gt"};

    	//String[] arrSrcCode = {"<script", "</script>"};
    	//String[] arrTgtCode = {"&ltscript_", "&lt/script_&gt"};


    	if ( strData == null || "".equals(strData) )
    		return strData;

       	for (int nLoop=0; nLoop < arrSrcCode.length; nLoop++)
       	{
       		strData = strData.replaceAll(arrSrcCode[nLoop], arrTgtCode[nLoop]);
       	}

    	return strData;

    }

    public static String recoveryLtGt(String strData)
    {
    	String[] arrSrcCode = {"&lt;", "&gt;","&lt", "&gt"};
    	String[] arrTgtCode = {"<", ">","<", ">"};

    	if ( strData == null || "".equals(strData) )
    		return strData;
    	for (int nLoop=0; nLoop < arrSrcCode.length; nLoop++)
    	{
    		strData = strData.replaceAll(arrSrcCode[nLoop], arrTgtCode[nLoop]);
    	}

    	return strData;

    }

    /**
     * URL 중에서 해당 필드 값을 삭제함 <br>
     * Method Description.
     * @param strParam URL 파라메터
     * @param strNotWord 삭제할 필드
     * @return String
     * @since 1.00
     * @see
     */
    public static String removeParam(String strParam, String strNotWord) {
        String strRetVal = "";

            if (strParam == null || "".equals(strParam))
                return "";
            if (strNotWord == null || "".equals(strNotWord))
                return "";

        	int iStartPos = indexOfaA(strParam, strNotWord, 0);

            if (iStartPos < 0)
                return strParam;

            strRetVal = strParam;

            while (iStartPos >= 0)
            {
	            int iEndPos = indexOfaA(strRetVal, "&", iStartPos);

	            if (iEndPos <= 0)
	                iEndPos = strRetVal.length() - 1;

	            strRetVal = strRetVal.substring(0, iStartPos) + strRetVal.substring(iEndPos + 1);

            	iStartPos = indexOfaA(strRetVal, strNotWord, 0);
            }

        return strRetVal;

    }

    /**
     * <pre>
     *
     *   대소문자 구분없이 String 값에서 시작위치를 주고 찾고자하는 값이 몇번째 순서에 있는지 리턴하는 메소드.
     *
     * </pre>
     *
     * @param str String 값
     * @param indexstr 찾고자 하는 값
     * @param fromindex String 의 시작위치
     * @see StringHandler#indexOfaA(String str, String indexstr)
     * @return 찾고자 하는 값의 String 의 위치
     */
    public static int indexOfaA(String str, String indexstr, int fromindex) {
        int index = 0;
        indexstr = indexstr.toLowerCase();
        str = str.toLowerCase();
        index = str.indexOf(indexstr, fromindex);
        return index;
    }

    public static String getFrontPageNavi(String link, int totCnt, int pageNow, String param, int pagePerBlock, int numPerPage)
    {
    	String rtnNavi = "";
        String sDelim = "";
        String sPgDlm = "";
        String sParam = param;
        String strUrl = "";
        int iNext;
        int iPrev;

        if ( pageNow <= 0)
        	pageNow = 1;

        sParam = removeParam(param, "page_now");

        // 총 페이지 수
        int totalPage = (int) Math.ceil(totCnt / (numPerPage * 1d));

        // 현재 페이지가 속한 블럭 번호
        int currBlock = (int) Math.ceil(pageNow / (pagePerBlock * 1d));

        // 총 블럭 갯수
        int totalBlock = (int) Math.ceil(totalPage / (pagePerBlock * 1d));

        // 현재 블록의 시작 페이지
        int startPage = (currBlock - 1) * pagePerBlock + 1;
        // 현재 블록의 마지막 페이지
        int endPage = startPage + pagePerBlock - 1;

        if (endPage > totalPage)
            endPage = totalPage;

        // 파라미터가 없으면 ? 붙임
        if (link.indexOf("?") == -1)
            sDelim = "?";
        else
            sDelim = "&";

        if (!"".equals(sParam))
            sPgDlm = "&";

    	strUrl =  link + sDelim + sParam + sPgDlm;

    	if (totCnt > 0) {
	        if (currBlock > 1) {
	            iPrev = (currBlock - 1)* pagePerBlock;

	            rtnNavi += " <a class='first' title='맨처음 1페이지' href=\"" + strUrl + "page_now=1\"><<</a>\n";
	            rtnNavi += " <a class='prev' title='이전 페이지' href=\"" + strUrl + "page_now=" + iPrev +"\"><</a> \n";
	        } else {
	            rtnNavi += " <a class='first' title='맨처음 1페이지' href=\"" + strUrl + "page_now=1\"><<</a>\n";
	            rtnNavi += " <a class='prev' title='이전 페이지' href=\"" + strUrl + "page_now=1\"><</a> \n";
	        }


	        //페이지 번호
	        if (endPage == 0) {
	            rtnNavi += "<a href='#this' class='active'>1</a>&nbsp;";
	        } else {
	            for (int i = startPage; i <= endPage; i++) {
	                if (i == pageNow) {
	                	rtnNavi += "<a href='" + strUrl + "page_now=" + i + "' class='active' title='" + i + " 페이지'>" + i + "</a>&nbsp;";
	                    if (i != endPage)
	                        rtnNavi += "&nbsp;";
	                } else {
	                    rtnNavi += "<a href='" + strUrl + "page_now=" + i + "' title='" + i + " 페이지'>" + i + "</a>&nbsp;";
	                    if (i != endPage)
	                        rtnNavi += "&nbsp;";
	                }
	            }
	        }

	        if (currBlock < totalBlock) {
	            iNext = (currBlock * pagePerBlock) + 1;

	            rtnNavi += "<a class='next' title='다음 페이지'  href=\"" + strUrl+"page_now="+iNext+"\">></a>\n";
	            rtnNavi += "<a class='last' title='마지막 페이지'  href=\"" + strUrl+"page_now="+totalPage+"\">>></a>\n";
	        } else {
	            rtnNavi += "<a class='next' title='다음 페이지' href=\"" + strUrl+"page_now="+totalPage+"\">></a>\n";
	            rtnNavi += "<a class='last' title='마지막 페이지' href=\"" + strUrl+"page_now="+totalPage+"\">>></a>\n";
	        }
    	}

        return rtnNavi;
    }

    public static String getAdmPageNavi(String link, int totCnt, int pageNow, String param, int pagePerBlock, int numPerPage)
    {
    	String rtnNavi = "";
        String sDelim = "";
        String sPgDlm = "";
        String sParam = param;
        String strUrl = "";
        int iNext;
        int iPrev;

        if ( pageNow <= 0)
        	pageNow = 1;

        sParam = removeParam(param, "page_now");

        // 총 페이지 수
        int totalPage = (int) Math.ceil(totCnt / (numPerPage * 1d));

        // 현재 페이지가 속한 블럭 번호
        int currBlock = (int) Math.ceil(pageNow / (pagePerBlock * 1d));

        // 총 블럭 갯수
        int totalBlock = (int) Math.ceil(totalPage / (pagePerBlock * 1d));

        // 현재 블록의 시작 페이지
        int startPage = (currBlock - 1) * pagePerBlock + 1;
        // 현재 블록의 마지막 페이지
        int endPage = startPage + pagePerBlock - 1;

        if (endPage > totalPage)
            endPage = totalPage;

        // 파라미터가 없으면 ? 붙임
        if (link.indexOf("?") == -1)
            sDelim = "?";
        else
            sDelim = "&";

        if (!"".equals(sParam))
            sPgDlm = "&";

    	strUrl =  link + sDelim + sParam + sPgDlm;

    	if (totCnt > 0) {
	        if (currBlock > 1) {
	            iPrev = (currBlock - 1)* pagePerBlock;

	            rtnNavi += " <a class='arr first' href=\"" + strUrl + "page_now=1\"><i class='axi axi-angle-double-left'></i></a>\n";
	            rtnNavi += " <a class='arr prev' href=\"" + strUrl + "page_now=" + iPrev +"\"><i class='axi axi-angle-left'></i></a> \n";
	        } else {
	            rtnNavi += " <a class='arr first' href=\"" + strUrl + "page_now=1\"><i class='axi axi-angle-double-left'></i></a>\n";
	            rtnNavi += " <a class='arr prev' href=\"" + strUrl + "page_now=1\"><i class='axi axi-angle-left'></i></a> \n";
	        }


	        //페이지 번호
	        if (endPage == 0) {
	            rtnNavi += "<a href='#this' class='num active'>1</a>&nbsp;";
	        } else {
	            for (int i = startPage; i <= endPage; i++) {
	                if (i == pageNow) {
	                	rtnNavi += "<a href='" + strUrl + "page_now=" + i + "' class='num active'>" + i + "</a>&nbsp;";
	                    if (i != endPage)
	                        rtnNavi += "&nbsp;";
	                } else {
	                    rtnNavi += "<a href='" + strUrl + "page_now=" + i + "' class='num'>" + i + "</a>&nbsp;";
	                    if (i != endPage)
	                        rtnNavi += "&nbsp;";
	                }
	            }
	        }

	        if (currBlock < totalBlock) {
	            iNext = (currBlock * pagePerBlock) + 1;

	            rtnNavi += "<a class='arr next' href=\"" + strUrl+"page_now="+iNext+"\"><i class='axi axi-angle-right'></i></a>\n";
	            rtnNavi += "<a class='arr last' href=\"" + strUrl+"page_now="+totalPage+"\"><i class='axi axi-angle-double-right'></i></a>\n";
	        } else {
	            rtnNavi += "<a class='arr next' href=\"" + strUrl+"page_now="+totalPage+"\"><i class='axi axi-angle-right'></i></a>\n";
	            rtnNavi += "<a class='arr last' href=\"" + strUrl+"page_now="+totalPage+"\"><i class='axi axi-angle-double-right'></i></a>\n";
	        }
    	}

        return rtnNavi;
    }


    /**
     * Method Summary. <br>
     * @param sData String : 데이터 값
     * @param sTrans String : null, "", "null"일 경우 변경할값
     * @return String
     */
    public static int getNullInt(Object objData, int nTrans) {
    	return Integer.parseInt(getNullTrans(objData, nTrans));
    }


    /**
     * Method Summary. <br>
     * @param sData String : 데이터 값
     * @return String
     */
    public static String getNullTrans(String sData) {
        return getNullTrans(sData, "");
    }

    /**
     * Method Summary. <br>
     * @param sData String : 데이터 값
     * @param sTrans String : null, "", "null"일 경우 변경할값
     * @return String
     */
    public static String getNullTrans(String sData, String sTrans) {
        if (sTrans == null)
            sTrans = "";
        if (sData != null && !"".equals(sData) && !"null".equals(sData))
            return removeXSS(sData.trim());

        return removeXSS(sTrans);
    }

    /**
     * Method Summary. <br>
     * @param oData Object : 객체
     * @param sTrans String : null, "", "null"일 경우 변경할값
     * @return String
     */
    public static String getNullTrans(Object oData, String sTrans) {
        if (sTrans == null)
            sTrans = "";
        if (oData != null && !"".equals(oData) && !"null".equals(oData))
            return removeXSS(oData.toString().trim());

        return removeXSS(sTrans);
    }

    public static String getNullTrans(Object oData, int nTrans) {
        return getNullTrans(oData, Integer.toString(nTrans));
    }

    /**
     * Method Summary. <br>
     * @param oData Object : 객체
     * @return String
     */
    public static String getComma(String strVal) {

    	strVal = getNullTrans(strVal, "0");

        DecimalFormat formatter = new DecimalFormat("#,##0");
        return formatter.format(Integer.parseInt(strVal));
    }

    public static String getComma(long nVal) {
        return getComma(Long.toString(nVal));
    }


    public static String XSSConv(Object oData, String strWriteAuth) {

    	String strVal = nvl(oData);
    	if ("ADMIN".equals(strWriteAuth) || "MANAGER".equals(strWriteAuth) || "COUNSEL".equals(strWriteAuth)) {
    		strVal = recoveryLtGt(strVal);
    	}

    	strVal = strVal.replaceAll("&ltbr/&gt", "<br/>");
    	strVal = strVal.replaceAll("&ltbr&gt", "<br/>");

    	strVal = strVal.replaceAll("&lttable", "<table");
    	strVal = strVal.replaceAll("&lt/table&gt", "</table>");

    	strVal = strVal.replaceAll("&lttr", "<tr");
    	strVal = strVal.replaceAll("&lt/tr&gt", "</tr>");

    	strVal = strVal.replaceAll("&lttd", "<td");
    	strVal = strVal.replaceAll("&lt/td&gt", "</td>");

        return strVal;
    }


    /**
     * Method Summary. <br>
     * @param oData Object : 객체
     * @return String
     */
    public static String nvl(Object oData) {
        return getNullTrans(oData, "");
    }

    /**
     * Method Summary. <br>
     * @param oData Object : 객체
     * @param sTrans String : null, "", "null"일 경우 변경할값
     * @return String
     */
    public static String nvl(Object oData, String sTrans) {
    	return getNullTrans(oData, sTrans);
    }

    /**
     * Method Summary. <br>
     * @param oData Object : 객체
     * @return String
     */
    public static String getNullTrans(Object oData) {
        return getNullTrans(oData, "");
    }

    /**
     * Method Summary. <br>
     * Method Description.
     * @param name description
     * @return description
     * @throws name description
     * @since 1.00
     * @see
     */
    public static String getFormParm(HttpServletRequest request) {
        return getFormParm(request, "");
    }

    /**
     * Method Summary. <br>
     * html hidden 속성의 파라미터 생성 method.
     * @param request HttpServletRequest
     * @param notParam 제외 파라미터
     * @return retQueryString
     * @throws name description
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "rawtypes", "unused" })
	public static String getFormParm(HttpServletRequest request, String notParam) {
        HashMap map = new HashMap();

        String retQueryString = "";

        Map parameter = request.getParameterMap();
        Iterator it = parameter.keySet().iterator();
        Object paramKey = null;
        String[] paramValue = null;

        while (it.hasNext()) {

            paramKey = it.next();
            if (paramKey.equals(notParam))
                continue;

            paramValue = (String[]) parameter.get(paramKey);

            for (int i = 0; i < paramValue.length; i++) {
                retQueryString += "<input name=\"" + paramKey + "\" type=hidden value=\"" + removeXSS(paramValue[i]) + "\" >  \n";
            }
        }
        return retQueryString;
    }

    /**
     * Throws :<br>
     * Parameters : MultipartRequest request <br>
     * Return Value : String <br>
     * 내용 : HttpServletRequest를 이용하여 파라메터 HashMap에 저장하여 반환 <br>
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map getRequestMap(HttpServletRequest request, boolean bFileUpload) {

        Map mapParam = new HashMap();
        Map retMap = new HashMap();
        if (!bFileUpload) {
            return getRequestMap(request);
        }

        try {
            Part part;
            MultipartParser multiReq = new MultipartParser(request, 10 * 1024 * 1024); // 10MB

            while ((part = multiReq.readNextPart()) != null) {
                String strKey = new String(part.getName());

                if (part.isParam()) { // 파일이 아닐때
                    ParamPart paramPart = (ParamPart) part;
                    String strValue = new String(paramPart.getStringValue());
                    mapParam.put(strKey.toLowerCase(), strValue);
                    //System.out.println("param; strKey=" + strKey + ", value=" + strValue);
                }

            }
            retMap.put("param", mapParam);
            retMap.put("multi", multiReq);
            return retMap;
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());
            return null;
        } catch(IOException e) {
    		LOGGER.error(e.getMessage());
    		 return null;
    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());
    		return null;
    	}
    }

    /**
     *
     * 작품연관이미지 파일 첨부 KEY값 난수 생성
     * @return strVal
     */
    public static String getUniqueValue()
    {
    	Random r = new Random();
    	//setSeed() 메소드를 사용해서 r을 예측 불가능한 long타입으로 설정
    	r.setSeed(new Date().getTime());
    	//난수 생성
    	int rand = (r.nextInt() % 999999999) + 1;

    	return getCurrentDate("", "YYYYMMDDHHMISS") + Integer.toString(rand);
    }


    /**
     *
     * 임시비밀번호 생성
     * @return strVal
     */
    public static String shufflePasswd(int nLen)
    {
    	Random r = new Random();
    	//setSeed() 메소드를 사용해서 r을 예측 불가능한 long타입으로 설정
    	r.setSeed(new Date().getTime());
    	//난수 생성
    	int rand = (r.nextInt() % 999999999) + 1;

    	return Integer.toString(rand);
    }

    /**
     * Throws : IOException <br>
     * Parameters : String StrDelimittoken : (ex) "/" , ".", "-" , String rtnFormmat <br>
     * Return Value : String <br>
     * 내용 : 오늘 날짜 값 가져오기 <br>
     */
    @SuppressWarnings("static-access")
	public static String getCurrentDate(String StrDelimittoken, String rtnFormmat) {

        try {
            Calendar currentWhat = Calendar.getInstance();
            int currentYear = currentWhat.get(Calendar.YEAR);
            int currentMonth = currentWhat.get(Calendar.MONTH) + 1;
            int currentDay = currentWhat.get(Calendar.DAY_OF_MONTH);
            int currentHour = currentWhat.get(Calendar.HOUR_OF_DAY);
            int currentMinute = currentWhat.get(Calendar.MINUTE);
            int currentSecond = currentWhat.get(Calendar.SECOND);

            String yearToday = padLeftwithZero(currentYear, 4); // 4자리 스트링으로 변환
            String monthToday = padLeftwithZero(currentMonth, 2); // 2자리 스트링으로 변환
            String dayToday = padLeftwithZero(currentDay, 2); // 2자리 스트링으로 변환
            String hourToday = padLeftwithZero(currentHour, 2); // 2자리 스트링으로 변환
            String minuteToday = padLeftwithZero(currentMinute, 2); // 2자리 스트링으로 변환
            String secondToday = padLeftwithZero(currentSecond, 2); // 2자리 스트링으로 변환

            if (rtnFormmat.equals("YYYY/MM/DD HH:MI:SS")) {
                return new String(yearToday + "/" + monthToday + "/" + dayToday + " " + hourToday + ":" + minuteToday
                        + ":" + secondToday);
            } else if (rtnFormmat.equals("YYYY-MM-DD HH:MI:SS")) {
                return new String(yearToday + "-" + monthToday + "-" + dayToday + " " + hourToday + ":" + minuteToday + ":" + secondToday);
            } else if (rtnFormmat.equals("YYYY-MM-DD")) {
                return new String(yearToday + "-" + monthToday + "-" + dayToday);
            } else if (rtnFormmat.equals("YYYY-MM")) {
                return new String(yearToday + "-" + monthToday);
            } else if (rtnFormmat.equals("YYYYMM")) {
                return new String(yearToday + monthToday);
            } else if (rtnFormmat.equals("YYYYMMDD-HHMISS")) {
                return new String(yearToday + "" + monthToday + "" + dayToday + "-" + hourToday + "" + minuteToday
                        + "" + secondToday);
            } else if (rtnFormmat.equals("YYYYMMDDHHMISS")) {
                return new String(yearToday + "" + monthToday + "" + dayToday + hourToday + "" + minuteToday + ""
                        + secondToday);
            } else if (rtnFormmat.equals("YYYYMMDD")) {
                return new String(yearToday + monthToday + dayToday);
            } else if (rtnFormmat.equals("HH:MI:SS")) {
                return new String(hourToday + ":" + minuteToday + ":" + secondToday);
            } else if (rtnFormmat.equals("HHMISS")) {
                return new String(hourToday + minuteToday + secondToday);
            } else if (rtnFormmat.equals("YYYY")) {
                return new String(yearToday);
            } else if (rtnFormmat.equals("MM")) {
                return new String(monthToday);
            } else if (rtnFormmat.equals("DD")) {
                return new String(dayToday);
            } else if (rtnFormmat.equals("HHMI")) {
                return new String(hourToday + minuteToday);
            } else if (rtnFormmat.equals("HH:MI")) {
                return new String(hourToday + ":" + minuteToday);
            } else if (rtnFormmat.equals("dafault")) {
                return new String(yearToday + StrDelimittoken + monthToday + StrDelimittoken + dayToday);

            } else if (rtnFormmat.equals("prevmonth1")) { //지난달 1일
            	currentWhat.add(currentWhat.MONTH, -1);
                return new String(padLeftwithZero(currentWhat.get(Calendar.YEAR),4) + "-" + padLeftwithZero(currentWhat.get(Calendar.MONTH) + 1, 2) + "-01");
            } else if (rtnFormmat.equals("prevmonth2")) { //지난달 마지막일
            	currentWhat.add(currentWhat.MONTH, -1);
                return new String(padLeftwithZero(currentWhat.get(Calendar.YEAR),4) + "-" + padLeftwithZero(currentWhat.get(Calendar.MONTH) + 1, 2) + "-" + padLeftwithZero(currentWhat.getActualMaximum(Calendar.DAY_OF_MONTH),2) );
            } else if (rtnFormmat.equals("prevday")) { //어제날짜
            	currentWhat.add(currentWhat.DATE, -1);
                return new String(padLeftwithZero(currentWhat.get(Calendar.YEAR),4) + "-" + padLeftwithZero(currentWhat.get(Calendar.MONTH) +1 ,2) + "-" + padLeftwithZero(currentWhat.get(Calendar.DAY_OF_MONTH),2));
            } else if (rtnFormmat.equals("firstWeek")) {  //이번주 첫째 날짜
            	currentWhat.add(Calendar.DATE, 1 - currentWhat.get(Calendar.DAY_OF_WEEK));
	        	return new String(padLeftwithZero(currentWhat.get(Calendar.YEAR),4) + "-" + padLeftwithZero(currentWhat.get(Calendar.MONTH) +1 ,2)  + "-" + padLeftwithZero(currentWhat.get(Calendar.DAY_OF_MONTH),2));
            } else if (rtnFormmat.equals("prevWeek1")) {  //지난주 일요일 날짜
            	currentWhat.add(Calendar.DATE, -7);
	        	currentWhat.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
	        	return new String(padLeftwithZero(currentWhat.get(Calendar.YEAR),4) + "-" + padLeftwithZero(currentWhat.get(Calendar.MONTH) +1 ,2) + "-" + padLeftwithZero(currentWhat.get(Calendar.DAY_OF_MONTH),2));
            } else if (rtnFormmat.equals("prevWeek2")) {  //지난주 토요일 날짜
            	currentWhat.add(Calendar.DATE, -7);
	        	currentWhat.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
	        	return new String(padLeftwithZero(currentWhat.get(Calendar.YEAR),4) + "-" + padLeftwithZero(currentWhat.get(Calendar.MONTH) +1 ,2) + "-" + padLeftwithZero(currentWhat.get(Calendar.DAY_OF_MONTH),2));
            } else {
                return new String(yearToday + StrDelimittoken + monthToday + StrDelimittoken + dayToday);
            }
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());
            return "";
        } catch(IOException e) {
    		LOGGER.error(e.getMessage());
    		return "";
    	} catch(Exception e) {
    		LOGGER.error(e.getMessage());
    		return "";
    	}
    }

    public static String getCurrentDate() {
        return getCurrentDate("", "");
    }


   /**
    * Parameters : String day, String delim <br>
    * Return Value : String <br>
    * 내용 : Date Format 변경. <br>
    */
   public static String getDateFormat(Object objDay) {

	   if ( objDay == null)
	     return "";

	   String day = objDay.toString();

	   day = day.replaceAll("-", "");
	   day = day.replaceAll("//.", "");
	   day = day.replaceAll(":", "");
	   day = day.replaceAll("\\[", "");
	   day = day.replaceAll("\\]", "");
	   day = day.replaceAll(" ", "");

	   if (day.length() == 6) {
		   return day.substring(0, 4) + "-" + day.substring(4, 6);
	   }

	   if (day.length() < 8)
	   	  return objDay.toString();

       return getDateFormat(day.substring(0, 8), "ymd");
   }


   /**
    * Parameters : String day, String delim <br>
    * Return Value : String <br>
    * 내용 : Date Format 변경. <br>
    */
   public static String getDateTimeFormat(Object objDay) {

	   if ( objDay == null)
		   return "";

	   String day = objDay.toString();

	   day = day.replaceAll("-", "");
	   day = day.replaceAll("//.", "");

	   if (day.length() < 12)
	   	  return objDay.toString();

       return getDateFormat(day, "-");
   }

   /**
    * Parameters : String day, String delim <br>
    * Return Value : String <br>
    * 내용 : Date Format 변경. <br>
    */
   public static String getDateFormat(Object objDay, String delim) {
       String tmp = "";

       if (objDay == null)
           return tmp;
       String day = objDay.toString();

       if (delim.equals("korean")) {
       	int i = 0;
       	String[] fg = {"년 ","월 "};
       	while(day.indexOf(".") != -1){
       		day = day.replace(".", fg[i]);
       		i++;
       	}
       	day += "일";
       	return day;
       } else if (delim.equals("y.m.d")) {
       	return day;
       }

       day = day.replace(".", "");
       day = day.replace("-", "");
       day = day.replace("/", "");
       day = day.replace(" ", "");
       day = day.replace(":", "");
       int  iDayLen = day.length();

       if (day == null || day.equals("") || delim == null) {
           tmp = "";
       } else if (iDayLen < 6) {
           tmp = day;
       } else if (delim.equals("ymd")) {
           tmp = day.substring(0, 4) + "." + day.substring(4, 6) + "." + day.substring(6, 8);
       } else if (delim.equals("ym")) {
           tmp = day.substring(0, 4) + "." + day.substring(4, 6);
       } else if (delim.equals("YMD")) {
       	tmp = day.substring(0, 4) + "년 " + day.substring(4, 6) + "월 " + day.substring(6, 8) + "일";
       } else if (delim.equals("ymdh")) {
       	tmp = day.substring(0, 4) + "." + day.substring(4, 6) + "." + day.substring(6, 8) + " "+day.substring(8, 10);
       } else if (delim.equals("ymdhm")) {
       	tmp = day.substring(0, 4) + "." + day.substring(4, 6) + "." + day.substring(6, 8);
       	tmp +=  " " + day.substring(8, 10) + ":" + day.substring(10, 12);
       } else if (delim.equals("ymdhms")) {
      	tmp = day.substring(0, 4) + "." + day.substring(4, 6) + "." + day.substring(6, 8);
      	tmp +=  " " + day.substring(8, 10) + ":" + day.substring(10, 12) + ":" + day.substring(12, 14);
       } else if (delim.equals("ymd2")) {
       	tmp = day.substring(0, 4) + "-" + day.substring(4, 6) + "-" + day.substring(6, 8);
       } else if (delim.equals("hh")) {
       	tmp = day.substring(8, 10);
       } else if (delim.equals("mm")) {
       	tmp = day.substring(10, 12);
       } else if (delim.equals("HHmmss")) {
          	tmp = day.substring(8, 10) + day.substring(10, 12) + day.substring(12, 14);
       } else if (delim.equals("HHmmss2")) {
         	tmp = day.substring(0, 2) + ":" + day.substring(2, 4) + ":" +  day.substring(4, 6);
       } else {
       	tmp = day.substring(0, 4) + delim + day.substring(4, 6) + delim + day.substring(6, 8);

       	if ( iDayLen > 11) {
       		tmp +=  " " + day.substring(8, 10) + ":" + day.substring(10, 12) + ":" + day.substring(12);
       	} else if ( iDayLen > 8) {
              tmp +=  " " + day.substring(8, 10) + ":" + day.substring(10, 12);
              //+ ":" + day.substring(12);
       	}
       }

       return tmp;
   }

    /**
     * Parameters : int convert, int size <br>
     * Return Value : String <br>
     * 내용 : 숫자의 왼쪽 자리를 '0'으로 채운다. <br>
     */
    public static String padLeftwithZero(int convert, int size) throws IOException {
        Integer inTemp = new Integer(convert);
        String stTemp = new String();
        String stReturn = new String();

        stTemp = inTemp.toString();
        if (stTemp.length() < size)
            for (int i = 0; i < size - stTemp.length(); i++)
                stReturn += "0";

        return (stReturn + stTemp);
    }

    public static String convertHtmlTags(Object obj) {
    	if ( obj == null)
    		return "";

    	return convertHtmlTags(obj.toString());
    }

    public static String convertHtmlTags(String s) {
    	s = CommonUtil.recoveryLtGt(s);

        s = s.replaceAll("<[^>]*>", ""); //정규식 태그삭제
        s = s.replaceAll("\r\n", " "); //엔터제거
        return s;
    }


    /**
     * 전달 받은 Request 객체에 전달 받은 strKey가 null이면 "" 문자열을 반환한다.
     * @param request 대상이 되는 HttpServletRequest 객체
     * @param strKey Parameter Key
     * @return formatting 날짜 문자열
     */
    public static String getNullConv(String strTarget) {
        return getNullConv(strTarget, "");
    }

    /**
     * 전달 받은 Request 객체에 전달 받은 strKey가 null이면 "" 문자열을 반환한다.
     * @param request 대상이 되는 HttpServletRequest 객체
     * @param strKey Parameter Key
     * @return formatting 날짜 문자열
     */
    public static String getNullConv(String strTarget, String strConv) {
        String szTemp;

        if (strConv == null)
            strConv = "";

        if (strTarget == null || "".equals(strTarget) || "null".equals(strTarget)) {
            szTemp = strConv;
        } else {
            szTemp = strTarget;
        }

        return szTemp;
    }

    /**
     * Map 초기값 처리. <br>
     * Map의 Key에 해당하는 값이 존재하지 않으면 초기값을 부여한다.
     * @param map
     * @param strKey
     * @param strVal
     * @return description
     * @since 1.00
     * @see
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map setNullVal(Map map, String strKey, String strVal) {
        String strMapVal = "";

        if (map.get(strKey) != null && map.get(strKey) != "")
            strMapVal = map.get(strKey).toString().trim();

        if ("".equals(strMapVal))
            map.put(strKey, strVal);

        return map;
    }

    @SuppressWarnings("rawtypes")
	public static String getMapVal(Map map, String strKey) {
        return getMapVal(map, strKey, "");
    }

    @SuppressWarnings("rawtypes")
	public static String getMapVal(Map map, String strKey, String strVal) {
        String strMapVal = strVal;

        if (map == null || "".equals(strKey))
        	return strVal;

        if (map.get(strKey) != null && map.get(strKey) != "")
            strMapVal = map.get(strKey).toString().trim();

        return strMapVal;
    }

    public static String setNullVal(String strKey, String strVal) {
        if (strKey == null || "".equals(strKey))
            return strVal;
        return strKey;
    }

    public static String setNullVal(Object objKey, String strVal) {
        if (objKey != null) {
            String strKey = objKey.toString().trim();
            if (!"".equals(strKey))
                return strKey;
        }
        return strVal;
    }

    public static String setNullVal(Object objKey) {
        return setNullVal(objKey, "");
    }

    public static String getConv(Object objKey, String strVal) {
        // UtilEncoder utilEncoder = new UtilEncoder();

        if (objKey != null && !objKey.equals("null")) {
            /*
             * String strKey = objKey.toString().trim(); strKey = utilEncoder.toKorean(strKey);
             */

            String strKey = objKey.toString().trim();

            if (!"".equals(strKey))
                return strKey;
        }
        return strVal;
    }

    public static String getConv(Object objKey) {

        return getConv(objKey, "");
    }

    /**
     * 입력 문자열 끝부분의 공백문자 " "를 제거한다. Method Description.
     * @param String str 공백을 제거할 문자열
     * @return String
     * @since 1.00
     * @see
     */
    public static String rightTrim(String str) {
        if (str == null || str.equals(""))
            return str;

        int i;
        int len = str.length();

        for (i = 0; i < len; i++) {
            if (str.charAt(len - i - 1) != ' ')
                break;
        }

        return str.substring(0, len - i);
    }

    public static String getFileName(Object strFileName) {

        if (strFileName != null && !"".equals(strFileName)) {
            return getFileName(strFileName.toString());
        } else {
            return "";
        }
    }

    public static String getFileName(String strFileName) {

        if (strFileName != null && !"".equals(strFileName)) {
            return strFileName.substring(strFileName.lastIndexOf("/") + 1, strFileName.length());
        } else {
            return "";
        }

    }

    public static String getFileExt(String strFileName) {

        if (strFileName != null && !"".equals(strFileName)) {
            return strFileName.substring(strFileName.lastIndexOf(".") + 1, strFileName.length()); // 파일확장빼기
        } else {
            return "";
        }

    }

    public static String number_format(Object objNumber) {
        return number_format(objNumber, "#,##0");
    }

    public static String number_format(Object objNumber, String strFormat) {
        String strRetVal = "0";

        if (objNumber == null || "".equals(objNumber.toString()))
            return "0";
        String strNumber = objNumber.toString();

        Double dblNumber = Double.valueOf(strNumber);

        strFormat = ("".equals(strFormat)) ? "#,##0" : strFormat;

        DecimalFormat formatter = new DecimalFormat(strFormat);
        strRetVal = formatter.format(dblNumber);

        return strRetVal;
    }

    public static String number_format(int objNumber) {

        return number_format(objNumber, "#,##0");
    }

    public static String number_format(long objNumber) {

        return number_format(objNumber, "#,##0");
    }

    public static String number_format(float objNumber) {

        return number_format(objNumber, "#,##0");
    }

    public static String number_format(int objNumber, String strFormat) {
        String strRetVal = "0";

        if (objNumber <= 0) return "0";
        String strNumber = Integer.toString(objNumber);

        Double dblNumber = Double.valueOf(strNumber);

        strFormat = ("".equals(strFormat)) ? "#,##0" : strFormat;

        DecimalFormat formatter = new DecimalFormat(strFormat);
        strRetVal = formatter.format(dblNumber);

        return strRetVal;
    }

    public static boolean isImageFile(Object objFileName) {
        if (objFileName == null || "".equals(objFileName.toString()))
            return false;

        String strFileExt = getFileExt(objFileName.toString().toLowerCase());
        boolean bImage = false;

		if ("bmp".equals(strFileExt)) {
			bImage = true;
		} else if ("jpg".equals(strFileExt)) {
			bImage = true;
		} else if ("gif".equals(strFileExt)) {
			bImage = true;
		} else if ("png".equals(strFileExt)) {
			bImage = true;
        }

        return bImage;
    }

    public static String getFileSize(Object obj)
    {
    	String strVal = "";
    	if ( obj == null )
    		return "";

    	Long nSize = Long.parseLong(obj.toString());

    	nSize /= 1000; // Byte를 KB로 환산

    	if (nSize < 1)
    		nSize = 1L;

    	if ( nSize < 1000 ) {
    		strVal = String.format("%dKB", nSize);
    	} else {
    		strVal = String.format("%.2fMB", nSize/1000.0);
    	}

    	return strVal;

    }

    /**
     * 쿠키를 설정한다. <br>
     * Method Description.
     * @param response
     * @param name 쿠기명
     * @param value 값
     * @param iMinute 설정시간 (분)
     * @throws java.io.UnsupportedEncodingException description
     * @since 1.00
     * @see
     */
    public static void setCookieObject(HttpServletResponse response, String name, String value, int iMinute)
            throws java.io.UnsupportedEncodingException {

        Cookie cookie = new Cookie(name, URLEncoder.encode(value, "UTF-8"));

        cookie.setMaxAge(60 * iMinute);
        cookie.setPath("/");
        cookie.setSecure(true);
        response.addCookie(cookie);
    }

    public static String getCookieObject(HttpServletRequest request, String cookieName)
            throws UnsupportedEncodingException {

        Cookie[] cookies = request.getCookies();

        if (cookies == null)
            return null;
        String value = null;
        for (int i = 0; i < cookies.length; i++) {

            if (cookieName.equals(cookies[i].getName())) {
                value = cookies[i].getValue();
                if ("".equals(value))
                    value = null;
                break;
            }
        }

        return (value == null ? null : URLDecoder.decode(value, "UTF-8"));
    }

    /**
     * <pre>
     *  Html 화면 구성에 말줄임 표시 기능.
     * </pre>
     *
     * @param inputString 변환할 String 값
     * @param max_Length 반환할 String Length
     * @return "aaaaaaaaa" 를 "aaaa..."으로 변환하여 Return
     */
    public static String getStrCut(String inputString, int max_Length) {

        String outputString = "";
        int string_size = 0;
        int new_size = 0;

        for (int i = 0; i < max_Length && i < inputString.length(); i++) {
            if (Character.getType(inputString.charAt(i)) == 5) {
                string_size += 2;
            } else if (Character.getType(inputString.charAt(i)) == 1
                    || Character.getType(inputString.charAt(i)) == 2
                    || Character.getType(inputString.charAt(i)) == 15
                    || Character.getType(inputString.charAt(i)) == 24) {
                string_size += 1;
            } else {
                string_size += 1;
            }
        }

        if (inputString == null)
            return outputString;

        //if (max_Length < 4 || inputString.length() < max_Length)
        if (max_Length < 4 || string_size < max_Length)
            return inputString;

        for (int i = 0; new_size < max_Length - 3; i++) {
            if (Character.getType(inputString.charAt(i)) == 5) {
                new_size += 2;
            } else if (Character.getType(inputString.charAt(i)) == 1
                    || Character.getType(inputString.charAt(i)) == 2
                    || Character.getType(inputString.charAt(i)) == 15
                    || Character.getType(inputString.charAt(i)) == 24) {
                new_size += 1;
            } else {
                new_size += 1;
            }

            if (new_size <= max_Length - 3) {
                outputString += new Character(inputString.charAt(i)).toString();
            }
        }

        outputString += "...";
        return outputString;
    }


    @SuppressWarnings("rawtypes")
	public static float[] getListToIntArrayFloat(List rsList, String strField) {

        return getListToIntArrayFloat(rsList, strField, 0, 0);
    }

    @SuppressWarnings("rawtypes")
	public static float[] getListToIntArrayFloat(List rsList, String strField, int iStartPos, int iEndPos) {
        if (rsList == null)
            return null;

        if (iEndPos > rsList.size())
            iEndPos = rsList.size();
        if (iEndPos <= 0)
            iEndPos = rsList.size();

        float[] rsArr = new float[iEndPos - iStartPos];

        int iCnt = 0;

        for (int iLoop = 0; iLoop < iEndPos; iLoop++) {

            if (iLoop < iStartPos)
                continue;

            Map dbRow = (Map) rsList.get(iLoop);
            rsArr[iCnt++] = Float.parseFloat(CommonUtil.getConv(dbRow.get(strField), "0.0"));
        }

        return rsArr;
    }

    @SuppressWarnings("rawtypes")
	public static int[] getListToIntArray(List rsList, String strField) {

        return getListToIntArray(rsList, strField, 0, 0);
    }

    @SuppressWarnings("rawtypes")
	public static int[] getListToIntArray(List rsList, String strField, int iStartPos, int iEndPos) {
        if (rsList == null)
            return null;

        if (iEndPos > rsList.size())
            iEndPos = rsList.size();
        if (iEndPos <= 0)
            iEndPos = rsList.size();

        int[] rsArr = new int[iEndPos - iStartPos];

        int iCnt = 0;

        for (int iLoop = 0; iLoop < iEndPos; iLoop++) {

            if (iLoop < iStartPos)
                continue;

            Map dbRow = (Map) rsList.get(iLoop);
            rsArr[iCnt++] = Integer.parseInt(CommonUtil.getConv(dbRow.get(strField), "0"));
        }

        return rsArr;
    }

    @SuppressWarnings("rawtypes")
	public static String[] getListToArray(List rsList, String strField) {

        return getListToArray(rsList, strField, 0, 0);
    }

    @SuppressWarnings("rawtypes")
	public static String[] getListToArray(List rsList, String strField, int iStartPos, int iEndPos) {
        if (rsList == null)
            return null;

        if (iEndPos > rsList.size())
            iEndPos = rsList.size();
        if (iEndPos <= 0)
            iEndPos = rsList.size();

        String[] rsArr = new String[iEndPos - iStartPos];

        int iCnt = 0;

        for (int iLoop = 0; iLoop < iEndPos; iLoop++) {

            if (iLoop < iStartPos)
                continue;

            Map dbRow = (Map) rsList.get(iLoop);
            rsArr[iCnt++] = CommonUtil.getConv(dbRow.get(strField));
        }

        return rsArr;
    }

    public static String getArrayValueComma(String[] rsArr) {
        return getArrayValueComma(rsArr, 0, 0);
    }

    public static String getArrayValueComma(String[] rsArr, int iStartPos, int iMax) {
        StringBuffer sb = new StringBuffer();

            if (rsArr == null)
                return "";
            if (iMax == 0)
                iMax = rsArr.length;
            for (int iLoop = iStartPos; iLoop < rsArr.length; iLoop++) {
                sb.append((sb.length() == 0) ? String.valueOf(rsArr[iLoop]) : "," + String.valueOf(rsArr[iLoop]));
            }

        return sb.toString();
    }

    public static String getArrayValueComma(int[] rsArr) {
        StringBuffer sb = new StringBuffer();

            if (rsArr == null)
                return "";
            for (int iLoop = 0; iLoop < rsArr.length; iLoop++) {
                sb.append((iLoop == 0) ? String.valueOf(rsArr[iLoop]) : "," + String.valueOf(rsArr[iLoop]));
            }

        return sb.toString();
    }

    public static String getRealContent(String source) {
        int start = source.indexOf("<DIV");
        if (start < 0)
            return source;

        int realStart = source.substring(start, source.length()).indexOf(">") + start + 1;
        int end = source.indexOf("</DIV");
        return source.substring(realStart, end);
    }

    public static String getTitleLimit(String title, int maxNum, int re_level) {
        int blankLen = 0;
        if (re_level != 0) {
            blankLen = (re_level + 1) * 2;
        }
        int tLen = title.length();
        int count = 0;
        char c;
        int s = 0;

        for (s = 0; s < tLen; s++) {
            c = title.charAt(s);
            if ((int) (count) > (int) (maxNum - blankLen)) {
                break;
            }

            if (c > 127)
                count += 2;
            else
                count++;
        }
        return (tLen > s) ? title.substring(0, s) + "..." : title;
    }


    /**
     * URL 중에서 해당 필드 값을 삭제함 <br>
     * Method Description.
     * @param strParam URL 파라메터
     * @param strNotWord 삭제할 필드
     * @return String
     * @since 1.00
     * @see
     */
    @SuppressWarnings("unused")
	public static String changeHtmlTag(String strParam) {
        String strSTag = "<table";
        String strETag = "</table>";
        String strTag  = "";

        //int iEndPos    = 0;
        int iStartPos  = 0;
        StringBuffer sb = new StringBuffer();


            if (strParam == null || "".equals(strParam))
                return "";

        	iStartPos = indexOfaA(strParam.toLowerCase(), strSTag, 0);

            if (iStartPos < 0)
                return changeBrTag(strParam);

            sb.append(changeBrTag(strParam.substring(0, iStartPos)));
            strParam = strParam.substring(iStartPos);


            iStartPos = strParam.lastIndexOf(strETag);
            if (iStartPos < 0) {
            	sb.append(changeBrTag(strParam));
            } else {
                sb.append(changeBrTag(strParam.substring(0, iStartPos + strETag.length())));
                strParam = strParam.substring(iStartPos + strETag.length());
            }

            sb.append(changeBrTag(strParam));

        return sb.toString();

    }

    public static String changeBrTag(Object objKey)
    {
        String strKey = getConv(objKey, "&nbsp;");

        strKey = recoveryLtGt(strKey);

        String strComp = strKey.toLowerCase();

         if ( strComp.indexOf("<br")     >= 0 ||
        	  strComp.indexOf("<li")     >= 0 ||
        	  strComp.indexOf("<table")  >= 0 ||
        	  strComp.indexOf("<tr")     >= 0 ||
        	  strComp.indexOf("<td")     >= 0 ||
        	  strComp.indexOf("<div")    >= 0 ||
        	  strComp.indexOf("<p")      >= 0 ) {
        } else {
        	strKey = strKey.replace("\r\n", "<br/>");
        	strKey = strKey.replace("\n", "<br/>");
        }

         return strKey;
    }

    public static String getReplaceToHtml(Object objKey) {
        String strKey = changeHtmlTag(getConv(objKey, "&nbsp;"));
        strKey = strReplace(strKey, "\\", "");
        return strKey;
    }

    public static String strReplace(String stro, String s1, String s2) {
        int i = 0;
        String rStr = "";
        while(stro.indexOf(s1) > -1){
                i = stro.indexOf(s1);
                rStr += stro.substring(0,i)+s2;
                stro = stro.substring(i+s1.length());
        }
        return rStr+stro;
  }



    public static int getRandomInt(int limit) {
        int number = random.nextInt();
        number = (number >>> 16) & 0xffff;
        number /= (0xffff / limit);
        return number;
    }



    @SuppressWarnings("static-access")
	public static String getNow() {
        String now = "";
        String nows[] = new String[3];
        int date[] = new int[3];
        Calendar cal = Calendar.getInstance();

        date[0] = cal.get(cal.MONTH) + 1;
        date[1] = cal.get(cal.DATE);
        date[2] = cal.get(cal.HOUR_OF_DAY);

        for (int i = 0; i < date.length; i++) {
            if (date[i] < 10) {
                nows[i] = "0" + new Integer(date[i]).toString();
            } else {
                nows[i] = new Integer(date[i]).toString();
            }
            now = now + nows[i];
        }
        return String.valueOf(cal.get(cal.YEAR)) + now;
    }

    public static int getLastDay(String days) {
        int ls = 0;
        int year = Integer.parseInt(days.substring(0, 4));
        int mon = Integer.parseInt(days.substring(4, 6));
        switch (mon) {
        case 2:
            ls = yoonMon(year);
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            ls = 30;
            break;
        default:
            ls = 31;
        }
        return ls;
    }

    public static int yoonMon(int year) {
        int yn = 0;
        int fyear = (int) (year / 100);
        int byear = year % 100;
        if (fyear % 4 == 0 && year % 4 == 0) {
            yn = 29;
        } else {
            if (byear != 0 && byear % 4 == 0) {
                yn = 29;
            } else {
                yn = 28;
            }
        }
        return yn;
    }


    /**<pre>
     * 년월일 사이에 구분자 sep를 첨가한다. 구분자가 "/"인 경우 "yyyymmdd" -> "yyyy/mm/dd"가 된다.
     *
     * @return java.lang.String
     * @param str 날짜(yyyymmdd)
     */
    public static String date(String str, String sep) {
      String temp = null;
      if (str == null)
        return "";
      int len = str.length();

      if (len != 8)
        return str;
      if ( (str.equals("00000000")) || (str.equals("       0")) || (str.equals("        ")))
        return "";
      temp = str.substring(0, 4) + sep + str.substring(4, 6) + sep + str.substring(6, 8);

      return temp;
    }

    public static long toLong(Float fNum) {
        String strVal;

        strVal = String.valueOf(fNum);

        if ( strVal.indexOf('.') > 0 ) {

            strVal =  strVal.substring(0, strVal.indexOf('.'));
        }

        return Long.valueOf(strVal);

    }

    public static long toLong(float fNum){
        return toLong( (Float) fNum );
    }

    public static String getSelBoxRepeat(int nStart, int nEnd, int nComp, int nSize)
    {
        return getSelBoxRepeat(nStart, nEnd, String.valueOf(nComp), nSize);
    }

    public synchronized static String getSelBoxRepeat(int nStart, int nEnd, Object objComp, int nSize)
    {
        StringBuffer strBuf = new StringBuffer();
        String strValue = new String();
        String strComp  = "";

        if ( objComp != null)
            strComp = objComp.toString();

        String strFormat = "%0" + String.valueOf(nSize) + "d";

        for (int nLoop = nStart; nLoop <= nEnd; nLoop ++ )
        {
           strBuf.append("<option value='");
           if ( nSize > 0 )
               strValue = String.format(strFormat, nLoop);
           else
               strValue = String.valueOf(nLoop);
           strBuf.append(strValue + "' " );
           if ( String.valueOf(nLoop).equals(strComp))
               strBuf.append(" selected " );
           strBuf.append(" >"  + String.valueOf(nLoop) + " </option> " + "\n");
        }


        return strBuf.toString();
    }

    public static String getNewImage(Object objDt) {
    	return getNewImage(objDt, "");
	}

    /**
     * Method Summary. <br>
     * New 이미지를 표시
     * @param imgPath 이미지 경로
     * @return imgSize 이미지 사이즈 배열
     * @throws Exception ex
     * @since 1.00
     * @see
     */
    public static String getNewImage(Object objDt, String kind)
    {
        String strBaseDt;
        String strCurDt = addDay(getCurrentDate(), -2);

        if ( objDt == null) return "";

        strBaseDt = objDt.toString();
        if ( "".equals(strBaseDt)) return "";

        if ( strBaseDt.length() > 8)
        	strBaseDt = strBaseDt.replace("-", "").substring(0, 8);

        if ( Integer.parseInt(strBaseDt) >= Integer.parseInt(strCurDt) ) {
        	if (kind.equals("board")) {
        		return  "<img src=\"" + CommDef.APP_CONTENTS + "/images/sb_ico_notice.png\" style=\"center;padding-right:5px;\"/>";
        	} else {
        		return  "&nbsp;&nbsp;<font color=\"red\">New</font>";
        	}
        }

        return "";
    }

    /**
     * Parameters : srcDate - 기준일자 <br>
     * cnt - 카운터 <br>
     * Return Value : String <br>
     * 내용 : 기준일에 해달 카운터 만큼의 일자를 증가시킨다. <br>
     */
    public static String addDay(String srcDate, int cnt) {
        String rtnData = null;
        try {

            String year = srcDate.substring(0, 4);
            String month = srcDate.substring(4, 6);
            String day = srcDate.substring(6, 8);

            SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
            formatter.getCalendar().set(Integer.parseInt(year), Integer.parseInt(month) - 1, Integer.parseInt(day),
                    0, 0, 0);
            formatter.getCalendar().add(Calendar.DATE, cnt);

            Date chkDay = formatter.getCalendar().getTime();

            rtnData = (String) formatter.format(chkDay);

            year = rtnData.substring(0, 4);
            month = rtnData.substring(5, 7);
            day = rtnData.substring(8, 10);

            rtnData = year + month + day;
        } catch (RuntimeException e) {
            LOGGER.error(e.getMessage());
            rtnData = "";

        } catch(Exception e) {
    		LOGGER.error(e.getMessage());
    		rtnData = "";

    	}

        return rtnData;
    }

    /**
     * Method Summary. <br>
     * File Text Read
     * @param imgPath 이미지 경로
     * @return imgSize 이미지 사이즈 배열
     * @throws Exception ex
     * @since 1.00
     * @see
     */

    public static String getFileRead(String strFile)
    {
    	String strContext="";

        try {
        	  Reader reader = new InputStreamReader(  new FileInputStream(strFile),"UTF-8");
        	  BufferedReader fin = new BufferedReader(reader);

        	  String fileContent;
        	  while ((fileContent = fin.readLine())!=null) {
        		  strContext +=  fileContent + "\n";
              }
        	  //Remember to call close.
        	  //calling close on a BufferedReader/BufferedWriter
        	  // will automatically call close on its underlying stream
        	  fin.close();
		  	  } catch (RuntimeException e) {
				  LOGGER.error(e.getMessage());
        	  } catch (IOException e) {
        		  LOGGER.error(e.getMessage());
        	  } catch (Exception e) {
        		  LOGGER.error(e.getMessage());
        	  }

   	   return strContext;
    }

    @SuppressWarnings("rawtypes")
	public static String getInStr(List lstGroupMin, String strField)
    {
    	String strVal = "";

    	for(int nLoop=0; nLoop < lstGroupMin.size(); nLoop++)
    	{
    		Map  dbRow = (Map) lstGroupMin.get(nLoop);

    		String strMap  = CommonUtil.getMapVal(dbRow, strField);

    		if (!"".equals(strMap))
    		{
	    		if (!"".equals(strVal)) strVal += ",";
	    		strVal += CommonUtil.getMapVal(dbRow, strField);
    		}
    	}

    	return strVal;
    }

    public static String scriptMsg(String strMsg)
    {
    	return scriptMsg(strMsg, "");
    }

    public static String scriptMsg(String strMsg, String strUrl)
    {
    	StringBuffer sb = new StringBuffer();
    	sb.append("<script>");
    	sb.append("alert('" + strMsg + "')");

    	sb.append("</script>");

    	if ( !"".equals(strUrl))
    		sb.append("<meta http-equiv='refresh' content='0;url=" + strUrl + "'>");

    	return sb.toString();
    }

    @SuppressWarnings({ "rawtypes", "unused" })
	public static String getOneFileName(List fileList, String strCompareGbn)
    {

        int nCnt = 0;
        String strFileName = "";

        if(fileList != null && fileList.size() > 0){

           for( int iLoop = 0; iLoop < fileList.size(); iLoop++ ) {
               Map fileMap = ( Map ) fileList.get( iLoop );

               String strFileGbn = getNullTrans(fileMap.get("FILE_GBN"),"");

               if (strCompareGbn.equals(strFileGbn) ||  "".equals(strCompareGbn) )
               {
            	   strFileName = getNullTrans(fileMap.get("FILE_NM"));
            	   break;
               }
           }
        }

        return strFileName;
    }

    @SuppressWarnings("rawtypes")
	public static List getFileGbnList(List fileList)
    {
    	return getFileGbnList(fileList, "");
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
	public static List getFileGbnList(List fileList, String strCompareGbn)
    {

        List valLst = new ArrayList<Map>();

        if(fileList != null && fileList.size() > 0){

           for( int iLoop = 0; iLoop < fileList.size(); iLoop++ ) {
               Map fileMap = ( Map ) fileList.get( iLoop );

               String strFileGbn = getNullTrans(fileMap.get("FILE_GBN"),"");
               if (strCompareGbn.equals(strFileGbn) ||  "".equals(strCompareGbn) )
               {
            	   Map rowMap  = new HashMap<String, String>();

            	   Iterator iter = fileMap.keySet().iterator();

            	   while( iter.hasNext()) {
	            	    String key    = (String)iter.next();
	            	    String value  = (String)fileMap.get( key );

	            	    //System.out.println( key +": " + value );
	            	    rowMap.put(key, value);
	            	    valLst.add(rowMap);
            	   }
              }
           }

        }

        return valLst;
    }

	 public static String getImageResizeStr(HttpServletRequest req, String strImg, int nFixWidth) {

		 return getImageResizeStr(req, strImg, nFixWidth, 9000);
	 }


	 public static String getImageResizeStr(HttpServletRequest req, String strImg, int nFixWidth, int nFixHeight)
	 {
		 String strImgWH = "";
		 try {
		     int nArrSize[] = getImageResize(req, strImg, nFixWidth, nFixHeight);
			 if ( nArrSize[0] > 0 && nArrSize[1] > 0)
			 {
				 strImgWH = " width = '" + nArrSize[0] + "' height='" + nArrSize[1] + "'";
			 }
		 }
       catch (RuntimeException e) {
		  LOGGER.error(e.getMessage());
	  } catch (Exception e) {
		  LOGGER.error(e.getMessage());
	  }

		 return strImgWH;
	 }

	 @SuppressWarnings("unused")
	public static int[] getImageResize(HttpServletRequest req, String strImg, int nFixWidth, int nFixHeight)
	 {

		 int nReWidth = 0;
		 int nReHeight = 0;
		 int nRate     = 0;
		 int nArrSize[] = {0,0};
		 InputStream is = null;
	     try {

	    	 if ( strImg == null || "".equals(strImg))
	    		 return nArrSize;

	    	 String strUrl = getServletUrl(req)   + strImg;

	        // URL url = new URL(strUrl);
	        // Image image = ImageIO.read(url);

	    	   // Read from an input stream

	    	 String strPath = strImg;


	    	 is = new BufferedInputStream( new FileInputStream(strPath));
	    	 Image  image = ImageIO.read(is);

	         int nWidth  = image.getWidth(null);
	         int nHeight = image.getHeight(null);

	         if ( nWidth >= nFixWidth ) // 원하는 길이보다 넓이가 넓은 경우
	         {
	        	 nRate   = ( nFixWidth * 100 ) /  nWidth  ;
	        	 nWidth  = ( nWidth    *  nRate ) / 100 ;
	        	 nHeight = ( nHeight   *  nRate ) / 100 ;
	         }

	         if ( nHeight >= nFixHeight ) // 원하는 길이보다 넓이가 넓은 경우
	         {
	        	 nRate   = ( nFixHeight * 100)  / nHeight  ;
	        	 nWidth  = ( nWidth     * nRate ) / 100 ;
	        	 nHeight = ( nHeight    * nRate ) / 100 ;
	         }

	    	 nArrSize[0] = nWidth;
	    	 nArrSize[1] = nHeight;

	        } catch (RuntimeException e) {
	        	LOGGER.error(e.getMessage());

	        } catch(IOException e) {
	        	LOGGER.error(e.getMessage());

	    	} catch(Exception e) {
	    		LOGGER.error(e.getMessage());

	    	} finally {
	    		if (is != null) try { is.close();} catch (Exception e) { LOGGER.error(e.getMessage());  }
	    	}

	     return nArrSize;
	 }

	    /**
	     * request 객체 정보를 기반으로 context Root 전까지의 URL 정보를 반환한다.
	     * @param request HttpServletRequest 객체
	     * @return URL 정보 (예. http://www.abc.com:7001)
	     * @since 1.00
	     * @see
	     */
	    public static String getServletUrl(HttpServletRequest request) {
	        String sServerName = request.getServerName();
	        int iServerPort = request.getServerPort();
	        String sScheme = request.getScheme();

	        String sServerUrl = sScheme + "://" + sServerName + (iServerPort == 80 ? "" : ":" + iServerPort);
	        return sServerUrl;
	    }


		public static Object alertMsgGoUrl(HttpServletResponse response, String msg, String returnUrl) throws IOException{

	   		response.setContentType("text/html;charset=euc-kr");

			PrintWriter output = response.getWriter();

			output.println("<html>");
			output.println("<head>");
			output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
			output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

			output.println("<script type='text/javascript' >");
			if (!"".equals(msg))
			{
			   output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
			}
			//output.println("alert('"+kscToAsc(msg).replaceAll("\\'", "\\\"")+"');");
			output.println("window.location.href='" + returnUrl+"';");
			output.println("</script>");

			output.println("</head>");
			output.println("</html>");

			output.flush();
			output.close();

			return "";
		}



		public static Object alertMsgBack(HttpServletResponse response, String msg) throws IOException{

			response.setContentType("text/html;charset=utf-8");

			PrintWriter output = response.getWriter();

			output.println("<html>");
			output.println("<head>");
			output.println("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
			output.println("<title>" + CommDef.CONFIG_COMPANY + "</title>");

			output.println("<script type='text/javascript' charset='utf-8'>");
			output.println("alert('"+msg.replaceAll("\\'", "\\\"")+"');");
			//output.println("alert('"+kscToAsc1(msg).replaceAll("\\'", "\\\"")+"');");
			output.println("window.history.back();");
			output.println("</script>");

			output.println("</head>");
			output.println("</html>");

			output.flush();
			output.close();

			return "";
		}

      public static String getReplyImg(String strDepth)
      {
    	  String strVal = "";

    	  if (strDepth == null || "".equals(strDepth))
    		  return "";

    		  int nDepth = Integer.parseInt(strDepth);
    		  for (int nLoop = 1; nLoop < nDepth; nLoop++)
    		  {
    			  strVal += "&nbsp;&nbsp;&nbsp;";
    		  }

    		  if ( !"".equals(strVal))
    		  {
    			  strVal += "<img src='/images/common/ico_reply.gif'>";
    		  }

    	  return strVal;
      }

      public static String getSecretImg(String strDepth)
      {
    	  String strVal = "";

    	  if ("Y".equals(strDepth)) {
    			  strVal += "<img src='/images/common/ico_secret.jpg' style='width:16px;height:16px'>";
    	  }
    	  return strVal;
      }


	    /**
	     * 썸네일 이미지 주소 반환
	     * @param value
	     * @return
	     */
	    public static String getThumnailSrc(Object value, String foldernm) {
	    	String valueText = "";

	    	try {
	    		String[] valuesplit = value.toString().split("/");
	    		int id = valuesplit[3].lastIndexOf(".");
	    		valueText = "/" + valuesplit[1] + "/" + valuesplit[2] + "/" + foldernm + "/" + valuesplit[3].substring(0, id) + ".png";
	    	} catch (Exception e) {
	    		LOGGER.error(e.getMessage());
	    	}

	    	return valueText;
	    }

	    /**
	     * 게시판 전용 썸네일 이미지 주소 반환
	     * @param value
	     * @return
	     */
	    public static String getThumnailSrc(Object value) {
	    	String valueText = "";

	    	try {
	    		String[] valuesplit = value.toString().split("/");
	    		int id = valuesplit[4].lastIndexOf(".");
	    		valueText = "/" + valuesplit[1] + "/" + valuesplit[2] + "/" + valuesplit[3] + "/thumbnail/"  + valuesplit[4].substring(0, id) + ".png";
	    	  } catch (NullPointerException e) {
	    		  LOGGER.error(e.getMessage());
	    	  } catch (RuntimeException e) {
	    		  LOGGER.error(e.getMessage());
	    	  } catch (Exception e) {
	    		  LOGGER.error(e.getMessage());
	    	  }

	    	return valueText;
	    }

    /**
     * 브라우저 구분 얻기.
     *
     * @param request
     * @return
     */
    public static String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1) {
            return "IE";
        } else if (header.indexOf("Trident") > -1) {     // IE11 문자열 깨짐 방지
            return "IE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        } else if (header.indexOf("Safari") > -1) {
            return "Safari";
        } else if (header.indexOf("Firefox") > -1) {
            return "Firefox";
        }
        return "ETC";
    }

    /**
     * 접속자의 OS 정보를 가져옵니다.
     * @param request
     * @return
     */
    public static String getOs(HttpServletRequest request) {
    	String header = request.getHeader("User-Agent");
    	String os = null;

    	if(header.indexOf("NT 6.0") != -1) os = "Windows Vista/Server 2008";
    	else if(header.indexOf("NT 5.2") != -1) os = "Windows Server 2003";
    	else if(header.indexOf("NT 5.1") != -1) os = "Windows XP";
    	else if(header.indexOf("NT 5.0") != -1) os = "Windows 2000";

    	else if(header.indexOf("NT 6.1") != -1) os = "Windows 7";
    	else if(header.indexOf("NT 6.2") != -1) os = "Windows 8";
    	else if(header.indexOf("NT 6.3") != -1) os = "Windows 8.1";
    	else if(header.indexOf("NT 10.0") != -1) os = "Windows 10";

    	else if(header.indexOf("NT") != -1) os = "Windows NT";
    	else if(header.indexOf("9x 4.90") != -1) os = "Windows Me";
    	else if(header.indexOf("98") != -1) os = "Windows 98";
    	else if(header.indexOf("95") != -1) os = "Windows 95";
    	else if(header.indexOf("Win16") != -1) os = "Windows 3.x";
    	else if(header.indexOf("Windows") != -1) os = "Windows";
    	else if(header.indexOf("Linux") != -1) os = "Linux";
    	else if(header.indexOf("Macintosh") != -1) os = "MAC OS";

    	else if(header.indexOf("Android") != -1 && header.indexOf("Linux") != -1) os = "Android";
    	else if(header.indexOf("iPhone") != -1 && header.indexOf("Mac OS") != -1) os = "iOS";
    	else if(header.indexOf("iPad") != -1 && header.indexOf("Mac OS") != -1) os = "iOS";

    	else os = "ETC";

    	return os;
    }

    /**
     * 문자열 UTF-8 인코딩
     * @param request
     * @param str
     * @return
     * @throws Exception
     */
    public static String getUrlEncodeString(HttpServletRequest request, String str) throws Exception{

    	String browser = getBrowser(request);
    	String encodedString = str;

        if (browser.equals("MSIE")) {
        	encodedString = URLEncoder.encode(str, "UTF-8").replaceAll("\\+", "%20");
        } else if (browser.equals("Trident")) {          // IE11 문자열 깨짐 방지
        	encodedString = URLEncoder.encode(str, "UTF-8").replaceAll("\\+", "%20");
        }

    	return encodedString;

    }

    /**
     * 파일 존재 여부 체크
     * @param request
     * @param src 체크 파일 경로
     * @param nSrc 변경 파일 경로
     * @return
     */
    public static String checkExistFile(HttpServletRequest request, String src, String nSrc) {

    	String path = request.getSession().getServletContext().getRealPath(src);
    	File file = new File(path);

    	if(!file.isFile()) {
    		if(nSrc != null && !"".equals(nSrc)) {
    			src = nSrc;
    		}
    	}

    	return src;
    }


    /**
     * 다음 알파벳을 반환합니다.
     * @param source
     * @return
     */
    public static String nextAlphabet(String source) {
        int length = source.length();
        char lastChar = source.charAt(length - 1);
        if (lastChar == 'Z') {
          if (length == 1) {
            return source = "AA";
          }
          if (length < 10) {
        	  source = nextAlphabet(source.substring(0, length - 1));
          }
          source += "A";
          return source;
        }
        return source.substring(0, length - 1) + String.valueOf((char) (lastChar + 1));
     }

    /**
     * 답변 공백 라인 확인
     * @param reply
     * @param replyType
     * @return
     */
    public static String getReplylen(String reply, String replyType) {
    	String replylen = "";

    	//skin용
    	if (replyType.equals("img")) {
    		if (reply.length() > 0)
    			replylen = "reply" + reply.length();

    	//코멘트용
    	} else if (replyType.equals("comment")) {
    		if (reply.length() > 0)
    			replylen = "reply";
    		else
    			replylen = "info";
    	//관리자용
    	} else {
    		if (reply.length() > 0) {
    			for (int i = 0; i <= reply.length(); i ++) {
    				replylen += "&nbsp;";
    			}

    			replylen += "└&nbsp;";
    		}
    	}

    	return replylen;
    }

    /**
     * 비밀글을 표시합니다.
     * @param secret
     * @param boardimg
     * @return
     */
    public static String getListSecret(String secret, String boardimg) {
    	String secretText = "";

    	if (secret.equals("Y")) {
    		//skin 용
    		if (boardimg.equals("board")) {
    			secretText = "<img src=\"" + CommDef.APP_CONTENTS + "/images/sb_ico_secret.png\" alt=\"비밀글\" />";
    		} else {
    			secretText = "<b>[비밀글]</b>&nbsp;";
    		}
    	}

    	return secretText;
    }

    /**
     * Method Summary. <br>
     * 댓글 코멘트를 반환합니다.
     * @param oData Object : 객체
     * @return String
     */
    public static String getReplyComma(String strVal) {

    	strVal = getNullTrans(strVal, "0");
    	if (!"0".equals(strVal)) {
    		DecimalFormat formatter = new DecimalFormat("#,##0");
    		return "&nbsp;[" + formatter.format(Integer.parseInt(strVal)) + "]";
    	} else {
    		return "";
    	}

    }

    /**
     * 사용, 미사용 여부를 반환합니다.
     * @param strVal
     * @return
     */
    public static String getYNusetext(String strVal) {
    	strVal = getNullTrans(strVal, "");

    	if ("Y".equals(strVal)) {
    		return "<b>사용</b>";
    	} else if ("N".equals(strVal)) {
    		return "미사용";
    	} else {
    		return "";
    	}
    }

    /**
     * 노출, 미노출 여부를 반환합니다.
     * @param strVal
     * @return
     */
    public static String getYNshowtext(String strVal) {
    	strVal = getNullTrans(strVal, "");

    	if ("Y".equals(strVal)) {
    		return "<b>노출</b>";
    	} else if ("N".equals(strVal)) {
    		return "미노출";
    	} else {
    		return "";
    	}
    }

    /**
     * 답변, 미답변 여부를 반환합니다.
     * @param strVal
     * @return
     */
    public static String getYNReplytext(String strVal) {
    	strVal = getNullTrans(strVal, "");

    	if ("Y".equals(strVal)) {
    		return "<b>답변완료</b>";
    	} else if ("N".equals(strVal)) {
    		return "답변대기";
    	} else {
    		return "";
    	}
    }

    /**
     * 숫자별 요일을 반환합니다.
     * @param strVal
     * @return
     */
    public static String getWeekDay(String strVal) {
    	strVal = getNullTrans(strVal, "");

    	if ("0".equals(strVal)) {
    		return "일요일";
    	} else if ("1".equals(strVal)) {
    		return "월요일";
    	} else if ("2".equals(strVal)) {
    		return "화요일";
    	} else if ("3".equals(strVal)) {
    		return "수요일";
    	} else if ("4".equals(strVal)) {
    		return "목요일";
    	} else if ("5".equals(strVal)) {
    		return "금요일";
    	} else if ("6".equals(strVal)) {
    		return "토요일";
    	} else {
    		return "";
    	}
    }


    /**
     * 일단위 날짜 차이 계산하기
     * @param regdt
     * @return
     * @throws Exception
     */
    public static long diffDays(Object regdt) throws Exception{

    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyyMMdd");
        String stDate = df.format(new Date());
        Date date = df.parse(stDate);

        String stRegdt = ((String)regdt).replace("-", "").substring(0, 8);
        Date oDate = df.parse(stRegdt);

        long diff = date.getTime() - oDate.getTime();
        long diffDays = diff / (24*60*60*1000);

        return diffDays;
    }

    @SuppressWarnings("rawtypes")
	public static String getListTransXml(List rsLst, String strRoot)
	 {
		 String strVal = "";

		 if ( rsLst != null && !rsLst.isEmpty()) {
			 for (int nLoop=0; nLoop < rsLst.size(); nLoop++) {

				 strVal += "<" + strRoot + ">";
				 Map rsMap = (Map)rsLst.get(nLoop);

				  Iterator iter = rsMap.keySet().iterator();

					 while( iter.hasNext())
					 {
						  String key = (String)iter.next();
						  String value = nvl(rsMap.get( key ));

						  strVal += "<" + key.toLowerCase() + ">";
						  strVal += "<![CDATA[" + value.trim() + "]]>";
						  strVal += "</" + key.toLowerCase() + ">\n";
					 }
				 strVal += "</" + strRoot + ">";
			 }
		 }

	    return strVal;
	 }

	    /**
	    회원 등급 구분
	   */
	  public static String getMemberType(Object value) {
	  	String valueText = "";

	  	if (value.equals("Y")) {
	  		valueText = "일반";
	  	} else if (value.equals("N")) {
	  		valueText = "<font color='blue'>승인대기</font>";
	  	} else if (value.equals("D")) {
	  		valueText = "<font color='red'>탈퇴</font>";
	  	}

	  	return valueText;
	  }

    /*
    * XSS 방지
    */
    public static String removeXSS(String str, boolean use_html) {
	    String str_low = "";
	    if(use_html){ // HTML tag를 사용하게 할 경우 부분 허용
		    // HTML tag를 모두 제거
		    str = str.replaceAll("<","&lt;");
		    str = str.replaceAll(">","&gt;");
		    // 허용할 HTML tag만 변경
		    str = str.replaceAll("&lt;p&gt;", "<p>");
		    str = str.replaceAll("&lt;P&gt;", "<P>");
		    str = str.replaceAll("&lt;br&gt;", "<br>");
		    str = str.replaceAll("&lt;BR&gt;", "<BR>");
		    // 스크립트 문자열 필터링
		    str_low= str.toLowerCase();

		    if( str_low.contains("x-javascript") || str_low.contains("script") || str_low.contains("iframe") ||
		    str_low.contains("document") || str_low.contains("vbscript") || str_low.contains("applet") ||
		    str_low.contains("embed") || str_low.contains("object") || str_low.contains("frame") ||
		    str_low.contains("grameset") || str_low.contains("layer") || str_low.contains("bgsound") ||
		    str_low.contains("alert") || str_low.contains("onblur") || str_low.contains("onchange") ||
		    str_low.contains("onclick") || str_low.contains("ondblclick") || str_low.contains("enerror") ||
		    str_low.contains("onfocus") || str_low.contains("onload") || str_low.contains("onmouse") ||
		    str_low.contains("onscroll") || str_low.contains("onsubmit") || str_low.contains("onunload"))
		    {
			    str = str_low;
			    str = str.replaceAll("x-javascript", "x-x-javascript");
			    str = str.replaceAll("script", "x-script");
			    str = str.replaceAll("iframe", "x-iframe");
			    str = str.replaceAll("document", "x-document");
			    str = str.replaceAll("vbscript", "x-vbscript");
			    str = str.replaceAll("applet", "x-applet");
			    str = str.replaceAll("embed", "x-embed");
			    str = str.replaceAll("object", "x-object");
			    str = str.replaceAll("frame", "x-frame");
			    str = str.replaceAll("grameset", "x-grameset");
			    str = str.replaceAll("layer", "x-layer");
			    str = str.replaceAll("bgsound", "x-bgsound");
			    str = str.replaceAll("alert", "x-alert");
			    str = str.replaceAll("onblur", "x-onblur");
			    str = str.replaceAll("onchange", "x-onchange");
			    str = str.replaceAll("onclick", "x-onclick");
			    str = str.replaceAll("ondblclick","x-ondblclick");
			    str = str.replaceAll("enerror", "x-enerror");
			    str = str.replaceAll("onfocus", "x-onfocus");
			    str = str.replaceAll("onload", "x-onload");
			    str = str.replaceAll("onmouse", "x-onmouse");
			    str = str.replaceAll("onscroll", "x-onscroll");
			    str = str.replaceAll("onsubmit", "x-onsubmit");
			    str = str.replaceAll("onunload", "x-onunload");
		    }
		    }else{ // HTML tag를 사용하지 못하게 할 경우
		    str = str.replaceAll("\"","&gt;");
		    str = str.replaceAll("&", "&amp;");
		    str = str.replaceAll("<", "&lt;");
		    str = str.replaceAll(">", "&gt;");
		    str = str.replaceAll("%00", null);
		    str = str.replaceAll("\"", "&#34;");
		    str = str.replaceAll("\'", "&#39;");
		    str = str.replaceAll("%", "&#37;");
		    str = str.replaceAll("../", "");
		    str = str.replaceAll("..\\\\", "");
		    str = str.replaceAll("./", "");
		    str = str.replaceAll("%2F", "");
	    }
	    return str;
    }

    /**
     * 이름 마스킹 처리
     * @param name
     * @return
     */
    public static String getMaskedName(String name) {

        String maskedName = "";    // 마스킹 이름
        String firstName = "";     // 성
        String middleName = "";    // 이름 중간
        String lastName = "";      //이름 끝
        int lastNameStartPoint;    // 이름 시작 포인터

        if(!name.equals("") || name != null){
            if(name.length() > 1){
                firstName = name.substring(0, 1);
                lastNameStartPoint = name.indexOf(firstName);

                if(name.trim().length() > 2){
                    middleName = name.substring(lastNameStartPoint + 1, name.trim().length()-1);
                    lastName = name.substring(lastNameStartPoint + (name.trim().length() - 1), name.trim().length());
                }else{
                    middleName = name.substring(lastNameStartPoint + 1, name.trim().length());
                }

                String makers = "";
                for(int i = 0; i < middleName.length(); i++){
                    makers += "*";
                }

                lastName = middleName.replace(middleName, makers) + lastName;
                maskedName = firstName + lastName;
            }else{
                maskedName = name;
            }
        }

        return maskedName;
    }
    
    /**
     * 전화번호 패턴 매치
     * @param phoneNoStr
     * @return
     */
    public static String makePhoneNumber(String phoneNoStr) {
    	 
        String regEx = "(\\d{3})(\\d{3,4})(\\d{4})";
        if(!Pattern.matches(regEx, phoneNoStr)) return null;
        return phoneNoStr.replaceAll(regEx, "$1-$2-$3");
   
     }

}
