
<script>
    /*
     *    auth : 倪瑞
     *    param:
     *    1:text:需要展示的文字
     *    2:divWidth: div的长度
     *    3：chinesePx  每个中文的长度
     *    4：upPx 大写英文的长度
     *    5：小写英文的长度
     */
    function writeFitStringNirui(text,divwidth,chinesePx,upPx,lowPx) {
        var curwidth = 0;
        var distext = "";

        if(divwidth>10){
           divwidth = divwidth-10;
        }
        for (var i = 0; i < text.length; i++) {
                var c = text.charCodeAt(i);
                if (c > 255) {                   //chinese
                    curwidth = curwidth + chinesePx;
                }else if(c>=65 && c<=90){       //upenglish
                    curwidth = curwidth + upPx;
                }else if(c==105 || c==106 || c==108 || c==102 || c==114 || c==116){//ijlfrt
                    curwidth = curwidth + lowPx*12/5;
                }else {                        //lowenglish
                    curwidth = curwidth + lowPx;
                }
                if (curwidth >= divwidth) {
                    distext = distext + "..";
                    break;
                }
                distext = distext + text.substring(i, i + 1);
         }
         return distext;
    }



    //  获取字符串的长度，如果有中文，则每个中文字符计为2位
    function strlen(str)
    {
        var len = 0;
        for (var i = 0; i < str.length; i++)
        {
            if (str.charCodeAt(i) > 255) len += 2; else len++;
        }
        return len;
    }


    function writeFitString(text, px, divwidth, type) {
		if(type != 0){
			text = text.replace(new RegExp("<","gm"),"&lt;");
			text = text.replace(new RegExp(">","gm"),"&gt;");
		}
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var curwidth = 0;
        var distext = "";
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (divwidth >= stringwidth) {
            distext = text;
        } else {
            for (var i = 0; i < text.length; i++) {
                if (text.charCodeAt(i) > 255) {
                    curwidth = curwidth + px;
                }else if(text.charCodeAt(i) >=65&&text.charCodeAt(i)<=90){
                     curwidth = curwidth + (2/3)*px;
                }
                else {
                    curwidth = curwidth + px / 2;
                }
                if (curwidth > divwidth - px) {
                    break;
                }
                distext = distext + text.substring(i, i + 1);
            }
            distext = distext + "..";
        }
        return distext;
    }

    //  根据输入字符串的字体大小和div的宽度，截取不会折行的字符串，超过div宽度的后面加".."
    // text  原始字符串
    // px  字体大小，以px为单位
    // divwidth  div的宽度，以px为单位
    // 字体颜色
    // 适合宽度的字符串
    function getFitString(text, px, divwidth, color) {
        var distext = writeFitString(text, px, divwidth);
        document.write("<font color='#" + color + "' size='" + pxtosize(px) + "'>" + distext + "</font>");
    }

    // 字符串滚动
    function scrollString(divid, text, px, divwidth) {
		text = text.replace(new RegExp("<","gm"),"&lt;");
		text = text.replace(new RegExp(">","gm"),"&gt;");
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            var scrolltext = "<marquee version='3' scrolldelay='250' width='"+divwidth+"'>" + text + "</marquee>";
            document.getElementById(divid).innerHTML = scrolltext;
        }
    }

    // 字符串停止滚动
    function stopscrollString(divid, text, px, divwidth) {
		text = text.replace(new RegExp("<","gm"),"&lt;");
		text = text.replace(new RegExp(">","gm"),"&gt;");
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            text = writeFitString(text, px, divwidth);
        }
        document.getElementById(divid).innerText = text ;
    }

    function pxtosize(px) {
        var size = 4;
        if (px == 50) {
            size = 7;
        } else if (px == 29) {
            size = 6;
        } else if (px == 22) {
            size = 5;
        } else if (px == 18) {
            size = 4;
        } else if (px == 16) {
            size = 3;
        } else if (px == 15) {
            size = 2;
        } else if (px == 10) {
            size = 1;
        }
        return size;
    }

</script>

<%!
    /**
     * 判断字符是否为中文
     *
     * @param str
     *            指定的字符
     * @return true or false
     */
    public boolean isChinese(String str) {
        boolean value = false;
        String chinese = "[\u0391-\uFFE5]";
        if (str.matches(chinese)) {
            value = true;
        }
        return value;
    }


    /**
     * 获取字符串的长度，如果有中文，则每个中文字符计为2位
     *
     * @param value
     *            指定的字符串
     * @return 字符串的长度
     */
    public int length(String value) {
        int valueLength = 0;
        String chinese = "[\u0391-\uFFE5]";
        /* 获取字段值的长度，如果含中文字符，则每个中文字符长度为2，否则为1 */
        for (int i = 0; i < value.length(); i++) {
            /* 获取一个字符 */
            String temp = value.substring(i, i + 1);
            /* 判断是否为中文字符 */
            if (isChinese(temp)) {
                /* 中文字符长度为2 */
                valueLength += 2;
            } else {
                /* 其他字符长度为1 */
                valueLength += 1;
            }
        }
        return valueLength;
    }

    /**
     * 根据输入字符串的字体大小和div的宽度，截取不会折行的字符串，超过div宽度的后面加".."
     * @param text  原始字符串
     * @param px  字体大小，以px为单位
     * @param divwidth  div的宽度，以px为单位
     * @return 适合宽度的字符串
     */
    public String getFitString(String text, int px, int divwidth) {
        int curwidth = 0;
        String distext = "";
        int stringwidth = length(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (divwidth >= stringwidth) {
            distext = text;
        } else {
            for (int i = 0; i < text.length(); i++) {
                String chartemp = text.substring(i, i + 1);
                if (isChinese(chartemp)) {
                    curwidth = curwidth + px;
                } else {
                    curwidth = curwidth + px / 2;
                }
                if (curwidth > divwidth - px) {
                    break;
                }
                distext = distext + chartemp;
            }
            distext = distext + "..";
        }
        return distext;
    }
%>