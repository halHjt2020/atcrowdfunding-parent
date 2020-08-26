package com.atguigu.atcrowdfunding.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 日期工具类
 */
public class DateUtil {

	public static String format(Date d, String f) {
		SimpleDateFormat sdf = new SimpleDateFormat(f);
		return sdf.format(d);
	}

	public static String getFormatTime() {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String string = format.format(new Date());
		return string;
	}

	public static String getFormatTime(String pattern) {
		SimpleDateFormat format = new SimpleDateFormat(pattern);
		String string = format.format(new Date());
		return string;
	}

}
