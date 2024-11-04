<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<script type="text/javascript" src="<c:url value="/common/innorix.js" />"></script>

<style>
body { font-family: 'Dotum', '돋음', Arial sans-serif; font-size:12px; }
a { margin:0; padding:0; font-size:100%; vertical-align:baseline; background:transparent; color:#777776; text-decoration:none; }
#instalWrap { position:absolute; left:50%; top:20%; margin-left:-248px; padding:5px 5px 5px 5px; background:#a7bdd7; width:497px;  font-size:14px; }
table.table_style_install { padding:10px; margin:10px;  width:477px; border:1px solid #317de5; background:#f7f7f7; color:#666666; }
table.table_style_install tr td { height:70px; line-height:19px; border-bottom:0; }
table.table_style_install tr td h2 { color:#333333; font-weight:bold; padding-top:5px; }
table.table_style_install span.installBox { width:195px; height:35px; display:block; text-align:left; line-height:14px;  background:#2e8be9; border:1px solid #317de5; margin:0; font-size:14px; padding:5px 0 0 10px; color:#ffffff; cursor:pointer; }
table.table_style_install span.installBoxOver { background:#317de5; cursor:pointer; }
</style>

</head>

<body>

<div id="instalWrap">
	<div id="install_msg" style="padding:0px 0px 0px 0px; background:#ffffff; width:495px;  font-size:14px; display:block; border:1px solid #d7d7d7;">
		<table class="table_style_install" style="padding:10px; margin:0px;  width:100%; border:0px solid #317de5; background:#f7f7f7; color:#666666;">
			<tr>
			<script type="text/javascript" src="<c:url value="/JavaScript/numeral.min.js" />"></script>
				<td align="center" style="padding-top:35px;"><img src="<c:url value="/common/image/install_icon.png" />" /></td>
			</tr>
			<tr>
				<td style="text-align:center;"><img src="<c:url value="/common/image/install_text.png" />" alt="install" /></td>
			</tr>
			<tr>
				<td align="center" style="padding-top:10px;"><a id="innomp_download_link" href="<c:url value="/common/package/InnoGMP_Win.exe" />" ><span class="installBox" style="padding-top:10px;" id="innomp_download_button"><b>설치파일 다운로드</b><br/><span style="font-size:12px; padding-top:3px;" id="innomp_download_str">Version 7.2 for Windows</span></span></a></td>
			</tr>
			<tr style="height:15px;">
				<td style="height:15px;"></td>
				<td style="height:15px;"></td>
			</tr>
		</table>
	</div>
</div>

<div id="innomp_check_obj"></div>

<script type="text/javascript">
	Install.Init();
	Install.SelectPackage();
	Install.UpdateStatus();

	browserDetect.init();
	
    var auto_down_flag = true;
	var innomp_detected_os = browserDetect.OS;
	var innomp_download_file = "";
	
	if (innomp_detected_os == "Win32") {
		innomp_download_file = "InnoGMP_Win.exe";
		document.getElementById("innomp_download_str").innerHTML = "Version 7.2 for Windows";
		document.getElementById('innomp_download_link').href = Install.InnoPackage + "/" + innomp_download_file;

        var bit_chk = window.navigator.cpuClass == "x86"?"32":"64";
        var brw_type = browserDetect.browser;

        if (brw_type == "Explorer") {
            if (bit_chk == "64") {
                if (navigator.language == "ko-KR")
                {
                    var str = '';

                        str += '<div style="padding:10px; margin:0px;  width:100%; font-size:9pt">';
                        str += '이 브라우저에서는 플러그인을 정상적으로 설치할 수 없습니다.<br />';
                        str += '정상적인 플러그인 설치를 위하여, 아래 링크를 통하여 문제를 해결하여 주십시오.<br />';
                        str += '<br />';
                        str += '1. 32 비트 브라우저 응용 프로그램 실행설정<br />';
                        str += '<a href="http://support.microsoft.com/kb/2716529/ko">http://support.microsoft.com/kb/2716529/ko</a>';
                        str += '<br />';
                        str += '<br />';
                        str += '2. 브라우저 기본설정 복구<br />';
                        str += '<a href="http://support.microsoft.com/kb/923737/ko">http://support.microsoft.com/kb/923737/ko</a>';
                        str += '</div>';                    

                } else {
                    var str = '';

                        str += '<div style="padding:10px; margin:0px;  width:100%;">';
                        str += 'This browser is not supported to install a plug-in.<br />';
                        str += 'In order to install plug-in, please fix this problem by link below.<br />';
                        str += '<br />';
                        str += '1. Setting 32-bit browser application program execution<br />';
                        str += '<a href="http://support.microsoft.com/kb/2716529/en">http://support.microsoft.com/kb/2716529/en</a>';
                        str += '<br />';
                        str += '<br />';
                        str += '2. Recover default browser setting<br />';
                        str += '<a href="http://support.microsoft.com/kb/923737/en">http://support.microsoft.com/kb/923737/en</a>'; 
                        str += '</div>';                                        
                }
                
                document.getElementById("install_msg").innerHTML = str;
                auto_down_flag = false;
            }
        }
	}
	else if (innomp_detected_os == "Linux i686") {
		innomp_download_file = "InnoGMP_Linux.bin";
		document.getElementById("innomp_download_str").innerHTML = "Version 7.2 for Linux";
		document.getElementById('innomp_download_link').href = Install.InnoPackage + "/" + innomp_download_file;
	}
	else if (innomp_detected_os == "Linux x86_64") {
		innomp_download_file = "InnoGMP_Linux.bin";
		document.getElementById("innomp_download_str").innerHTML = "Version 7.2 for Linux";
		document.getElementById('innomp_download_link').href = Install.InnoPackage + "/" + innomp_download_file;

            if (navigator.language == "ko-KR")
            {
                var str = '';
                
                    str += '<div style="padding:10px; margin:0px;  width:100%;">';
                    str += '64 bit 브라우저에서는 플러그인을 정상적으로 설치할 수 없습니다.<br />';
                    str += '</div>';     
            } else {
                var str = '';

                    str += '<div style="padding:10px; margin:0px;  width:100%;">';
                    str += 'This 64-bit browser does not support installation of a plug-in.<br />';
                    str += '</div>';                         
            }

            document.getElementById("install_msg").innerHTML = str;
            auto_down_flag = false;
	}    
	else if (innomp_detected_os == "MacIntel") {
		innomp_download_file = "InnoGMP_Mac_Intel.pkg";
		document.getElementById("innomp_download_str").innerHTML = "Version 7.2 for Intel";
		document.getElementById('innomp_download_link').href = Install.InnoPackage + "/" + innomp_download_file;
	}
	else if (innomp_detected_os == "MacPPC") {
		innomp_download_file = "InnoGMP_Mac_PPC.pkg";
		document.getElementById("innomp_download_str").innerHTML = "Version 7.2 for PPC";
		document.getElementById('innomp_download_link').href = Install.InnoPackage + "/" + innomp_download_file;
	}

	if (auto_down_flag) {
		document.write('<META HTTP-EQUIV="Refresh" CONTENT="3; URL='+Install.InnoPackage+"/"+innomp_download_file+'"/>');
	}

	var timer = setInterval(function () {
        var value = InnoInterface.IsInstalled();
        if (value) {
        	location.href = '<c:url value="/data/file/sendForm.lin"/>';
        }
        clearInterval(timer);
        }, 3000);

</script>

</body>
</html>