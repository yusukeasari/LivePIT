//
// Licensed under the MIT License
//
// Copyright (C) 2008-2009  TAKANAWA Tomoaki (http://nutsu.com) and
//					   		Spark project (www.libspark.org)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

package caurina.transitions.properties {

	import caurina.transitions.Tweener;
	/**
	* Spline Modifiers for Tweener
	* @author nutsu
	* 
	* @example
	* {x:targetX, y:targetY, _spline:[{x:x1,y:y1},{x:x2,y:y2}]};
	*/
	public class SplineModifiers 
	{
		private static var _tightness:Number = 1 / 6;
		
		public function SplineModifiers() 
		{
			trace ("This is an static class and should not be instantiated.")
		}
		
		public static function init(): void
		{
			Tweener.registerSpecialPropertyModifier("_spline", _spline_modifier, _spline_get );
		}
		
		public static function _spline_modifier(p_obj:*):Array
		{
			var mList:Array = [];
			var pList:Array;
			if (p_obj is Array) {
				pList = p_obj;
			} else {
				pList = [p_obj];
			}
			var i:uint;
			var istr:String;
			var mListObj:Object = {};
			for (i = 0; i < pList.length; i++) {
				for (istr in pList[i]) {
					if (mListObj[istr] == undefined) mListObj[istr] = [];
					mListObj[istr].push(pList[i][istr]);
				}
			}
			for (istr in mListObj) {
				mList.push({name:istr, parameters:mListObj[istr]});
			}
			return mList;
		}
		
		/**
		 * @param	b	begin
		 * @param	e	end
		 * @param	t	transtion value
		 * @param	p	parameters
		 */
		public static function _spline_get( b:Number, e:Number, t:Number, p:Array ):Number
		{
			var a0:Number;
			var a1:Number;
			var a2:Number;
			var a3:Number;
			
			var plen:int  = p.length + 1; //segment number
			var t2:Number = Math.max( Math.min( t, 1.0 ), 0 );
			var ip:uint   = Math.min( plen - 1, Math.floor(t2 * plen) ); // 0 to plen-1
			var it:Number = (t - (ip * (1 / plen))) * plen;
			
			if ( ip == 0 )
			{
				a0 = a1 = b;
				a2 = p[0];
			}
			else if( ip == 1 )
			{
				a0 = b;
				a1 = p[0];
				a2 = (ip == plen-1) ? e : p[1];
			}
			else
			{
				a0 = p[int(ip - 2)];
				a1 = p[int(ip - 1)];
				a2 = (ip == plen-1) ? e : p[ip];
			}
			if ( plen - ip < 3 )
			{
				a3 = e;
			}
			else
			{
				a3 = p[int(ip+1)];
			}
			var tp:Number = 1 - it;
			return a1*tp*tp*tp + 3*(a1 + (a2 - a0)*_tightness)*it*tp*tp + 3*(a2 - (a3 - a1)*_tightness)*it*it*tp + a2*it*it*it;
		}
		
		static public function set tightness(value:Number):void 
		{
			if( value > 0 )
				_tightness = value/6;
		}
	}
	
}