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
      public boolean isBigEng(String str) {
        boolean value = false;
        String BigEng = "[A-Z]";
        if (str.matches(BigEng)) {
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
    int divwidths=0;
    public int length(String value) {
        int valueLength = 0;

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
//        if(coutn/3>0){
//          divwidths=valueLength+coutn/3;
//        }
        return valueLength;
    }

    /**
     * ���������ַ����������С��div�Ŀ�ȣ���ȡ�������е��ַ���������div��ȵĺ����".."
     * @param text  ԭʼ�ַ���
     * @param px  �����С����pxΪ��λ
     * @param divwidth  div�Ŀ�ȣ���pxΪ��λ
     * @return �ʺϿ�ȵ��ַ���
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