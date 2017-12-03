package openfl.controls;

import com.slipshift.engine.helpers.Utils;
import openfl.controls.UIScrollBar;
import openfl.containers.ScrollPane;
import openfl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.XFLSprite;
import openfl.display.XFLMovieClip;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import xfl.XFL;
import xfl.dom.DOMTimeline;

/**
 * Textarea
 */
class TextArea extends UIComponent {

    public var maxVerticalScrollPosition: Float;
    public var verticalScrollPosition: Float;

    public var htmlText(get, set): String;
    public var text(get, set): String;
    public var editable: Bool;

    private var scrollBar: UIScrollBar;
    private var scrollPane: ScrollPane;
    private var textField: TextField;

    /**
     * Public constructor
     **/
    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreBlocked: Bool = false)
    {
        super(xfl, timeline, parametersAreBlocked);
        for (i in 0...numChildren) {
            var child: DisplayObject = getChildAt(i);
            if (Std.is(child, UIScrollBar) == true) {
                scrollBar = cast(child, UIScrollBar);
                break;
            }
        }
        scrollPane = new ScrollPane();
        textField = new TextField();
        textField.name = "textfield";
        textField.x = 0;
        textField.y = 0;
        textField.type = TextFieldType.INPUT;
        textField.multiline = true;
        textField.wordWrap = true;
        scrollPane.source = textField;
        // TODO: a.drewke
        if (scrollBar != null) {
            scrollBar.visible = true;
            scrollBar.x = 0.0;
            scrollBar.y = 0.0;
            scrollBar.scrollTarget = scrollPane;
        }
        addChild(scrollPane);
        updateTextField();
        layoutChildren();
    }

    override public function drawFocus(draw: Bool): Void {
        trace("drawFocus(): " + draw);
    }

    override public function setStyle(style: String, value: Dynamic): Void {
        if (style == "textFormat") {
            var textFormat: TextFormat = cast(value, TextFormat);
            textField.setTextFormat(textFormat);
            updateTextField();
        } else {
            trace("setStyle(): '" + style + "', " + value);
        }
    }

    public function set_htmlText(_htmlText: String): String {
        textField.htmlText = _htmlText;
        updateTextField();
        return textField.htmlText;
    }

    public function get_htmlText(): String {
        return textField.htmlText;
    }

    public function set_text(_text: String): String {
        textField.text = _text;
        updateTextField();
        return textField.text;
    }

    public function get_text(): String {
        return textField.text;
    }

    override public function setSize(_width: Float, _height: Float) {
        super.setSize(_width, _height);
        scrollPane.setSize(_width, _height);
        if (scrollBar != null) {
            scrollBar.setSize(width, height);
        }
        updateTextField();
        layoutChildren();
    }

    private function updateTextField(): Void {
        textField.width = width - (scrollBar != null?scrollBar.scrollBarWidth:0.0);
        textField.height = textField.textHeight;
    }

    private function layoutChildren() {
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").visible = true;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").visible = true;
        if (getXFLDisplayObject("focusRectSkin") != null) getXFLDisplayObject("focusRectSkin").visible = true;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").visible = true;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").x = 0.0;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").y = 0.0;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").width = width;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").height = height;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").x = 0.0;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").y = 0.0;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").width = width;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").height = height;
        if (getXFLDisplayObject("focusRectSkin") != null) getXFLDisplayObject("focusRectSkin").x = 0.0;
        if (getXFLDisplayObject("focusRectSkin") != null) getXFLDisplayObject("focusRectSkin").y = 0.0;
        if (getXFLDisplayObject("focusRectSkin") != null) getXFLDisplayObject("focusRectSkin").width = width;
        if (getXFLDisplayObject("focusRectSkin") != null) getXFLDisplayObject("focusRectSkin").height = height;
    }

}
