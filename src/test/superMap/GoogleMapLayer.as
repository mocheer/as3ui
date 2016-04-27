package test.superMap
{
	import com.supermap.web.core.*;
	import com.supermap.web.mapping.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import mx.events.*;
	
	
	public class GoogleMapLayer extends TiledCachedLayer
	{
		private var _mapType:String;
		private var _mapTypeChanged:Boolean;
		
		private const MAPURL:String = "http://mt{subdomain}.google.cn/vt/lyrs=m@130&hl=zh-CN&gl=cn&{tileurl}&s={GALILEO}";
		//		private const SATELLITEURL:String = "http://mt{subdomain}.google.cn/vt/lyrs=s@102&gl=cn&{tileurl}&s={GALILEO}";
		//		private const SATELLITEURL:String = "http://khm{subdomain}.google.cn/kh/v=108&src=app&{tileurl}&s={GALILEO}";
		//		private const SATELLITEURL:String = "http://khm{subdomain}.google.cn/kh?v=128&hl=zh-CN&{tileurl}&s={GALILEO}";
		private const SATELLITEURL:String = "http://khm{subdomain}.google.cn/kh?v=138&hl=zh-CN&{tileurl}&s={GALILEO}";
		private const TERRAINURL:String = "http://mt{subdomain}.google.cn/vt/lyrs=t@130,r@207000000&hl=zh-CN&gl=cn&{tileurl}&s={GALILEO}";
		private const ANNOTATIONURL:String = "http://mt{subdomain}.google.cn/vt/imgtp=png32&lyrs=h@130&hl=zh-CN&gl=cn&{tileurl}&s={GALILEO}";
		private const TRAFFICURL:String = "http://mt{subdomain}.google.com/vt?hl=x-local&gl=cn&lyrs=m@130,traffic|seconds_into_week:-1&{tileurl}&style=15";
		
		public static const MAP_TYPE_MAP:String = "map";
		public static const MAP_TYPE_SATELLITE:String = "satellite";
		public static const MAP_TYPE_TERRAIN:String = "terrain";
		public static const MAP_TYPE_ANNOTATION:String = "annotation";
		
		public function GoogleMapLayer(mapType:String = MAP_TYPE_MAP)
		{
			this.bounds = new Rectangle2D(-20037508.3392, -20037508.3392, 20037508.3392, 20037508.3392);
			this.CRS = new CoordinateReferenceSystem(900913);
			this.buildTileInfo();
			this._mapType = mapType;
			setLoaded(true);
		}
		
		public function get mapType():String
		{
			return _mapType;
		}
		
		public function set mapType(value:String):void
		{
			var old_mapType:String = this.mapType;
			if (old_mapType !== value)
			{
				if (this._mapType != value)
				{
					this._mapType = value;
					this._mapTypeChanged = true;
					invalidateProperties();
				}
				if (this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mapType", old_mapType, value));
				}
			}
		}
		
		override protected function getTileURL(row:int, col:int, level:int) : URLRequest
		{
			var serverURL:String;
			var serverID:int;
			switch(this._mapType)
			{
				case MAP_TYPE_MAP:
					serverURL = MAPURL;
					serverID = Math.round(Math.random() * 3);
					break;
				case MAP_TYPE_SATELLITE:
					serverURL = SATELLITEURL;
					serverID = Math.round(Math.random() * 3);
					break;
				case MAP_TYPE_TERRAIN:
					serverURL = TERRAINURL;
					serverID = Math.round(Math.random() * 3);
					break;
				case MAP_TYPE_ANNOTATION:
					serverURL = ANNOTATIONURL;
					serverID = Math.round(Math.random() * 3);
					break;
				default:
					serverURL = MAPURL;
					break;
			}
			var tileUrl:String = "x=" + col + "&y=" + row + "&z=" + level;
			serverURL = serverURL.replace("{subdomain}", serverID);
			serverURL = serverURL.replace("{tileurl}", tileUrl);
			serverURL = serverURL.replace("{GALILEO}", "Galileo".substring(0,((3 * col + row) & 7)));
			
			trace(serverURL);
			return new URLRequest(serverURL);
			
		}
		
		override protected function commitProperties() : void
		{
			super.commitProperties();
			if (this._mapTypeChanged)
			{
				removeAllChildren();
				this._mapTypeChanged = false;
				invalidateLayer();
			}
		}
		
		private function buildTileInfo() : void
		{
			this.tileSize = 256;
			this.origin = new Point2D(-20037508.3392, 20037508.3392);
			this.resolutions = [
				156543.0339, 
				78271.51695, 
				39135.758475, 
				19567.8792375,
				9783.939619, 
				4891.969809, 
				2445.984905,
				1222.992452,  
				611.496226, 
				305.748113, 
				152.874057,
				76.437028, 
				38.218514,
				19.109257,
				9.554629, 
				4.777314,
				2.388657, 
				1.1943285,
				0.59716426, 
				0.298582139,
				0.1492910699, 
				0.0746455355, 
				0.0373227679     //0.037322767895
			];
		}
	}
}