

package ws.fossette.PIT{
	import ws.fossette.PIT.*;

	import idv.cjcat.stardust.twoD.emitters.Emitter2D;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.twoD.zones.SinglePoint;

	public class PointEmitter extends Emitter2D{

		public var point:SinglePoint;
	
	
		public function PointEmitter(clock:Clock = null) {
			super(clock);
			init();
		}
	

		private function init():void {
			point = new SinglePoint();
		}
	}
}