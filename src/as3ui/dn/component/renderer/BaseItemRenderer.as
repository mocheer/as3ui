package as3ui.dn.component.renderer
{
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.ILayoutManagerClient;
	import mx.styles.IStyleClient;
	/**
	 * @author gyb
	 * @date：2015-3-9 下午02:17:23
	 * 列表render基类，任何render都可以继承该类
	 */
	public class BaseItemRenderer extends UIComponent implements IDataRenderer,IDropInListItemRenderer, ILayoutManagerClient,IListItemRenderer, IStyleClient
	{
		//==================================================属性及构造函数================================================
		{
			/**由 IDataRenderer 接口定义的 data 属性实现 */
			private var _data:Object;
			/**由 IDropInListItemRenderer 接口定义的 listData 属性实现*/
			private var _listData:BaseListData;

			public function BaseItemRenderer()
			{
				super();
			}
		}
		//===================================================Getter/Setter================================================
		public function set data(value:Object):void
		{
			_data = value ;
			invalidateProperties();
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		[Bindable("dataChange")]
		public function get data():Object
		{
			return _data ;
		}
		
		[Bindable("dataChange")]
		public function get listData():BaseListData
		{
			return _listData;
		}
		public function set listData(value:BaseListData):void
		{
			_listData = value;
		}
		//=====================================================事件处理=====================================================
		
		//=======================================================方法=====================================================
		/**
			public function getGridInfo():void
			{
				
				//获取绑定字段
				var dataField:String = (this.listData as DataGridListData).dataField
				//获取列索引和行索引
				var columnIndex:int = this.listData.columnIndex;
				var rowIndex:int = this.listData.rowIndex;
				//获取表格
				var datagrid:DataGrid = this.listData.owner as DataGrid; 
				//获取该render要显示的值
				var str:String = this.listData.label;
				
			}
		 */
	}
}

