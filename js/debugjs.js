/*!
 * the iframe controller function v1.0 in Static EPG;
 * UTStarcom EPG team.
 * Copyright 2012,
 * Create Date:2012-07-18
 * Restructure Date:
 * Author:Carl
 * Email: Carl.li@utstar.com
 * Last Modify Date: 2012/11/7 9:41:28
 */
var g_o={};
var _Debug=function(){
    this.line_count=1;
    this.log_arr=[];
    this.max_line=10;
    this.print_log=function(msg){
        var d=new Date();
        this.log_arr.push(this.line_count++ +" "+d.toLocaleTimeString() +" "+msg);
        this.check_length();
        this.log_refresh();
    };
    this.check_length=function(msg){
        var d_num=this.log_arr.length - this.max_line;
        while(d_num-- > 0){
            this.log_arr.shift();
        };
    };
    this.log_refresh=function(){
        var origin_arr=this.log_arr;
        var revers_arr=origin_arr.reverse();
        //epg_log("revers_arr:"+typeof(revers_arr));
        if(typeof(revers_arr)=="undefined"){//the judgment is only for the UTStarcom rubbish browser;
            revers_arr=origin_arr;//on the rubbish browser, typeof(Array.reverse) still get "function" value. but executed it get "undefined";
        }
        document.getElementById("debug_div").innerHTML=revers_arr.join("<br>");
    };
    this.log_clear=function(){
        document.getElementById("debug_div").innerHTML="&nbsp;";
    };
    this.show_debug=function(){
        document.getElementById("debug_div").style.display="block";
    };
};