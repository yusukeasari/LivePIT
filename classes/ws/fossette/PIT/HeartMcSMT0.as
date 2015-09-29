package ws.fossette.PIT{
	import ws.fossette.PIT.*;
	
	import flash.geom.ColorTransform;
	import flash.display.*;
	import flash.events.Event;

	public class HeartMcSMT0 extends Bitmap
	{
		public var rot:int = 0;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var ax:Number = 0;
		public var ay:Number = 0;
		public var sc:Number = 2;
		public var num:uint = 0;
		
		//public static var bmdList:Array;

		function HeartMcSMT0( x:Number, y:Number,_num/*,_bmdList*/) {

			this.x = x;
			this.y = y;
			this.num = _num
			
			//bmdList=_bmdList;
			
			var cc:ColorTransform = new ColorTransform();
			cc.color = Math.random()*0x333333|0xFF0000;
			this.transform.colorTransform=cc;
			this.alpha = Math.random()*0.2+0.2;
			rot = Math.floor(Math.random()*360);
			sc = Math.max(2,Math.round(Math.random()*15));
			vx = Math.random()*15+2;
			vy = Math.random()*8;
			
			//addEventListener(Event.ENTER_FRAME,bgsnowmove);
		}

		public function set _bmp0(data){
			this.bitmapData = data;
		}
		
		function bgsnowmove(e:Event):void {
			/*	
			this.x += this.vx/(0.02*num+1)+0.3;
			this.y += 1.5/(0.02*num+1);
			this.rot++;
			
			 var rot = Math.round( this.rot % 360 )
			//this.bitmapData =  htbitmap[2][_rotation];
			this._bmp0= bmdList[this.sc][rot];

			if (this.y>1100||this.x>1300) {
				this.x = Math.random()*1200;
				this.y = -50;
			}*/

		}
	}
}
