package jp.pitcom{
	import flash.utils.Timer;
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.system.ApplicationDomain;
	import jp.pitcom.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	
	public class Telop extends ViewBClass{
		private var model:Object;
		private var ILoader1:Loader;
		//ColorShortcuts.init();
		
		private var _bg:Sprite;
		private var _mask:Sprite;
		private var _titleTxt:TextField;
		private var _titleTf:TextFormat;
		private var _speed:int = 6;
		private var _sideMargin:int = 0;
		private var _textRightEdge:Number;
		private var _textList:Array = [];
		private var _textIndex:int = 0;		
		//private var linfo:LoaderInfo;

		public function Telop(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			
			model = _model;
			model.addEventListener("loadCompM",loadCompM);


		}
		private function loadCompM(evt:CEvent):void {
			var data = model.srcData("telop");
			trace(data[0]+"///"+data[1]+"///"+data[2]);
			init();
		}
		public function init():void {
			_bg = new Sprite();
			_bg.graphics.beginFill( 0x000000 );
			_bg.graphics.drawRect( -10, 0, 1940, 63 );
			mc.addChild( _bg );
			_bg.alpha = 0.6;
			
			//var FontLibrary:Class = ApplicationDomain.currentDomain.getDefinition("HiraginoKakugo7") as Class;
			//var f = FontLibrary;//model.fonts;
			_titleTxt = new TextField();
			_titleTxt.x = _sideMargin;
			_titleTxt.y = 3;
			_titleTxt.width = _bg.width - _sideMargin * 2;
			_titleTxt.width = _bg.width;
			_titleTxt.selectable = false;
			_titleTxt.autoSize = TextFieldAutoSize.NONE;
			
			//_titleTf = new TextFormat("_ゴシック",52,0xffffff,true);
			_titleTf = new TextFormat();
			_titleTf.size = 52;
			_titleTf.color = 0xffffff;
			_titleTf.font = new HiraginoKakugo7().fontName;
			//trace("FONT_NAME:"+f.fontName);
			_titleTf.align = TextFormatAlign.CENTER;
			
			_titleTxt.embedFonts=true;
			_titleTxt.antiAliasType = AntiAliasType.ADVANCED;
			//_titleTxt.setTextFormat(_titleTf);
			_titleTxt.defaultTextFormat = _titleTf;
			
			mc.addChild( _titleTxt );
			
			//addEventListener( MouseEvent.ROLL_OVER, rollOverHandler );
			//addEventListener( MouseEvent.ROLL_OUT, rollOutHandler );
			buttonMode = true;
			_textList = model.srcData("telop");
			//_textList.push( "クリックでテキスト変更" )
			//_textList.push( "魅力的なインタラクティブコンテンツを作成するための業界スタンダードのオーサリング環境。それがAdobe® Flash® CS4 Professionalです。" )
			//_textList.push( "Lorem ipsum dolor sit amet, consectetur adipisicing elit" )
			
			clickHandler(new MouseEvent("CLICK"));
		}
				
		public function setText( value:String ):void {
			trace("VAL:"+value);
			_titleTxt.text = value;
			if ( _titleTxt.textWidth > _bg.width - _sideMargin * 2 ) {
				_titleTxt.autoSize = TextFieldAutoSize.LEFT;
				//addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
				//addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
				_textRightEdge = _titleTxt.width - _bg.width + _sideMargin+1980;
			} else {
				//if( hasEventListener( MouseEvent.MOUSE_OVER ) ) removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
				//if( hasEventListener( MouseEvent.MOUSE_OUT ) ) removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
				_titleTxt.autoSize = TextFieldAutoSize.NONE;
				_titleTxt.width = _bg.width - _sideMargin * 2 - 4;
				_titleTxt.x = _sideMargin;
			}
			//clickHandler(new MouseEvent("CLICK"));
			//addEventListener( MouseEvent.CLICK, clickHandler );
			Tweener.removeTweens(mc);
			Tweener.addTween(mc,{
							 y:1020,
							 transition:args.eases,
							 time:1,
							 delay:2,
							 onComplete:motionStart
							 });
		}
		
		private function motionStart(){
			Tweener.removeTweens(mc);
			removeEventListener( Event.ENTER_FRAME, marqueeHandler );
			addEventListener( Event.ENTER_FRAME, marqueeHandler );
		}
		
		override protected function fadeOutC():void{
			remove();
		}
		
		function remove():void{
			//mc.filters = null;
			//disChildAll(mc);
			//removeChildAll(mc);

			//mc.parent.removeChild(mc);
			//Tweener.removeTweens(mc);
			/*
			if(ILoader1!=null){
				ILoader1.unload();
				ILoader1=null;
			}*/
			//linfo.removeEventListener(Event.OPEN,imageLInfoOpen);		

			
			//model.removeEvent(this,"popupOpened");

			model=null;
		}
		
		private function clickHandler( e:MouseEvent ):void {
			_textIndex = ( _textIndex == _textList.length - 1 ) ? 0 : ++_textIndex;
			setText( _textList[ _textIndex ] );
			//mouseOutHandler();
		}
		private function marqueeHandler( e:Event ):void {
			if ( _titleTxt.x > -_textRightEdge ) {
				_titleTxt.x -= _speed;
			}else{
			trace("ENDDDDDDDDDD111");
				removeEventListener( Event.ENTER_FRAME, marqueeHandler );
				Tweener.removeTweens(mc);
				Tweener.addTween(mc,{
								 y:1080,
								 time:1,
								 delay:1,
								 onComplete:motionEnd
								 });
			}
		}
		private function motionEnd(){
			trace("ENDDDDDDDDDD2");
			_titleTxt.x = _sideMargin;
			clickHandler(new MouseEvent("CLICK"));
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
							 delay:args.delayTime//,
							 //onComplete:mStart
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