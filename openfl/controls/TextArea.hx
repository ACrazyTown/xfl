package openfl.controls;

import openfl.display.XFLSprite;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFieldType;

/**
 * Textarea
 */
class TextArea extends TextField {

    public var verticalScrollPosition: Int;
    public var maxVerticalScrollPosition: Int;
    public var editable: Bool;

    /**
     * Public constructor
     **/
    public function new()
    {
        super();
        type = TextFieldType.INPUT;
        multiline = true;
        wordWrap = true;
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
