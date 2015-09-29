package jp.pitcom{
	import jp.pitcom.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	
	import flash.media.Camera;
	import flash.media.Video;	
	
	import flash.display.MovieClip;	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;	
	
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	import flash.net.*;
	
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	
	import com.adobe.images.JPGEncoder;	
	import flash.external.ExternalInterface;	
	import flash.display.Stage;
	
	public class ExpoCamera extends ViewBClass{
		private var video:Video;
		private var videoScreen:Camera;
		private var screen:MovieClip;
		private var model:Object;
		//private var p:Particle;
		
		private var CameraSizeX:int = 0;
		private var CameraSizeY:int = 0;
		//private var CameraSizeX:int = 250;
		//private var CameraSizeY:int = 250;
		private var bmdPerlin:BitmapData;
		//private var shutterImg:Bitmap;
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		private var phpPath:String = "http://d.pitcom.jp/pittest4/uploadSend.php";
		private var x_stage:Stage;
		
		public function ExpoCamera(_mc:MovieClip,_model:Object,_args:Object=null) {
			// constructor code
			super(_mc,_args);// 親クラスの変数を使えるようにする
			
			model=_model;
			x_stage = model.mstage;
			
			//x_stage.quality = "HIGH";
			this.screen = mc;
			this.MyCamera();
			
			//x_stage.addEventListener(KeyboardEvent.KEY_DOWN, Shatter);			
			x_stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
		}
		
		public function MyCamera()
		{
			// カメラソースを取得
			this.videoScreen = Camera.getCamera();
			this.videoScreen.setQuality(10240,100);//setQuality(bandwidth:int,quality:int)
			this.videoScreen.setMode(1920,1080,80); //setMode(width:int,height:int,fps:Number)P.450

			// 表示処理
			if (this.videoScreen != null)
			{
				// ビデオオブジェクト配置：サイズ指定
				this.video = new Video(462,260);
				this.video.x=0;
				this.video.y=0;
				
				// カメラ設定
				this.video.attachCamera( this.videoScreen );
				screen.camera.addChild( this.video );
				
				//縦・横・座標を調整
				screen.camera.x -= screen.camera.width/2;
				screen.camera.y -= screen.camera.height/2;
				
				screen.camera.mask = screen.cameraMask; //マスク処理
				screen.shatter_mc.mask = screen.cameraMask2;
				
			}
			else
			{
				// カメラが接続されてない
			}
		}
		
		private function onUpload(event:Event):void
		{
			//ExternalInterface.call('setMessage');
			//fileName = urlLoader.data;
			//this.MyCamera();
			x_stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown); //2度目以降のキーイベント呼び出し
			trace("onUpload");			
		}
		
		private function upload():void
		{
			trace("upload");			
			var jpgEncoder:JPGEncoder = new JPGEncoder(80);
			var byteArr:ByteArray = jpgEncoder.encode(bmdPerlin);
			urlRequest = new URLRequest(phpPath);
			urlLoader = new URLLoader();
			urlRequest.contentType = "application/octet-stream";
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = byteArr;
			urlLoader.load(urlRequest);
			//urlLoader.addEventListener(Event.COMPLETE,onUpload);
			
			//var timerObj:Timer = new Timer(model.srcData("reshotTime")*1000, 1);
			var timerObj:Timer = new Timer(5000, 1);
			timerObj.addEventListener(TimerEvent.TIMER, onUpload);//model.srcData("reshotTime")秒後onUpload呼び出し
			timerObj.start();
			trace("upload");
		}

		private function clipBitmap( source:BitmapData, x:Number, y:Number, w:Number, h:Number ):BitmapData {
			//	切り抜き用の矩形
			var clipRect:Rectangle = new Rectangle( 0, 0, w, h );
			//	切り抜き位置調整用のマトリックス
			var clipMatrix:Matrix = new Matrix();
			//	切り抜き位置をマイナスにずらす
			//clipMatrix.translate( -x, -y );
			//	切り抜き後のビットマップデータ
			var clipBmp:BitmapData = new BitmapData( w, h );
			//	オリジナル画像をクリッピング情報を元にdraw()
			clipBmp.draw( source, clipMatrix, new ColorTransform(), null, clipRect );
			return clipBmp;
		}

		private function onClick():void
		{
			x_stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			
			var s:BitmapData = new BitmapData(screen.camera.width,screen.camera.height);
			s.draw(this.video);
			var m:BitmapData = clipBitmap( s, screen.camera.x, screen.camera.y, screen.camera.width, screen.camera.height);
			s.dispose();

			bmdPerlin = m;

			this.upload();
		}

        private function KeyDown(e:KeyboardEvent):void {
				trace("KeyDown");            
			if(e.keyCode == 49){//keycode:49は「1」
				//loading.visible=true;
				
				screen.shatter_mc.gotoAndPlay(2);
				x_stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
				
				this.onClick();
				
				trace("KeyDown");
			}
        }
	}
}
