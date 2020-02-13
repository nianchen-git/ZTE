<%@ page contentType="text/html; charset=GBK" %>
<script language="javascript" type="">
    //  ��ȡ�ַ����ĳ��ȣ���������ģ���ÿ�������ַ���Ϊ2λ
    function strlen(str)
    {
        var len = 0;
        for (var i = 0; i < str.length; i++)
        {
            if (str.charCodeAt(i) > 255) len += 2; else len++;
        }
        return len;
    }


    function writeFitString(text, px, divwidth) {
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
                } else {
                    curwidth = curwidth + px / 2;
                }
                if (curwidth > divwidth - px) {
                    break;
                }
                distext = distext + text.substring(i, i + 1);
            }
            distext = distext ;
        }
        return distext;
    }

    //  ���������ַ����������С��div�Ŀ�ȣ���ȡ�������е��ַ���������div��ȵĺ����".."
    // text  ԭʼ�ַ���
    // px  �����С����pxΪ��λ
    // divwidth  div�Ŀ�ȣ���pxΪ��λ
    // ������ɫ
    // �ʺϿ�ȵ��ַ���
    function getFitString(text, px, divwidth, color) {
//        alert("==================================��ľ�н�������"+text);
        var distext = writeFitString(text, px, divwidth);
        document.write("<font color='#" + color + "' size='" + pxtosize(px) + "'>" + distext + "</font>");
    }

    // �ַ�������
    //
    function scrollString(divid, text, px, divwidth, color,scrollwidth) {
        if(scrollwidth==null){
           scrollwidth=divwidth;
        }
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            var scrolltext = "<marquee version='3' scrolldelay='200' width='"+scrollwidth+"'><font color='#" + color + "' size='" + pxtosize(px) + "'>" + text + "</font></marquee>";
            document.getElementById(divid).innerHTML = scrolltext;
        }
    }

    // �ַ���ֹͣ����
    function stopscrollString(divid, text, px, divwidth, color) {
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            text = writeFitString(text, px, divwidth);
        }
        document.getElementById(divid).innerHTML = "<font color='#" + color + "' size='" + pxtosize(px) + "'>" + text + "</font>";
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
     * �ж��ַ��Ƿ�Ϊ����
     *
     * @param str
     *            ָ�����ַ�
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
     * ��ȡ�ַ����ĳ��ȣ���������ģ���ÿ�������ַ���Ϊ2λ
     *
     * @param value
     *            ָ�����ַ���
     * @return �ַ����ĳ���
     */
    public int length(String value) {
        int valueLength = 0;
        String chinese = "[\u0391-\uFFE5]";
        /* ��ȡ�ֶ�ֵ�ĳ��ȣ�����������ַ�����ÿ�������ַ�����Ϊ2������Ϊ1 */
        for (int i = 0; i < value.length(); i++) {
            /* ��ȡһ���ַ� */
            String temp = value.substring(i, i + 1);
            /* �ж��Ƿ�Ϊ�����ַ� */
            if (isChinese(temp)) {
                /* �����ַ�����Ϊ2 */
                valueLength += 2;
            } else {
                /* �����ַ�����Ϊ1 */
                valueLength += 1;
            }
        }
        return valueLength;
    }

    /**
     * ���������ַ����������С��div�Ŀ�ȣ���ȡ�������е��ַ���������div��ȵĺ����".."
     * @param text  ԭʼ�ַ���
     * @param px  �����С����pxΪ��λ
     * @param divwidth  div�Ŀ�ȣ���pxΪ��λ
     * @return �ʺϿ�ȵ��ַ���
     */
    public String getFitStringWithPoint(String text, int px, int divwidth) {
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
        }
        return distext;
    }

    /**
     * ���������ַ����������С��div�Ŀ�ȣ���ȡ�������е��ַ���������div��ȵĺ��治��".."
     * @param text  ԭʼ�ַ���
     * @param px  �����С����pxΪ��λ
     * @param divwidth  div�Ŀ�ȣ���pxΪ��λ
     * @return �ʺϿ�ȵ��ַ���
     */
    public String getFitStringWithoutPoint(String text, int px, int divwidth) {
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
                if (curwidth > divwidth) {
                    break;
                }
                distext = distext + chartemp;
            }
        }
        return distext;
    }
%>