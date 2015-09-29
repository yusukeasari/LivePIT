/************************************************************
　Class McSMT 2009 Fossette,KawanoEichi
 ************************************************************/
package ws.fossette.PIT{
	import flash.display.MovieClip;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import ws.fossette.PIT.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	
	public class McSMT extends SuperView{
		public var stt:Object;
		public var defX:Number;
		public var defY:Number;
		public var defA:Number;
		public var defR:Number;
		public var defXr:Number;
		public var defYr:Number;
		public var defW:Number;
		public var defH:Number;
		
		function McSMT(_mc:MovieClip,_stt:Object=null){
			super();
			mc = _mc;
			if(_stt!=null){
				stt = _stt;
			}else{
				stt = new Object();
			}
			
			defA = mc.alpha;
			defX = mc.x;
			defY = mc.y;
			defR=mc.rotation;
			defXr = 1024/defX;
			defYr = 768/defY;
			defW = mc.width;
			defH=mc.height;
	
			if(stt.dA>0){
				mc.alpha = stt.dA;
			}else{
				mc.alpha = 0;
				mc.visible = false;
			}
			
		}
		protected function f1Mok():void{
			chaildMon();
		}
		protected function f2Mok():void{
			mc.visible = false;
		}
		public function fadeIN(_t1:Number):void{
			if(iid!=null){
				iid.stop();
			}
			mc.y = defY;
			mc.x = defX;
			mc.visible = true;
			
			iid=new Timer(_t1,0);
			iid.addEventListener(TimerEvent.TIMER, fadeINM);
			iid.start();
		}
		protected function fadeINM(_timerDispatch):void{
			iid.stop();
			if(stt.e1==undefined){
				stt.e1 = "easeInOutQuart";
			}
			if(stt.t1==undefined){
				stt.t1 = 1;
			}
			if(stt.dt1==undefined){
				stt.dt1 = 0;
			}
			Tweener.addTween(mc,{alpha:1, transition:stt.e1,time:stt.t1,delay:stt.dt1,onComplete:f1Mok});
		}
		public function fadeIN2(_t1:Number){
			chaildMoff();
			if(iid!=null){
				iid.stop();
			}
			
			iid=new Timer(_t1,0);
			iid.addEventListener(TimerEvent.TIMER, fadeINM2);
			iid.start();
		}
		public function chaildMoff():void{
			mc.mouseChildren = false;
			mc.mouseEnabled  = false;
		}
		public function chaildMon():void{
			mc.mouseChildren = true;
			mc.mouseEnabled  = true;
		}
		protected function fadeINM2(_timerDispatch){
			//clearInterval(iidMcSMT);
			iid.stop();
			if(stt.e2==undefined){
				stt.e2 = "easeInOutQuart";
			}
			if(stt.t2==undefined){
				stt.t2 = 1;
			}
			if(stt.dt2==undefined){
				stt.dt2 = 0;
			}
			Tweener.addTween(mc, {alpha:0, transition:stt.e2,time:stt.t2,delay:stt.dt2,onComplete:f2Mok});
		}
	}
}