
var left_focus_index=0;
var left_focus_length=length;
var left_focus_flag=1;
var playUrl="";
var poster_flag = 0;
custom_load_page();
function custom_load_page(){

show_product_list();
show_product_recommend(0);
init_focus();
if(programname.length >= 12){
    document.getElementById("product_program_name").innerHTML = programname.substr(0,12)+"...";
}else{
    document.getElementById("product_program_name").innerHTML = programname;
}

page_up_down();
}
/*function $(id) {
    if (!$$[id]) {
        $$[id]=document.getElementById(id);
    }
    return $$[id];
}*/


window.parent.document.onkeypress = cateKeyPressa;

function commonKeyPress(evt) {
    var keycode = evt.which;
    if (keycode == 0x0101) { //????????
        _window.top.remoteChannelPlus();
    } else if (keycode == 0x0102) {
        _window.top.remoteChannelMinus();
    } else if (keycode == 0x0110) {
       // Authentication.CTCSetConfig("KeyValue", "0x110");
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 36) {
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 0x0008 || keycode == 24) {
		//alert("111111111back");
      // _window.top.mainWin.document.location = "back.jsp";
	    document.getElementById("big_bg").style.display="none";
		window.parent.document.getElementById("detail_bg").style.display = "block";
		window.parent.document.getElementById("detail").style.visibility = "visible";
		
		if(window.parent.document.getElementById("playimg")!=null){
			window.parent.document.getElementById("playimg").style.visibility = "visible";	
		}
		
		
        window.parent.document.getElementById("fdiv").style.width = "1px";
        window.parent.document.getElementById("fdiv").style.height = "1px";
        window.parent.document.getElementById("hiddenFrame").style.width="1px";
        window.parent.document.getElementById("hiddenFrame").style.height="1px";
	    window.parent.document.onkeypress = window.parent.mykeypres;
    } else {
        _window.top.doKeyPress(evt);
    }
}

function cateKeyPressa(evt) {
    var keyCode = parseInt(evt.which);
   // alert("keycode======"+keyCode);
    if (keyCode == 0x0028) { //onKeyDown
	 
        cateKeyDown();
    } else if (keyCode == 0x0026) {//onKeyUp
	
        cateKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
	
        cateKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
	
        cateKeyRight();
    } else if (keyCode == 0x000D) {  //OK
	
        cateKeyOK();
    } else if (keyCode == 0x0008 || keyCode == 24 || keyCode==8 ) {
		if(document.getElementById("dialog_erweima").style.visibility=="visible"){
			backFlag=0;
			getorderresult();	
		}else{
			if(ajaxTimeoutTest){
				ajaxTimeoutTest.abort();
			}
			document.getElementById("big_bg").style.display="none";
			window.parent.document.getElementById("detail_bg").style.display = "block";
			window.parent.document.getElementById("detail").style.visibility = "visible";
			
			if(window.parent.document.getElementById("playimg")!=null){
				window.parent.document.getElementById("playimg").style.visibility = "visible";	
			}
			
			window.parent.document.getElementById("fdiv").style.width = "1px";
			window.parent.document.getElementById("fdiv").style.height = "1px";
			window.parent.document.getElementById("hiddenFrame").style.width="1px";
			window.parent.document.getElementById("hiddenFrame").style.height="1px";
			//window.parent.document.getElementById("detail").style.visibility="visible";
			window.parent.document.onkeypress = window.parent.mykeypres;
		}
    }else {
		//clearBackParam();
        _window.top.mainWin.commonKeyPress(evt);
	
        return true;
    }
    return false;
}
// function doKeyPress(evt) {
//     var keycode = evt.which;
//// alert("keycode:"+keycode);
// //	//g_o.debug.print_log("*******keycode:"+keycode);
//     if (keycode == 119) {//左
//         cateKeyLeft();
//     } else if (keycode == 115) {//右
//         cateKeyRight();
//    } else if (keycode == 0) {//确认
//         cateKeyOK();
//     } else if (keycode == 113) {//上
//         cateKeyUp();
//     } else if (keycode == 97) {//下
//          cateKeyDown();
//     } else {
//       //  commonKeyPress(evt);
//     }
//     return false;
// }
//function doKeyPress(evt) {
//    var keycode = evt.which;
//	//g_o.debug.print_log("keycode:"+keycode);
//    if (keycode == 37) {
//        cateKeyLeft();
//    } else if (keycode == 39) {
//        cateKeyRight();
//    } else if (keycode == 13) {
//        cateKeyOK();
//    } else if (keycode == 38) {
//        cateKeyUp();
//    } else if (keycode == 40) {
//         cateKeyDown();
//    } else {
//        commonKeyPress(evt);
//    }
//    return false;
//}

function doKeyPress(evt) {
    var keycode = evt.which;
	//g_o.debug.print_log("keycode:"+keycode);
    if (keycode == 0x0025) {
        cateKeyLeft();
    } else if (keycode == 0x0027) {
        cateKeyRight();
    } else if (keycode == 0x000D) {
        cateKeyOK();
    } else if (keycode == 0x0026) {
        cateKeyUp();
    } else if (keycode == 0x0028) {
         cateKeyDown();
    } else {
        commonKeyPress(evt);
    }
    return false;
}

function show_product_list(){

    for(var i=0; i<5; i++){
	var m = istart+i;
    if(m<iend){
	//document.getElementById("order_product_name_"+i).innerHTML = writeFitString(product['strProductDesca'][m], 18, 120);
	document.getElementById("order_product_name_"+i).innerHTML = writeFitString(product['strProductNamea'][m], 18, 120);
	}else{
	document.getElementById("order_product_name_"+i).innerHTML = "";
	}
   }
   //document.getElementById("product_program_name").innerHTML = length;
}

function show_product_recommend(focusindex){
	var unite_a ="";
	if(product['strRentalUnita'][focusindex]=="0"){
		unite_a="";
	}else if(product['strRentalUnita'][focusindex]=="1"){
		unite_a="天";
	}else if(product['strRentalUnita'][focusindex]=="2"){
		unite_a="周";
	}else if(product['strRentalUnita'][focusindex]=="3"){
		unite_a="月";
    }else if(product['strRentalUnita'][focusindex]=="4"){
		unite_a="半年";
    }else if(product['strRentalUnita'][focusindex]=="5"){
		unite_a="年";
    }else if(product['strRentalUnita'][focusindex]=="6"){
		unite_a="小时";
    }else if(product['strRentalUnita'][focusindex]=="7"){
		unite_a="分钟";
    }else{
	    unite_a="";
	}
	//添加元/次测试
//	var price_a="";
//	if(product['strPurchaseTypea'][focusindex]=="1"){
//		price_a="元/次";
//		}else{
//			price_a="元";
//			}
	if(product['strPurchaseTypea'][focus_index]=="0"){
		document.getElementById("product_endtime").innerHTML="自然月";
	}else{
		if(product['strRentalUnita'][focusindex]!="7"&&product['strRentalUnita'][focusindex]!="0"){
			document.getElementById("product_endtime").innerHTML = product['strRentalTerma'][focusindex]+""+unite_a;
		}else if (product['strRentalUnita'][focusindex]=="0"){
			var data_time = new Date();
            var time_now = data_time.getTime();
			var time_db = product['strRentalTerma'][focusindex]*1000;//化为毫秒
	 	  data_time.setTime(time_db + time_now);
		document.getElementById("product_endtime").innerHTML=data_time.getFullYear()+"-"+checkTime(data_time.getMonth()+1)+"-"+checkTime(data_time.getDate())+"  "+checkTime(data_time.getHours())+":"+checkTime(data_time.getMinutes())+":"+checkTime(data_time.getSeconds());
		}
	}
	if(product['strProductNamea'][focusindex].length >=12){
        document.getElementById("product_name").innerHTML = product['strProductNamea'][focusindex].substr(0,12)+"...";
    }else{
        document.getElementById("product_name").innerHTML = product['strProductNamea'][focusindex];
    }

    //document.getElementById("product_name").innerHTML = product['strProductDesca'][focusindex];
   

 	for(var i=0;i<product['strProductIDa'].length;i++){
		if(product['strProductIDa'][focusindex] == "100476"){
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
			document.getElementById("product_price").style.textDecoration = "line-through";
			document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
		}else if(product['strProductIDa'][focusindex] == "100468"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100467"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">22.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100466"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">190.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100465"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">22.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100464"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100461"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100458"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100455"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100454"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">93.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100453"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">33.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100452"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";

        }else if(product['strProductIDa'][focusindex] == "100451"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">93.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100450"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">33.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100449"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100446"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">60.00元</font>";
        }else if(product['strProductIDa'][focusindex] == "100443"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100440"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100437"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100434"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100431"){
            document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "line-through";
            document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
        }else if(product['strProductIDa'][focusindex] == "100325"){
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
			document.getElementById("product_price").style.textDecoration = "line-through"; 
			document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">29.9元</font>";
		}else if(product['strProductIDa'][focusindex] == "100327"){
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
			document.getElementById("product_price").style.textDecoration = "line-through"; 
			document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">29.9元</font>";
		}else if(product['strProductIDa'][focusindex] == "100328"){
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
			document.getElementById("product_price").style.textDecoration = "line-through"; 
			document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">29.99元</font>";
		}else if(product['strProductIDa'][focusindex] == "100472"){
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
			document.getElementById("product_price").style.textDecoration = "line-through";
			document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">262.88元</font>";
		}else if(product['strProductIDa'][focusindex] == "100485"){
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
			document.getElementById("product_price").style.textDecoration = "line-through";
			document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">29.9元</font>";
		}else if(product['strProductIDa'][focusindex] == "100486"){
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
			document.getElementById("product_price").style.textDecoration = "line-through";
			document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">33.88元</font>";
		}else if(product['strProductIDa'][focusindex] == "100487"){
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
			document.getElementById("product_price").style.textDecoration = "line-through";
			document.getElementById("current_price").innerHTML ="<font color=\"#f2f104\">199元</font>";
		}else{
			document.getElementById("product_price").innerHTML = product['strPricea'][focusindex]+"元";
            document.getElementById("product_price").style.textDecoration = "none";
            document.getElementById("current_price").innerHTML ="";
		}
	}
	
   //document.getElementById("product_discribe").innerHTML = product['strProductDesca'][focusindex];
   document.getElementById("product_discribe").innerHTML = product['strProductNamea'][focusindex];
 	if(product['strProductIDa'][focusindex] === "100346"){
		document.getElementById("product_discribe").innerHTML = "产品即将下线，暂无法订购";
	}if(product['strProductIDa'][focusindex] === "100474" || product['strProductIDa'][focusindex] === "100475"|| product['strProductIDa'][focusindex] === "100476"){
		document.getElementById("product_discribe").innerHTML = "订【电视剧】VIP剧集随意看（百视通电视剧除外";
	}else if(product['strProductIDa'][focusindex] === "100101" || product['strProductIDa'][focusindex] === "100102" || product['strProductIDa'][focusindex] === "100103" || product['strProductIDa'][focusindex] === "100105" || product['strProductIDa'][focusindex] === "100108" || product['strProductIDa'][focusindex] === "100110" || product['strProductIDa'][focusindex] === "100349" || product['strProductIDa'][focusindex] === "100350" || product['strProductIDa'][focusindex] === "100351" || product['strProductIDa'][focusindex] === "100352" || product['strProductIDa'][focusindex] === "100201" || product['strProductIDa'][focusindex] === "100202" || product['strProductIDa'][focusindex] === "100205" || product['strProductIDa'][focusindex] === "100208" || product['strProductIDa'][focusindex] === "100210"){
		document.getElementById("product_discribe").innerHTML = "本产品仅限此节目";
	}
}

      function checkTime(i){
         if(i<10){
           i="0"+i;
         }
         return i;
      }
function cateKeyDown(){
	
	//document.getElementById("order_button").style.visibility = "hidden";
	//document.getElementById("remove_button").style.visibility = "hidden";
	//alert("cateKeyDown");
	if(document.getElementById("dialog_order").style.visibility == "visible" || document.getElementById("dialog_erweima").style.visibility == "visible"){
		return;
	}
	if(document.getElementById("order_button_wx").style.visibility == "hidden" && document.getElementById("order_button").style.visibility == "hidden" && document.getElementById("remove_button").style.visibility == "hidden"){

		if(document.getElementById("poster_focus").style.visibility == "visible"){
			document.getElementById("poster_focus").style.visibility = "hidden";
			focus_left_index(left_focus_index);
			textScroll(1);
		}else{
			blur_left_index(left_focus_index);
			textScroll(-1);
			left_focus_index++;
			if(istart+left_focus_index<iend){
				focus_left_index(left_focus_index);
				textScroll(1);
				focus_index = istart+left_focus_index;
				show_product_recommend(focus_index);
			}else if(pageSeq+1 != pageCount){
				page_next();
				show_product_list();
				left_focus_index=0;
				focus_left_index(left_focus_index);
				textScroll(1);
				focus_index = istart+left_focus_index;
				show_product_recommend(focus_index);
			}else{
				left_focus_index--;
				focus_left_index(left_focus_index);
			}
		}
	}
}

function cateKeyUp(){
	//document.getElementById("order_button").style.visibility = "hidden";
	//document.getElementById("remove_button").style.visibility = "hidden";
	//alert("cateKeyUp");

	if(document.getElementById("dialog_order").style.visibility == "visible" || document.getElementById("dialog_erweima").style.visibility == "visible"){
		return;
	}
	if(document.getElementById("order_button_wx").style.visibility == "hidden" && document.getElementById("order_button").style.visibility == "hidden" && document.getElementById("remove_button").style.visibility == "hidden"){

		if(istart+left_focus_index == 0 && poster_flag === 1){
			document.getElementById("poster_focus").style.visibility = "visible";
			blur_left_index(left_focus_index);
			textScroll(-1);
		}else{
			blur_left_index(left_focus_index);
			textScroll(-1);
			left_focus_index--;
			if(left_focus_index>=0){
				focus_left_index(left_focus_index);
				textScroll(1);
				focus_index = istart+left_focus_index;
				show_product_recommend(focus_index);
			}else{
				page_prev();
				show_product_list();
				left_focus_index=0;
				focus_left_index(left_focus_index);
				textScroll(1);
				focus_index = istart+left_focus_index;
				show_product_recommend(focus_index);
			}
		}

	}


}

function cateKeyLeft(){
	if(document.getElementById("poster_focus").style.visibility == "visible"){
		return;
	}else if(document.getElementById("remove_button").style.visibility=="visible"){
	    document.getElementById("remove_button").style.visibility="hidden";
	    document.getElementById("order_button").style.visibility="visible";
    }else if(document.getElementById("order_button").style.visibility=="visible"){
		document.getElementById("order_button").style.visibility="hidden";
	    document.getElementById("order_button_wx").style.visibility="visible";
    }else if(document.getElementById("order_button_wx").style.visibility=="visible"){
	    document.getElementById("order_button_wx").style.visibility="hidden";
		left_focus_flag=1;
		textScroll(1);
		focus_left_index(left_focus_index);
    }else if(document.getElementById("dialog_order").style.visibility=="visible"){
		if(document.getElementById("dialog_order_button").style.visibility=="visible"){
			document.getElementById("dialog_order_button").style.visibility="hidden";
		    document.getElementById("dialog_remove_button").style.visibility="visible";
		}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
			document.getElementById("dialog_order_button").style.visibility="visible";
		    document.getElementById("dialog_remove_button").style.visibility="hidden";
		}
    }else if(document.getElementById("dialog_erweima").style.visibility=="visible"){
		if(document.getElementById("dialog_order_button_wx").style.visibility=="visible"){
			document.getElementById("dialog_order_button_wx").style.visibility="hidden";
		    document.getElementById("dialog_remove_button_wx").style.visibility="visible";
		}else if(document.getElementById("dialog_remove_button_wx").style.visibility=="visible"){
			document.getElementById("dialog_order_button_wx").style.visibility="visible";
		    document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
		}
    }
}

function cateKeyRight(){
	//alert("cateKeyRight");
	if(document.getElementById("poster_focus").style.visibility == "visible"){
		return;
	}else if(left_focus_flag==1){
		
		focus_left_index_blr(left_focus_index);
		left_focus_flag=0;
		textScroll(-1);
		document.getElementById("order_button_wx").style.visibility="visible";
	}else if(document.getElementById("order_button_wx").style.visibility=="visible"){
	    document.getElementById("order_button_wx").style.visibility="hidden";
		document.getElementById("order_button").style.visibility="visible";
    }else if(document.getElementById("order_button").style.visibility=="visible"){
	    document.getElementById("order_button").style.visibility="hidden";
		document.getElementById("remove_button").style.visibility="visible";
     }else if(document.getElementById("dialog_order").style.visibility=="visible"){
		if(document.getElementById("dialog_order_button").style.visibility=="visible"){
			document.getElementById("dialog_order_button").style.visibility="hidden";
		    document.getElementById("dialog_remove_button").style.visibility="visible";
		}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
			document.getElementById("dialog_order_button").style.visibility="visible";
		    document.getElementById("dialog_remove_button").style.visibility="hidden";
		}
    }else if(document.getElementById("dialog_erweima").style.visibility=="visible"){
		if(document.getElementById("dialog_order_button_wx").style.visibility=="visible"){
			document.getElementById("dialog_order_button_wx").style.visibility="hidden";
		    document.getElementById("dialog_remove_button_wx").style.visibility="visible";
		}else if(document.getElementById("dialog_remove_button_wx").style.visibility=="visible"){
			document.getElementById("dialog_order_button_wx").style.visibility="visible";
		    document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
		}
    }
}
function select_pay_back(){
	document.getElementById("no_wxpay_tips").style.visibility="hidden";
	document.getElementById("order_button_wx").style.visibility="visible";
}

function select_error(error_id){
    document.getElementById("order_button").style.visibility="visible";
    document.getElementById(error_id).style.visibility="hidden";
}
function pay_back_time(){
	setTimeout("select_pay_back()",2000);
}
function cateKeyOK(){
	if(document.getElementById("poster_focus").style.visibility == "visible"){
		top.mainWin.document.location='poster_auth_orderlist.jsp?leefocus=8_';
	} else if(document.getElementById("order_button").style.visibility=="visible"){
	  /* document.getElementById("order_button").style.visibility="hidden";
	   document.getElementById("dialog_order").style.visibility="visible";
	   //document.getElementById("test").innerHTML="====="+product['strPurchaseTypea'][left_focus_index];
	   if(product['strPurchaseTypea'][left_focus_index]==0){
		   document.getElementById("order_img").src="images/order/dialog_order_all.png";
	   }else{
		   document.getElementById("order_img").src="images/order/dialog_order.png";
	   }
	   //document.getElementById("dialog_order_button").style.visibility="visible";
	   document.getElementById("dialog_remove_button").style.visibility="visible";*/
        if(product['strPurchaseTypea'][left_focus_index]==0){
            document.getElementById("order_button").style.visibility="hidden";
            document.getElementById("broadband_error").style.visibility="visible";
            setTimeout("select_error('broadband_error')",5000);
        }else{
            document.getElementById("order_button").style.visibility="hidden";
            document.getElementById("broadband_error_gowx").style.visibility="visible";
            setTimeout("select_error('broadband_error_gowx')",5000);
        }


	}else if(document.getElementById("order_button_wx").style.visibility=="visible"){
		document.getElementById("order_button_wx").style.visibility="hidden";
		var index_focus = istart+left_focus_index;
		if(product['strPurchaseTypea'][index_focus]==0){
		   document.getElementById("no_wxpay_tips").style.visibility="visible";
		   pay_back_time();
	    }else{
		   load_erweima_result();
	    }		
	}else if(document.getElementById("remove_button").style.visibility=="visible"){
		if(ajaxTimeoutTest){
			ajaxTimeoutTest.abort();
		}
		document.getElementById("big_bg").style.display="none";
		window.parent.document.getElementById("detail_bg").style.display = "block";
		window.parent.document.getElementById("detail").style.visibility = "visible";
		
			if(window.parent.document.getElementById("playimg")!=null){
			window.parent.document.getElementById("playimg").style.visibility = "visible";	
		}
		
        window.parent.document.getElementById("fdiv").style.width = "1px";
        window.parent.document.getElementById("fdiv").style.height = "1px";
        window.parent.document.getElementById("hiddenFrame").style.width="1px";
        window.parent.document.getElementById("hiddenFrame").style.height="1px";
		window.parent.document.onkeypress = window.parent.mykeypres;
	}else if(document.getElementById("dialog_order").style.visibility=="visible"){
		if(document.getElementById("dialog_order_button").style.visibility=="visible"){
			document.getElementById("dialog_order").style.visibility="hidden";
			document.getElementById("dialog_order_button").style.visibility="hidden";	
			load_order_result();
			
		}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
			//left_focus_flag=1;
			document.getElementById("dialog_order").style.visibility="hidden";
			document.getElementById("dialog_remove_button").style.visibility="hidden";
			document.getElementById("order_button").style.visibility = "visible";
		}
	}else if(document.getElementById("dialog_erweima").style.visibility=="visible"){
		if(document.getElementById("qrcode").style.visibility=="visible"){
			getorderresult();
		}
	}

}

function load_order_result(){
	//alert("22222222222");
	var nowURL = istart+left_focus_index; 
    var requestUrl = product['order_urla'][nowURL];
	//alert("33333333333333"+requestUrl);
    var loaderSearch = new net.ContentLoader(requestUrl, show_order_result);

}

function show_order_result(){
	
	var results = this.req.responseText;
	//document.getElementById("product_program_name").innerHTML =results;
    catedata = eval("(" + results + ")");
	playUrl = catedata.playUrl;
	var orderFlag = parseInt(catedata.orderFlag,10);
	//alert("111111aaaa"+catedata.returncode);
	if(0==orderFlag && playUrl != ""){
		if(product['strPurchaseTypea'][left_focus_index]==0){
			document.getElementById("dialog_ordered_all").style.visibility="visible";
			
		}else{
			document.getElementById("dialog_ordered").style.visibility="visible";
		}
	    set_play_time();
		
	}else{
		if(catedata.returncode == 9301){
			document.getElementById("dialog_ordered_second").style.visibility="visible";
			ordered_back_time();
		}else{
			document.getElementById("dialog_ordered_failed").style.visibility="visible";
			set_back_time();
		}
	}
	
}
//第三方支付 获取二维码
function load_erweima_result(){
	//alert("22222222222");
	var nowURL = istart+left_focus_index; 
    var requestUrl = product['third_urla'][nowURL];
    var loaderSearch = new net.ContentLoader(requestUrl, show_erweima_result);
}

var transactionID;
var productID;
var productPriceWx;
function show_erweima_result(){
	var results = this.req.responseText;
	//alert("code_url33"+results);
	catedata = eval("(" + results + ")");	
	if(parseInt(catedata.return_code) == 0){
		if(typeof(catedata) != "undefined"){
			transactionID=catedata.transactionID;
			var imgurl=catedata.code_url;
			productID=catedata.productID;
			creatimg(imgurl);
			productPriceWx=(catedata.payFee)/100;
			document.getElementById("product_price_wx").innerHTML = productPriceWx+"元";
			//if(product['strPurchaseTypea'][left_focus_index]==0){
			//   document.getElementById("erweima_img").src="images/order/erweima_all.png";
			//   document.getElementById("product_endtime_wx").innerHTML="订购成功，立即生效，在订购成功的自然月内有效。";
			//}else{
			   document.getElementById("erweima_img").src="images/order/erweima.png";
			   var data_time = new Date();
			   var time_now = data_time.getTime();
			   var time_db = product['strRentalTerma'][left_focus_index+istart]*1000;
			   data_time.setTime(time_db + time_now);
			   document.getElementById("product_endtime_wx").innerHTML="自订购成功时间起至"+data_time.getFullYear()+"-"+checkTime(data_time.getMonth()+1)+"-"+checkTime(data_time.getDate())+"  "+checkTime(data_time.getHours())+":"+checkTime(data_time.getMinutes())+":"+checkTime(data_time.getSeconds())+"期间内有效。";
			//}
			document.getElementById("product_name_wx").innerHTML = product['strProductNamea'][left_focus_index+istart];
			document.getElementById("dialog_erweima").style.visibility="visible";
			document.getElementById("product_name_wx").style.visibility="visible";
			document.getElementById("product_price_wx").style.visibility="visible";		
			document.getElementById("product_endtime_wx").style.visibility="visible";
			document.getElementById("dialog_order_button_wx").style.visibility="visible";
		}
	}else{
		if(parseInt(catedata.return_code) == 96003){
			document.getElementById("order_button_wx").style.visibility="hidden";
			document.getElementById("timeout_msg").style.visibility="visible";
			setTimeout("hideouttime()",3000);
		}else{
			document.getElementById("order_button_wx").style.visibility="hidden";
			//document.getElementById("dialog_ordered_failed").style.visibility="visible";
			//set_back_time();
			document.getElementById("timeout_msg").style.visibility="visible";
			setTimeout("hideouttime()",3000);
		}
	}
	
}
var ajaxTimeoutTest = null;
var backFlag=1;//返回键标志位，1代表返回到详情页，0代表返回到订购页
function getorderresult(){
	ajaxTimeoutTest = $.ajax({
	　　url:"http://210.13.0.139:8080/iptv_tpp/order/checkEpayOrderState?ditch=9999&transactionID="+transactionID+"&productID="+productID+"&userID="+userId,
	　　timeout : 1000, //超时时间设置，单位毫秒
	　　type : 'get',  //请求方式，get或post
	　　dataType:'json',//返回的数据格式
	　　success:function(data){ //请求成功的回调函数
	　　　　//alert("成功"+data+"ddd"+data.return_code);	
			if(parseInt(data.return_code) == 2){
				if(document.getElementById("dialog_erweima").style.visibility=="visible"){
					if(document.getElementById("dialog_order_button_wx").style.visibility=="visible" && backFlag==1){	
						document.getElementById("dialog_order_button_wx").style.visibility="hidden";
						document.getElementById("weix_dialog_ordered_notice").style.visibility="visible";
						setTimeout("goonpay()",3000);
					}else{
						backFlag = 1;
						document.getElementById("dialog_order_button_wx").style.visibility="hidden";
						document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
						document.getElementById("qrcode").innerHTML="";
						document.getElementById("product_name_wx").innerHTML="";
						document.getElementById("product_price_wx").innerHTML="";
						document.getElementById("product_endtime_wx").innerHTML="";
						document.getElementById("order_button_wx").style.visibility = "visible";
					}
				}
			}else if(parseInt(data.return_code) == 0){
				//alert("成功");
				if(document.getElementById("dialog_erweima").style.visibility=="visible"){
					if(document.getElementById("dialog_order_button_wx").style.visibility=="visible" && backFlag==1){	
						document.getElementById("dialog_order_button_wx").style.visibility="hidden";
						play_vod_wx();
					}else{
						backFlag = 1;
						backtodetail();
					}
				}
			}else if(parseInt(data.return_code) == 1){
				//alert("失败");	
				if(document.getElementById("dialog_erweima").style.visibility=="visible"){
					document.getElementById("qrcode").innerHTML="";
					document.getElementById("product_name_wx").innerHTML="";
					document.getElementById("product_price_wx").innerHTML="";
					document.getElementById("product_endtime_wx").innerHTML="";
					if(document.getElementById("dialog_order_button_wx").style.visibility=="visible" && backFlag==1){
						document.getElementById("weix_dialog_ordered_failed").style.visibility="visible";
						setTimeout("backtodetail()",3000);					
					}else{
						backFlag = 1;
						backtodetail();
					}
				}
			}else if(parseInt(data.return_code) == 96003){
				document.getElementById("dialog_order_button_wx").style.visibility="hidden";
				document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
				document.getElementById("timeout_msg").style.visibility="visible";
				setTimeout("hideouttime()",3000);
			}else{
				document.getElementById("dialog_order_button_wx").style.visibility="hidden";
				document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
				//document.getElementById("dialog_ordered_failed").style.visibility="visible";
				//set_back_time();
				document.getElementById("timeout_msg").style.visibility="visible";
				setTimeout("hideouttime()",3000);
			}
			if(document.getElementById("dialog_erweima").style.visibility=="visible"){
				document.getElementById("dialog_erweima").style.visibility="hidden";
				document.getElementById("qrcode").style.visibility="hidden";
				document.getElementById("product_name_wx").style.visibility="hidden";
				document.getElementById("product_price_wx").style.visibility="hidden";
				document.getElementById("product_endtime_wx").style.visibility="hidden";
			}
			
	　　},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			//alert(XMLHttpRequest.status);
		},
	　　complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
	　　　　if(status=='timeout'){//超时,status还有success,error等值的情况
	　　　　　  alert("超时");
	　　　　}
	　　}
	});
}
function hideouttime(){
	document.getElementById("timeout_msg").style.visibility="hidden";
	document.getElementById("order_button_wx").style.visibility="visible";
}
function goonpay(){
	document.getElementById("weix_dialog_ordered_notice").style.visibility="hidden";
	document.getElementById("dialog_erweima").style.visibility="visible";
	document.getElementById("qrcode").style.visibility="visible";
	document.getElementById("dialog_order_button_wx").style.visibility="visible";
	document.getElementById("product_name_wx").style.visibility="visible";
	document.getElementById("product_price_wx").style.visibility="visible";
	document.getElementById("product_endtime_wx").style.visibility="visible";
	//document.getElementById("current_price_wx").style.visibility="visible";
	//load_erweima_result();
}
function backtodetail(){
	if(ajaxTimeoutTest){
		ajaxTimeoutTest.abort();
	}
	document.getElementById("big_bg").style.display="none";
	window.parent.document.getElementById("detail_bg").style.display = "block";
	window.parent.document.getElementById("detail").style.visibility = "visible";
	if(window.parent.document.getElementById("playimg")!=null){
		window.parent.document.getElementById("playimg").style.visibility = "visible";	
	}
	window.parent.document.getElementById("fdiv").style.width = "1px";
	window.parent.document.getElementById("fdiv").style.height = "1px";
	window.parent.document.getElementById("hiddenFrame").style.width="1px";
	window.parent.document.getElementById("hiddenFrame").style.height="1px";
	window.parent.document.onkeypress = window.parent.mykeypres;
}
function creatimg(imgurl){
	//alert("44444");
	document.getElementById("qrcode").innerHTML="";
	document.getElementById("qrcode").style.visibility="visible";
	var qrcode = new QRCode(document.getElementById("qrcode"), {
		width : 200,
		height :200
	});
	qrcode.clear();
	qrcode.makeCode(imgurl);
}

function set_play_time(){
	setTimeout("play_url()",2000);
}
function play_url(){

 document.getElementById("big_bg").style.display="none";
 window.parent.document.getElementById("detail_bg").style.display="none";
 window.parent.document.getElementById("fdiv").style.width = "1px";
 window.parent.document.getElementById("fdiv").style.height = "1px";
 window.parent.document.getElementById("hiddenFrame").style.width="1px";
 window.parent.document.getElementById("hiddenFrame").style.height="1px";
 window.parent.top.mainWin.frames["hiddenFrame"].document.location=playUrl;	
//window.parent.top.mainWin.frames["hiddenFrame"].document.location = "vod_order_success.jsp?columnid=130601&programid=0000000030010000102790&programtype=0&programname=xx&vodtype=0&leefocus=href4";
//document.location="vod_order_success.jsp?columnid=130601&programid=0000000030010000102790&programtype=0&programname=xx&vodtype=0&leefocus=href4";
}

function set_play_time_wx(){
	setTimeout("play_url_wx()",2000);
}
function play_url_wx(){
 document.getElementById("big_bg").style.display="none";
 window.parent.document.getElementById("detail_bg").style.display="none";
 window.parent.document.getElementById("fdiv").style.width = "1px";
 window.parent.document.getElementById("fdiv").style.height = "1px";
 window.parent.document.getElementById("hiddenFrame").style.width="1px";
 window.parent.document.getElementById("hiddenFrame").style.height="1px";
 window.parent.top.mainWin.frames["hiddenFrame"].document.location=play_url_wx_str;	
//window.parent.top.mainWin.frames["hiddenFrame"].document.location = "vod_order_success.jsp?columnid=130601&programid=0000000030010000102790&programtype=0&programname=xx&vodtype=0&leefocus=href4";
//document.location="vod_order_success.jsp?columnid=130601&programid=0000000030010000102790&programtype=0&programname=xx&vodtype=0&leefocus=href4";
}


function play_vod_wx(){		
	if(product['strPurchaseTypea'][left_focus_index]==0){//baoyue weix_dialog_ordered_all
		document.getElementById("weix_dialog_ordered_all").style.visibility="visible";
	}else{
		document.getElementById("weix_dialog_ordered").style.visibility="visible";
	}
	set_play_time_wx();
}

function set_back(){
	document.getElementById("dialog_ordered_failed").style.visibility="hidden";
}
function set_back_time(){
	setTimeout("set_back()",2000);
}
var sec_time = 3;
var sec_order_timer;
function ordered_back_time(){ 	
	document.getElementById("ordered_sec_time").style.visibility="visible";
	document.getElementById("ordered_sec_time").innerHTML = sec_time;
	sec_order_timer = setInterval("ordered_timer()",1000);
}
function ordered_timer(){		
	sec_time --;	
	if(sec_time == 0){
		clearInterval(sec_order_timer);
		document.getElementById("ordered_sec_time").style.visibility="hidden";
		document.getElementById("dialog_ordered_second").style.visibility="hidden";
		play_url_wx();
	}else{
		document.getElementById("ordered_sec_time").innerHTML = sec_time;
	}
}

function init_focus(){
	for(var i = 0; i < product['strProductIDa'].length; i++){
		if(product['strProductIDa'][i] != "100379" && product['strProductIDa'][i] != "100444" && product['strProductIDa'][i] != "100445" && product['strProductIDa'][i] != "100446" && product['strProductIDa'][i] != "100469" && product['strProductIDa'][i] != "100470" && product['strProductIDa'][i] != "100472" && product['strProductIDa'][i] != "100313" && product['strProductIDa'][i] != "100315" && product['strProductIDa'][i] != "100482" && product['strProductIDa'][i] != "100483" && product['strProductIDa'][i] != "100484"){
			poster_flag = 1;
			break;
		}
	}
	if (poster_flag === 1){
		document.getElementById("poster").style.display = "block";
		document.getElementById("poster_focus").style.visibility = "visible";
	} else{
		focus_left_index(left_focus_index);
		textScroll(1);
	}
}

function focus_left_index(focus_id){
  document.getElementById("select_order_product_"+focus_id).src="images/portal/focus.png";
}
function blur_left_index(focus_id){
	document.getElementById("select_order_product_"+focus_id).src="images/btn_trans.gif";
}
function focus_left_index_blr(focus_id){
	document.getElementById("select_order_product_"+focus_id).src="images/vod/btv_column_focus_spring.png";
}
function page_up_down(){
	//alert("page_up_down");
	if(pageSeq>0){
	document.getElementById("button_up").style.visibility ="visible";
	}else{
	document.getElementById("button_up").style.visibility ="hidden";
	}
	if(pageSeq+1<pageCount){
	document.getElementById("button_down").style.visibility ="visible";
	}else{
	document.getElementById("button_down").style.visibility ="hidden";
	}

}
function page_next(){
	if(pageCount>1){
	if(pageSeq<pageCount){
		pageSeq++;
		istart = pageSeq*5;
		if(pageSeq+1==pageCount){
			iend = length;
		}else{
			iend = (pageSeq+1)*5;
		}
	}/*else{
		pageSeq=0;
		istart = 0;
		iend = 5;
	}*/
	}
	page_up_down();
}
function page_prev(){
	if(pageCount>1){

	if(pageSeq>0){
		pageSeq--;
		istart = pageSeq*5;
		iend = (pageSeq+1)*5;
	}/*else{
		pageSeq=pageCount-1;
		istart = pageSeq*5;
		iend =length;
	}*/
	}
	page_up_down();
}
function textScroll(doi) {
    try{
        if (doi == 1) {
            //scrollString("order_product_name_" + left_focus_index, product['strProductDesca'][left_focus_index+istart], 32, 200);
			scrollString("order_product_name_" + left_focus_index, product['strProductNamea'][left_focus_index+istart], 32, 200);
        }
        if (doi == -1) {
            //stopscrollString("order_product_name_" + left_focus_index, product['strProductDesca'][left_focus_index+istart], 32, 200);
			stopscrollString("order_product_name_" + left_focus_index, product['strProductNamea'][left_focus_index+istart], 32, 200);
        }
    }catch(e){
        alert("SSSSSSSSSSSSSSStextScroll!!!");
    }
}