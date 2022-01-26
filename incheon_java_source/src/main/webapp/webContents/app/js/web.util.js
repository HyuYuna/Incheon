/************************************************************

File Name : web.Util.js
Description : 웹 페이지 작성 시 필요한 공통 스크립트를 로드합니다.

*************************************************************/

function webUtil() { }

//Description : 파라미터 value의 Null 여부를 체크 합니다. Null 일 경우 true 반환 Null이 아닐경우 false 반환
webUtil.IsNull = function (value) { return (value != undefined) ? !/[^\s]/g.test(value) : true; }

//Description : 파라미터 value의 앞뒤 공백 문자를 제거한 내용을 반환합니다.
webUtil.Trim = function (value) { return value.replace(/^\s*|\s*$/g, ""); };

//Description : 파라미터 originString의 targetChar 문자(열)를 replaceChar 문자(열)로 치환한 결과를 반환합니다.
webUtil.Replace = function (originString, targetChar, replaceChar) { var strTmp = new String; for (i = 0; i < originString.length; i++) if (originString.charAt(i) != targetChar) strTmp = strTmp + originString.charAt(i); elsestrTmp = strTmp + replaceChar; return strTmp; };

//Description : 파라미터 value가 숫자형태로 변환가능한 값인지 체크합니다. 가능하다면 true 아니라면 false를 반환합니다.
webUtil.IsNumeric = function (value) { var ValidChars = ",0123456789"; var IsNumber = true; var Char; if (typeof (value) == "undefined") return false; if (typeof (value) != "number" && value == "") return false; for (i = 0; i < value.length && IsNumber == true; i++) { Char = value.charAt(i); if (ValidChars.indexOf(Char) == -1) { IsNumber = false; } } return IsNumber; };

//Description : 파라미터 num의 앞에 size 만큼 0을 붙여서 반환합니다.
webUtil.GetPadZeros = function (num, size) { var str = num.toString(); while (str.length < size) str = "0" + str; return str; };

//Description : 파라미터 origin을 파라미터 pos(자릿수) 만큼 반올림 한 값을 반환합니다.
webUtil.Round = function (origin, pos) { var digits = Math.pow(10, pos); var sign = 1; if (origin < 0) { sign = -1; } origin = origin * sign; var num = Math.round(origin * digits) / digits; num = num * sign; return num.toFixed(pos); }

webUtil.CheckPeriod = function (sDate, eDate) { if (webUtil.Replace(sDate, "-") - webUtil.Replace(eDate, "-") > 0) return false; else return true; };
webUtil.CheckPeriodLang = function (sDate, eDate, Msg) { if (webUtil.Replace(sDate, "-") - webUtil.Replace(eDate, "-") > 0) { alert(Msg); return false; } else return true; };

webUtil.isDate = function (ymd) { var errCode = 0; var days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; if (ymd.length < 8) errCode = 1; var y = ymd.substring(0, 4); var m = ymd.substring(4, 6); var d = ymd.substring(6, 8); if (y % 1000 != 0 && y % 4 == 0) days[1] = 29; if (d > days[m - 1] || d < 1) errCode = 1; if (m < 1 || m > 12) errCode = 1; if (m % 1 != 0 || y % 1 != 0 || d % 1 != 0) errCode = 1; if (errCode == 1) return false; else return true; };
//Description : 파라미터 date1과 date2간의 (날짜의)차를 반환합니다. 반환타입은 int입니다.
webUtil.DateDiff = function (date1, date2) { var d1 = webUtil.Replace(date1, '-', ''); var d2 = webUtil.Replace(date2, '-', ''); if (d1.length < 8) return -1; if (d2.length < 8) return -1; d1 = d1.substring(0, 4) + "/" + d1.substring(4, 6) + "/" + d1.substring(6); d2 = d2.substring(0, 4) + "/" + d2.substring(4, 6) + "/" + d2.substring(6); var sDate = new Date(d1); var eDate = new Date(d2); var timeSpan = (eDate - sDate) / 86400000; var daysApart = Math.abs(Math.round(timeSpan)); return daysApart; };
//Description : 파라미터 date1에서 date2를 뺀 차를 반환합니다. 반환타입은 int입니다.
webUtil.DateSubtract = function (date1, date2) { if (date1.length < 8) return -1; if (date2.length < 8) return -1; date1 = date1.substring(0, 4) + "/" + date1.substring(4, 6) + "/" + date1.substring(6); date2 = date2.substring(0, 4) + "/" + date2.substring(4, 6) + "/" + date2.substring(6); var sDate = new Date(date1); var eDate = new Date(date2); var timeSpan = (sDate - eDate) / 86400000; var daysApart = Math.round(timeSpan); return daysApart; };
//Description : 파마리커 data1에서 data2를 뺀 차의 총날짜스트링(00일 00시 00분)을 출력합니다
webUtil.DateDiffToDayTimeString = function (date1, date2) { if (date1.length < 8) return -1; if (date2.length < 8) return -1; date1 = date1.substring(0, 4) + "-" + date1.substring(4, 6) + "-" + date1.substring(6, 8) + 'T' + date1.substring(8, 10) + ':' + date1.substring(10, 12); date2 = date2.substring(0, 4) + "-" + date2.substring(4, 6) + "-" + date2.substring(6, 8) + 'T' + date2.substring(8, 10) + ':' + date2.substring(10, 12); var sDate = new Date(date1); var eDate = new Date(date2); var timeSpan = (eDate - sDate) / 60000; var day = Math.floor(timeSpan / (60 * 24)); var hour = Math.floor(timeSpan % (60 * 24) / 60); var minutes = (timeSpan % 60); return (day > 0 ? day + '일 ' : '') + hour + '시간 ' + minutes + '분'; };

webUtil.ConvertDayToString = function (gubun, nDate, ymd, day) { var dt = new Date(day.substring(0, 4), day.substring(5, 7) - 1, day.substring(8, 10)); var y, m, d; var formattedDate; switch (ymd.toLowerCase()) { case "yy": { dt.setFullYear(dt.getFullYear() + nDate); break; } case "mm": { dt.setMonth(dt.getMonth() + nDate); break; } case "dd": { dt.setDate(dt.getDate() + nDate); break; } } y = dt.getFullYear(); m = dt.getMonth() + 1; d = dt.getDate(); formattedDate = y + gubun; formattedDate += m < 10 ? "0" + m : m; formattedDate += gubun; formattedDate += d < 10 ? "0" + d : d; return formattedDate; };
webUtil.DateToString = function (date) { var dateString = date.getFullYear(); dateString += "-"; if (date.getMonth() + 1 < 10) dateString += "0"; dateString += date.getMonth() + 1; dateString += "-"; if (date.getDate() < 10) dateString += "0"; dateString += date.getDate(); return dateString; }
webUtil.DateAdd = function (objDate, strInterval, intIncrement) { if (typeof (objDate) == "string") { objDate = new Date(objDate); if (isNaN(objDate)) { throw ("DateAdd: Date is not a valid date"); } } else if (typeof (objDate) != "object" || objDate.constructor.toString().indexOf("Date()") == -1) { throw ("DateAdd: First parameter must be a date object"); } if (strInterval != "M" && strInterval != "D" && strInterval != "Y" && strInterval != "h" && strInterval != "m" && strInterval != "uM" && strInterval != "uD" && strInterval != "uY" && strInterval != "uh" && strInterval != "um" && strInterval != "us") { throw ("DateAdd: Second parameter must be M, D, Y, h, m, uM, uD, uY, uh, um or us"); } if (typeof (intIncrement) != "number") { throw ("DateAdd: Third parameter must be a number"); } switch (strInterval) { case "M": objDate.setMonth(parseInt(objDate.getMonth()) + parseInt(intIncrement)); break; case "D": objDate.setDate(parseInt(objDate.getDate()) + parseInt(intIncrement)); break; case "Y": objDate.setYear(parseInt(objDate.getYear()) + parseInt(intIncrement)); break; case "h": objDate.setHours(parseInt(objDate.getHours()) + parseInt(intIncrement)); break; case "m": objDate.setMinutes(parseInt(objDate.getMinutes()) + parseInt(intIncrement)); break; case "s": objDate.setSeconds(parseInt(objDate.getSeconds()) + parseInt(intIncrement)); break; case "uM": objDate.setUTCMonth(parseInt(objDate.getUTCMonth()) + parseInt(intIncrement)); break; case "uD": objDate.setUTCDate(parseInt(objDate.getUTCDate()) + parseInt(intIncrement)); break; case "uY": objDate.setUTCFullYear(parseInt(objDate.getUTCFullYear()) + parseInt(intIncrement)); break; case "uh": objDate.setUTCHours(parseInt(objDate.getUTCHours()) + parseInt(intIncrement)); break; case "um": objDate.setUTCMinutes(parseInt(objDate.getUTCMinutes()) + parseInt(intIncrement)); break; case "us": objDate.setUTCSeconds(parseInt(objDate.getUTCSeconds()) + parseInt(intIncrement)); break; } return objDate; }

//파라미터로 받은 obj(json datetime format)를 년월일(yyyymmdd) 데이터로 변환합니다. 년월일 사이에 구분자 seperator를 끼워넣을 수 있습니다.
webUtil.FormatDateJson = function (obj, seperator) { if (webUtil.IsNull(obj)) return ""; var date = eval(obj.replace(/\/Date\((.*?)\)\//gi, "new Date($1)")); var currdate = date.getDate(); if (currdate <= 9) currdate = "0" + date.getDate(); var currmonth = date.getMonth(); currmonth++; var curryear = date.getFullYear(); if (curryear == "1900") return ""; else return curryear + seperator + webUtil.GetPadZeros(currmonth, 2) + seperator + currdate; };

webUtil.IsTelChar = function (value) { var Char_pattern = /[^-()]/; var IsChar = true; if (value == "") return false; if (Char_pattern.test(value)) { IsChar = false; } return IsChar; };
webUtil.IsChar = function (value) { var Char_pattern = /[<>'"&@]/; var IsChar = true; if (value == "") return false; if (Char_pattern.test(value)) { IsChar = false; } return IsChar; };
webUtil.IsEngNum = function (value) { var EnNum_pattern = /[^a-zA-Z0-9]/; var IsEngNum = true; var Char; if (value == "") return false; if (EnNum_pattern.test(value)) { IsEngNum = false; } return IsEngNum; };
webUtil.IsKor = function (value) { var IsKor = true; for (var i = 0; i < value.length; i++) { var ch = value.charCodeAt(i); if (!((0xAC00 <= ch && ch <= 0xD7A3) || (0x3131 <= ch && ch <= 0x318E))) { IsKor = false; } } return IsKor; };

//StringBuilder의 기능을 제공합니다.
//파라미터 value를 가지고 새로운 Array를 생성합니다.
webUtil.StringBuilder = function (value) { this.strings = new Array(""); this.append(value); };
//파라미터 value를 Array에 추가합니다.
webUtil.StringBuilder.prototype.append = function (value) { if (value) { this.strings.push(value); } };
//Array를 초기화 합니다.
webUtil.StringBuilder.prototype.clear = function () { this.strings.length = 1; };
//Array에 입력된 내용을 문자열로 반환합니다.
webUtil.StringBuilder.prototype.toString = function () { return this.strings.join(""); };

//숫자만 입력 가능합니다.
webUtil.numberCheck = function(obj) { var val = obj.value; var re = /[^0-9|.]/gi; obj.value = val.replace(re, ''); };

webUtil.NumberWithComma = function (number) { var parts = number.toString().split("."); parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ","); return parts.join("."); }
webUtil.GetStringLength = function (checkStr) { var ilength = 0; var tmpStr = new String(checkStr); var onechar; for (var i = 0; i < tmpStr.length; i++) { onechar = tmpStr.charAt(i); if (escape(onechar).length > 4) { ilength += 2; } else { ilength += 1; } } return ilength; };
webUtil.CharAllowCheck = function (element, lantype, chartype) { var text = element.value || ''; var result = new webUtil.StringBuilder(); for (var i = 0; i < text.length; i++) { var ch = text.substring(i, i + 1); if (lantype == "N" && chartype == "T") { if (webUtil.IsNumeric(ch) || webUtil.IsTelChar(ch)) { result.append(ch); } } else if (lantype == "K") { if (webUtil.IsChar(ch)) result.append(ch); } else if (lantype == "E") { if ((Utils.IsEngNum(ch) || webUtil.IsChar(ch)) && !webUtil.IsKor(ch)) { result.append(ch); } } } if (element.value != result.toString()) { element.value = result.toString(); } };
webUtil.Right = function (str, len) { str = str.toString(); if (str == null) return null; if (str.length <= len) return str; if (len == 0) return ""; return str.substring(str.length - len, str.length); }
webUtil.Left = function (str, len) { str = str.toString(); if (str == null) return null; if (str.length <= len) return str; if (len == 0) return ""; return str.substring(0, len); }
webUtil.Mid = function (str, sidx, len) { str = str.toString(); if (str == null) return null; if (len == 0) return ""; if (sidx == 0) return null; sidx = sidx - 1; return str.substring(sidx, sidx + len); }

//공통 Popup 함수
webUtil.OpenPopup = function (url, popupName, width, height, scrollbars, resizable) {
	var positionX = (screen.width) ? (screen.width - width) / 2 : 100;
	var positionY = (screen.height) ? (screen.height - height) / 2 : 100;

	var winOptions = "width=" + width;
	winOptions += ",height=" + height;
	winOptions += ",left=" + positionX;
	winOptions += ",top=" + positionY;
	winOptions += ",scrollbars=" + scrollbars;
	winOptions += ",toolbar=no,location=no,directories=no";
	winOptions += ",resizable=" + resizable;
	winOptions += ",status=no";

	var obj = window.open(url, popupName, winOptions);
}

//공통 Ajax Call 함수
webUtil.AjaxCall = function (target_url, parameters, success_function, error_function, isAsync) {

	$.ajax({
		type: "POST",
		url: target_url,
		async: isAsync,
		//processData: false,
		data: parameters,
		//dataType: isJson ? "json" : "",
		//contentType: "application/json;charset=utf-8",
		success: function (data) {
			if (data == null) {
				alert("데이터 로드 실패");
				return;
			}

			if ($.isFunction(success_function))
				success_function(data);
		},
		error: function (obj, text, error) {
			if ($.isFunction(error_function))
				error_function(obj, text, error);
		}
	});
}

function Faild(obj, text, error) {
	alert(obj);
	alert(text);
	alert(error);
}

//영문,숫자,메시지를 선택하여 허용
function checkEngNumValue(strValue, msg, num)
{
	strValue = String(strValue).replace(/^\s+|\s+$/g, "");

	if (num == 1) { //영문과 숫자영역
		 var strReg = /^[A-Za-z0-9]+$/;
	} else if (num == 2 ) { //숫자영역 -, 소수점 포함
		var strReg = /^[-]?\d+(?:[.]\d+)?$/;
	}

   if (!strReg.test(strValue))
   {
		alert(msg);
		return "N";
   }
}

//모바일 디바이스인지 체크
function checkMobileDevice() {
	var mobileKeyWords = new Array('Android', 'iPhone', 'iPad', 'iPod', 'BlackBerry', 'Windows CE', 'SAMSUNG', 'LG', 'MOT', 'SonyEricsson');
	for (var info in mobileKeyWords) {
		if (navigator.userAgent.match(mobileKeyWords[info]) != null) {
			return true;

		}
	}
	return false;
}


//*********************************************************
//새로운 창 열기
//
//1.URL 2.새윈도우명 4.넓이 5.높이, 6. 옵션
//*********************************************************
function popupWin(winURL, winName, winWidth, winHeight, winOption) {

	var l = 16, t = 16; 	// 윈도우 위치(x, y)
	var props = "";

	if (winOption == "") {
		props += "toolbar=0,location=0,directories=0,status=0,menubar=0,";	//윈도우 옵션
		props += "scrollbars=1,resizable=0,copyhistory=0,";
	} else {
		props = winOption;
	}

	props += "width=" + winWidth + ",height=" + winHeight;

	if (window.screen && window.screen.availWidth) {

		l = Math.floor(((screen.availWidth - winWidth)/2) + 5);
		t = Math.floor((screen.availHeight - winHeight)/2);
		if (l < 0) l = 0;
		if (t < 0) t = 0;
		props += ",left=" + l + ",top=" + t;
	}

	var aWinObj = window.open(winURL, winName, props);
	aWinObj.focus();
}

//영문, 숫자 조합 필수
function rtn_engnum_chk(str) {
	var reg1 = /[a-z]/g;
	var reg2 = /[0-9]/g;
	return (reg1.test(str) && reg2.test(str));
}

//파일 다운로드
function download(vFileNo)
{
   window.location.href="/common/download.do?file_no=" + vFileNo;
}

//전체 문자 치환
function replaceAll(str, searchStr, replaceStr) {
    return str.split(searchStr).join(replaceStr);
}

/**
 *  페이지 이름 가져오기
 *  @return pageName 현재 페이지 이름
 */
function getPageName(){
    var pageName = "";

    var tempPageName = window.location.href;
    var strPageName = tempPageName.split("/");
    pageName = strPageName[strPageName.length-1].split("?")[0];

    return pageName;
}
