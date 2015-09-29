package jp.pitcom{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.display.Shape;

	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.net.*;
	import flash.display.Loader;
    import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.BlendMode;
	import jp.pitcom.*;
	import caurina.transitions.Tweener;
	import flash.utils.ByteArray;
	import flash.utils.escapeMultiByte;

	//import jp.pitcom.asari.util.StageUtil;
	//import jp.pitcom.asari.util.Dumper;
	
	public class NewBadge extends ViewBClass{
		private var model:Object;
		
		function NewBadge(_mc:MovieClip,_model:Object,_args:Object=null){
			super(_mc,_args);
			model = _model;
			
			mc.alpha=1;
			mc.visible = true;
			var shape = new Shape();
			mc.addChild(shape);
			var g = shape.graphics;
			
			g.lineStyle (1, 0x000000, 1.0);	// 線のスタイル指定
			g.beginFill (0xFF0000, 1.0);	// 面のスタイル設定
			
			
			g.drawCircle  ( 100, 200 , 100);
			
		}
		
	}
}
