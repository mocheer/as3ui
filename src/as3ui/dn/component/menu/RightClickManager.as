package as3ui.dn.component.menu
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	/**
	 * 打开html-template文件夹下的index.template.html文件，
	 * 在var params = {};语句的下面添加下面的语句：params.wmode = "opaque";//屏蔽系统右键菜单的关键
	 */
	public class RightClickManager
	{
		//static public var rightClickTarget:DisplayObject;//ori
		static public var rightClickTarget:InteractiveObject;
		static public const RIGHT_CLICK:String = "rightClick";
		static private const javascript:XML = 
		<script>
			<![CDATA[
				/**
				 * Version 0.6.2
				 */
				function(flashObjectId)
				{				
					var RightClick = {
						/**
						 *  Constructor
						 */ 
						init: function (flashObjectId) {
							this.FlashObjectID = flashObjectId;
							this.Cache = this.FlashObjectID;
							if(window.addEventListener){
								 window.addEventListener("mousedown", this.onGeckoMouse(), true);
							} else {
								document.getElementById(this.FlashObjectID).parentNode.onmouseup = function() { document.getElementById(RightClick.FlashObjectID).parentNode.releaseCapture(); }
								document.oncontextmenu = function(){ if(window.event.srcElement.id == RightClick.FlashObjectID) { return false; } else { RightClick.Cache = "nan"; }}
								document.getElementById(this.FlashObjectID).parentNode.onmousedown = RightClick.onIEMouse;
							}
						},
						/**
						 * GECKO / WEBKIT event overkill
						 * @param {Object} eventObject
						 */
						killEvents: function(eventObject) {
							if(eventObject) {
								if (eventObject.stopPropagation) eventObject.stopPropagation();
								if (eventObject.preventDefault) eventObject.preventDefault();
								if (eventObject.preventCapture) eventObject.preventCapture();
								if (eventObject.preventBubble) eventObject.preventBubble();
							}
						},
						/**
						 * GECKO / WEBKIT call right click
						 * @param {Object} ev
						 */
						onGeckoMouse: function(ev) {
							return function(ev) {
							if (ev.button != 0) {
								RightClick.killEvents(ev);
								if(ev.target.id == RightClick.FlashObjectID && RightClick.Cache == RightClick.FlashObjectID) {
									RightClick.call();
								}
								RightClick.Cache = ev.target.id;
							}
						  }
						},
						/**
						 * IE call right click
						 * @param {Object} ev
						 */
						onIEMouse: function() {
							if (event.button > 1) {
								if(window.event.srcElement.id == RightClick.FlashObjectID && RightClick.Cache == RightClick.FlashObjectID) {
									RightClick.call(); 
								}
								document.getElementById(RightClick.FlashObjectID).parentNode.setCapture();
								if(window.event.srcElement.id)
								RightClick.Cache = window.event.srcElement.id;
							}
						},
						/**
						 * Main call to Flash External Interface
						 */
						call: function() {
							document.getElementById(this.FlashObjectID).rightClick();
						}
					}
					
					RightClick.init(flashObjectId);
				}
			]]>
		</script>;
		
		public function RightClickManager()
		{
			return;
		}
		
		static public function regist() : Boolean
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(javascript, ExternalInterface.objectID);
				ExternalInterface.addCallback("rightClick", dispatchRightClickEvent);
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			}// end if
			return true;
		}
		
		static private function mouseOverHandler(event:MouseEvent) : void
		{
			//rightClickTarget = DisplayObject(event.target); //ori
			rightClickTarget = InteractiveObject(event.target);  
			return;
		}
		//修改RightClickManager的事件从MouseEvent改为ContextMenuEvent是为了能在列表控件DataGrid\Tree\List上点右键时自动选择当前行，
		//使用了ContextMenuEvent事件中的 event.mouseTarget和列表控件的IListItemRenderer接口！
		static private function dispatchRightClickEvent() : void
		{
			//var event:MouseEvent;//ori
			var event:ContextMenuEvent;
			if (rightClickTarget != null)
			{
				//event = new MouseEvent(RIGHT_CLICK, true, false, rightClickTarget.mouseX, rightClickTarget.mouseY);//ori
				event = new ContextMenuEvent(RIGHT_CLICK, true, false, rightClickTarget, rightClickTarget);
				rightClickTarget.dispatchEvent(event);
			}// end if
			return;
		}
		
		static public function setRightClickTargetNULL():void{
			rightClickTarget = null;
		}
	}
	}