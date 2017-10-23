package openfl.lang;

import com.slipshift.engine.core.Assets;

/**
 * Locale
 */
class Locale {

    public static var autoReplace: Bool = true;
    private static var localeLanguage: String = "default";
    private static var localeStrings: Map<String, Map<String, String>> = new Map<String, Map<String, String>>();

    public static function addXMLPath(lang: String, assetName: String): Void {
        var localeStringMap: Map<String, String> = new  Map<String, String>();
        localeStrings.set(lang, localeStringMap);
        for (element in Assets.getXMLAsset(assetName).node.file.node.body.elements) {
            if (element.name == "trans-unit") {
                var key: String = element.att.resname;
                var value: String = element.node.source.innerData;
                localeStringMap.set(key, value);
            }
        }
    }

    public static function loadString(key: String): String 
    {
        var localeStringMap : Map<String, String> = localeStrings.get(localeLanguage);
        if (localeStringMap == null) return key;
        var localeString: String = localeStringMap.get(key);
        if (localeString == null) return key;
        localeString = StringTools.replace(localeString, "\t", "    ");
        return localeString;
    }

    public static function loadLanguageXML(language: String, callback: Bool->Void): Void
    {
        localeLanguage = language;
        callback(true);
    }

}
