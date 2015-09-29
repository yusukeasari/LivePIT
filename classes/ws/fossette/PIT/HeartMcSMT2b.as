package ws.fossette.PIT{
	import ws.fossette.PIT.*;
	
	import flash.geom.ColorTransform;
	import flash.display.*;
	import flash.events.Event;

	public class HeartMcSMT2b
	{
		public var rot:int = 0;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var ax:Number = 0;
		public var ay:Number = 0;
		public var sc:Number = 2;
		public var x:Number = 0;
		public var y:Number = 0;
		public var alp:Number = 0;
		public var num:uint = 0;
		
		//public static var bmdList:Array;

		function HeartMcSMT2b( _x:Number, _y:Number,_num/*,_bmdList*/) {

			x=_x;
			y=_y;
			num = _num
			
			//bmdList=_bmdList;
			
			
			alp = Math.random()*0.2+0.2;
			rot = Math.floor(Math.random()*360);
			sc = Math.max(12,Math.round(Math.random()*25));
			//vx = Math.random()*15+2;
			vx = Math.random()*5+2;
			vy = Math.random()*6;
			
			//addEventListener(Event.ENTER_FRAME,bgsnowmove);
		}

	}
}
