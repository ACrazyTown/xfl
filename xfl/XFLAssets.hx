package xfl;

import openfl.display.BitmapData;
import openfl.display.XFLMovieClip;
import openfl.display.XFLSprite;
import openfl.media.Sound;

/**
 * XFL assets class
 */
class XFLAssets {

    private static var xfl: XFL;

    /**
     *  Constructor
     *  @param paths
     */
    public function new(paths: Array<String>, customSymbolLoader: XFLCustomSymbolLoader = null) {
        xfl = new XFL(paths, customSymbolLoader);
    }

    /**
     *  Get XFL XML asset
     *  @param asset name
     *  @return haxe.xml.Fast
     */
    public static function getXFLAsset(assetName: String) : haxe.xml.Fast {
        return new haxe.xml.Fast(Xml.parse(openfl.Assets.getText(assetName)).firstElement());
    }

    /**
     *  Get XFL movie clip asset
     *  @param asset name
     *  @return XFLMovieClip
     */
    public function getXFLMovieClipAsset(assetName: String) : XFLMovieClip {
        return xfl.createMovieClip(assetName);
    }

    /**
     *  Get XFL sprite asset
     *  @param asset name
     *  @return XFLSprite
     */
    public function getXFLSpriteAsset(assetName: String) : XFLSprite {
        return xfl.createSprite(assetName);
    }

    /**
     *  Get XFL bitmap asset
     *  @param asset name
     *  @return BitmapData
     */
    public function getXFLBitmapDataAsset(assetName: String) : BitmapData {
        return xfl.getBitmapData(assetName);
    }

    /**
     *  Get XFL sound asset
     *  @param asset name
     *  @return Sound
     */
    public function getXFLSoundAsset(assetName: String) : Sound {
        return xfl.getSound(assetName);
    }

}
