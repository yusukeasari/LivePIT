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
	import flash.geom.Point;
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
	import caurina.transitions.properties.MatrixShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.external.ExternalInterface;
	
	public class PopupWindow2 extends ViewBClass{
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

		function PopupWindow2(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			
			//popup mc //popupMc
			windowArea=new MovieClip();
			mc.addChild(windowArea);
			windowArea.name="windowArea";
			mc["windowArea"]=windowArea;
			
			backImage=new MovieClip();
			mc["windowArea"].addChild(backImage);
			backImage.name="backImage";
			mc["windowArea"]["backImage"]=backImage;
			
			rupeImage=new MovieClip();
			mc["windowArea"].addChild(zoomImage);
			rupeImage.name="rupeImage";
			mc["windowArea"]["rupeImage"]=zoomImage;
			
			//new badge //newBadge
			zoomImage=new MovieClip();
			mc["windowArea"].addChild(zoomImage);
			zoomImage.name="zoomImage";
			mc["windowArea"]["zoomImage"]=zoomImage;
			
			MatrixShortcuts.init();
			
			model = _model;
			blendMode = BlendMode.LAYER;
			model.setEvent(this,"popupOpened");
			model.setEvent(this,"popupClosed");
			model.setEvent(this,"onSoundEffects");
			imageLoad();
			
			
		}
		
		public function addBackImage(bitmap):void{
			
			mc["windowArea"]["rupeImage"].addChild(bitmap);
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
				//ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg2")+args.img+'.jpg?'+Math.floor(Math.random()*1000));
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg2")+args.img+'.jpg');
			}else{
				ureq = new URLRequest(model.srcData("swfData")+model.srcData("blockImg2")+args.img+'.jpg');
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
			mc.popupMask.width=mc.popupMask.height=model.srcData("blockViewSize")*1.5;
			//mc["windowArea"]["zoomImage"].addChildAt(ILoader1, mc["windowArea"].numChildren - 1);
			mc["windowArea"]["zoomImage"].addChild(ILoader1);
			ILoader1.width=ILoader1.height=model.srcData("blockViewSize")*1.5/2;
			
			//スムージングプロパティ
			var bmp = Bitmap(ILoader1.content);
			bmp.smoothing = true;

			if(args.cs.substr(0,1) == "b"){
				ILoader1.y=model.srcData("blockViewSize")*1.5/4;
			}else{
				mc["windowArea"].rupeImage.y-=model.srcData("blockViewSize")*1.5;
				ILoader1.y-=model.srcData("blockViewSize")*1.5*0.75;
			}
			if(args.cs.substr(1,1) == "r"){
				ILoader1.x=model.srcData("blockViewSize")*1.5/4;
			}else{
				mc["windowArea"].rupeImage.x=model.srcData("blockViewSize")*1.5*-1;
				ILoader1.x-=model.srcData("blockViewSize")*1.5*0.75;
			}
			
			mc.windowArea.mask=mc.popupMask;
			
			if(args.cs.substr(0,1) == "b"){
				mc["popupMask"].scaleY *=-0.1;
			}else{
				mc["popupMask"].scaleY *=0.1;
			}
			if(args.cs.substr(1,1) == "r"){
				mc["popupMask"].scaleX *=0.1;
			}else{
				mc["popupMask"].scaleX *=-0.1;
			}
			
			var n=Math.floor(Math.random() * colorList.length );
			var co=colorList[n];
			var c:uint=0xFFFFFF;
			var a:Number=1;
			var bX:Number=6;
			var bY:Number=6;
			var st:Number=10;
			var filterglow:GlowFilter=new GlowFilter(c,a,bX,bY,st);
			
			
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
			mc["windowArea"].filters = [filterglow,filterdrop];
			//trace("rupeImage:"+mc.rupeImage.width+":"+mc["zoomImage"].width+":"+ILoader1.x);
			
			
			if(args.cs.substr(0,1) == "b"){
			Tweener.addTween([mc],{
			_scale:2.5,
							
_global_x:1900,
_global_y:1000,
				//rotation:360,
				rotationZ:Math.random()*-360,
							 time:0							 });
						 }else{
			Tweener.addTween([mc],{
				_scale:2.5,
							
_global_x:1900,
_global_y:1000,
				//rotation:360,
				rotationZ:Math.random()*360,
							 time:0							 });						 
						 }
			Tweener.addTween(mc.popupMask,{
							 scaleY:mc["popupMask"].scaleY*10,
							 scaleX:mc["popupMask"].scaleX*10,
							 
							 transition:"easeOutBounce",
							 time:0
							 })
			fadeIN(0);
		}
		function imageLInfoComp2():void {
			
		}
		
		function imageLInfoIOError(event:IOErrorEvent) {
			popupClose();

			//sysmex
			dispatchEvent(new CEvent("popupOpened",args));
			//throw new ArgumentError("popup blockimg2取得失敗:"+event.text);
		}
		private function mStart():void{
			//mc.gotoAndPlay("start");
			Tweener.removeTweens(mc);
			
			Tweener.addTween(mc.popupMask,{
							/* scaleY:mc["popupMask"].scaleY*10,
							 scaleX:mc["popupMask"].scaleX*10,
							 
							 transition:"easeOutBounce",*/
							 time:0.5,
							 onComplete:mDisplayed
							 })
			
		}
		function etColor(inst:Object,color:uint):Function {
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
			
			
			Tweener.removeTweens(mc["windowArea"]["zoomImage"]);
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
			Tweener.addTween(mc,{time:3,delay:0,onComplete:popupClose});
			

			
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
			mc["windowArea"].filters = null;
			disChildAll(mc);
			removeChildAll(mc);
			
			Tweener.removeTweens(mc);
			
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
			
			vObj.removeEventListener(TimerEvent.TIMER, fadeINM);
			
			model.removeEvent(this,"popupOpened");
			model.removeEvent(this,"popupClosed");
			model.removeEvent(this,"onSoundEffects");			
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
							 transition:"easeOutSine",
	
				rotation:0,
	rotationY:0,
							 time:1,
							 delay:args.delayTime
							 });
							 
var tx = args.xx0;
var ty = args.yy0;
var cptxy = getcptxy(new Point(mc.x,mc.y),new Point(tx,ty));
							 
			Tweener.addTween([mc],{

x:tx, y:ty,_bezier:[{x: cptxy.x, y: cptxy.y}],
							 transition:"easeOutBack",

							 time:1,
							 delay:args.delayTime
							 });
Tweener.addTween([mc],{
							_scale:1,
	
							 transition:"easeInOutBack",
							 time:1,
							  delay:args.delayTime
							 });
			Tweener.addTween([mc],{
							 alpha:1,
							 transition:args.eases,
							 time:1,
							 delay:args.delayTime,
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
			
			Tweener.addTween([mc],{
_autoAlpha:0,
x:args.xx0,
y:args.yy0-200,
							 transition:"easeOutSine",

							 time:0.5,
							 delay:args.delayTime
							 });
Tweener.addTween([mc],{
							_scale:1.2,
	
							 transition:"easeOutSine",
							 time:0.5,
							  delay:args.delayTime,
	onComplete:fadeOUTM
							 });			
			
			
			/*Tweener.addTween(mc,{
							 alpha:0,
							 scaleY:mc.popupMask.scaleY*ozy,
							 scaleX:mc.popupMask.scaleX*ozx,
							 transition:"easeOut",
							 time:0.4,
							 onComplete:fadeOUTM
							 });*/
		}
		function fadeOUTM():void {
			remove();
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
			return newpe;
}
	}
}