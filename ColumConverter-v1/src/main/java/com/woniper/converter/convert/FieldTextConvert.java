package com.woniper.converter.convert;

import com.woniper.converter.dto.InfomationSchemaDto;

import java.util.List;

/**
 * Created by woniper on 2014. 6. 7..
 */
public class FieldTextConvert {

    public String textToUpperCase(String str, boolean firstCase) {
        StringBuilder result = new StringBuilder();
        int len = str.length();
        int upperNum = 0;
        for(int i = 0; i < len; i++) {
            String subStr = str.substring(i, i+1);
            if(i == 0) {
                if(firstCase) {
                    result.append(subStr.toLowerCase());
                } else {
                    result.append(subStr.toUpperCase());
                }
                continue;
            }
            if(("-".equals(subStr)) || ("_".equals(subStr))) {
                upperNum = i+1;
                result.append(str.substring(upperNum, upperNum+1).toUpperCase());
                continue;
            } else {
                if(i == upperNum)
                    continue;
                else
                    result.append(subStr.toLowerCase());
            }
        }
        return result.toString();
    }

    public String removeUnderbar(String str) {
        return str.replace("-", "").replace("_", "");
    }

    public String typeToVariable(String str) {
        String result = null;
        if("BIGINT".equalsIgnoreCase(str))
            result = "long ";
        else if("VARCHAR".equalsIgnoreCase(str))
            result = "String ";
        else if("TIMESTAMP".equalsIgnoreCase(str))
            result = "Date ";
        else if("INT".equalsIgnoreCase(str))
            result = "int ";
        else if("LONGTEXT".equalsIgnoreCase(str))
            result = "String ";
        else
            result = str+" ";
        return result;
    }

    public String getClassText(List<InfomationSchemaDto> list) {
        StringBuilder result = new StringBuilder();
        int index = list.size();
        result.append("public class ");
        result.append(removeUnderbar(textToUpperCase(list.get(0).getTable(), false)) + " {\n");
        for(InfomationSchemaDto dto : list) {
            result.append("\tprivate ");
            result.append(typeToVariable(dto.getType()));
            result.append(removeUnderbar(textToUpperCase(dto.getColumn(), true)) + ";\n");
        }
        result.append("}");
        return result.toString();
    }
}
