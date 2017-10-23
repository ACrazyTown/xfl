package xfl.dom;

import haxe.xml.Fast;

class DOMLayer {

	public var name: String;
	public var animationType: String;
	public var visible: Bool;
	public var frames: Array<DOMFrame>;
	public var layerType: String;

	public function new() {
		frames = new Array <DOMFrame> ();
	}

	public static function parse(xml: Fast): DOMLayer {
		var layer = new DOMLayer();
		layer.name = xml.has.name == true?xml.att.name:null;
		if (xml.has.animationType) layer.animationType = xml.att.animationType;
		if (xml.has.layerType) layer.layerType = xml.att.layerType;
		layer.visible = true;
		if (xml.has.layerType == true &&
			xml.att.layerType == "mask") {
			layer.visible = false;
		}
		for (element in xml.elements) {
			switch (element.name) {
				case "frames":
					for (frame in element.elements) {
						layer.frames.push(DOMFrame.parse(frame));
					}
			}
		}
		return layer;
	}

}
