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
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.BitmapFilterQuality;
	import jp.pitcom.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.MatrixShortcuts;
	
	import flash.external.ExternalInterface;
	
	public class PopupWindow3 extends ViewBClass{
		private var model:Object;
		private var ILoader1:Loader;
		private var imgCF:Boolean=false;
		private var imgS:int;
		private var defXI:Number;
		private var defYI:Number;
		private var rF:Boolean=false;
		private var newBadge:MovieClip;
		
		private var colorList:Array=['0xCC0033','0x993399','0x0066CC','0x006600','0xFF6600','0xFFFF00','0x66CCFF','0xFF3399','0x999999','0x66CC00'];
		
		private var linfo:LoaderInfo;
		private var mc2:MovieClip;
		
		private var popupMask:MovieClip = new MovieClip();
		private var backImage:MovieClip = new MovieClip();
		private var zoomImage:MovieClip = new MovieClip();
		private var windowArea:MovieClip;
		private var rupeImage:MovieClip;
		
		public function PopupWindow3(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			
			MatrixShortcuts.init();
			
			model = _model;
			//blendMode = BlendMode.LAYER;
			model.setEvent(this,"popupOpened");
			model.setEvent(this,"popupClosed");
			model.setEvent(this,"onSoundEffects");
			model.setEvent(this,"PopupWindow3_fadein");
			model.setEvent(this,"zoomIn2");
			
			var aa = Math.random()*3;
			mc["frame"].frm1.visible=false;
			mc["frame"].frm2.visible=false;
			mc["frame"].frm3.visible=false;
			if(aa>3){
				mc["frame"].frm1.visible=true;
			}else if(aa>2){
				mc["frame"].frm2.visible=true;
			}else{
				mc["frame"].frm3.visible=true;
			}

			
			imageLoad();
		}
		
		public function addBackImage(bitmap):void{
			
			//mc["windowArea"]["rupeImage"].addChild(bitmap);
			//bitmap.name="rupeImage";
			//mc["windowArea"]["rupeImage"]=bitmap;
			
		}
		
		private function imageLoad():void{
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
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg")+args.img+'.jpg?'+Math.floor(Math.random()*1000));
			}else{
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg")+args.img+'.jpg');
			}
			ILoader1.load(ureq);
		}
		private function imageLInfoOpen(event:Event){
			
		}
		private function imageLInfoProgress(event:ProgressEvent){
			
		}
		private function imageLInfoInit(event:Event){
			
		}
		private function imageLInfoComp (event:Event){
			//mc.popupMask.width=mc.popupMask.height=model.srcData("blockViewSize")*1.5;
			//mc["windowArea"]["zoomImage"].addChildAt(ILoader1, mc["windowArea"].numChildren - 1);
			
			ILoader1.content.width=ILoader1.content.height=360;
						
			
			mc["popupLoadPoint"].addChild(ILoader1);
			//mc["windowArea"]["zoomImage"].addChild(ILoader1);			
			
			
            var color:Number = 0x000000;
            var angle:Number = 45;
            var alpha:Number = 0.5;
            var blurX:Number = 15;
            var blurY:Number = 15;
            var distance:Number = 25;
            var strength:Number = 0.45;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;
			var filterdrop =	new DropShadowFilter(distance,
                                        angle,
                                        color,
                                        alpha,
                                        blurX,
                                        blurY,
                                        strength,
                                        quality,
                                        inner,
                                        knockout);
			
			//枠線適用
			mc.filters = [filterdrop];
			//trace("rupeImage:"+mc.rupeImage.width+":"+mc["zoomImage"].width+":"+ILoader1.x);
			
	/*		
Tweener.addTween(mc,{ 
time:0,
_global_x:900,
_global_y:500
});*/


			fadeIN(600);
		}
		private function imageLInfoComp2():void {
			
		}
		
		private function imageLInfoIOError(event:IOErrorEvent) {
			popupClose();
		}
		private function mStart():void{
			//mc.gotoAndPlay("start");
			dispatchEvent(new CEvent("zoomIn2",args));
			Tweener.removeTweens(mc);
			trace(args.xx+"/"+args.yy+"/"+args.numx);
			trace(mc.parent.x+"/"+mc.parent.y);
			Tweener.addTween(mc,{
							 //transition:args.eases,
							 x:args.xx-mc["popupLoadPoint"].x,
							 y:args.yy-mc["popupLoadPoint"].y,
							 rotation:0,
							 time:2,
							 onComplete:mStart2
							 });
			Tweener.addTween(mc["popupLoadPoint"],{
							 //transition:args.eases,
							 time:2,
							 width:args.blockWidth,
							 height:args.blockHeight
							 });
			Tweener.addTween(mc["frame"],{
							 //transition:args.eases,
							 alpha:0
							 });
			dispatchEvent(new CEvent("popupOpened",args));
			
			/*
			Tweener.addTween(mc.popupMask,{
							 scaleY:mc["popupMask"].scaleY*10,
							 scaleX:mc["popupMask"].scaleX*10,
							 
							 transition:"easeOutBounce",
							 time:0.5,
							 onComplete:mDisplayed
							 })
							 */
			
		}
		private function mStart2(){
			dispatchEvent(new CEvent("popupClosed",args));
			Tweener.addTween(mc,{
							 alpha:0,
							 transition:"easeOut",
							 time:1,
							 onComplete:fadeOUTM
							 });
		}
		private function etColor(inst:Object,color:uint):Function {
			return function (evt:MouseEvent):void{
				var colorTransform:ColorTransform = inst.transform.colorTransform;
				colorTransform.color = color;
				inst.transform.colorTransform = colorTransform;
			}
		}
		
		private function mDisplayed():void {
			//trace();
			//Tweener.removeTweens(mc.txt);
			if(args.rnd != 1){
				//args.sn = 'Glass';
				args.sn = 'Ping';
			}else{
				//args.sn = 'Pop';
				args.sn = 'Morse';
			}
			dispatchEvent(new CEvent("onSoundEffects",args));
			
			
			Tweener.removeTweens(mc["popupLoadPoint"]);
			if(args.rnd != 1){
			Tweener.addTween(mc.newBadge,{
							 alpha:1,
							 transition:"easeInOutQuart",
							 time:0.3,
							 onComplete:mDisplayed2
							 });
			
							args.num.substr(args.num.length-1,1);
							
							
							newBadge=new timelineNewBadge();
							mc.addChild(newBadge);
							newBadge.name="newBadge";
							mc["newBadge"]=newBadge;
							var n=args.id.substr(args.id.length-1,1);
							var co=colorList[n];
							trace(mc["newBadge"]["newBadge"]["base"]);
							var colorTransform:ColorTransform = mc["newBadge"]["newBadge"]["base"].transform.colorTransform;
							colorTransform.color = co;
							mc["newBadge"]["newBadge"]["base"].transform.colorTransform = colorTransform;
							
							
							//etColor(mc["newBadge"]["newBadge"]["base"],co);
							
							mc["newBadge"].scaleX=mc["newBadge"].scaleY=6;
				
							switch(args.cs.substr(0,1)){
								case "t":
									mc["newBadge"].y-=mc.height-(mc["newBadge"].height*0.7);
									break;
								
								case "b":
									mc["newBadge"].y=mc.height-(mc["newBadge"].height*0.7);
									break;
							}
							switch(args.cs.substr(1,1)){
								case "l":
									mc["newBadge"].x-=mc.width-(mc["newBadge"].width*0.7);
									break;
								case "r":
									mc["newBadge"].x=mc.width-(mc["newBadge"].width*0.7);
				
									break;
							}
				
							mc["newBadge"].gotoAndPlay("start");

			
			}
			Tweener.addTween(mc,{time:5,delay:0,onComplete:popupClose});
			

			
			dispatchEvent(new CEvent("popupOpened",args));
		}
		private function mDisplayed2():void {
			Tweener.removeTweens(mc.newBadge);
		}
		private function popupClose(){
			dispatchEvent(new CEvent("popupClosed",args));
			fadeOUT();
		}
		
		function remove():void{
			mc.filters = null;
			disChildAll(mc);
			removeChildAll(mc);

			mc.parent.removeChild(mc);
			Tweener.removeTweens(mc);
			
			if(ILoader1!=null){
				ILoader1.unload();
				ILoader1=null;
			}
			linfo.removeEventListener(Event.OPEN,imageLInfoOpen);		
			linfo.removeEventListener(ProgressEvent.PROGRESS,imageLInfoProgress);
			linfo.removeEventListener(Event.INIT,imageLInfoInit);
			linfo.removeEventListener(Event.COMPLETE,imageLInfoComp);
			linfo.removeEventListener(IOErrorEvent.IO_ERROR,imageLInfoIOError);
			
			vObj.removeEventListener(TimerEvent.TIMER, fadeINM);
			
			model.removeEvent(this,"PopupWindow3_fadein");
			model.removeEvent(this,"popupOpened");
			model.removeEvent(this,"popupClosed");
			model.removeEvent(this,"onSoundEffects");			
			model=null;
		}
		override protected function fadeOutC():void{
			remove();
		}
		
		
		override public function fadeIN(_startTime:Number):void{
			dispatchEvent(new CEvent("PopupWindow3_fadein",args));
			
			
			if(vObj!=null){
				vObj.stop();
			}
			
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
			mc.rotation=-30;

			Tweener.addTween([mc],{
				_scale:1,
							
_global_x:-900,
_global_y:900,
							 time:0							 });
							 
							 
			Tweener.addTween([mc],{
							 alpha:1,
_global_x:960,
_global_y:520,
							 transition:"easeInOutExpo",
							 rotation:0,
							 time:2,
							 delay:0
							 });
Tweener.addTween([mc],{
							_scale:1,
							 transition:"easeInOutBack",
							 time:2,
							 delay:0
							 });
							 
							 Tweener.addTween([mc],{
							 time:5,
							 delay:0,
							 onComplete:mStart
							 });
		}
		function fadeOUT():void {
			var ozy;
			var ozx;
			if(mc.popupMask.scaleY > 0 && mc.popupMask.scaleX < 0){
				ozy=-0.1;
				ozx=0.1;
			}else if(mc.popupMask.scaleY < 0 && mc.popupMask.scaleX > 0) {
				ozy=0.1;
				ozx=-0.1;
			}else{
				ozy=-0.1;
				ozx=-0.1;
			}
			Tweener.addTween(mc,{
							 alpha:0,
							 scaleY:mc.popupMask.scaleY*ozy,
							 scaleX:mc.popupMask.scaleX*ozx,
							 transition:"easeOut",
							 time:0.4,
							 onComplete:fadeOUTM
							 });
		}
		function fadeOUTM():void {
			remove();
		}
	}
}