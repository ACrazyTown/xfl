package xfl;

import openfl.Assets;
import xfl.dom.DOMBitmapItem;
import xfl.dom.DOMDocument;
import xfl.dom.DOMSoundItem;
import xfl.dom.DOMSymbolItem;
import xfl.dom.DOMTimeline;
import openfl.display.BitmapData;
import openfl.display.XFLMovieClip;
import openfl.display.XFLSprite;
import openfl.media.Sound;

class XFLSymbolArguments {
	public var xfl: XFL;
	public var timeline: DOMTimeline;
	public var parametersAreLocked: Bool;
	public function new(xfl: XFL, timeline: DOMTimeline, parametersAreLocked: Bool) {
		this.xfl = xfl;
		this.timeline = timeline;
		this.parametersAreLocked = parametersAreLocked;
	}
}

class XFL {

	public var paths: Array<String>;
	public var documents: Array<DOMDocument>;
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
						if (bitmapData != null) return bitmapData;
					}
				}
			}
		}
		trace("getBitmapData(): bitmap data not found: " + name);
		return null;
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
						if (sound != null) return sound;
					}
				}
			}
		}
		trace("getSound(): sound not found: " + name);
		return sound;
	}

	private function getSymbolItem(name: String): DOMSymbolItem {
		for (document in documents) {
			for (symbolItem in document.symbols) {
				if (symbolItem.linkageClassName == name && symbolItem.linkageExportForAS == true) {
					if (Std.is(symbolItem, DOMSymbolItem)) {
						return symbolItem;
					}
				}
			}
		}
		trace("getSymbolItem(): symbol not found: " + name);
		return null;
	}

	public function createSymbolArguments(name: String): XFLSymbolArguments {
		var symbolItem: DOMSymbolItem = getSymbolItem(name);
		if (symbolItem != null && Std.is(symbolItem, DOMSymbolItem)) {
			return new XFLSymbolArguments(this, symbolItem.timeline, symbolItem.parametersAreLocked);
		}
		trace("createSymbolArguments(): symbol not found: " + name);
		return null;
	}

	public function createMovieClip (name: String): XFLMovieClip {
		var symbolItem: DOMSymbolItem = getSymbolItem(name);
		if (symbolItem != null && Std.is(symbolItem, DOMSymbolItem)) {
			if (customSymbolLoader != null) {
				var movieClip: XFLMovieClip = customSymbolLoader.createMovieClip(this, symbolItem);
				if (movieClip != null) {
					customSymbolLoader.onMovieClipLoaded(this, symbolItem, movieClip);
					return movieClip;
				}
			}
			return new XFLMovieClip(new XFLSymbolArguments(this, symbolItem.timeline, symbolItem.parametersAreLocked));
		}
		trace("createMovieClip(): movie clip not found: " + name);
		return null;
	}

	public function createSprite (name: String): XFLSprite {
		var symbolItem: DOMSymbolItem = getSymbolItem(name);
		if (symbolItem != null && Std.is(symbolItem, DOMSymbolItem)) {
			if (customSymbolLoader != null) {
				var sprite: XFLSprite = customSymbolLoader.createSprite(this, symbolItem);
				if (sprite != null) {
					customSymbolLoader.onSpriteLoaded(this, symbolItem, sprite);
					return sprite;
				}
			}
			return new XFLSprite(new XFLSymbolArguments(this, symbolItem.timeline, symbolItem.parametersAreLocked));
		}
		trace("createSprite(): sprite not found: " + name);
		return null;
	}
	
}
