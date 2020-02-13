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
      public boolean isBigEng(String str) {
        boolean value = false;
        String BigEng = "[A-Z]";
        if (str.matches(BigEng)) {
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
    int divwidths=0;
    public int length(String value) {
        int valueLength = 0;

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
//        if(coutn/3>0){
//          divwidths=valueLength+coutn/3;
//        }
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
        if(divwidths!=0){
           divwidth=divwidths; 
        }
        divwidth = divwidth - (divwidth % px);
        if (divwidth >= stringwidth) {
            distext = text;
        } else {
            for (int i = 0; i < text.length(); i++) {
                String chartemp = text.substring(i, i + 1);
                if (isChinese(chartemp)) {
                    curwidth = curwidth + px;
                } else if (isBigEng(chartemp)) {

                    curwidth = curwidth + px * 2 /3;
                } else {
                    curwidth = curwidth + px / 2;
                }
                if (curwidth > divwidth - px) {
                    break;
                }
                distext = distext + chartemp;
            }
            //            distext = distext + "..";
        }
        return distext;
    }
%>