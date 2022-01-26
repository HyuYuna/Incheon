package egovframework.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import egovframework.db.DbController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class ServiceUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(ServiceUtil.class);
	public static DbController dbSvc;

	@SuppressWarnings("static-access")
	@Autowired
	private ServiceUtil(DbController dbSvc) {
		this.dbSvc = dbSvc;
	}

	public ServiceUtil() {}

	/**
	 * Class Summary.1 <br>
	 * Class Description.
	 * @since 1.00
	 * @version 1.00 - 2005. 12. 21
	 * @author 정소선
	 * @see
	 */

		    @SuppressWarnings("rawtypes")
			public List adminTopMenu(Map reqMap) {
		        return dbSvc.dbList(reqMap, "adminMember.userMenuList");
		    }

		    @SuppressWarnings("rawtypes")
			public List adminLeftTopMenu(Map reqMap) {
		        return dbSvc.dbList(reqMap, "adminMember.userLeftMenuList");
		    }


		    /**
		     * 주문 접수번호를 반환합니다.
		     * @param reqMap
		     * @return
		     */
		    @SuppressWarnings("rawtypes")
			public String getOrderNumber(Map reqMap) {

	    		int orderNumber = 0;
	    		int orderlength = 0;
	    		String regNumber = "";

		    	try {
	    		Map order = dbSvc.dbDetail(reqMap, "reservation.regLastNumber");

	    		if (order != null) {
	    			orderNumber = CommonUtil.getNullInt(order.get("REGN"), 0) + 1;
	    		} else {
	    			orderNumber = 1;
	    		}

	    		orderlength = 4;
	    		regNumber = "KSD" + CommonUtil.nvl(reqMap.get("today")) + CommonUtil.nvl(reqMap.get("reg_number")) + CommonUtil.padLeftwithZero(orderNumber, orderlength);

		  	  } catch (NullPointerException e) {
				  LOGGER.error(e.getMessage());
			  } catch (RuntimeException e) {
				  LOGGER.error(e.getMessage());
			  } catch (Exception e) {
				  LOGGER.error(e.getMessage());
			  }

		    	return regNumber;
		    }



		     /* Select Box  사용중*/
		      @SuppressWarnings({ "rawtypes", "unchecked" })
			public static String getSelectBox(String strReprcd, String strComp) {

		           Map reqMap = new HashMap();
		           String strVal = "";
		           String strSel = "";

		           //DbController dbDao = new DbController();

		           try {

		        	if ( "*".equals(strReprcd)) {
		        		reqMap.put("comm_cd"    , strReprcd);
		        	} else {
		           	    reqMap.put("cd_type"    , strReprcd);
		           	    reqMap.put("not_comm_cd", "*");
		        	}

		       		List rsLst = dbSvc.dbList(reqMap, "code.codeList");

		       		for(int nLoop=0; nLoop < rsLst.size(); nLoop++)
		       		{
		       			Map rsMap = (Map)rsLst.get(nLoop);
		       			String strCd = ("*".equals(strReprcd)) ? CommonUtil.nvl(rsMap.get("CD_TYPE")) : CommonUtil.nvl(rsMap.get("COMM_CD"));
		       			String strNm = CommonUtil.nvl(rsMap.get("CD_NM"));

		       			strSel = (strComp.equals(strCd)) ? " selected " : "";

		       			strVal += " <option value='" + strCd + "' " + strSel+">" + strNm + "</option>";
		       		}

		           } catch (RuntimeException e) {
		               LOGGER.error(e.getMessage());

		           } catch(Exception e) {
			       		LOGGER.error(e.getMessage());

			       	}

		           return strVal;
		       }

			     /* Select Box  사용중*/
		      @SuppressWarnings({ "rawtypes", "unchecked" })
			public static String getSelectBox(String strReprcd, String strComp, String strCompLike) {

		           Map reqMap = new HashMap();
		           String strVal = "";
		           String strSel = "";

		           //DbController dbDao = new DbController();

		           try {

		        	if ( "*".equals(strReprcd)) {
		        		reqMap.put("comm_cd"    , strReprcd);
		        	} else {
		           	    reqMap.put("cd_type"    , strReprcd);
		           	    reqMap.put("not_comm_cd", "*");
		        	}

		        	if (!strCompLike.equals("")) {
		        		reqMap.put("cd_type_like", strCompLike);
		        	}

		       		List rsLst = dbSvc.dbList(reqMap, "code.codeList");

		       		for(int nLoop=0; nLoop < rsLst.size(); nLoop++)
		       		{
		       			Map rsMap = (Map)rsLst.get(nLoop);
		       			String strCd = ("*".equals(strReprcd)) ? CommonUtil.nvl(rsMap.get("CD_TYPE")) : CommonUtil.nvl(rsMap.get("COMM_CD"));
		       			String strNm = CommonUtil.nvl(rsMap.get("CD_NM"));

		       			strSel = (strComp.equals(strCd)) ? " selected " : "";

		       			strVal += " <option value='" + strCd + "' " + strSel+">" + strNm + "</option>";
		       		}

		           } catch (RuntimeException e) {
		               LOGGER.error(e.getMessage());

		           } catch(Exception e) {
		       		LOGGER.error(e.getMessage());

		           }

		           return strVal;
		       }

		      /* Select Box 사용중 */
		      @SuppressWarnings({ "rawtypes", "unchecked" })
			public static String getRadioBox(String strReprcd, String strRdoNm, String strComp) {

		          Map reqMap = new HashMap();
		          String strVal = "";
		          String strSel = "";

		          //DbController dbDao = new DbController();

		           try {

		           	reqMap.put("cd_type"    , strReprcd);
		           	reqMap.put("not_comm_cd", "*");
		       		List rsLst = dbSvc.dbList(reqMap, "code.codeList");

		       		for(int nLoop=0; nLoop < rsLst.size(); nLoop++)
		       		{
		       			Map rsMap = (Map)rsLst.get(nLoop);
		       			String strCd = CommonUtil.nvl(rsMap.get("COMM_CD"));
		       			String strNm = CommonUtil.nvl(rsMap.get("CD_NM"));

		       			strSel = (strComp.equals(strCd)) ? " checked " : "";

		       			strVal += " <input type='radio' name='" + strRdoNm + "' id='id_" + strRdoNm + "_" + strCd + "' value='" + strCd + "' " + strSel+" class='input-text'><label for='id_"  + strRdoNm + "_" + strCd +  "'>" + strNm + "</label>";
		       		}

		           } catch (RuntimeException e) {
		               LOGGER.error(e.getMessage());

		           } catch(Exception e) {
		       		LOGGER.error(e.getMessage());

		       	}

		           return strVal;
		       }


		      /* Select Box 사용중 */
		      @SuppressWarnings({ "rawtypes", "unused" })
			public static String getRadioBox(List rsLst, String strRdoNm, String strComp) {

		          Map reqMap = new HashMap();
		          String strVal = "";
		          String strSel = "";

		          try {

		        	   if ( rsLst == null || rsLst.isEmpty())
		        		   return "";

			       		for(int nLoop=0; nLoop < rsLst.size(); nLoop++)
			       		{
			       			Map rsMap = (Map)rsLst.get(nLoop);
			       			String strCd = CommonUtil.nvl(rsMap.get("COMM_CD"));
			       			String strNm = CommonUtil.nvl(rsMap.get("CD_NM"));

			       			strSel = (strComp.equals(strCd)) ? " checked " : "";

			       			strVal += " <input type='radio' name='" + strRdoNm + "' id='id_" + strRdoNm + "_" + strCd + "' value='" + strCd + "' " + strSel+" class='input-text'><label for='id_"  + strRdoNm + "_" + strCd +  "'>" + strNm + "</label>";
			       		}

		          } catch (RuntimeException e) {
		              LOGGER.error(e.getMessage());

		          } catch(Exception e) {
		      		LOGGER.error(e.getMessage());

		      	}

		           return strVal;
		       }

		  @SuppressWarnings({ "rawtypes", "unchecked" })
		public String getCommCodeSelectBox(String strCodeSrt) {
		        Map reqMap = new HashMap();
		        reqMap.put("cd_type", strCodeSrt);

		        List lstCode = dbSvc.dbList(reqMap, "common.getCommonCodeList");

		        return makeSelectBox(lstCode);
		    }

		    @SuppressWarnings("rawtypes")
			public String makeSelectBox(List lstCode) {

		        StringBuffer retVal = new StringBuffer("");

		        if(lstCode != null && lstCode.size() > 0) {
		        	for(int iLoop=0; iLoop<lstCode.size(); iLoop++) {
		              Map dbRow = (Map) lstCode.get(iLoop);
		              retVal.append("<option value=\""+ (String)dbRow.get("CD") +"\">"+ (String)dbRow.get("NM") + "</option>\n");
		            }
		        }
		        return retVal.toString();
		    }


		    /**
		     * 공통코드 테이블(kpceb000)를 이용하여 SelectBox 테크에 <option value="코드">코드명 </option>
		     * 형태의 값을 구성함
		     * @param strCode  매핑할 대표코드
		     * @param strCompare  같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "unchecked", "rawtypes" })
			public String  getComboBox(String strCode, String strCompCode) {
		         Map map = new HashMap();
		         map.put("cd_type", strCode);

		         return getMakeSelectBox(dbSvc.dbList(map, "common.getCommonCodeList"), strCompCode);
		    }

		    /**
		     * 공통코드 테이블(kpceb000)를 이용하여 코드 그룹 SelectBox 테크에 <option value="코드">코드명 </option>
		     * 형태의 값을 구성함
		     * @param strCode  매핑할 대표코드
		     * @param strCd  매핑할 코드그룹
		     * @param strCompare  같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "unchecked", "rawtypes" })
			public String  getComboBox(String strCode,String strCd, String strCompCode) {
		         Map map = new HashMap();

		         map.put("cd_type", strCode);
		         map.put("cd", strCd);

		         return getMakeSelectBox(dbSvc.dbList(map, "common.getCommonCodeList"), strCompCode);
		    }


		    /**
		     * 공통코드 테이블(kpceb000)를 이용하여 코드 그룹 SelectBox 테크에 <option value="코드">코드명 </option>
		     * 형태의 값을 구성함
		     * @param strCode  매핑할 대표코드
		     * @param strCd  매핑할 코드그룹
		     * @param strCompare  같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public String  getComboBox(String strCode,String strCd, String strCdLike, String strCompCode) {
		         Map map = new HashMap();

		         map.put("cd_type",  strCode);
		         map.put("cd_like", strCdLike);

		         return getMakeSelectBox(dbSvc.dbList(map, "common.getCommonCodeList"), strCompCode);
		    }

		    /**
		     * 공통코드 테이블(kpceb000)를 정보를 읽음
		     * @param strCdSrt   대표코드
		     * @param strCd  코드
		     * @return Map
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public Map getCodeDetail(String strCdSrt, String strCd) {
		        Map map = new HashMap();

		        map.put("cd_type", strCdSrt);
		        map.put("comm_cd", strCd);

		        return dbSvc.dbDetail(map, "common.getCommonCodeDetail");
		    }

		    /**
		     * 공통코드 테이블(kpceb000)를 정보를 읽음
		     * @param strCdSrt   대표코드
		     * @param strCd  코드
		     * @return Map
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public List getCodeList(String strCdSrt) {
		        Map map = new HashMap();

		        map.put("cd_type", strCdSrt);
	            List  rltList = dbSvc.dbList(map, "common.getCommonCodeList")  ;
		        return rltList;
		    }


		    /**
		     * 공통코드 테이블(kpceb000)를 정보를 읽음
		     * @param strCdSrt   대표코드
		     * @param strCd  코드
		     * @return Map
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public Map getMenuCode(String strBrdKind) {
		        Map map = new HashMap();

		        map.put("menu_kind", strBrdKind);
	            Map  rltList = dbSvc.dbDetail(map, "adminMember.getMenuCode")  ;
		        return rltList;
		    }

		    /**
		     * 공통코드 테이블(kpceb000)를 이용하여 RadioBox 테크에 <option value="코드">코드명 </option> 부분을 생성함
		     * 형태의 값을 구성함
		     * @param strCode
		     * @param strFieldName
		     * @param strCompCode
		     * @param strEvent
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public String  getRadioBox(String strCode, String strFieldName, String strCompCode, String strEvent) {
		         Map map = new HashMap();

		         map.put("cd_type", strCode);

		         return getMakeRadioBox(dbSvc.dbList(map, "common.getCommonCodeList"), strFieldName, strCompCode, strEvent);
		    }

		    /**
		     * 공통코드 테이블(kpceb000)를 이용하여 RadioBox 테크에 <option value="코드">코드명 </option> 부분을 생성함
		     * 형태의 값을 구성함
		     * @param strCode
		     * @param strFieldName
		     * @param strCompCode
		     * @param strEvent
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public String  getRadioBox(String strCode,  String strLike, String strFieldName, String strCompCode, String strEvent) {
		         Map map = new HashMap();

		         map.put("cd_type", strCode);
		         map.put("cd_like", strLike);

		         return getMakeRadioBox(dbSvc.dbList(map, "common.getCommonCodeList"), strFieldName, strCompCode, strEvent);
		    }

		    /**
		     * Method 공통코드 테이블(kpceb000)를 이용하여 RadioBox 테크에 <option value="코드">코드명 </option> 부분을 생성함
		     * 형태의 값을 구성함
		     * @param strCode
		     * @param strLike
		     * @param strFieldName
		     * @param strCompCode
		     * @param strEvent
		     * @param strNotIn
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public String  getRadioBox(String strCode,  String strLike, String strFieldName, String strCompCode, String strEvent, String strNotIn) {
		         Map map = new HashMap();

		         map.put("cd_type", strCode);
		         map.put("cd_like", strLike);
		         map.put("not_in", strNotIn);

		         return getMakeRadioBox(dbSvc.dbList(map, "common.getCommonCodeList"), strFieldName, strCompCode, strEvent);
		    }


		    /**
		     * 공통코드 테이블(kpceb000)를 이용하여 CheckBox 테크에 <option value="코드">코드명 </option> 부분을 생성함
		     * 형태의 값을 구성함
		     * @param strCode
		     * @param strFieldName
		     * @param strCompCode
		     * @param strEvent
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "unchecked", "rawtypes" })
			public String  getCheckBox(String strCode, String strFieldName, String strCompCode, String strEvent) {
		         Map map = new HashMap();

		         map.put("cd_type", strCode);

		         return getMakeCheckBox(dbSvc.dbList(map, "common.getCommonCodeList"), strFieldName, strCompCode, strEvent);
		    }

		    @SuppressWarnings({ "unchecked", "rawtypes" })
			public String  getCheckBox(String strCode,  String strFieldName, String strCompCode) {
		         Map map = new HashMap();

		         map.put("cd_type", strCode);

		         strCompCode = strCompCode.replace(" ", "");

		         String[] arrCompCode = strCompCode.split(",");

		         return getMakeCheckBox(dbSvc.dbList(map, "common.getCommonCodeList"),  strFieldName , arrCompCode, "");
		    }

		    /**
		     * 공통코드 테이블(kpceb000)를 이용하여 CheckBox 테크에 <option value="코드">코드명 </option> 부분을 생성함
		     * 형태의 값을 구성함
		     * @param strCode
		     * @param strFieldName
		     * @param strCompCode
		     * @param strEvent
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "unchecked", "rawtypes" })
			public String  getCheckBox(String strCode, String strLike, String strFieldName, String strCompCode, String strEvent) {
		         Map map = new HashMap();

		         map.put("cd_type", strCode);
		         map.put("cd_like", strLike);

		         return getMakeCheckBox(dbSvc.dbList(map, "common.getCommonCodeList"), strFieldName, strCompCode, strEvent);
		    }

		    /**
		     * 공통코드 테이블(kpceb000)를 이용하여 CheckBox 테크에 <option value="코드">코드명 </option> 부분을 생성함
		     * 형태의 값을 구성함
		     * @param strCode
		     * @param strFieldName
		     * @param strCompCode
		     * @param strEvent
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public String  getCheckBox(String strCode, String strFieldName, List lstCompCode, String strEvent) {
		         Map map = new HashMap();

		         map.put("cd_type", strCode);

		         return getMakeCheckBox(dbSvc.dbList(map, "common.getCommonCodeList"), strFieldName, lstCompCode, strEvent);
		    }


		    /**
		     * RadioBox 테크에 <option value="코드">코드명 </option> 부분을 생성함
		     *
		     * @param strCompare comm_cd와 같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getMakeSelectBox(List listRow, String strCompare) {
		       String strVal = "";
		       try {
			 	       Iterator iterator = listRow.iterator();

			 	       while(iterator.hasNext())
			 	      {
			 	      	Map resultMap = (Map)iterator.next();
			 	        String strCode = resultMap.get("COMM_CD").toString();
			 	        String strName = (String)resultMap.get("CD_NM").toString();

		  	      	    String strSelected = strCode.equals(strCompare)  ? " selected " : " " ;

			 	      	strVal += " <option value=\'" + strCode + "\'" + strSelected + ">"  + strName + "</option>\n";
			 	     }

		        } catch (RuntimeException e) {
		            LOGGER.error(e.getMessage());

		        } catch(Exception e) {
		    		LOGGER.error(e.getMessage());

		    	}

		        return strVal;
		    }

		    /**
		     * RadioBox 테크에 <option value="코드">코드명 </option> 부분을 생성함
		     *
		     * @param strCompare comm_cd와 같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getMakeSelectBox(List listRow, String strCompare, List lstSubList) {
		       String strVal = "";
		       try {
		               Iterator iterator = listRow.iterator();

		               while(iterator.hasNext())
		              {
		                Map resultMap = (Map)iterator.next();
		                String strCode = resultMap.get("CD").toString();
		                String strName = (String)resultMap.get("NM").toString();

		                String strSelected = strCode.equals(strCompare)  ? " selected " : " " ;
		                boolean bFlag = true;

		                if(lstSubList.size()>0) {
		                    for(int i=0;i<lstSubList.size();i++) {
		                        if(strCode.equals(CommonUtil.getNullTrans(lstSubList.get(i)))) {
		                            bFlag = false;
		                            break;
		                        }
		                    }
		                } else {
		                    bFlag = true;
		                }

		                if(bFlag) strVal += " <option value=\'" + strCode + "\'" + strSelected + ">"  + strName + "</option>\n";
		             }

		        } catch (RuntimeException e) {
		            LOGGER.error(e.getMessage());

		        } catch(Exception e) {
		    		LOGGER.error(e.getMessage());

		    	}

		        return strVal;
		    }

		    /**
		     * RadioBox 테크에<input type="radio" name="radiobutton" value="srt"> 생성함
		     *
		     * @param strCompare comm_cd와 같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getMakeRadioBox(List listRow, String strFieldName, String strCompare, String strEvent) {
		        String strVal = "";
		 	       Iterator iterator = listRow.iterator();

		 	       while(iterator.hasNext())
		 	      {
		 	      	Map resultMap = (Map)iterator.next();

		 	        String strCode = (String)resultMap.get("CD");
		 	        String strName = (String)resultMap.get("NM");

		 	        if ( strCode != null) {
		 	      	     String strSelected = strCode.equals(strCompare)  ? " checked  " : " " ;
		 	      	    strVal += " <input type=\"radio\" name=\""+ strFieldName + "\" value=\'" + strCode + "\'" + strSelected + " " + strEvent + ">"  + strName + "\n";
		 	      	}
		 	      }

		        return strVal;
		    }

		    /**
		     * RadioBox 테크에<input type="check" name="check" value="srt"> 생성함
		     *
		     * @param strCompare comm_cd와 같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getMakeCheckBox(List listRow, String strFieldName, String strCompare, String strEvent) {
		        String strVal = "";
		 	       Iterator iterator = listRow.iterator();

		 	       while(iterator.hasNext())
		 	      {
		 	      	Map resultMap = (Map)iterator.next();

		 	        String strCode = (String)resultMap.get("CD");
		 	        String strName = (String)resultMap.get("NM");

		 	        if ( strCode != null) {
		 	      	     String strSelected = strCode.equals(strCompare)  ? " checked  " : " " ;
		 	      	    strVal += " <input type=\"checkbox\" name=\""+ strFieldName + "\" value=\'" + strCode + "\'" + strSelected + " " + strEvent + ">"  + strName + "\n";
		 	      	}
		 	      }

		        return strVal;
		    }


		    /**
		     * RadioBox 테크에<input type="check" name="check" value="srt"> 생성함
		     *
		     * @param strCompare comm_cd와 같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getMakeCheckBox(List listRow, String strFieldName, Map mapCompare, String strEvent) {
		           String strVal = "";
		 	       Iterator iterator = listRow.iterator();
		 	       while(iterator.hasNext())
		 	      {
		 	      	Map resultMap = (Map)iterator.next();
		 	        String strCode = (String)resultMap.get("CD");
		 	        String strName = (String)resultMap.get("NM");

		 	        if ( strCode != null) {
		 	             boolean bFlag=false;
		 	             Iterator keyIter = mapCompare.keySet().iterator();
			 	            while(keyIter.hasNext()){
			 	               String strKey     = (String)keyIter.next();
			 	               String strCompare = (String)mapCompare.get(strKey);
			 	               if (strName.equals(strCompare)) bFlag=true;
			 	             }

		 	      	     String strSelected = (bFlag)  ? " checked  " : " " ;
		 	      	    strVal += " <input type=\"checkbox\" name=\""+ strFieldName + "\" value=\'" + strCode + "\'" + strSelected + " " + strEvent + ">"  + strName + "\n";
		 	      	}
		 	      }

		        return strVal;
		    }


		    /**
		     * RadioBox 테크에<input type="check" name="check" value="srt"> 생성함
		     *
		     * @param strCompare comm_cd와 같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getMakeCheckBox(List listRow, String strFieldName, String[] arrCompare, String strEvent) {
		           String strVal = "";
		 	       Iterator iterator = listRow.iterator();
		 	       while(iterator.hasNext())
		 	      {
		 	      	Map resultMap = (Map)iterator.next();

		 	        String strCode = (String)resultMap.get("CD");
		 	        String strName = (String)resultMap.get("NM");

		 	        if ( strCode != null) {
		 	             boolean bFlag=false;

		 	             for (int iLoop=0; iLoop < arrCompare.length; iLoop++) {
			 	               if (strCode.equals(arrCompare[iLoop])) bFlag=true;
			 	         }

		 	      	     String strSelected = (bFlag)  ? " checked  " : " " ;
		 	      	    strVal += " <input type=\"checkbox\" name=\""+ strFieldName  + "\" id=\""+ "code_" + strFieldName + strCode + "\" value=\'" + strCode + "\'" + strSelected + " " + strEvent + "><label for=\""+ "code_" + strFieldName + strCode + "\"" + ">"  + strName + "</label>&nbsp;\n";
		 	      	}
		 	      }

		        return strVal;
		    }

		    /**
		     * RadioBox 테크에<input type="check" name="check" value="srt"> 생성함
		     *
		     * @param strCompare comm_cd와 같은 값이 존재하면 "selected" 문자를 추가한다.
		     * @return SelectBox 테크에 <option value="코드">코드명 </option> 형태의 값
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getMakeCheckBox(List listRow, String strFieldName, List listCompare, String strEvent) {
		           String strVal = "";
		           try {
				 	       Iterator iterator = listRow.iterator();
				 	       while(iterator.hasNext())
				 	      {

				 	      	Map resultMap = (Map)iterator.next();

				 	        String strCode =   (resultMap.get("CD") == null) ? "" : (String)resultMap.get("CD");
				 	        String strName =   (resultMap.get("NM") == null) ? "" : (String)resultMap.get("NM");

				 	        if ( strCode != null) {
				 	             boolean bFlag= getValueCompare(listCompare, strCode);

				 	      	     String strSelected = (bFlag)  ? " checked  " : " " ;
				 	      	    strVal += " <input type=\"checkbox\" name=\""+ strFieldName + "\" value=\'" + strCode + "\'" + strSelected + " " + strEvent + ">"  + strName + "\n";
				 	      	}
				 	      }
		           } catch (RuntimeException e) {
		               LOGGER.error(e.getMessage());

		           } catch(Exception e) {
		       		LOGGER.error(e.getMessage());

		       	   }

		        return strVal;
		    }


		    /**
		     * List와 String의 값을 비교 Method
		     * @param listRow
		     * @param strCompare
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "unused", "rawtypes" })
			public boolean getValueCompare(List listRow, String strCompare){
		        boolean bFlag =  false;

		        if ( listRow == null) return bFlag;
		        try {
				        String strVal = "";
					       Iterator iterator = listRow.iterator();

					       while(iterator.hasNext())
					      {
					      	Map resultMap = (Map)iterator.next();

					        String strCode =  CommonUtil.getNullTrans(resultMap.get("CD"));

					        if ( !"".equals(strCode)) {
					      	    if (strCode.equals(strCompare)) bFlag = true;
					      	}
					      }
		        } catch (RuntimeException e) {
		            LOGGER.error(e.getMessage());

		        } catch(Exception e) {
		    		LOGGER.error(e.getMessage());

		    	}

		     return bFlag;
		    }


		    /**
		     * 파일 정보를 조회한다.
		     * @param iFileNo
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings({ "rawtypes", "unchecked" })
			public Map getFileInfo(String  strFileNo) {

		        Map map = new HashMap();

		        map.put("file_seq", strFileNo);

		        return dbSvc.dbDetail(map, "common.getUploadFile");

		    }


		    /**
		     * 파일 정보를 조회한다.
		     * @param iFileNo
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public Map getFileInfo(Map paramMap) {
		        return dbSvc.dbDetail(paramMap, "common.getUploadFile");

		    }

		    /**
		     * 공통코드의 NM 필드의 내용을 하나로 묶는 Method
		     * @param strReprCd
		     * @param strCompare
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getCommomCodeNames(String strReprCd , String strCompare, String strDivision){
		           String strRetVal = "";
		           List listRow = getCodeList(strReprCd);
			       Iterator iterator = listRow.iterator();

			       while(iterator.hasNext())
			      {
			      	Map resultMap = (Map)iterator.next();
			        String strCode = (String)resultMap.get("CD");
			        String strName = (String)resultMap.get("NM");

			        if ( strCode != null && strCompare.indexOf(strCode) >= 0) {
			      	     if (!"".equals(strRetVal)) strRetVal += " " + strDivision + " ";
			      	   strRetVal += strName;
			      	}
			      }

		       return strRetVal;
		    }

		    /**
		     * 공통코드의 NM 필드의 내용을 하나로 묶는 Method
		     * @param strReprCd
		     * @param strCompare
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    @SuppressWarnings("rawtypes")
			public String getCodeName(String strReprCd , String strCompare){
	           String strRetVal = "";

	           if ("".equals(strCompare) || "".equals(strCompare))
	        	   return "";

		      	Map resultMap = getCodeDetail(strReprCd, strCompare);

		      	if ( resultMap != null) {
		      		strRetVal = (String)resultMap.get("CD_NM");
		      	}

		       return strRetVal;
		    }

		    /**
		     * 공통코드의 NM 필드의 내용을 하나로 묶는 Method
		     * @param strReprCd
		     * @param strCompare
		     * @return description
		     * @since 1.00
		     * @see
		     */
		    public String getCommomCodeNames(String strReprCd,  String strCompare){
		       return getCommomCodeNames(strReprCd, strCompare, "/");
		    }


}


