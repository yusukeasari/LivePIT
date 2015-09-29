/************************************************************
　Class PatLineMcSMT 2015 Fossette
 ************************************************************/
package ws.fossette.PIT{
	import ws.fossette.PIT.*;
	import flash.display.MovieClip;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.SplineModifiers;
	
	import idv.cjcat.stardust.common.clocks.SteadyClock;
	import idv.cjcat.stardust.common.initializers.Life;
	import idv.cjcat.stardust.common.initializers.Alpha;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.actions.Age;
	
	import idv.cjcat.stardust.common.actions.DeathLife;
	import idv.cjcat.stardust.common.actions.ScaleCurve;
	import idv.cjcat.stardust.common.actions.AlphaCurve;
	import idv.cjcat.stardust.common.initializers.Scale;
	import idv.cjcat.stardust.common.initializers.Mass;
	
	import idv.cjcat.stardust.twoD.handlers.DisplayObjectHandler;
	import idv.cjcat.stardust.twoD.initializers.DisplayObjectClass;
	import idv.cjcat.stardust.twoD.initializers.Position;
	import idv.cjcat.stardust.twoD.initializers.Velocity;
	import idv.cjcat.stardust.twoD.zones.LazySectorZone;
	import idv.cjcat.stardust.twoD.actions.Accelerate;
	import idv.cjcat.stardust.twoD.actions.*;
	
	import idv.cjcat.stardust.twoD.zones.SinglePoint;
	import idv.cjcat.stardust.twoD.emitters.Emitter2D;
	import idv.cjcat.stardust.twoD.actions.Move;
	import idv.cjcat.stardust.twoD.zones.SectorZone;
	import idv.cjcat.stardust.twoD.fields.UniformField;
	import idv.cjcat.stardust.twoD.zones.CircleZone;
	
	public class PatLine5McSMT extends McSMT{
		private var model:Object;
		private var nowOn:Boolean=false;
		
		private var container:Sprite;
		private var emitter:PointEmitter;
		//var emitter:Emitter2D;
		private var angle:Number = 0;
		private var speed:Number = 2;
		private var radian:Number = Math.PI/180;
		
		private var clock:SteadyClock;

		
		function PatLine5McSMT(_mc:MovieClip,_stt:Object=null){
			super(_mc,_stt);
			
			container = new Sprite();
			mc.addChild(container);
			
			
			stt.t2=0.5;
			SplineModifiers.init();
			CurveModifiers.init();
			container.x = 0;
			container.y = 0;
			
			Tweener.removeTweens(stt.kira);
			Tweener.addTween(stt.kira,{
						 _autoAlpha:0,
								  transition:"easeOutSine",
								  time:0,
								
								  delay:0});
			
			
			clock = new SteadyClock(1);
			
			emitter = new PointEmitter(clock);
			emitter.particleHandler = new DisplayObjectHandler(container);
			
			//emitter.addInitializer(new DisplayObjectClass(Circle));
			//emitter.addInitializer(new DisplayObjectClass(PixelParticle));
			if(Math.random()<0.5){
				emitter.addInitializer(new DisplayObjectClass(Drip2));
			}else{
				emitter.addInitializer(new DisplayObjectClass(Drip));
			}
			
			emitter.addInitializer(new Position(emitter.point));
			
			//emitter.addInitializer(new Velocity(new CircleZone(2, -0.5, 2)));
			emitter.addInitializer(new Velocity(new LazySectorZone(1,1)));
			
			// Life : パーティクルの生存値(アクションでAgeとDaethLifeを有効にする必要あり)
			//emitter.addInitializer(new Life(new UniformRandom(40, 3)));
			//emitter.addInitializer(new Life(new UniformRandom(60, 5)));
			emitter.addInitializer(new Life( new UniformRandom( 30 ,10 ) ) );
			
			emitter.addInitializer(new Scale(new UniformRandom(0.7, 0.1)));
			emitter.addInitializer(new Mass(new UniformRandom(1, 0.5)));
			
			emitter.addInitializer(new Alpha( new UniformRandom( 0.5, 0.1)));
			
			//emitter.addInitializer(new Alpha(new UniformRandom(0.5, 0)));
			
			/*
			
				Accelerate : 加速を有効化
				Damping : 減速を有効化
				
				DeathZone : パーティクルが死滅する領域を指定
				AbsoluteDrift : 動きのランダム方向を指定(雨粒のように左右にぶれるような動き)
				Oriented : Velocityに関係する回転運動を指定
			
			*/
			
			//Gravity : 重力の速度を有効化
			var gravity:Gravity = new Gravity();
			gravity.addField(new UniformField(-0.2, -0.1));
			emitter.addAction(gravity);
			/*
			
			Tweener.removeTweens(emitter.point);
			Tweener.addTween(emitter.point,{x:200,y:100,time:10,onUpdate :aaa});
			
			var aaab=0;
			function aaa(){
			aaab+=0.001;
			gravity.addField(new UniformField(-0.1+aaab, -0.1));
			emitter.addAction(gravity);
			}*/
			
			//Age : 寿命を有効化
			emitter.addAction(new Age());
			
			//DeathLife : 死滅を有効化
			emitter.addAction(new DeathLife());
			
			//Accelerate : 加速を有効化
			emitter.addAction(new Accelerate(0.1));
			
			//Move : 移動を有効化
			emitter.addAction(new Move(2));
			
			// ScaleCurve : スケール変化を有効化
			emitter.addAction(new ScaleCurve(5, 5));
			
			
			//AlphaCurve : 透明度変化を有効化
			emitter.addAction(new AlphaCurve(0, 10));
			
			/*
			var clock:SteadyClock = new SteadyClock(1);
			emitter = new Emitter2D(clock);
			emitter.particleHandler = new DisplayObjectHandler(container);
			emitter.addInitializer(new DisplayObjectClass(Circle));
			emitter.addInitializer(new Position(new SinglePoint(0, 0)));
			emitter.addInitializer(new Velocity(new LazySectorZone(1, 0)));
			emitter.addInitializer(new Life(new UniformRandom(40, 0)));
			emitter.addInitializer(new Alpha(new UniformRandom(1, 0)));
			emitter.addAction(new Age());
			emitter.addAction(new DeathLife());
			emitter.addAction(new Accelerate(0.2));
			emitter.addAction(new Move());
			emitter.addAction(new ScaleCurve(20, 10));
			emitter.addAction(new AlphaCurve(0, 10));
			//emitter.addInitializer(new Position(new SectorZone(0, 0, 50, 75, 135, 405)));
			emitter.addInitializer(new Position(new Line(-150, 0, 150, 0)));
			*/
			
		}
		
		override public function fadeIN(_t1:Number):void{
			nowOn=true;
			if(iid!=null){
				iid.stop();
			}
			mc.y = defY;
			mc.x = defX;
			

			iid=new Timer(_t1,0);
			iid.addEventListener(TimerEvent.TIMER, fadeINM);
			iid.start();
		}
		
		override protected function fadeINM(_timerDispatch):void{
			iid.stop();
			
			twdmy.x=-200;
			twdmy.y=-200;

			/*var tx = 172;
			var ty = 300;*/
			var tx = 1200;
			var ty = -200;
			var cptxy = getcptxy(new Point(twdmy.x,twdmy.y),new Point(tx,ty));
		
			Tweener.removeTweens(mc);
			Tweener.addTween(mc,{
						 _autoAlpha:1,
								  transition:"easeOutSine",
								  time:0,
								
								  delay:0});
		
			Tweener.removeTweens(twdmy);
			/*Tweener.addTween(twdmy, {
							 x:tx,
							 y: ty,
							//_bezier: {x:cptxy.x, y:cptxy.y},
							_bezier: {x:600, y:300},
							 
							 transition:"easeInOutSine",
												  time:2,
												  delay:0,
												  onComplete:f1Mok});*/
			twdmy.x=600;
			twdmy.y=1300;
			twdmy.x=-300;
			twdmy.y=1500;
			Tweener.addTween(twdmy, {
							 x:1500,
							 y:-600,
							 transition:"easeOutSine",
												  time:2,
												  delay:0,
												  onComplete:f1Mok});
			
			/*Tweener.addTween(twdmy,{
											 x:-200,
												y:300,
												  
						_spline:[
					{x:900+Math.random()*50,y:400+Math.random()*50},
					{x:700+Math.random()*50,y:400+Math.random()*50},
					{x:500+Math.random()*50,y:450+Math.random()*50},
					 {x:300+Math.random()*50,y:430+Math.random()*50},
					 {x:200+Math.random()*50,y:400+Math.random()*50}
			
					  ],
												 
												  transition:"easeOutSine",
												  time:1,
												  delay:0,
												  onComplete:f1Mok});*/
												  
			addEventListener(Event.ENTER_FRAME, patupdate, false, 0, true);
			
			Tweener.removeTweens(stt.kira);
			Tweener.addTween(stt.kira,{
						 _autoAlpha:1,
								  transition:"easeOutSine",
								  time:5,
								
								  delay:1});

		}
		override protected function f1Mok():void{
			chaildMon();
			
			
			fadeIN2(2000);
		}
		override protected function f2Mok():void{
			mc.visible = false;
			
			removeEventListener(Event.ENTER_FRAME, patupdate);
		}
		function patupdate(evt:Event):void {
	 	
			emitter.point.x =twdmy.x;
			emitter.point.y =twdmy.y;

					
			emitter.step();
		}
		
		function patupdate2(evt:Event):void {

			
			angle += speed;
			//_ball.x = _scx + _radius * Math.cos(radian);
			//_ball.y = _scy + _radius * Math.sin(radian);
			//
			 emitter.point.x = 150*Math.cos(angle*radian)+450;
			 emitter.point.y = 120*Math.sin(angle*radian*1.1)+400;
			 
			
			// emitter.point.x = 500*Math.sin(angle*radian*4)*Math.cos(angle*radian);
			// emitter.point.y = 100*Math.sin(angle*radian*4)*Math.sin(angle*radian);
			
			
			//emitter.point.x = 600*Math.sin(angle*radian*4)*Math.cos(angle*radian);
			//emitter.point.y = 50*Math.sin(angle*radian*4)*Math.sin(angle*radian);
		
			
			//emitter.point.x = 600*Math.sin(angle*radian*2)*Math.cos(angle*radian*2);
			//emitter.point.y = 200*Math.sin(angle*radian*1)*Math.cos(angle*radian*1);
		
			
			/**/
					
			emitter.step();
		}
		
		private function getcptxy(start:Point, end:Point):Point {
			var cxp:Point = Point.interpolate(start,end,0.5);
			var length:Number = Point.distance(start, end) / 2;
			var p1:Point = end.subtract(start);
			var r1:Number = Math.atan2(p1.y, p1.x);
			r1 += Math.PI / 2;
			var newps:Point = Point.polar(length, r1);
			newps = newps.add(cxp);
			var newpe:Point = Point.polar(-length, r1);
			newpe = newpe.add(cxp);
			return newps;
		}

	}
}