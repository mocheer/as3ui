/**
 * 图片按钮：目前只有两种状态：标准、按下。
 */
package as3ui.dn.component.button
{
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	import mx.controls.TextInput;
	import mx.core.mx_internal;
	
	public class ImageButton extends Sprite 
	{
		public static const NORMAL:int = 0;
		public static const PRESSED:int = 1;
		
		private var normalImage:Loader;
		private var pressedImage:Loader;
		private var m_iState:int;
		
		public var stateChangeCallback:Function;
		public function ImageButton(normalImageUrl:String, pressedImageUrl:String, state:int = 0)
		{
			super();
			normalImage = new Loader();
			normalImage.x = 0;
			normalImage.y = 0;
			normalImage.load(new URLRequest(normalImageUrl));
			addChild(normalImage);
			
			pressedImage = new Loader();
			pressedImage.x = 0;
			pressedImage.y = 0;
			pressedImage.visible = false;
			pressedImage.load(new URLRequest(pressedImageUrl));
			addChild(pressedImage);
			
			this.state = state;
		}
		
		public function get state():int
		{
			return m_iState;
		}
		
		public function set state(val:int):void
		{
			if(m_iState != val)
			{
				m_iState = val;
				
				normalImage.visible = (m_iState == NORMAL);
				pressedImage.visible = (m_iState == PRESSED);
				if (stateChangeCallback != null)
				{
					stateChangeCallback(this);
				}
			}
		}
	}
}