package xfl.dom;

import haxe.xml.Fast;

class DOMTextAttrs {

	public var aliasText: Bool;
	public var alignment: String;
	public var alpha: Float;
	public var face: String;
	public var fillColor: Int;
	public var size: Null<Float>;

	public function new() {
	}

	public static function parse(xml: Fast): DOMTextAttrs {
		var textAttrs = new DOMTextAttrs ();
		if (xml.has.alignment) textAttrs.alignment = xml.att.alignment;
		if (xml.has.aliasText) textAttrs.aliasText = (xml.att.aliasText == "true");
		if (xml.has.alpha) textAttrs.alpha = Std.parseFloat(xml.att.alpha);
		if (xml.has.size) textAttrs.size = Std.parseFloat(xml.att.size);
		if (xml.has.face) textAttrs.face = xml.att.face;
		// TODO: a.drewke, hack to get custom font into GUI
		// 	this actually works but font rendering is at wrong position
		/*
		if (textAttrs.face != null && textAttrs.face == "VinerHandITC") {
			textAttrs.face = "Aquiline";
			textAttrs.size/= 1.2;
		}
		*/
		if (xml.has.fillColor) textAttrs.fillColor = Std.parseInt("0x" + xml.att.fillColor.substr(1));
		return textAttrs;
	}

}
