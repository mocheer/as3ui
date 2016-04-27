package as3ui.dn.format
{
	import mx.resources.IResourceManager;

	/**
	 * @author gyb
	 * @date：2014-12-23 上午11:36:05
	 */
	public class DateFormat
	{
		//==================================================属性及构造函数================================================
		public static const FORMAT_IN_DAY:String = "YYYY-MM-DD";
		public static const FORMAT_FULL_0:String = "YYYY-MM-DD JJ:NN:SS";
		public static const FORMAT_FULL_1:String = "YYYY-MM-DD HH:NN:SS";
		//=======================================================方法=====================================================
		/**
		 * DateField.stringToDate：字符串转换成日期类型
		 * update:支持时分秒
		 * @param dateString
		 * @param formatString 文本字段中所显示日期的格式。此属性包含 "MM"、"DD"、"YY"、"YYYY"、分隔符和标点符号的任意组合。
		 * @return 
		 */
		public static function stringToDate(valueString:String, inputFormat:String=FORMAT_IN_DAY):Date
		{
			var mask:String
			var temp:String;
			var dateString:String = "";
			var monthString:String = "";
			var yearString:String = "";
			var hoursString:String = "";
			var minutesString:String = "";
			var secondsString:String = "";
			var msString:String = "";
			var j:int = 0;
			
			var n:int = inputFormat.length;
			for (var i:int = 0; i < n; i++,j++)
			{
				temp = "" + valueString.charAt(j);
				mask = "" + inputFormat.charAt(i);
				
				switch(mask)
				{
					case "Y":
						yearString += temp;
						break;
					case "M":
						if (isNaN(Number(temp)) || temp == " ")
							j--;
						else
							monthString += temp;
						break;
					case "D":
						if (isNaN(Number(temp)) || temp == " ")
							j--;
						else
							dateString += temp;
						break;
					case "E":// day in the week
						break;
					case "A":// am/pm marker
						break;
					case "J":// hour in day (0-23)
						break;
					case "H":// hour in day (1-24)
						break;
					case "K":// hour in am/pm (0-11)
						break;
					case "L":// hour in am/pm (1-12)
						break;
					case "N":// minutes in hour
						break;
					case "S":// seconds in minute
						break;
					case "Q":// milliseconds in second
						break;
					default :
						if(!isNaN(Number(temp)) && temp != " ")
						{
							return null;
						}
						break;
				}
			}
			
			temp = "" + valueString.charAt(inputFormat.length - i + j);
			if (!(temp == "") && (temp != " "))
				return null;
			
			var monthNum:Number = Number(monthString);
			var dayNum:Number = Number(dateString);
			var yearNum:Number = Number(yearString);
			
			if (isNaN(yearNum) || isNaN(monthNum) || isNaN(dayNum))
				return null;
			
			if (yearString.length == 2 && yearNum < 70)
				yearNum+=2000;
			
			var newDate:Date = new Date(yearNum, monthNum - 1, dayNum);
			
			if (dayNum != newDate.getDate() || (monthNum - 1) != newDate.getMonth())
				return null;
			
			return newDate;
		}
		
		/**
		 * DateField.dateToString:日期转换成字符串类型
		 * @param date
		 * @param formatString
		 * @return 
		 */
		public static function dateToString(value:Date,outputFormat:String=FORMAT_IN_DAY):String
		{
			if (!value)
				return "";
			
			var date:String = String(value.getDate());
			if (date.length < 2)
				date = "0" + date;
			
			var month:String = String(value.getMonth() + 1);
			if (month.length < 2)
				month = "0" + month;
			
			var year:String = String(value.getFullYear());
			
			var output:String = "";
			var mask:String;
			
			// outputFormat will be null if there are no resources.
			var n:int = outputFormat != null ? outputFormat.length : 0;
			for (var i:int = 0; i < n; i++)
			{
				mask = outputFormat.charAt(i);
				
				if (mask == "M")
				{
					if ( outputFormat.charAt(i+1) == "/" && value.getMonth() < 9 ) {
						output += month.substring(1) + "/";
					} else {
						output += month;
					}
					i++;    
				}
				else if (mask == "D")
				{
					if ( outputFormat.charAt(i+1) == "/" && value.getDate() < 10 ) {
						output += date.substring(1) + "/";
					} else {    
						output += date;                         
					}
					i++;
				}
				else if (mask == "Y")
				{
					if (outputFormat.charAt(i+2) == "Y")
					{
						output += year;
						i += 3;
					}
					else
					{
						output += year.substring(2,4);
						i++;
					}
				}
				else
				{
					output += mask;
				}
			}
			
			return output;
		}
		
		
	}
}

