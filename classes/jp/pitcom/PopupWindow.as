package jp.pitcom{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
    import flash.display.LoaderInfo;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.BlendMode;
	import jp.pitcom.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.external.ExternalInterface;
	
	public class PopupWindow extends ViewBClass{
		private var model:Object;
		private var ILoader1:Loader;
		private var imgCF:Boolean=false;
		private var imgS:int;
		private var defXI:Number;
		private var defYI:Number;
		private var rF:Boolean=false;
		
		private var linfo:LoaderInfo;
		private var mc2:MovieClip;

		function PopupWindow(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			
			model = _model;
			blendMode = BlendMode.LAYER;
			mc.newBadge.alpha=0;
			mc.imgLoader.alpha=0;
			model.setEvent(this,"popupOpened");
			model.setEvent(this,"popupClosed");
			mc.rf.height=args.blockHeight;
			mc.rf.width=args.blockWidth;
			mc.rf.x=args.xx;
			mc.rf.y=args.yy;
			imageLoad();

		}
		
		private function imageLoad():void{
			ILoader1 = new Loader();
			fadeIN(0);
			linfo = ILoader1.contentLoaderInfo;
			
			linfo.addEventListener(Event.OPEN,imageLInfoOpen);		
			linfo.addEventListener(ProgressEvent.PROGRESS,imageLInfoProgress);
			linfo.addEventListener(Event.INIT,imageLInfoInit);
			linfo.addEventListener(Event.COMPLETE,imageLInfoComp);
			linfo.addEventListener(IOErrorEvent.IO_ERROR,imageLInfoIOError);
			
			var nowDate:Date = new Date();
			var ureq:URLRequest;
			if(model.srcData("isOnline") == true){
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg")+args.img+'.jpg?'+Math.floor(Math.random()*1000));
			}else{
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg")+args.img+'.jpg');
			}
			ILoader1.load(ureq);
		}
		function imageLInfoOpen(event:Event){
			
		}
		function imageLInfoProgress(event:ProgressEvent){
			
		}
		function imageLInfoInit(event:Event){
			
		}
		function imageLInfoComp (event:Event){
			mc.imgLoader.addChild(ILoader1);
			ILoader1.width=ILoader1.height=model.srcData("blockViewSize");
			//
			
			/*
			Tweener.addTween(mc2.cl,{_autoAlpha:0,transition:"easeInOutSine",time:0.5});

			if(!imgCF){
				imgCF=true;
			}
			ILoader1.width=ILoader1.height=model.srcData("blockViewSize");
			ILoader1.x = -ILoader1.width/2;
			ILoader1.y = -ILoader1.height/2;
			
			Tweener.addTween(mc2.imgtgt,{_brightness:0,transition:"easeInOutSine",time:0.5});
			mc2.imgtgt.addChild(ILoader1);

			dispatchEvent(new CEvent("onLoadComment",args));*/
			
		}
		function imageLInfoIOError(event:IOErrorEvent) {
			
		}
		private function mStart():void{
			mc.gotoAndPlay("start");
			Tweener.removeTweens(mc);
			/*
			Tweener.addTween(mc.txt,{
							 alpha:1,
							 transition:"easeInOutQuart",
							 time:0.7
							 });
							 */
			Tweener.addTween(mc.imgLoader,{
							 alpha:1,
							 transition:"easeInOutQuart",
							 time:0.7,
							 onComplete:mDisplayed
							 });
		}
		private function mDisplayed():void {
			//Tweener.removeTweens(mc.txt);
			Tweener.removeTweens(mc.imgLoader);
			if(args.rnd != 1){
			Tweener.addTween(mc.newBadge,{
							 alpha:1,
							 transition:"easeInOutQuart",
							 time:0.3,
							 onComplete:mDisplayed2
							 });
			
			}
			Tweener.addTween(mc,{time:5,delay:0,onComplete:popupClose});
			//dispatchEvent(new CEvent("popupOpened",args));
		}
		private function mDisplayed2():void {
			Tweener.removeTweens(mc.newBadge);
		}
		private function popupClose(){
			dispatchEvent(new CEvent("popupClosed",args));
			fadeOUT();
		}
		
		function remove():void{
			disChildAll(mc);
			removeChildAll(mc);

			mc.parent.removeChild(mc);
			
			if(ILoader1!=null){
				ILoader1.unload();
				ILoader1=null;
			}
			linfo.removeEventListener(Event.OPEN,imageLInfoOpen);		
			linfo.removeEventListener(ProgressEvent.PROGRESS,imageLInfoProgress);
			linfo.removeEventListener(Event.INIT,imageLInfoInit);
			linfo.removeEventListener(Event.COMPLETE,imageLInfoComp);
			linfo.removeEventListener(IOErrorEvent.IO_ERROR,imageLInfoIOError);
			
			model=null;
		}
		override protected function fadeOutC():void{
			remove();
		}
		
		
		override public function fadeIN(_startTime:Number):void{
			if(vObj!=null){
				vObj.stop();
			}
			mc.visible = true;
			mc.alpha =1;
						
			mc.visible = true;
			mc.alpha = 0;
			
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
				args.delayTime = 0;
			}
			Tweener.addTween([mc],{
							 alpha:1,
							 transition:args.eases,
							 time:1,
							 delay:args.delayTime,
							 onComplete:mStart
							 });

		}
		function fadeOUT():void {
			Tweener.addTween(mc,{
							 alpha:0,
							 transition:"easeInOutQuart",
							 time:1,
							 onComplete:fadeOUTM
							 });
		}
		function fadeOUTM():void {
			remove();
		}
	}
}