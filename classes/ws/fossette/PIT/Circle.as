

package ws.fossette.PIT{
	import ws.fossette.PIT.*;

	import flash.display.Sprite;

	public class Circle extends Sprite{

    private static var color:uint = 0xFF00FF;
	

    public function Circle() {
        init();
    }

    private function init():void {
        graphics.beginFill(color, 0.5);
        graphics.drawCircle(0, 0, 8);
        graphics.beginFill(color, 1);
        graphics.drawCircle(0, 0, 4);
        graphics.endFill();
    }

}

}