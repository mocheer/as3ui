/**
* 功能：地图弹出框位置辅助类
*/
package as3ui.map
{
	import flash.display.Sprite;
	
	public class AnchorMarker extends Sprite
	{
		public static const TOP_LEFT:int = 0;
		public static const TOP_RIGHT:int = 1;
		public static const BOTTOM_LEFT:int = 2;
		public static const BOTTOM_RIGHT:int = 3;
		public static const TOP_CENTER:int=4;
		public static const BOTTOM_CENTER:int=5;
		public static const CENTER:int=6;
		
		private var m_iAnchor:int = 0;
		
		//对象宽高属性名称
		public var contentWidthProperty:String = "width";
		public var contentHeightProperty:String = "height";
		
		//锚点的偏移数量
		public var offsetX:int = 0;
		public var offsetY:int = 0;
		
		public var content:*;
		public function AnchorMarker(content:*, anchor:int = 0)
		{
			super();
			this.content = content;
			addChild(content);
			
			this.anchor = anchor;
		}
		
		//================================================= 属性部分 ===========================================
		public function get anchor():int
		{
			return m_iAnchor;
		}
		
		public function set anchor(val:int):void
		{
			m_iAnchor = val;
			updateContentPosition();
		}
		
		public function get mesuredWidth():Number
		{
			return offsetX + content[contentWidthProperty];
		}
		
		public function get mesuredHeight():Number
		{
			return offsetY + content[contentHeightProperty];
		}
		
		//================================================= 方法部分 ===========================================
		public function updateContentPosition():void
		{
			switch(m_iAnchor)
			{
				case TOP_LEFT:
					content.x = offsetX;
					content.y = offsetY;
					break;
				case TOP_RIGHT:
					content.x = -(offsetX + content[contentWidthProperty]);
					content.y = offsetY;
					break;
				case TOP_CENTER:
					content.x=offsetX-content[contentWidthProperty]/2;
					content.y = offsetY+30;
					break;
				case BOTTOM_LEFT:
					content.x = offsetX;
					content.y = -(offsetY + content[contentHeightProperty]);
					break;
				case BOTTOM_RIGHT:
					content.x = -(offsetX + content[contentWidthProperty]);
					content.y = -(offsetY + content[contentHeightProperty]);
					break;
				case BOTTOM_CENTER:
					content.x = offsetX-content[contentWidthProperty]/2;
					content.y = -(offsetY + content[contentHeightProperty])-30;
					break;
				case CENTER:
					content.x = offsetX - content[contentWidthProperty]/2;
					content.y = offsetY - content[contentHeightProperty]/2;
					break;
			}
		}
	}
}