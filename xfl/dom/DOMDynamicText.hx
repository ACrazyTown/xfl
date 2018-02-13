package xfl.dom;

import xfl.geom.Matrix;
import haxe.xml.Fast;

class DOMDynamicText {

	public static var TYPE_NONE: Int = 0;
	public static var TYPE_DYNAMIC: Int = 1;
	public static var TYPE_INPUT: Int = 2;

	public var height: Float;
	public var isSelectable: Bool;
	public var multiLine: Bool;
	public var left: Float;
	public var matrix: Matrix;
	public var name: String;
	public var textRuns: Array<DOMTextRun>;
	public var width: Float;
	public var type: Int;

	public function new() {
		textRuns = new Array <DOMTextRun> ();
	}

	public static function parse(xml: Fast, type: Int): DOMDynamicText {
		var dynamicText = new DOMDynamicText ();
		dynamicText.type = type;
		dynamicText.height = Std.parseFloat (xml.att.height);
		dynamicText.width = Std.parseFloat (xml.att.width);
		if (xml.has.name) dynamicText.name = xml.att.name;
		dynamicText.isSelectable = xml.has.isSelectable == false || xml.att.isSelectable == "true";
		dynamicText.multiLine = xml.has.lineType == true && xml.att.lineType == "multiline";
		dynamicText.left = (xml.has.left == true)?Std.parseFloat(xml.att.left):0;
		for (element in xml.elements) {
			switch (element.name) {
				case "matrix":
					dynamicText.matrix = Matrix.parse (element.elements.next ());
				case "textRuns":
					for (childElement in element.elements) {
						dynamicText.textRuns.push (DOMTextRun.parse (childElement));
					}
			}
		}
		return dynamicText;
	}
	
}
