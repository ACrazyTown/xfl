package xfl.dom;

import openfl.Assets;
import haxe.xml.Fast;

class DOMSymbolItem {

	public var itemID: String;
	public var linkageBaseClass: String;
	public var linkageClassName: String;
	public var linkageExportForAS: Bool;
	public var name: String;
	public var timeline: DOMTimeline;

	public function new () {
	}

	public static function load(path: String, file: String): DOMSymbolItem {	
		return parse(new Fast(Xml.parse(Assets.getText(path + "/" + file)).firstElement()));
	}

	public static function parse(xml: Fast): DOMSymbolItem {
		var symbolItem = new DOMSymbolItem();
		symbolItem.name = xml.att.name;
		symbolItem.itemID = xml.att.itemID;
		symbolItem.linkageBaseClass = xml.has.linkageBaseClass == true?xml.att.linkageBaseClass:null;
		if (xml.has.linkageExportForAS) symbolItem.linkageExportForAS = (xml.att.linkageExportForAS == "true");
		if (xml.has.linkageClassName) symbolItem.linkageClassName = xml.att.linkageClassName;
		for (element in xml.elements) {
			switch (element.name) {
				case "timeline":
					symbolItem.timeline = DOMTimeline.parse(element.elements.next());
			}
		}
		return symbolItem;
	}

}
