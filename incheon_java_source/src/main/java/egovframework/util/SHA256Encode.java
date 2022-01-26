package egovframework.util;

import java.security.MessageDigest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.controller.BoardController;

/**
 * SHA256 Encode
 * @author kcore
 *
 */
public class SHA256Encode {

	private static final Logger LOGGER = LoggerFactory.getLogger(SHA256Encode.class);
	
	public SHA256Encode() { }

	public static final int byteLength = 20;

	/*
	 * SHA256 일반 암호화
	 */
	public static String Encode(String password) {

		 try{
	            MessageDigest digest = MessageDigest.getInstance("SHA-256");

	            byte[] hash = digest.digest(password.getBytes("UTF-8"));
	            StringBuffer hexString = new StringBuffer();

	            for (int i = 0; i < hash.length; i++) {
	                String hex = Integer.toHexString(0xff & hash[i]);
	                if(hex.length() == 1) hexString.append('0');
	                hexString.append(hex);
	            }

	            return hexString.toString().toUpperCase().trim();

	       } catch (RuntimeException e) {
	    	   throw new RuntimeException();

		   } catch(Exception e) {
			   throw new RuntimeException();
	       }
	}

	/*
	 * SHA256 byte[] 로 가미 시켜 암호화 처리
	 */
	public static String Encode(String password, byte[] salt) {

		 try{
	            MessageDigest digest = MessageDigest.getInstance("SHA-256");

	            digest.reset();
	            digest.update(salt);

	            byte[] hash = digest.digest(password.getBytes("UTF-8"));
	            StringBuffer hexString = new StringBuffer();

	            for (int i = 0; i < hash.length; i++) {
	                String hex = Integer.toHexString(0xff & hash[i]);
	                if(hex.length() == 1) hexString.append('0');
	                hexString.append(hex);
	            }

	            return hexString.toString().toUpperCase().trim();

	       } catch (RuntimeException e) {
	    	   throw new RuntimeException();

		   } catch(Exception e) {
			   throw new RuntimeException();
	       }
	}

}

