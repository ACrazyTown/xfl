package xfl;

import xfl.XFL;
import openfl.display.BitmapData;
import openfl.display.XFLMovieClip;
import openfl.display.XFLSprite;
import openfl.media.Sound;

/**
 * XFL assets class
 */
class XFLAssets {
	private static var instance:XFLAssets = null;

	private var xfl:XFL;

	public static function getInstance():XFLAssets {
		if (instance == null) {
			instance = new XFLAssets();
		}
		return instance;
	}

	public function setup(paths:Array<String>, customSymbolLoader:XFLCustomSymbolLoader = null) {
		xfl = new XFL(paths, customSymbolLoader);
	}

	/**
	 * Private constructor
	 */
	private function new() {
		this.xfl = null;
	}

	/**
	 * Get font mapping for given font
	 * @param font
	 * @return mapped font
	 */
	public function getFontMapping(font:String):String {
		return xfl.getFontMapping(font);
	}

	/**
	 * Add font mapping for given font
	 * @param font
	 * @param font mapping
	 */
	public function addFontMapping(font:String, fontMapping:String):Void {
		xfl.addFontMapping(font, fontMapping);
	}

	/**
	 *  Get XML asset
	 *  @param asset name
	 *  @return haxe.xml.Access
	 */
	public function getXFLXMLAsset(assetName:String):haxe.xml.Access {
		return XFL.getXMLData(assetName);
	}

	/**
	 *  Get XFL symbol arguments
	 *  @param asset name
	 *  @return XFLSymbolArguments
	 */
	public function createXFLSymbolArguments(assetName:String):XFLSymbolArguments {
		return xfl.createSymbolArguments(assetName);
	}

	/**
	 *  Get XFL movie clip asset
	 *  @param asset name
	 *  @return XFLMovieClip
	 */
	public function getXFLMovieClipAsset(assetName:String):XFLMovieClip {
		return xfl.createMovieClip(assetName);
	}

	/**
	 *  Get XFL sprite asset
	 *  @param asset name
	 *  @return XFLSprite
	 */
	public function getXFLSpriteAsset(assetName:String):XFLSprite {
		return xfl.createSprite(assetName);
	}

	/**
	 *  Get XFL bitmap asset
	 *  @param asset name
	 *  @return BitmapData
	 */
	public function getXFLBitmapDataAsset(assetName:String):BitmapData {
		return xfl.getBitmapData(assetName);
	}

	/**
	 *  Get XFL bitmap asset by path
	 *  @param asset path
	 *  @return BitmapData
	 */
	public function getXFLBitmapDataAssetByPath(assetPath:String):BitmapData {
		return xfl.getBitmapDataByPath(assetPath);
	}

	/**
	 *  Get XFL sound asset
	 *  @param asset name
	 *  @return Sound
	 */
	public function getXFLSoundAsset(assetName:String):Sound {
		return xfl.getSound(assetName);
	}
}
