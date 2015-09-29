package caurina.transitions.properties {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import caurina.transitions.Tweener;
	
	/**
	 *
	 * @author		@24
	 * @version	2009.06.06
	 * 
	 */

	public class MosaicShortcuts
	{
		/**
		 * Initialization method.
		 * This method register some special properties to the Tweener.
		 */
		public static function init():void
		{
			Tweener.registerSpecialProperty( "_mosaic" , _mosaic_get , _mosaic_set );
		}
		
		/**
		 * Returns the current pixel of mosaic.
		 */
		protected static function _mosaic_get( p_obj:Object , p_parameters:Array , p_extra:Object = null ):Number
		{
			var _mosaicContainer:MovieClip = p_obj.getChildByName( "MOSAIC_CONTAINER" );
			if ( _mosaicContainer ) return _mosaicContainer._mosaic; 
			else return 1;
		}
		
		/**
		 * On mosaic.
		 */
		protected static function _mosaic_set( p_obj:Object , p_value:Number , p_parameters:Array , p_extra:Object = null ):void
		{
			var _target:Sprite = p_obj as Sprite;
			var _mosaicContainer:MovieClip;
			var _child:DisplayObject;
			var _children:Array = new Array();
			var _minX:Number;
			var _minY:Number;
			var _matrix:Matrix = new Matrix();
			var _oriBmp:Bitmap;
			
			var _old_sp:MovieClip = p_obj.getChildByName( "MOSAIC_CONTAINER" );
			
			if ( !_old_sp )
			{
				_mosaicContainer = new MovieClip();
				_mosaicContainer.name = "MOSAIC_CONTAINER";
				_mosaicContainer._children = new Array();
				
				var _xArray:Array = new Array();
				var _yArray:Array = new Array();
				for ( var k:int = 0; k < _target.numChildren; k ++ ) 
				{
					_child = _target.getChildAt( k );
					_xArray.push( _child.x );
					_yArray.push( _child.y );
				}
				_minX = Math.min.apply( null , _xArray );
				_minY = Math.min.apply( null , _yArray );
				_mosaicContainer._minX = _minX;
				_mosaicContainer._minY = _minY;
				_matrix.tx = -_minX;
				_matrix.ty = -_minY;
				
				var _bmp:Bitmap = drawMosaic( _target , 1 , _matrix );
				_mosaicContainer.x = _minX;
				_mosaicContainer.y = _minY;
				_mosaicContainer.addChild( _bmp );
				_mosaicContainer._oriBmp = _bmp;
				
				for ( var j:int = 0; j < _target.numChildren + 1; j ++ )
				{
					_child = _target.getChildAt( 0 );
					_children.push( _child );
					_target.removeChild( _child );
				}
				_mosaicContainer._children = _children;
				_target.addChild( _mosaicContainer );
			}
			else _mosaicContainer = _old_sp;
			
			if ( p_value <= 1 )
			{
				p_value = 1;
				_target.removeChild( _mosaicContainer );
				
				var _length:int = _mosaicContainer._children.length;
				for ( var i:int = 0; i < _length; i ++ ) _target.addChild( _mosaicContainer._children[ i ] );
			}
			else
			{
				_minX = _mosaicContainer._minX;
				_minY = _mosaicContainer._minY;
				_oriBmp = _mosaicContainer._oriBmp;
				_matrix.tx = 0;
				_matrix.ty = 0;
				_matrix.scale( 1 / p_value, 1 / p_value );
				
				_mosaicContainer.removeChildAt( 0 );
				_mosaicContainer.addChild( drawMosaic( _oriBmp , p_value , _matrix ) );
			}
			_mosaicContainer._mosaic = p_value;
		}
	
		static private function drawMosaic( _target:* , _pixel:Number , _matrix:Matrix ):Bitmap
		{
			var _bmpData:BitmapData = new BitmapData( _target.width / _pixel , _target.height / _pixel , true , 0x00FFFF );
			var _bmp:Bitmap = new Bitmap( _bmpData );
			_bmpData.draw( _target , _matrix , null , "normal", new Rectangle( 0 , 0 , _target.width , _target.height ) );
			_bmp.width = _target.width;
			_bmp.height = _target.height;
			return _bmp;
		}
	}
}