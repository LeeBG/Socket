/**
 * create on 2018.03.15
 */

function showUI( dom_obj ){
	removeClass( dom_obj , 'none');
}
function hideUI( dom_obj ){
	addClass( dom_obj , 'none');
}
function addClass( dom_obj , class_name ){
	if( ! dom_obj || !dom_obj.classList || ! class_name ){
		return;
	}
	dom_obj.classList.add( class_name );
}
function removeClass( dom_obj , class_name ){
	if( ! dom_obj || !dom_obj.classList || ! class_name ){
		return;
	}
	dom_obj.classList.remove( class_name );
}
function changeInnerHtml( dom_obj , html ){
	if( ! dom_obj ){
		return;
	}
	dom_obj.innerHTML = html;
}
function isIE(){
	var agent = navigator.userAgent.toLowerCase();
	if( agent.indexOf("msie") != -1 ){
		return true;
	}
	return false;
}

function removeSessionStorage(key) {
	if( sessionStorage.getItem(key) != null )
		sessionStorage.removeItem(key);
}