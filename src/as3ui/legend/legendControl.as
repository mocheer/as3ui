package as3ui.legend
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	
	public class legendControl extends Sprite
	{
		//=========================================== 私有成员 =======================================
		private var m_bSuspend:Boolean = false;
		private var m_iFullHeight:Number = 0;	  //当前图例管理组件的总高度
		private var m_oWidgets:Array = [];      //所有图例
		private var m_oComponent:UIComponent;
		private var m_oMaskShape:Shape;
		private var m_marginbottom:Number=26;
		
		public function legendControl()
		{
			//添加 UIComponent 组件，便于添加任意 DisplayObject 作为图例显示。
			m_oComponent = new UIComponent();
			m_oComponent.x = 0;
			m_oComponent.y = 0;

			this.addChild(m_oComponent);
			
			//创建遮罩
			createMask();
			onResized(null);
		}
	
		//=========================================== 事件处理 ========================================
		private function onResized(e:Event):void
		{
			createMask();
			updateWidget();
		}
		private function onLegendContainerResize(e:Event):void {
			this.updateWidget(LegendContainer(e.target).widget);
		}
		
		//=========================================== 接口方法 ============================================
		public function dispose():void 
		{
			m_bSuspend=false;
		}
		
		public function resume():void 
		{
			m_bSuspend = false;
		}
		public function suspend():void 
		{
			m_bSuspend = true;
		}
		//=========================================== 方法部分 ============================================
		/**
		 * 添加图例插件
		 */
		public function addWidget(caption:String, widget:DisplayObject, widgetWidth:Number, widgetHeight:Number,marginbottom:Number=26):void
		{
			m_marginbottom=marginbottom;
			if(widget != null && m_oWidgets.indexOf(widget) < 0){
				var legendContainer:LegendContainer = new LegendContainer(widget, caption, widgetWidth, widgetHeight, 0);
				legendContainer.x = 0;
				legendContainer.y = this.height - m_iFullHeight - legendContainer.currentHeight;
				legendContainer.addEventListener(Event.RESIZE, onLegendContainerResize);
				m_oComponent.addChild(legendContainer);
				
				m_iFullHeight = m_iFullHeight + legendContainer.currentHeight;
				m_oWidgets.push(widget);
			}
		}
		/**
		 * 创建遮罩
		 */
		private function createMask():void
		{
			if(m_oMaskShape == null){
				m_oMaskShape = new Shape();
				m_oComponent.addChildAt(m_oMaskShape, 0);
				this.mask = m_oMaskShape;
			}
			
			m_oMaskShape.graphics.clear();
			m_oMaskShape.graphics.beginFill(0, 1);
			m_oMaskShape.graphics.drawRect(0, 0, this.width, this.height);
			m_oMaskShape.graphics.endFill();
			m_oMaskShape.visible = false;
		}
		/**
		 * 获取图例
		 */
		public function getWidget(index:int):*
		{
			if(index > -1 && index < m_oWidgets.length)
			{
				return m_oWidgets[index];
			}
		}
		/**
		 * 删除图例
		 */
		public function removeWidget(widget:DisplayObject):void {
			var _iIndex:int = m_oWidgets.indexOf(widget);
			if(_iIndex > -1)
			{
				var legendContainer:LegendContainer = LegendContainer(m_oWidgets[_iIndex].parent);
				if(legendContainer)
				{
					m_oComponent.removeChild(legendContainer);
					m_oWidgets.splice(_iIndex, 1);
					updateWidget();
				}
			}
		}
		
		/**
		 * 更新图例：根据图例数组往上叠加图例
		 */
		public function updateWidget(widget:DisplayObject = null, widgetWidth:Number = -1, widgetHeight:Number = -1):void{
			if(m_oWidgets.length <= 0){
				m_iFullHeight = 0;
				return;
			}
			var _iIndex:int = (widget == null ? 0 : m_oWidgets.indexOf(widget));
			if(_iIndex > -1)
			{
				var legendContainer:LegendContainer = LegendContainer(m_oWidgets[_iIndex].parent);
				if(legendContainer)
				{
					if(widgetWidth >= 0)
					{
						legendContainer.contentWidth = widgetWidth;
					}
					if(widgetHeight >= 0)
					{
						legendContainer.contentHeight = widgetHeight;
					}
					m_iFullHeight = (_iIndex > 0 ? this.height - LegendContainer(m_oWidgets[_iIndex - 1].parent).y  : 0);
					for(var k:int = _iIndex;k<m_oWidgets.length;k++)
					{
						m_iFullHeight += LegendContainer(m_oWidgets[k].parent).currentHeight;
						LegendContainer(m_oWidgets[k].parent).y = this.height - m_iFullHeight;
					}
				}
			}
		}
	}
}