package openfl.controls;

import openfl.display.XFLSprite;
import openfl.text.TextFormat;

/**
 * Textarea
 */
class TextArea extends XFLSprite {

    public var verticalScrollPosition: Int;
    public var maxVerticalScrollPosition: Int;
    public var htmlText: String;
    public var editable: Bool;

    /**
     * Public constructor
     **/
    public function new()
    {
        super();
    }

    /**
     *  Set draw focus
     *  @param arg0 - Not yet
     */
    public function drawFocus(arg0: Bool) {
    }

    /**
     *  Set style
     *  @param arg0 - Not yet
     *  @param textFormat - Not yet
     */
    public function setStyle(arg0: String, textFormat: TextFormat) {
    }
}
