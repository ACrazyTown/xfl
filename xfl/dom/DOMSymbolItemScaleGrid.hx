package xfl.dom;

import haxe.xml.Access;
import openfl.geom.Rectangle;

class DOMSymbolItemScaleGrid {

    public static function parse(xml: Access): Rectangle {
        if (xml.has.scaleGridLeft == false ||
            xml.has.scaleGridRight == false ||
            xml.has.scaleGridTop == false ||
            xml.has.scaleGridBottom == false) return null;
        var left: Float = Std.parseFloat(xml.att.scaleGridLeft);
        var right: Float = Std.parseFloat(xml.att.scaleGridRight);
        var top: Float = Std.parseFloat(xml.att.scaleGridTop);
        var bottom: Float = Std.parseFloat(xml.att.scaleGridBottom);
        return
            new Rectangle(
                left,
                top,
                right - left,
                bottom - top
            );
    }

}
