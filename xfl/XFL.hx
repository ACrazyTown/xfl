package xfl;

import openfl.Assets;
import xfl.dom.DOMBitmapItem;
import xfl.dom.DOMDocument;
import xfl.dom.DOMSoundItem;
import xfl.dom.DOMSymbolItem;
import openfl.display.BitmapData;
import openfl.display.XFLMovieClip;
import openfl.display.XFLSprite;
import openfl.media.Sound;

class XFL {

	public var documents: Array<DOMDocument>;
	public var paths: Array<String>;
	public var customSymbolLoader: XFLCustomSymbolLoader;

	public function new (paths: Array<String>, customSymbolLoader: XFLCustomSymbolLoader = null) {
		this.documents = [];
		this.paths = paths;
		this.customSymbolLoader = customSymbolLoader;
		for (path in this.paths) {
			documents.push(DOMDocument.load(path, "DOMDocument.xml"));
		}
	}

	public function getBitmapData (name:String): BitmapData {
		var bitmapData: BitmapData = null;
		for (document in documents) {
			for (medium in document.media) {
				if (medium.linkageClassName == name && medium.linkageExportForAS == true) {
					if (Std.is(medium, DOMBitmapItem) == true) {
						var bitmapItem: DOMBitmapItem = cast(medium, DOMBitmapItem);
						var assetUrl: String = document.path + "/LIBRARY/" + bitmapItem.href;
						if (Assets.exists(assetUrl) == true) bitmapData = Assets.getBitmapData(assetUrl);
						if (bitmapData != null) break;
					}
				}
			}
		}
		if (bitmapData == null) {
			trace("getBitmapData(): bitmap data not found: " + name);
		}
		return bitmapData;
	}

	public function getSound(name:String): Sound {
		var sound: Sound = null;
		for (document in documents) {
			for (medium in document.media) {
				if (medium.linkageClassName == name && medium.linkageExportForAS == true) {
					if (Std.is(medium, DOMSoundItem) == true) {
						var soundItem: DOMSoundItem = cast(medium, DOMSoundItem);
						var assetUrl: String = document.path + "/LIBRARY/" + soundItem.href;
						if (Assets.exists(assetUrl) == true) sound = Assets.getSound(assetUrl);
						if (sound != null) break;
					}
				}
			}
		}
		if (sound == null) {
			trace("getSound(): sound not found: " + name);
		}
		return sound;
	}

	public function createMovieClip (name: String): XFLMovieClip {
		var timeline = null;
		for (document in documents) {
			for (symbolItem in document.symbols) {
				if (symbolItem.linkageClassName == name && symbolItem.linkageExportForAS == true) {
					if (Std.is(symbolItem, DOMSymbolItem)) {
						if (customSymbolLoader != null) {
							var movieClip: XFLMovieClip = customSymbolLoader.createMovieClip(this, symbolItem);
							if (movieClip != null) {
								customSymbolLoader.onMovieClipLoaded(this, symbolItem, movieClip);
								return movieClip;
							}
						}
						timeline = symbolItem.timeline;
						break;
					}
				}
			}
			if (timeline != null) break;
		}

		if (timeline != null) {
			return new XFLMovieClip(this, timeline);
		}

		trace("createMovieClip(): movie clip not found: " + name);
		return null;
	}

	public function createSprite (name: String): XFLSprite {
		var timeline = null;
		for (document in documents) {
			for (symbolItem in document.symbols) {
				if (symbolItem.linkageClassName == name && symbolItem.linkageExportForAS == true) {
					if (Std.is(symbolItem, DOMSymbolItem)) {
						if (customSymbolLoader != null) {
							var sprite: XFLSprite = customSymbolLoader.createSprite(this, symbolItem);
							if (sprite != null) {
								customSymbolLoader.onSpriteLoaded(this, symbolItem, sprite);
								return sprite;
							}
						}
						timeline = symbolItem.timeline;
						break;
					}
				}
			}
			if (timeline != null) break;
		}

		if (timeline != null) {
			return new XFLSprite(this, timeline);
		}

		trace("createSprite(): sprite not found: " + name);
		return null;
	}
	
}
