package jp.pitcom{
	import jp.pitcom.*;
	import flash.display.MovieClip;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	
	public class ViewBClass extends SuperView{
		public var args:Object;
		public var defX:Number;
		public var defY:Number;
		public var defA:Number;
		public var defR:Number;
		public var defXr:Number;
		public var defYr:Number;
		public var defW:Number;
		public var defH:Number;
		
		function ViewBClass(_mc:MovieClip,_args:Object=null){
			super();
			
			mc = _mc;
			if(_args!=null){
				args = _args;
			}else{
				args = new Object();
			}
			
			CurveModifiers.init();
			ColorShortcuts.init();
			FilterShortcuts.init();
			DisplayShortcuts.init();
			
			defA = mc.alpha;
			defX = mc.x;
			defY = mc.y;
			defR=mc.rotation;
			defXr = 1024/defX;
			defYr = 768/defY;
			defW = mc.width;
			defH=mc.height;
	
			if(args.dA>0){
				mc.alpha = args.dA;
			}else{
				mc.alpha = 0;
				mc.visible = false;
			}
			
		}
		protected function fadeOutC():void{
			mc.visible = false;
		}
		public function fadeIN(_startTime:Number):void{
			if(vObj!=null){
				vObj.stop();
			}
			mc.y = defY;
			mc.x = defX;
			//mc.visible = true;
			
			vObj=new Timer(_startTime,0);
			vObj.addEventListener(TimerEvent.TIMER, fadeINM);
			vObj.start();
		}
		protected function fadeINM(_timerDispatch):void{
			vObj.stop();
			if(args._sc!=undefined){
				Tweener.addTween(mc,{_scale:args._sc,time:0,delay:0});
			}
			
			if(args.eases==undefined){
				args.eases = "easeInOutQuart";
			}
			if(args.startTime==undefined){
				args.startTime = 1;
			}
			if(args.delayTime==undefined){
				args.delayTime = 0;
			}
			if(args.ta==undefined){
				args.ta = 1;
			}
			Tweener.removeTweens(mc);
			Tweener.addTween(mc,{_autoAlpha:args.ta, transition:args.eases,time:args.startTime,delay:args.delayTime});
		}
		public function fadeIN2(_startTime:Number){
			if(vObj!=null){
				vObj.stop();
			}
			
			vObj=new Timer(_startTime,0);
			vObj.addEventListener(TimerEvent.TIMER, fadeINM2);
			vObj.start();
		}
		protected function fadeINM2(_timerDispatch){
			//clearInterval(vObjViewBClass);
			vObj.stop();
			if(args.e2==undefined){
				args.e2 = "easeInOutQuart";
			}
			if(args.t2==undefined){
				args.t2 = 1;
			}
			if(args.dt2==undefined){
				args.dt2 = 0;
			}
			Tweener.removeTweens(mc);
			Tweener.addTween(mc, {alpha:0, transition:args.e2,time:args.t2,delay:args.dt2,onComplete:fadeOutC});
		}
		function chkMcOn():Boolean{
			var a = mc.width/2;
			var b = mc.height/2
//			trace(mc.mouseX,mc.mouseY);
			if(mc.mouseX> -a && mc.mouseX<a && mc.mouseY> -b && mc.mouseY< b){
				return true;
			}else{
				return false;
			}
		}
	}
}