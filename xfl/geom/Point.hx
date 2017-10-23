package xfl.geom;

import haxe.xml.Fast;

class Point extends openfl.geom.Point {

	public function new(x: Float = 0, y: Float = 0) {
		super (x, y);		
	}

	public static function parse (xml: Fast): Point {
		var point = new Point();
		point.x = xml.has.x == true?Std.parseFloat(xml.att.x):-1;
		point.y = xml.has.y == true?Std.parseFloat(xml.att.y):-1;
		return point;
	}

}
