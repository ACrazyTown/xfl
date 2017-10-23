package xfl.dom;

import haxe.xml.Fast;
import haxe.ds.StringMap;
import openfl.Assets;

class DOMDocument {

	public var path: String;
	public var height: Int;
	public var media: StringMap <Dynamic>;
	public var symbols: StringMap <DOMSymbolItem>;
	public var timelines: Array <DOMTimeline>;
	public var width: Int;
	public var xflVersion: Float;

	public function new(path: String) {
		this.path = path;
		media = new StringMap<DOMBitmapItem>();
		symbols = new StringMap<DOMSymbolItem>();
		timelines = new Array<DOMTimeline>();
	}

	public static function load(path: String, file: String): DOMDocument {
		return parse(new Fast(Xml.parse(Assets.getText(path + "/" + file)).firstElement()), path);
	}

	public static function parse(xml: Fast, path: String) : DOMDocument {
		var document = new DOMDocument(path);
		if (xml.has.width) document.width = Std.parseInt(xml.att.width);
		if (xml.has.height) document.height = Std.parseInt(xml.att.height);
		document.xflVersion = Std.parseFloat (xml.att.xflVersion);
		for (element in xml.elements) {
			switch (element.name) {
				case "media":
					for (medium in element.elements) {
						switch (medium.name) {
							case "DOMBitmapItem":
								var bitmapItem : DOMBitmapItem = DOMBitmapItem.parse(medium);
								if (document.media.exists(bitmapItem.name)) {
									trace("Media with key '" + bitmapItem.name + "' already exists");
								}
								document.media.set(bitmapItem.name, bitmapItem);
							case "DOMSoundItem":
								var soundItem : DOMSoundItem = DOMSoundItem.parse(medium);
								if (document.media.exists(soundItem.name)) {
									trace("Media with key '" + soundItem.name + "' already exists");
								}
								document.media.set(soundItem.name, soundItem);
						}
					}
				case "symbols":
					for (symbol in element.elements) {
						var symbolItem : DOMSymbolItem = DOMSymbolItem.load(path + "/LIBRARY", symbol.att.href);
						if (document.symbols.exists(symbolItem.name)) {
							trace("Symbol with key '" + symbolItem.name + "' already exists");
						}
						document.symbols.set(symbolItem.name, symbolItem);
					}
				case "timelines":
					for (timeline in element.elements) {
						document.timelines.push(DOMTimeline.parse(timeline));
					}				
			}
		}
		return document;
	}

}
