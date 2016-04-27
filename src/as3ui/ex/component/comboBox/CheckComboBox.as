package as3ui.ex.component.comboBox
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.ComboBox;
	import mx.controls.List;
	import mx.core.ClassFactory;
	import mx.core.SpriteAsset;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	use namespace mx_internal;
	
	[Event(name="selectedChange", type="flash.events.Event")]
	/**
	 * @author gyb
	 * @date：2015-3-25 下午03:44:08
	 */
	public class CheckComboBox extends ComboBox
	{  
		[Bindable]  
		private var _selectedLabel:String;
		
		public var splitStr:String=";";
		public var showSingleLabel:Boolean = false;
		
		public function CheckComboBox()
		{  
			super();  
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
			this.itemRenderer=new ClassFactory(CheckBoxRenderer);
		} 
		private function onCreateComplete(event:FlexEvent):void
		{
			dropdown.allowMultipleSelection=true;
			dropdown.addEventListener(MouseEvent.CLICK,onMouseClick,true);
		}
		private function onMouseClick(event:MouseEvent):void
		{
			var clickTarget:CheckBoxRenderer;
			clickTarget = event.target as CheckBoxRenderer;
			if(!clickTarget)
			{
				var eventTarget:List = event.currentTarget as List;
				clickTarget = eventTarget.getItemRendererForMouseEvent(event) as CheckBoxRenderer;
				if(clickTarget)
				{
					var isSelected:Boolean = !clickTarget.selected;
					clickTarget.selected = isSelected;
					clickTarget.data.selected = isSelected;
				}
			}
		}
		/**
		 * 重写close方法：当trigger不为空的时候关闭下拉框 
		 */
		override public function close(trigger:Event=null):void
		{
			if(isShowingDropdown)
			{
				if (dropdown)
				{
					selectedIndex = dropdown.selectedIndex;
				}
				if(trigger)
				{
					super.close();
				}
			}
			
		}
		/**
		 * 重写selectedIndex，更新文本内容
		 */
		override public function set selectedIndex(value:int):void
		{
			super.selectedIndex = value;
//			invalidateDisplayList();
			updateSelectedLabel();
		}
		
		/**
		 * 执行文本更新
		 * @param flag 是否强制刷新文本框
		 */
		public function updateSelectedLabel(flag:Boolean = false):void
		{
			if (textInput)
			{
				var list:* = this.dataProvider;
				var selectedStr:String = "";  //复选框收缩后的label,此处以"/"分割显示选中的值
				for each(var obj:Object in list)  //遍历数据源，向selArr数组添加状态selected=true(选中)的值
				{    
					if(obj.selected)
					{
						selectedStr += obj.label+this.splitStr;
					}        
				}
				if(_selectedLabel != selectedStr)
				{
					_selectedLabel = selectedStr;
					
					var _changeEvent:Event = new Event("selectedChange");
					dispatchEvent(_changeEvent);
				}
				if(flag)
				{
					textInput.text = selectedStr;
				}
			}
		}
			
		/**
		 * 获取选中项数组
		 */
		public function get selectedItems():Array
		{ 
			var list:ArrayCollection=ArrayCollection(this.dataProvider);
			var _seletedItems:Array=[];
			for each(var obj:Object in list)
			{    
				if(obj.selected)
				{
					_seletedItems.push(obj);
				}        
			}
			return _seletedItems;
		}
		/**
		 * @return 
		 */
		override public function get selectedLabel():String
		{
			return _selectedLabel;
		}
	}  
}
