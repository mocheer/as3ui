package as3ui.dn.component.menu
{
	import flash.display.Sprite;
	import mx.utils.NameUtil;
	
	[Event(name="rightClick",type="flash.events.MouseEvent")]
	/**
	 * @author gyb
	 * @date：2015-1-19 上午10:10:40
	 */
	public dynamic class RightClickRegister extends Sprite
	{
		//====================================================事件类型====================================================
		
		//==================================================属性及构造函数================================================
		private var rightClickRegisted:Boolean = false;
		public function RightClickRegister()
		{
			if (!rightClickRegisted)
			{
				RightClickManager.regist();
				rightClickRegisted = true;
			}
			try
			{
				name = NameUtil.createUniqueName(this);
			}
			catch (e:Error)
			{
			}
			return;
		}
		//===================================================Getter/Setter================================================
		
		//=====================================================事件处理=====================================================
		
		//=======================================================方法=====================================================
		public override function toString():String
		{
			return NameUtil.displayObjectToString(this);
		}
	}
}

