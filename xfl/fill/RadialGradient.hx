package xfl.fill;

import openfl.geom.Matrix;
import haxe.xml.Access;

class RadialGradient {

	public var entries: Array<GradientEntry>;
	public var matrix: Matrix;
	public var spreadMethod: String;

	public function new() {
		entries = new Array<GradientEntry>();
	}

	public static function parse(xml: Access): RadialGradient {
		var radialGradient = new RadialGradient ();
		radialGradient.spreadMethod = xml.has.spreadMethod == true?xml.att.spreadMethod:"pad";
		for (element in xml.elements) {
			switch (element.name) {
				case "matrix":
					radialGradient.matrix = xfl.geom.Matrix.parse(element.elements.next ());
				case "GradientEntry":
					radialGradient.entries.push(GradientEntry.parse (element));
			}
		}
		return radialGradient;
	}

}
