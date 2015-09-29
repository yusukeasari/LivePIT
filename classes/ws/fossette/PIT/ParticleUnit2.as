package ws.fossette.PIT
	
{
	import flash.display.Sprite;
	import flash.events.Event;
	import ws.fossette.PIT.*;
	import flash.geom.ColorTransform;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import flash.display.MovieClip;

	public class ParticleUnit2 extends Sprite
	{
		public var nx:Number,ny:Number,vx:Number,vy:Number;
		private var cnt:uint = 0;
		public var mySize:Number;
		public var friction:Number = 0.99;
		public var vectx:Number = -0.1;
		public var vecty:Number = -0.1;
		public var xrandom:Number = 0.2;
		public var yrandom:Number = 0.3;
		public var myNum:Number;
		
		private var baseR:Number = 105; 
		private var baseG:Number = 55;
		private var baseB:Number = 25;
		private var model:Object;
		private var stt:Object;

		
		private var dmy:MovieClip = new MovieClip();
		
		public function ParticleUnit2(n:Number, _vx:Number, _vy:Number, mn:Number,_nx:Number,_ny:Number,_stt:Object=null)
		{
			super();
			stt = _stt;

			myNum = n;
			vx = _vx;
			vy = _vy;
			nx = _nx;
			ny = _ny;
		
			if(stt.md==2){
				mySize = Math.random()*20;
				vectx = Math.random()*0.2;//-0.1;
				vecty = Math.random()*-0.2;//-0.1;
				xrandom = Math.random()*0.4;
				yrandom = Math.random()*0.6;
				friction  =0.92;
			}else{
				mySize = Math.random()*30;
				vectx = Math.random()*0.2;//-0.1;
				vecty = Math.random()*0.2-0.1;
				xrandom = Math.random()*0.4-0.2;
				yrandom = Math.random()*0.6-0.3;
				friction  =0.95;
			}
			setCircle(); 
			
			baseR = Math.random()*255;
			baseG = Math.random()*255;
			baseB = Math.random()*255;
			//_init();
			addEventListener(Event.ADDED_TO_STAGE, _addStage );
		}
		
		private function _addStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _addStage );
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			
			Tweener.addTween(this,{alpha:0,transition:"easeInOutQuart",time:5,delay:0.5,onComplete:f1Mok});
		}
		private function setCircle():void 
		{
			this.graphics.beginFill(Math.random()*0x222222|stt.col,1);
			this.graphics.drawCircle(0, 0, mySize);
			this.graphics.endFill();
			this.alpha = 0;
			//this.alpha = Math.random()*0.2;
			Tweener.addTween(this,{alpha:Math.random()*0.2,transition:"easeInOutQuart",time:0.5,delay:0});
			//this.transform.colorTransform =  new ColorTransform(1,1,1,1,baseR,baseG,baseB,1);
		}
		private function _init():void
		{
			nx = ny = 0;
		}

		private function brownMove():void
		{
			vx += Math.random()*xrandom + vectx;
			vy += Math.random()*yrandom + vecty;
			nx += vx;
			ny += vy;
			vx *= friction;
			vy *= friction;
		}
		function f1Mok():void{
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			this.graphics.clear();
			this.parent.removeChild(this);

		}
		public function _onEnterFrame(e:Event=null):void
		{
			brownMove();

			this.x = nx;
			this.y = ny;
		}
		
	}
}