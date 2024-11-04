<%@ page
	import="sun.misc.*,
			java.io.*,
			java.util.*,
			com.initech.eam.nls.*,
			com.initech.eam.api.*,
			com.initech.eam.base.*,
			com.initech.eam.nls.command.*,
			com.initech.eam.smartenforcer.*"
%>
<%!
	// 아래의 이름에 해당하는 어플리케이션이 자원으로 등록되어 있어야 함
	// 아래 이름의 어플리케이션에 해당하는 SSO Account를 꺼내오게 되어있음
	//private String SERVICE_NAME = "KOMIPO";
	private String SERVICE_NAME = "seoul.komipo.net";

	// server url : 해당 Application의 URL --> 업무시스템에 맞게 URL 수정!
	private String SERVER_URL = "http://seoul.komipo.net:8888/";

	// ASCP(로그인후 리다이렉트 페이지) --> 설치한 경로에 맞게 수정!
	private String ASCP_URL	= SERVER_URL + "/initech/sso/login_exec.jsp";
	//private String ASCP_URL	= SERVER_URL + "index.jsp";  
	//private String ASCP_URL	= "http://seoul.komipo.net:8888/index.jsp";  

	// ASCP 페이지에서 uurl 로 리다이렉트하지 않을 페이지 지정
	private String[] SKIP_URL = {"", "/", "/index.html", "/index.htm", "/index.jsp", "/index.asp","/initech/sso/login_exec.jsp"};

	// nls url --> 해당 Domain 맞게 수정! http://sso.komipo.net or http://sso.komipo.co.kr
	private String NLS_URL = "http://sso.komipo.net";
	// nls port
	private String NLS_PORT = "8080";

	// 로그인을 위해서 NLS로 redirect할 URL (fail-over는 L4)
	private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + "/nls3/clientLogin.jsp";
	// SSO 로그아웃 URL
	private String NLS_LOGOUT_URL = NLS_URL + ":" + NLS_PORT + "/nls3/ssologout.jsp";
	// 에러 페이지 URL
	private String NLS_ERROR_URL = NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";

	// Nexess API가 사용할 Nexess Daemon의 주소
	private String ND_URL = "http://sso.komipo.net:5480";
   private String RPC_URL = "http://sso.komipo.net:8080/rpc2/";

	// ID/PW type
	private String TOA = "1";
	// domain (.mento.com) --> 해당 Domain 맞게 수정! .komipo.net or .komipo.co.kr
	private String SSO_DOMAIN = ".komipo.net";

	//public static Properties ipProperties = null;
	//public static java.util.ArrayList list = null;
%>

<%!
	public NXContext getContext()
	{
		NXContext context = null;
		try
		{
			List serverurlList = new ArrayList();
			serverurlList.add(RPC_URL);
			context = new NXContext(serverurlList);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return context;
	}

	public NXContext getContextND()
	{
		NXContext context = null;
		try
		{
			List serverurlList = new ArrayList();
			serverurlList.add(ND_URL);
			context = new NXContext(serverurlList);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return context;
	}

	public void goLoginPage(HttpServletResponse response, String uurl) throws Exception
	{
		CookieManager.addCookie(SECode.USER_URL, uurl, SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
		System.out.println("^^^^^^^^^^[config.jsp]  NLS_LOGIN_URL==>"+NLS_LOGIN_URL);

		//response.sendRedirect(NLS_LOGIN_URL+"?UURL="+uurl);
		response.sendRedirect(NLS_LOGIN_URL);
		//response.sendRedirect(NLS_LOGIN_URL + "?" + SECode.USER_URL + "=" + uurl + "&" + SECode.R_TOA + "=" + TOA);
	}

	public void goErrorPage(HttpServletResponse response, int error_code)
	throws Exception {
		CookieManager.removeNexessCookie(SSO_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}

	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;

		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
		return sso_id;
	}

	public String getSsoDomain(HttpServletRequest request) throws Exception {
		String sso_domain = null;

		sso_domain = NLSHelper.getCookieDomain(request);
		return sso_domain;
	}

	// 통합인증 세션을 체크 하기 위하여 사용되는 API
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response)
	{
		String retCode = "";
		NXContext context = null;
		try {
			context = getContextND();
			NXNLSAPI nxNLSAPI = new NXNLSAPI(context);
			retCode = nxNLSAPI.readNexessCookie(request, response, 0, 0);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}

	public String getEncPwd(String userid)    throws Exception {
		//System.out.println("getEncPwd  userid:[" + userid + "]");
        NXContext context = getContext();
        NXUserAPI userAPI = new NXUserAPI(context);
        Properties prop = null;
		String pwd = "";

        try {
            NXUserInfo userInfo = userAPI.getUserInfo(userid);
            prop = new Properties();
			pwd = userInfo.getEncpasswd();

        } catch (EmptyResultException e) {
            // 사용자가 존재하지 않거나 외부계정이 없음
        } catch (APIException e) {
            throw e;
            //e.printStackTrace();
        }

        //System.out.println("getEncPwd:[" + pwd + "]");
        return pwd;
    }

	public boolean login(String userid, String password)    throws Exception {

		NXContext context = getContext();
		NXUserAPI userAPI = new NXUserAPI(context);
		Properties prop = null;
		String pwd = "";
		boolean returnValue = false;

		try {
			NXUserInfo userInfo = userAPI.getUserInfo(userid);

         prop = new Properties();
			pwd = userInfo.getEncpasswd();

			if(pwd != null && pwd != password){
				if(password.equals(pwd)){
					returnValue = true;
				}
			}

      } catch (EmptyResultException e) {
         // 사용자가 존재하지 않거나 외부계정이 없음
      } catch (APIException e) {
            throw e;
         //e.printStackTrace();
      }

      //System.out.println("getEncPwd:[" + pwd + "]");
      return returnValue;
    }

	  /**
	 * 사용자 추가
	 * sso_id : 사번
	 * name: 사용자명 or 업체명
	 * pwd: 사용자 비밀번호
	 * registcode: 주민번호 뒤 7자리
	 * userType: 사용자종류 ["1":정직원, "2":현지채용인, "3":EP특수직, "4":공용ID, "5":기타]
	 * 사용자가 존재한다면 return false
	 * 성공한다면 return true
	 */

	public boolean AddUser(String userid,  String name, String passwd )  throws Exception
	{
		if(userid==null||userid.length()<1) return false;

      NXContext context = getContext();
		NXUserAPI userAPI = new NXUserAPI(context);

		NXExternalFieldMetaAPI nxefma = null;
		NXExternalFieldMetaSet nxefms = null;
		NXExternalFieldSet nxefs = null;
		NXExternalField nxef = null;
		String enable = "T";
		String email = "";
		Enumeration enm = null;
		String exName = null;
		String exValue = null;
      boolean returnFlag = false;

      Properties prop = new Properties();

      if (prop != null) {
			nxefma = NXExternalFieldMetaAPI.getInstance(context);
         nxefms = nxefma.getExternalFieldMetaSet();
         //System.out.println("nxefms : [" + nxefms + "]");
         nxefs = nxefms.getMustFields();
         //System.out.println("nxefs : [" + nxefs + "]");

		} else {
			nxefma = NXExternalFieldMetaAPI.getInstance(context);
			nxefms = nxefma.getExternalFieldMetaSet();
			nxefs = nxefms.getMustFields();
		}

		userAPI.addUser(userid, "T", name, "", passwd, nxefs);
		returnFlag = true;

		return returnFlag;
	}

	/**
	 * 사용자가 존재하지 않다면 return false
	 * 이미 등록된 확장필드라면 return false
	 * 성공한다면 return true
	 */
	public boolean addExFieldValueToUser(String userid, String exName,
	String exValue) throws Exception {
		if(userid==null||userid.length()<1) return false;
		//NXContext context = new NXContext(RPC_URL);
		NXContext context = null;

		boolean returnFlag = false;
		try {
			context = getContext();
			//NXNLSAPI nxNLSAPI = new NXNLSAPI(context);
		   NXUserAPI userAPI = new NXUserAPI(context);

			userAPI.addExternalFieldValueToUser(userid, exName, exValue);
			returnFlag = true;
		} catch (EmptyResultException e) {
	 		// 사용자가 존재하지 않음
	 		e.printStackTrace();
		} catch (APIException e) {
			//throw e;
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			//throw e;
			e.printStackTrace();
		}

		return returnFlag;
	}

	public boolean existUser(String userid)
	throws Exception {
		if(userid==null||userid.length()<1) return false;

		NXContext context = null;

		boolean returnFlag = false;

		try {
			context = getContext();
			NXUserAPI userAPI = new NXUserAPI(context);

			System.out.println("[config.jsp] userAPI=["+userAPI+"]");

			returnFlag= userAPI.existUser(userid);
		} catch (Exception e) {
			//e.printStackTrace();
		}

		return returnFlag;
	}

	public String getUseridFromSerialNo(String serialNo)
	throws Exception {
		NXContext context = getContext();
		NXUserAPI userAPI = new NXUserAPI(context);
		String userid = "";
		List list = null;


		try {
			list = userAPI.getUserIdListByExternalField("SerialNo", serialNo);
			userid = (String)list.get(0);
		} catch (Exception e) {
			//e.printStackTrace();
		}
		//System.out.println("getUseridFromSerialNo:[" + userid + ":" + userid + "]");
		return userid;
	}


	public Properties getUserInfo(String userid)
    throws Exception {
        NXContext context = getContext();
        //NXContext context = getContext();
        NXUserAPI userAPI = new NXUserAPI(context);
        Properties prop = null;
        String OLDCOMPANYID = null;
        String SABUN = null;
        String Temp = null;
        try {
            NXUserInfo userInfo = userAPI.getUserInfo(userid);

            prop = new Properties();

            prop.setProperty("USERID", userInfo.getUserId());
            prop.setProperty("EMAIL", userInfo.getEmail());
            prop.setProperty("ENABLE", String.valueOf(userInfo.getEnable()));
            prop.setProperty("STARTVALID", userInfo.getStartValid());
            prop.setProperty("ENDVALID", userInfo.getEndValid());
            prop.setProperty("NAME", userInfo.getName());
            prop.setProperty("LASTPASSWDCHANGE", userInfo.getLastpasswdchange());
            prop.setProperty("LastLoginIP", userInfo.getLastLoginIp());
            prop.setProperty("LastLoginTime", userInfo.getLastLoginTime());
            prop.setProperty("LastLoginAuthLevel", userInfo.getLastLoginAuthLevel());

				NXExternalField nxEx = userAPI.getUserExternalField(userid,"certstatus");
				prop.setProperty("certStatus", (String)nxEx.getValue());
				System.out.println("- certStatus: "+(String)nxEx.getValue() +"");

				prop.setProperty("ENCPASSWD", userInfo.getEncpasswd());
				System.out.println(" ENCPASSWD: "+userInfo.getEncpasswd() +"");


				nxEx = userAPI.getUserExternalField(userid,"registcode");
				System.out.println(" registcode: "+(String)nxEx.getValue() +"");

        } catch (EmptyResultException e) {
            // 사용자가 존재하지 않거나 외부계정이 없음
        } catch (APIException e) {
            throw e;
            //e.printStackTrace();
        }

        //System.out.println("getUserInfo:[" + prop + "]");
        return prop;
    }

    public boolean isPki(String serialNo) throws Exception {
	  boolean returnVal = false;
      String certStatus = "";
	  String userid =  "";
      Properties prop		= null;

      userid = getUseridFromSerialNo(serialNo);
	  if ( userid != null &&  !"".equals(userid) ) {
		  // [T: 유효한 인증서 , F: 유효하지 않은 인증서 ]
		  prop = getUserInfo(userid);
		  if ( prop != null ) {
			 certStatus = prop.getProperty("certStatus");
			 if(certStatus != null && "T".equals(certStatus)){
				  returnVal = true;
			  }
		  }
	  }

	  return returnVal;
	}

	public void removeUser(String userid)    throws Exception {
		//System.out.println("getEncPwd  userid:[" + userid + "]");
        NXContext context = getContext();
        NXUserAPI userAPI = new NXUserAPI(context);

        try {
             userAPI.removeUser(userid);


        } catch (EmptyResultException e) {
            // 사용자가 존재하지 않거나 외부계정이 없음
        } catch (APIException e) {
            throw e;
            //e.printStackTrace();
        }

        //System.out.println("getEncPwd:[" + pwd + "]");

    }

	/**
	 * 이전 비밀번호, 새로운 비밀번호를 입력받아서 갱신 처리
	 * 비밀번호가 틀린경우 APIException
	 * 에러코드 = ErrorCode.ID_NOT_FOUND
	 * 메시지 : userId [xxx] is not exist!!
	 */
	public boolean changePassword(String userid, String oldPw, String newPw)
	throws Exception {
		NXContext context = getContext();
		NXUserAPI userAPI = new NXUserAPI(context);
		boolean returnFlag = false;

		try {
			userAPI.changePassword(userid, oldPw, newPw);
			returnFlag = true;
		}catch (EmptyResultException ee) {
	 		// 사용자가 존재하지 않음
			throw ee;
		}catch (APIException e) {
			throw e;
			//e.printStackTrace();
		}
		/*
		System.out.println("changePassword:[" + userid + ":" + oldPw + ":"
			+ newPw + ":" + returnFlag + "]");
		*/
		return returnFlag;
	}

	/**
	 * 이전 비밀번호, 새로운 비밀번호를 입력받아서 갱신 처리
	 * 사용자가 존재하지 않다면 return false
	 */
	public boolean changePasswordByAdmin(String userid, String newPw)
	throws Exception {
		NXContext context = getContext();
		NXUserAPI userAPI = new NXUserAPI(context);
		boolean returnFlag = false;

		try {
			userAPI.changePasswordByAdmin(userid, newPw);
			returnFlag = true;
		} catch (EmptyResultException ee) {
	 		// 사용자가 존재하지 않음
			throw ee;
		} catch (APIException e) {
			throw e;
			//e.printStackTrace();
		}
		/*
		System.out.println("changePasswordByAdmin:[" + userid + ":"
			+ newPw + ":" + returnFlag + "]");
		*/
		return returnFlag;
	}

%>

