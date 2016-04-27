package meta.bind
{
	import flash.text.Font;

	/**
	 * 嵌入字体到flash文件中使用
	 */
	public class FontHelper
	{
		//================================================ 嵌入字体 ==============================================
		[Embed(source="/StrongSoftMap/res/fonts/MapInfo Symbols.TTF", fontName="MapInfo Symbols",mimeType="application/x-font")]
		public static var font_MapInfo_Symbols:Class;
		
		[Embed(source="/StrongSoftMap/res/fonts/MapInfo Cartographic.TTF", fontName="MapInfo Cartographic",mimeType="application/x-font")]
		private static var font_MapInfo_Cartographic:Class;
		
		public static const m_oEmbedFonts:Array = [ "MapInfo Symbols", "MapInfo Cartographic"];
		public static const m_oFonts:Array = [font_MapInfo_Symbols];
		//===================================================== 方法部分 ==========================================================
		/**
		 * 检测嵌入字体中是否包含具有 fontName 名称的字体
		 * @param	fontName	待检测的字体名称
		 * @return			如果嵌入字体中已包含该名称的字体，则返回true。否则返回false
		 */
		public static function isEmbedFont(fontName:String):Boolean
		{
			var index:int =  m_oEmbedFonts.indexOf(fontName)
			var flag:Boolean = index> -1;
			if(flag==false) return false;
			var isResgister:Boolean = false;
			var fontArray :Array = Font.enumerateFonts(false);
			for each(var item:Font in fontArray)
			{
				if(item.fontName==fontName)
				{
					isResgister = true;
					break;
				}
			}
			if(isResgister==false)
			{
				Font.registerFont(m_oFonts[index])
			}
			return true;
		}
	}
}