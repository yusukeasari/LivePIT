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
	
	import flash.external.ExternalInterface;
	
	public class RequestPopup extends ViewBClass{
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
		private var delayTime;
		
		public function RequestPopup(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			
			model = _model;
			blendMode = BlendMode.LAYER;
			model.setEvent(this,"RequestLinePopupOpened");
			model.setEvent(this,"RequestLinePopupClosed");
			model.setEvent(this,"onSoundEffects");

			model.setEvent(this,"zoomInRequestLine2");
			mc["frame"]["comm"].text=args.b2;
			var myBitmap:BitmapData = new BitmapData(788.6, 150,true,0x000000);
			myBitmap.draw(mc["frame"]["comm"]);
			var bmp:Bitmap = new Bitmap(myBitmap);
			bmp.x = 139.6;
			bmp.y = 396.45;
			mc["frame"].addChild(bmp);
			mc["frame"]["comm"].visible=false;
			mc.alpha=0;
			delayTime=args.delayTime;
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

			ILoader1.content.width=ILoader1.content.height=260;
			mc["popupLoadPoint"].addChild(ILoader1);
			
			
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
			fadeIN(0);
		}
		private function imageLInfoComp2():void {
			
		}
		
		private function imageLInfoIOError(event:IOErrorEvent) {
			popupClose();
		}
		private function mStart():void{
			dispatchEvent(new CEvent("zoomInRequestLine2",args));
			Tweener.removeTweens(mc);
			Tweener.addTween(mc,{
							 //transition:args.eases,
							 time:2,
							 delay:delayTime,
							 onComplete:mStart2
							 });
			Tweener.addTween(mc["popupLoadPoint"],{
							 //transition:args.eases,
							 time:2
							 });
			dispatchEvent(new CEvent("RequestLinePopupOpened",args));
			
		}
		private function mStart2(){
			var path =model.srcData("coordData3");
			if(model.srcData("isOnline")){
				path = path + "?="+Math.floor(Math.random()*10000);
			}
			var req:URLRequest = new URLRequest();
			req.url = path;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT; //返ってくるのはText
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.load(req);


			Tweener.addTween(mc,{
							 alpha:0,
							 transition:"easeOut",
							 time:2,
							 onComplete:fadeOUTM
							 });
			Tweener.addTween(mc.frame,{
							 alpha:0,
							 transition:"easeOut",
							 time:2
							 });
		}

		private function ioErrorHandler(err:*){

		}
		private function loaderCompleteHandler(err:*){

		}

		private function etColor(inst:Object,color:uint):Function {
			return function (evt:MouseEvent):void{
				var colorTransform:ColorTransform = inst.transform.colorTransform;
				colorTransform.color = color;
				inst.transform.colorTransform = colorTransform;
			}
		}

		private function popupClose(){
			//dispatchEvent(new CEvent("linePopupClosed",args));
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
			
			model.removeEvent(this,"RequestLinePopupOpened");
			model.removeEvent(this,"RequestLinePopupClosed");
			model.removeEvent(this,"onSoundEffects");	
			model.removeEvent(this,"zoomInRequestLine2");

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
			mc.alpha = 0;
			
			vObj=new Timer(_startTime,0);
			vObj.addEventListener(TimerEvent.TIMER, fadeINM);
			vObj.start();
		}
		override protected function fadeINM(_timerDispatch):void{

			vObj.stop();
			vObj.removeEventListener(TimerEvent.TIMER, fadeINM);
			Tweener.addTween(mc,{
							 alpha:1,
							 //transition:args.eases,
							 time:3,
							 onComplete:mStart
							 });
			var args={};
			args.sn = 'Submarine';
			dispatchEvent(new CEvent("onSoundEffects",args));

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
			
			args.rnd=0;
			dispatchEvent(new CEvent("RequestLinePopupClosed",args));
			remove();
		}
	}
}