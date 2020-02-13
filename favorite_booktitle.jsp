<%@    page contentType="text/html; charset=GBK" %>
<script type="text/javascript">
var bookdestpage = 1;
var booktotalpage = 1;
var bookindex = 0;
var bookdata;
var bookarr;
var bookleng;
function loadBPage() {
    clearbookdiv();
    var requestUrl = "action/favorite_bookMark_datas.jsp?destpage=" + bookdestpage;
    var loaderSearch = new net.ContentLoader(requestUrl, showBookInfo);
}
function clearbookdiv() {
    for (var i = 0; i < 10; i++) {
        $("bfocus_bg" + i).src = "images/btn_trans.gif";
        $("bfocus_img" + i).src = "images/btn_trans.gif";
        $("bfocus_name" + i).innerText = "";
        $("bfocus_name" + i).style.visibility = "hidden";

        $("book_bg" + i).src = "images/btn_trans.gif";
        $("book_img" + i).src = "images/btn_trans.gif";
        $("book_name" + i).innerText = "";
        $("book_name" + i).style.visibility = "hidden";

    }
}
function showBookInfo() {

    var results = this.req.responseText;
    bookdata = eval("(" + results + ")");
    bookarr = bookdata.bookMarkData;
    bookdestpage = bookdata.destpage;
    booktotalpage = bookdata.pageCount;

    bookleng = bookarr.length;
    if (bookleng > 0) {
        for (var i = 0; i < bookleng; i++) {
            $("book_img" + i).src = bookarr[i].normalposter;
            $("book_name" + i).innerText = writeFitString(bookarr[i].programName, 18, 160);
            $("book_name" + i).style.visibility = "visible";

        }

        if (!isTops) {
            if (!isCanShowp) {
                $("focus_x" + bookindex).style.visibility = "visible";
            }
            isleft = false;
            changebookImg(0);
        } else {
            $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkc.png";
        }
    } else {
        isleft = true;
    }
    isFoucsLeftIndex = cindex;
    showBpScrollBar();
    $("left" + cindex).src = "images/vod/btv_column_bar.png";
    document.onkeypress = bookKeyPress;

}
function bookKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0028)//onKeyDown
    {
        bookKeyDown();
    }
    else if (keyCode == 0x0026)//onKeyUp
    {
        bookKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
            bookKeyLeft();
        }
        else if (keyCode == 0x0027) { //onKeyRight
                bookKeyRight();
            } else if (keyCode == 0x0008 || keyCode == 24) {///back
                cateBack();
            } else if (keyCode == 0x0022) {  //page down
                bookpageNext();
            } else if (keyCode == 0x0021) { //page up
                bookpagePrev();
            } else if (keyCode == 0x0115) { //yellow

            } else if (keyCode == 0x0116) {  //green
                //                 goSearch();
            } else if (keyCode == 0x000D) {  //OK
                bookKeyOK();
            } else {
                //                clearStack();
                top.doKeyPress(evt);
                return true;
            }
    return false;
}
var bookKeyOK = function() {
    if (isTops && !isForOp) {
        dobookTopOk();
    } else if (isForOp) {
        isForOp = false;
        dobookOptionOk();
    } else if (isleft) {
        initByIndex();
    } else {
        dobookOk();
    }
}
var dobookOptionOk = function() {
    if (opIndex == 0) {
        var requestUrl = "action/bookpoint_del.jsp?delall=true&SubjectID='1'&ContentID='1'&FavoriteTitle='1'&seriesids='1'";
        var loaderSearch = new net.ContentLoader(requestUrl, showdellFav);
    }
    $("clearInfo").style.visibility = "hidden";
}
var dobookTopOk = function() {
    if (topIndex == 0) {
        if (isCanShowp) {
            $("buttonone").innerHTML = "确认";
            $("buttontwo").innerHTML = "取消";
            $("info").style.visibility = "visible";
            isCanShowp = false;
        } else {
            for (var i = 0; i < delList.length; i++) {
                if (i < delList.length - 1) {
                    deltitle = deltitle + bookarr[delList[i]].programName + "&";
                    delSubject = delSubject + bookarr[delList[i]].columnId + "&";
                    delContent = delContent + bookarr[delList[i]].contentId + "&";
                    delSeriesid = delSeriesid + bookarr[delList[i]].vSeriesprogramcode + "&";
                } else {
                    deltitle = deltitle + bookarr[delList[i]].programName;
                    delSubject = delSubject + bookarr[delList[i]].columnId;
                    delContent = delContent + bookarr[delList[i]].contentId;
                    delSeriesid = delSeriesid + bookarr[delList[i]].vSeriesprogramcode;
                }
            }
            var requestUrl = "action/bookpoint_del.jsp?SubjectID=" + delSubject + "&ContentID=" + delContent + "&FavoriteTitle=" + deltitle + "&seriesids=" + delSeriesid;
            var laderSearch = new net.ContentLoader(requestUrl, showdellFav);
            clearbookDelIco();
            $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkquit.png";
        }
    } else {
        if (isCanShowp) {
            isForOp = true;
            $("clearInfo").style.visibility = "visible";
            $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
            $("doY").src = "images/vod/btv-02-add-bookmarkc.png";

        } else {
            $("buttonone").innerHTML = "编辑";
            $("buttontwo").innerHTML = "清空";
            $("info").style.visibility = "hidden";
            clearbookDelIco();
            isCanShowp = true;
        }

    }

}
var clearbookDelIco = function() {
    for (var i = 0; i < delList.length; i++) {
        $("bpbg_x" + delList[i]).style.visibility = "hidden";
    }
    bookindex = 0;
}
var dobookOk = function() {
    if (!isCanShowp) {
        $("bpbg_x" + bookindex).style.visibility = "visible";
        $("bpfocus_x" + bookindex).src = "images/channel/btv-mytv-cancelclick.png";
        delList[delIndex] = bookindex;
        delIndex++;
    } else {
       // alert("===============shut" + bookarr[bookindex].programType);
        if (bookarr[bookindex].programType == "0") {
            document.location = "vod_detail.jsp?<%=EpgConstants.COLUMN_ID%>=" + bookarr[bookindex].columnId
                    + "&<%=EpgConstants.PROGRAM_ID%>=" + bookarr[bookindex].programId
                    + "&<%=EpgConstants.PROGRAM_TYPE%>=" + bookarr[bookindex].programType
                    + "&<%=EpgConstants.CONTENT_ID%>=" + bookarr[bookindex].contentId
                    + "&programname=" + bookarr[bookindex].programName;
        } else if (bookarr[bookindex].programType == "1") {
            document.location = "vod_series_list.jsp?<%=EpgConstants.COLUMN_ID%>=" + bookarr[bookindex].columnId
                    + "&<%=EpgConstants.PROGRAM_ID%>=" + bookarr[bookindex].programId
                    + "&<%=EpgConstants.PROGRAM_TYPE%>=" + bookarr[bookindex].programType
                    + "&<%=EpgConstants.CONTENT_ID%>=" + bookarr[bookindex].contentId
                    + "&programname=" + bookarr[bookindex].programName;
            +"&<%=EpgConstants.SERIES_PROGRAMCODE%>=" + bookarr[bookindex].programId + "&vodtype=100";
        }

    }
}
var bookKeyDown = function() {
    if (!isForOp) {
        if (isTops) {
            $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkquit.png";
            topIndex = 0;
            if (bookleng > 0) {
                isTops = false;
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/channel/tv_Xico.png";
                }
                changebookImg(0);
                //                $("bg_pro" + vodindex).style.visibility = "visible";
            }
        } else {
            if (isleft) { //栏目移动
                if (cindex == isFoucsLeftIndex) {
                    $("left" + cindex).src = "images/vod/btv_column_bar.png";
                } else {
                    $("left" + cindex).src = "images/btn_trans.gif";
                }
                if (cindex >= 0 && cindex < cleng) {
                    cindex++;
                }
                if (cindex == cleng) {
                    cindex = 0;
                }
                $("left" + cindex).src = "images/channel/channel_focus.png";


            } else if (bookleng > 0) { //vod移动
                //               vodtextScroll(-1);
                changebookImg(1)
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/btn_trans.gif";
                }
                if ((bookindex == 0 && bookleng > 5) || (bookindex == 1 && bookleng > 6) || (bookindex == 2 && bookleng > 7) || (bookindex == 3 && bookleng > 8) || (bookindex == 4 && bookleng > 9)) {
                    bookindex = bookindex + 5;
                }
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/channel/tv_Xico.png";
                }
                changebookImg(0);
                //               vodtextScroll(1);

            }
        }
    }
}
var bookKeyRight = function() {
    if (isForOp) {
        $("doY").src = "images/vod/btv-02-add-bookmarkquit.png";
        $("doN").src = "images/vod/btv-02-add-bookmarkc.png";
        opIndex = 1;
    } else {
        if (isTops) {

            $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkquit.png";
            topIndex ++;
            if (topIndex > 1) {
                topIndex = 0;
            }
            $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkc.png";
        }
        else {
            if (isleft == true && bookleng > 0) {
                isleft = false;
                if (cindex == isFoucsLeftIndex) {
                    $("left" + cindex).src = "images/vod/btv_column_bar.png";
                } else {
                    $("left" + cindex).src = "images/btn_trans.gif";
                }
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/channel/tv_Xico.png";
                }
                changebookImg(0);
                //               textScroll(-1);
                //               vodtextScroll(1);

            } else if (bookleng > 0) {
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/btn_trans.gif";
                }
                changebookImg(1);
                //                 vodtextScroll(-1);
                if (bookindex >= 0 && bookindex < bookleng - 1) {
                    bookindex++;
                } else {
                    bookindex = 0;
                }
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/channel/tv_Xico.png";
                }
                changebookImg(0);
                //                 vodtextScroll(1);

            }
        }
    }
}
var bookKeyLeft = function() {
    if (isForOp) {
        $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
        $("doY").src = "images/vod/btv-02-add-bookmarkc.png";
        opIndex = 0;
    } else {
        if (isTops) {
            if (topIndex == 0) {
                isleft = true;
                isTops = false;
                $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkquit.png";
                $("left" + cindex).src = "images/channel/channel_focus.png";
            }
            else {
                $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkquit.png";
                topIndex = 0;
                $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkc.png";

            }
        } else {
            if (!isleft) {
              //  alert("=====fdfdfdfdfdfd=cececececececece" + bookindex);
                if (bookindex == 0 || bookindex == 5) {
                   // alert("=========cececececececece");
                    isleft = true;
                    if (!isCanShowp) {
                        $("bpfocus_x" + bookindex).src = "images/btn_trans.gif";

                    }
                    changebookImg(1);
                    $("left" + cindex).src = "images/channel/channel_focus.png";

                } else {
                    if (bookindex > 0 && bookindex < bookleng) {
                        //                       vodtextScroll(-1);
                        if (!isCanShowp) {
                            $("bpfocus_x" + bookindex).src = "images/btn_trans.gif";
                        }
                        changebookImg(1);
                        bookindex--;
                        changebookImg(0);
                        if (!isCanShowp) {
                            $("bpfocus_x" + bookindex).src = "images/channel/tv_Xico.png";
                        }
                        //                       vodtextScroll(1);
                    }
                }
            }
        }
    }
}
var bookKeyUp = function() {
    if (!isForOp) {
        if (isleft) {//栏目移动

            if (cindex == isFoucsLeftIndex) {
                $("left" + cindex).src = "images/vod/btv_column_bar.png";
            } else {
                $("left" + cindex).src = "images/btn_trans.gif";
            }
            if (cindex < cleng) {
                cindex--;
            }
            if (cindex < 0) {
                cindex = cleng - 1;
            }
            $("left" + cindex).src = "images/channel/channel_focus.png";

        } else if (bookleng > 0) {//vod移动
            if (bookindex < 5) {
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/btn_trans.gif";
                }
                changebookImg(1);
                $("top" + topIndex).src = "images/vod/btv-02-add-bookmarkc.png";
                isTops = true;

            } else {
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/btn_trans.gif";
                }
                changebookImg(1);
                if (bookleng > 5 && bookindex >= 5) {
                    bookindex = bookindex - 5;
                }
                if (!isCanShowp) {
                    $("bpfocus_x" + bookindex).src = "images/channel/tv_Xico.png";
                }
                changebookImg(0);
            }
        }
    }
}
function changebookImg(flag) {
    if (flag == 0) {
        $("book_bg" + bookindex).src = "images/btn_trans.gif";
        $("book_img" + bookindex).src = "images/btn_trans.gif";
        $("book_name" + bookindex).style.visibility = "hidden";

        $("bfocus_bg" + bookindex).src = "images/vod/bt_bgclick.png";   //获取焦点背景图
        $("bfocus_img" + bookindex).src = bookarr[bookindex].normalposter;
        $("bfocus_name" + bookindex).innerText = $("book_name" + bookindex).innerText;
        $("bfocus_name" + bookindex).style.visibility = "visible";
    } else {
        $("bfocus_bg" + bookindex).src = "images/btn_trans.gif";   //失去焦点背景图
        $("bfocus_img" + bookindex).src = "images/btn_trans.gif";
        $("bfocus_name" + bookindex).style.visibility = "hidden";

        $("book_bg" + bookindex).src = "images/btn_trans.gif";
        $("book_img" + bookindex).src = bookarr[bookindex].normalposter;
        $("book_name" + bookindex).innerText = $("book_name" + bookindex).innerText;
        $("book_name" + bookindex).style.visibility = "visible";
    }
}
function showBpScrollBar() {
    if (bookleng > 0) {
        var heightX = 504 / totalpage;
        var topX = 3 + heightX * (cdestpage - 1)
        $("scrollbar2").height = heightX;
        $("scroll").style.top = topX;
        $("pageBar").style.visibility = "visible";
    } else {
        $("pageBar").style.visibility = "hidden";
    }
}
</script>
<div style="position:absolute;  left:0; top:0;">
<div id="bookF" style="position:absolute;  left:0; top:0; visibility:hidden;">
    <!--vod-->
    <%
        for (int i = 0; i < 10; i++) {
            int frow = i / 5;
            int fcol = i % 5;
            int fleft =275+ fcol * 192;
            int ftop = 132 + frow * 287;
    %>
    <div style="position:absolute;  left:<%=fleft%>; top:<%=ftop%>;width:158; height:227;" align="left">
        <img id="book_bg<%=i%>" src="images/btn_trans.gif" alt="" width="158" height="227" border="0">
    </div>
    <div id="book_poster<%=i%>" style="position:absolute;  left:<%=fleft%>; top:<%=ftop%>;width:160; height:240; ">
        <img id="book_img<%=i%>" src="images/btn_trans.gif" alt="" width="158" height="227" border="0">
    </div>
    <div id="book_name<%=i%>"
         style="position:absolute; background-image:url(images/vod/btv_vod.png); left:<%=fleft%>; top:<%=ftop+190%>;width:159; height:51px;font-size:20px; color:#FFFFFF;visibility:visible"
         align="center">
    </div>
    <div id="bpbg_x<%=i%>"
         style="left:<%=fleft+10%>;top:<%=ftop%>; position:absolute;width:180;height:35;visibility:hidden;">
        <img src="images/channel/tv_Xico.png" width="36" height="37" alt=""/>
    </div>
    <div style="position:absolute;  left:<%=fleft-20%>; top:<%=ftop-30%>;width:200; height:264;"
         align="left">
        <img id="bfocus_bg<%=i%>" src="images/btn_trans.gif" alt="" width="200" height="301" border="0">
    </div>
    <div style="position:absolute;  left:<%=fleft-10%>; top:<%=ftop-20%>;width:180; height:260; ">
        <img id="bfocus_img<%=i%>" src="images/btn_trans.gif" alt="" width="180" height="280" border="0">
    </div>

    <div id="bfocus_name<%=i%>"
         style="position:absolute; background-image:url(images/vod/btv_focus.png);left:<%=fleft-10%>; top:<%=ftop+210%>;width:180; height:51;font-size:24px;color:#FFFFFF;;visibility:visible"
         align="center">
    </div>
    <div
            style="position:absolute; left:<%=fleft-60%>; top:<%=ftop%>;width:180; height:51;font-size:24px;color:#FFFFFF;;visibility:visible"
            align="center">
        <img name="bpfocus_x<%=i%>" src="images/btn_trans.gif" width="36" height="37" alt=""/>
    </div>
    <%
        }
    %>
    <div style="position:absolute; width:750px; height:38px; left:805px; top:672px;font-size:18px;">
        <div id="pre" style="visibility:visible">
            <img src="images/vod/btv_page.png" alt=""  width="60" height="31" style="position:absolute;left:0;top:0px;">
            <font style="position:absolute;left:2;top:4px;color:#000000">上一页</font>
            <font style="position:absolute;left:83;top:4px;color:#FFFFFF">上一页</font>
        </div>
        <div id="next" style="visibility:visible">
            <img src="images/vod/btv_page.png" alt="" width="60" height="31" style="position:absolute;left:200;top:0px;">
            <font style="position:absolute;left:202;top:4px;color:#000000">下一页</font>
            <font style="position:absolute;left:282;top:4px;color:#FFFFFF">下一页</font>
        </div>
    </div>
    <div style="position:absolute; width:20px; height:534px; left:1220px; top:103px;">
        <div id="pageBar" style="position:absolute; width:20px; height:534px; left:0px; top:0px;visibility:hidden">
            <div style="position:absolute; width:20px; height:534px; left:0px; top:0px;">
                <img src="images/vod/btv-02-scrollbar.png"  width="20" height="534"border="0" alt=""/>
            </div>
            <div id="scroll" style="position:absolute; width:20px; height:534px; left:3px; top:3px;">
                <img id="scrollbar1" src="images/vod/btv-02-scrollbar01.png" alt=""   width="13" height="10" />
                <img id="scrollbar2" src="images/vod/btv-02-scrollbar02.png" alt=""  width="13" height="10" />
                <img id="scrollbar3" src="images/vod/btv-02-scrollbar03.png"  alt="" width="13" height="10" />
            </div>
        </div>
    </div>
</div>
</div>