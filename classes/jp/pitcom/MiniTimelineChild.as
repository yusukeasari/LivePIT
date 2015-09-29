package jp.pitcom{
	import flash.display.MovieClip;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
    import flash.display.LoaderInfo;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.net.*;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.BlendMode;
	import jp.pitcom.*;
	import caurina.transitions.Tweener;
	import flash.text.AntiAliasType;

	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	
	public class MiniTimelineChild extends ViewBClass{
		private var model:Object;
		private var tcmc:MovieClip;
		private var dataObj:Object;
		private var EVENT_1:String = "";
		private var EVENT_2:String = "onSearchForID";
		private var EVENT_3:String = "onTimelineLoaded";
		private var ILoader1:Loader;
		private var linfo:LoaderInfo;
		
		private var defPos:Number;
		
		public function MiniTimelineChild(_mc:MovieClip,_element:Object,_model:Object,_defPos){
			model=_model;
			dataObj = _element;
			defPos=_defPos;
			tcmc = new MiniTwitterWidgetChild_mc();
			//tcmc.newBadge.visible=false;
			//tcmc.nameText.text = dataObj.b1;
			//tcmc.messageText.text =dataObj.b2;
			tcmc = _mc.timelineChild.addChild(tcmc);
			model.setEvent(this,"miniActionEnd");
			super(tcmc);
			
			onStartLoad();
		}
		public function playNewBadge():void{
			Tweener.removeTweens(tcmc.newBadge);
			tcmc.newBadge.visible=true;
			tcmc.newBadge.gotoAndPlay("start");
		}
		
		public function onStartLoad(){
			model.setEvent(this,EVENT_3);
			//model.dumper(dataObj);
			
			imageLoad();
		}
		
		function imageLoad():void{
			ILoader1 = new Loader();
			
			linfo = ILoader1.contentLoaderInfo;

			linfo.addEventListener(Event.OPEN,imageLInfoOpen);		
			linfo.addEventListener(ProgressEvent.PROGRESS,imageLInfoProgress);
			linfo.addEventListener(Event.INIT,imageLInfoInit);
			linfo.addEventListener(Event.COMPLETE,imageLInfoComp);
			linfo.addEventListener(IOErrorEvent.IO_ERROR,imageLInfoIOError);
			var nowDate:Date = new Date();
			var ureq:URLRequest;
			if(model.srcData("isOnline") == true){
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg")+dataObj.img+'.jpg?'+Math.floor(Math.random()*1000));
			}else{
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg")+dataObj.img+'.jpg');
			}
			//trace(model.srcData("swfData")+model.srcData("blockImg")+dataObj.img+'.jpg');
			ILoader1.load(ureq);
		}
		
		private function searchButtonReleaseM(event:CEvent){
			
		}
		
		public function set defaultPositionX(x:Number){
			mc.x = x;
		}
		public function get defaultPositionX(){
			return mc.x;
		}
		public function set defaultPositionY(y:Number){
			tcmc.y = y;
		}
		public function get defaultPositionY(){
			return mc.y;
		}
		
		public function get defaultWidth(){
			return mc.width;
		}
		public function get defaultHeight(){
			return tcmc.height;
		}
		
		function imageLInfoOpen(event:Event){
			
		}
		function imageLInfoProgress(event:ProgressEvent){
		}
		function imageLInfoInit(event:Event){
			
		}
		function imageLInfoComp (event:Event){
			ILoader1.width=265/2;
			ILoader1.height=265/2;
			ILoader1.x -= ILoader1.width/2;
			ILoader1.y -= ILoader1.height/2;
			
			tcmc.imgLoad.addChild(ILoader1);
			
			dispatchEvent(new CEvent(EVENT_3,args));
			model.removeEvent(this,EVENT_3);
			mc.y = defY-20;
			fadeIN(1);
		}
		override public function fadeIN(_startTime:Number):void{
			
			Tweener.removeTweens(mc);
			Tweener.addTween(mc,{
							 time:0,
							 delay:0
							 });
			Tweener.addTween(mc,{_autoAlpha:0,time:0});

			vObj=new Timer(_startTime,0);
			vObj.addEventListener(TimerEvent.TIMER, fadeINM);
			vObj.start();
		}
		
		
		override protected function fadeINM(_timerDispatch):void{
			vObj.stop();
			if(args.eases==undefined){
				args.eases = "easeInOutQuart";
			}
			if(args.startTime==undefined){
				args.startTime = 1;
			}
			if(args.delayTime==undefined){
				args.delayTime = 1.4;
			}
			Tweener.removeTweens(mc);
			Tweener.addTween(mc,{x:defX,y:defY, transition:"easeOutBack",time:0.5,delay:args.delayTime});
			if(defPos != 0){
				if(model.srcData("timeline") == 'v'){
					defPos = mc.height*defPos;
					Tweener.addTween(mc,{_autoAlpha:1,y:defPos, transition:"easeInOutSine",time:0.5,delay:args.delayTime});
				}else{
					defPos = mc.width*defPos;
					Tweener.addTween(mc,{_autoAlpha:1,x:defPos, transition:"easeInOutSine",time:0.5,delay:args.delayTime});
				}
			}else{
				defPos=1;
				Tweener.addTween(mc,{_autoAlpha:1, transition:"easeInOutSine",time:0.5,delay:args.delayTime});
				Tweener.addTween(tcmc.newBadge,{time:0.5,delay:args.delayTime,onComplete:playNewBadge});
			}
			
				args.dtI=0.2;
		}
		
		private function newBadgeRemove():void {
			Tweener.removeTweens(tcmc.newBadge);
		}
		
		function imageLInfoIOError(event:IOErrorEvent) {
			
		}
		
		public function moveOut(){
			if(defPos != 0){
				//Tweener.addTween(tcmc.newBadge,{_autoAlpha:0,transition:"easeInOutSine",time:0.5,delay:args.delayTime,onComplete:newBadgeRemove});
			}
			if(model.srcData("timeline") == 'v'){
				Tweener.addTween(mc,{y:mc.height+mc.y,time:0.5,delay:1,transition:"easeinoutquad",onComplete:moveOutEnd});
			}else{
				Tweener.addTween(mc,{x:mc.width+mc.x,time:0.5,delay:1,transition:"easeinoutquad",onComplete:moveOutEnd});
			}		}
		private function moveOutEnd():void {
			dispatchEvent(new CEvent("miniActionEnd",args));
		}
		
		function remove():void{
			
			
			//disChildAll(tcmc);
			//removeChildAll(tcmc);
			
			if(ILoader1!=null){
				ILoader1.unload();
				ILoader1=null;
			}
			
			linfo.removeEventListener(Event.OPEN,imageLInfoOpen);		
			linfo.removeEventListener(ProgressEvent.PROGRESS,imageLInfoProgress);
			linfo.removeEventListener(Event.INIT,imageLInfoInit);
			linfo.removeEventListener(Event.COMPLETE,imageLInfoComp);
			linfo.removeEventListener(IOErrorEvent.IO_ERROR,imageLInfoIOError);
			
			//vObj.removeEventListener(TimerEvent.TIMER, fadeINM);
			//tcmc.button.buttonMode=false;
			//tcmc.removeEventListener(MouseEvent.CLICK,onClick);
			//tcmc.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			//tcmc.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			
			tcmc.parent.removeChild(tcmc);
			
			model.removeEvent(this,EVENT_3);
			model.removeEvent(this,"onSearchForID");
			
			model=null;
		}
		function getBytesTotal_code(_str:String):uint {
			var nCount:uint = 0;
			var nLength:int = _str.length;
			for (var i:uint = 0; i < nLength; i++) {
				var char_str:String = _str.charAt(i);
				var nCode:Number = char_str.charCodeAt(0);
				var bSingle:Boolean = (nCode < 0x7F) || (0xFF61 < nCode && nCode < 0xFF9F);
				nCount +=  bSingle ? 1 : 2;
			}
			return nCount;
		}
		
	}
}
