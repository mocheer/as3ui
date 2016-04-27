package as3ui.dn.control.delegate
{
	import flash.events.Event;

	/**
	 * @author gyb
	 * @date：2015-1-8 上午09:33:50
	 * 事件处理方法传参委托类，方便在不改变原有机制下添加新的功能。
	 */
	public class HandlerDelegate
	{
		/**常用与事件处理过程中的参数传递*/
		public static function call(applyFunc:Function,...params):Function
		{
			var _callFunc:Function = function (event:Event):void 
			{
				var _params:Array = [];
				applyFunc.apply(null,_params.concat(event,params));
			};
			return _callFunc; 
		}

	}
}

