package egovframework.util;



import java.util.Map;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import java.io.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Part;
import javax.mail.PasswordAuthentication;



public class SendMail {

	private static final Logger LOGGER = LoggerFactory.getLogger(SendMail.class);

    	public static void mailRun(Map<String, Object> param) {

	    	try {
		    	// 메일 환경 변수 설정입니다.
		    	Properties props = new Properties();

		    	// 메일 프로토콜은 smtp로 사용합니다.
		    	props.setProperty("mail.transport.protocol", "smtp");

		    	// 메일 호스트 주소를 설정합니다.
		    	props.setProperty("mail.host", param.get("smtpServer").toString());

		    	// ID, Password 설정이 필요합니다.
		    	props.put("mail.smtp.auth", "true");

		    	// port는 465입니다.
		    	props.put("mail.smtp.port", param.get("smtpPort").toString());

		    	// ssl를 사용할 경우 설정합니다.
/*		    	props.put("mail.smtp.socketFactory.port", "465");
		    	props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		    	props.put("mail.smtp.socketFactory.fallback", "false");
		    	props.setProperty("mail.smtp.quitwait", "false");*/

		    	final String userId = param.get("smtpId").toString();
		    	final String userPw = param.get("smtpPw").toString();

		    	// id와 password를 설정하고 session을 생성합니다.
		    	Session session = Session.getInstance(props, new Authenticator() {
		    		protected PasswordAuthentication getPasswordAuthentication() {
		    			return new PasswordAuthentication(userId, userPw);
		    		}
		    	});
	    	// 디버그 모드입니다.
	    	session.setDebug(true);
	    	// 메일 메시지를 만들기 위한 클래스를 생성합니다.
	    	MimeMessage message = new MimeMessage(session);

	    	// 송신자 설정
	    	message.setFrom(getAddress(param.get("smtpFromEmail").toString()));

	    	// 수신자 설정
	    	message.addRecipients(Message.RecipientType.TO, getAddresses(param.get("smtpToEmail").toString()));

	    	// 참조 수신자 설정
	    	//message.addRecipients(Message.RecipientType.CC, getAddresses("nowonbun@gmail.com"));

	    	// 숨은 참조 수신자 설정
	    	//message.addRecipients(Message.RecipientType.BCC, getAddresses("kcore7@naver.com"));

	    	// 메일 제목을 설정합니다.
	    	message.setSubject(param.get("smtpSubject").toString());

	    	// 메일 내용을 설정을 위한 클래스를 설정합니다.
	    	message.setContent(new MimeMultipart());

	    	// 메일 내용을 위한 Multipart클래스를 받아온다. (위 new MimeMultipart()로 넣은 클래스입니다.)
	    	Multipart mp = (Multipart) message.getContent();

	    	// html 형식으로 본문을 작성해서 바운더리에 넣습니다.
	    	//mp.addBodyPart(getContents("<html><head></head><body>Hello Test<br><img src=\"cid:image\" ></body></html>"));
	    	mp.addBodyPart(getContents(param.get("smtpContents").toString()));

	    	// 첨부 파일을 추가합니다.
	    	//mp.addBodyPart(getFileAttachment("test.xlsx"));

	    	// 이미지 파일을 추가해서 contextId를 설정합니다. contextId는 위 본문 내용의 cid로 링크가 설정 가능합니다.
	    	//mp.addBodyPart(getImage("capture.png", "image"));

	    	// 메일을 보냅니다.
	    	Transport.send(message);

	    	} catch (RuntimeException e) {
	    		LOGGER.error(e.getMessage());
	    	} catch (IOException e) {
	    		LOGGER.error(e.getMessage());
	    	} catch (Throwable e) {
	    		LOGGER.error(e.getMessage());
	    	}
    	}

    	// 이미지를 로컬로 부터 읽어와서 BodyPart 클래스로 만든다. (바운더리 변환)
    	@SuppressWarnings("unused")
		private static BodyPart getImage(String filename, String contextId) throws MessagingException {
	    	// 파일을 읽어와서 BodyPart 클래스로 받는다.
	    	BodyPart mbp = getFileAttachment(filename);
	    	if (contextId != null) {
	    	// ContextId 설정
	    	mbp.setHeader("Content-ID", "<" + contextId + ">");
	    	}
	    	return mbp;
    	}

    	// 파일을 로컬로 부터 읽어와서 BodyPart 클래스로 만든다. (바운더리 변환)
    	private static BodyPart getFileAttachment(String filename) throws MessagingException {
	    	// BodyPart 생성
	    	BodyPart mbp = new MimeBodyPart();
	    	// 파일 읽어서 BodyPart에 설정(바운더리 변환)
	    	File file = new File(filename);
	    	DataSource source = new FileDataSource(file);
	    	mbp.setDataHandler(new DataHandler(source));
	    	mbp.setDisposition(Part.ATTACHMENT);
	    	mbp.setFileName(file.getName());
	    	return mbp;
    	}

    	// 메일의 본문 내용 설정
    	private static BodyPart getContents(String html) throws MessagingException {
	    	BodyPart mbp = new MimeBodyPart();
	    	// setText를 이용할 경우 일반 텍스트 내용으로 설정된다.
	    	// mbp.setText(html);
	    	// html 형식으로 설정
	    	mbp.setContent(html, "text/html; charset=utf-8");
	    	return mbp;
    	}

    	// String으로 된 메일 주소를 Address 클래스로 변환
    	private static Address getAddress(String address) throws AddressException {
    		return new InternetAddress(address);
    	}

    	// String으로 된 복수의 메일 주소를 콤마(,)의 구분으로 Address array형태로 변환
    	private static Address[] getAddresses(String addresses) throws AddressException {
	    	String[] array = addresses.split(",");
	    	Address[] ret = new Address[array.length];

	    	for (int i = 0; i < ret.length; i++) {
	    		ret[i] = getAddress(array[i]);
	    	}

	    	return ret;
    	}



}
