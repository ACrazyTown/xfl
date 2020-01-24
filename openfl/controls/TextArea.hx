package openfl.controls;

import openfl.core.UIComponent;
import openfl.controls.ScrollBar;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.XFLSprite;
import openfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.ScrollEvent;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import xfl.XFLSymbolArguments;
import xfl.XFLAssets;
import xfl.dom.DOMTimeline;

/**
 * Textarea
 */
class TextArea extends UIComponent {

    public var maxVerticalScrollPosition(get, never): Int;
    public var verticalScrollPosition(get, set): Int;

    public var maxChars(get, set): Int;
    public var htmlText(get, set): String;
    public var text(get, set): String;
    public var editable(get, set): Bool;
    public var textField(get, never): TextField;

    private var scrollBar: ScrollBar;
    private var textFieldNumLinesLast: Int;
    private var _textField: TextField;

    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.TextArea"));
        removeChild(getXFLDisplayObject("TextArea_upSkin"));
        removeChild(getXFLDisplayObject("TextArea_disabledSkin"));
        _textField = new TextField();
        _textField.name = "_textField";
        _textField.x = 0;
        _textField.y = 0;
        _textField.type = TextFieldType.INPUT;
        _textField.multiline = true;
        _textField.wordWrap = true;
        _textField.addEventListener(Event.CHANGE, _textFieldChangeHandler);
        textFieldNumLinesLast = _textField.numLines;
        addChild(_textField);
        scrollBar = getXFLScrollBar("UIScrollBar");
        scrollBar.visible = false;
        scrollBar.x = width - scrollBar.width;
        scrollBar.y = 0.0;
        scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollEvent);
        removeChild(scrollBar);
        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        validateNow();
    }

    private function get_textField(): TextField {
        return _textField;
    }

    override public function drawFocus(draw: Bool): Void {
        trace("drawFocus(): " + draw);
    }

    override public function setStyle(style: String, value: Dynamic): Void {
        if (style == "textFormat") {
            var textFormat: TextFormat = cast(value, TextFormat);
            _textField.setTextFormat(textFormat);
            validateNow();
        }
    }

    public function get_maxVerticalScrollPosition(): Int {
        return _textField.numLines - _textField.bottomScrollV + 1;
    }

    public function get_verticalScrollPosition(): Int {
        return _textField.scrollV;
    }

    public function set_verticalScrollPosition(verticalScrollPosition: Int): Int {
        _textField.scrollV = verticalScrollPosition;
        scrollBar.scrollPosition = verticalScrollPosition - 1;
        return _textField.scrollV;
    }

    public function get_maxChars(): Int {
        return _textField.maxChars;
    }

    public function set_maxChars(maxChars: Int): Int {
        return _textField.maxChars = maxChars;
    }

    public function set_htmlText(_htmlText: String): String {
        _textField.htmlText = _htmlText;
        validateNow();
        return _textField.htmlText;
    }

    public function get_htmlText(): String {
        return _textField.htmlText;
    }

    public function set_text(_text: String): String {
        _textField.text = _text;
        validateNow();
        return _textField.text;
    }

    public function get_text(): String {
        return _textField.text;
    }

    public function get_editable(): Bool {
        return _textField.type == TextFieldType.INPUT; 
    }

    public function set_editable(editable: Bool): Bool {
        _textField.type = editable == true?TextFieldType.INPUT:TextFieldType.DYNAMIC; 
        return editable;
    }

    override public function setSize(_width: Float, _height: Float) {
        super.setSize(_width, _height);
        _textField.width = width - scrollBar.width;
        _textField.height = height;
        scrollBar.x = width - scrollBar.width;
        scrollBar.height = height;
        update_textField();
        updateScrollBar();
        layoutChildren();
    }

    private function update_textField(): Void {
        _textField.width = width - (scrollBar != null?scrollBar.width:0.0);
    }

    private function updateScrollBar(): Void {
        textFieldNumLinesLast = _textField.numLines;
        scrollBar.visibleScrollRange = _textField.bottomScrollV - _textField.scrollV + 1;
        scrollBar.pageScrollSize = _textField.numLines / scrollBar.visibleScrollRange;
        scrollBar.maxScrollPosition = _textField.numLines - scrollBar.visibleScrollRange;
        scrollBar.visible = scrollBar.maxScrollPosition > 0.0;
        if (scrollBar.visible == true) {
            if (getChildByName(scrollBar.name) == null) addChild(scrollBar);
        } else {
            if (getChildByName(scrollBar.name) != null) removeChild(scrollBar);
        }
        trace("_textField.numLines: " + _textField.numLines);
        trace("_textField.scrollV: " + _textField.scrollV);
        trace("_textField.bottomScrollV: " + _textField.bottomScrollV);
        trace("scrollBar.visibleScrollRange: " + scrollBar.visibleScrollRange);
        trace("scrollBar.pageScrollSize: " + scrollBar.pageScrollSize);
        trace("scrollBar.maxScrollPosition: " + scrollBar.maxScrollPosition);
    }

    private function layoutChildren() {
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").visible = true;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").visible = true;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").visible = true;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").x = 0.0;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").y = 0.0;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").width = width;
        if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").height = height;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").x = 0.0;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").y = 0.0;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").width = width;
        if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").height = height;
    }

    private function onScrollEvent(event: ScrollEvent): Void {
        _textField.scrollV = Std.int(scrollBar.scrollPosition) + 1;
    }

    private function onMouseWheel(event: MouseEvent): Void {
        _textField.scrollV = _textField.scrollV - event.delta;
        if (scrollBar != null) scrollBar.scrollPosition = _textField.scrollV - 1;
    }

    private function _textFieldChangeHandler(e : Event) : Void {
        if (textFieldNumLinesLast != _textField.numLines) {
            update_textField();
            updateScrollBar();
            var maxScrollPosition: Int = Std.int(scrollBar.maxScrollPosition);
            var cursorLine = _textField.getLineIndexOfChar(_textField.caretIndex) + 1;
            if (scrollBar.maxScrollPosition > 0.0 &&
                cursorLine >= _textField.scrollV + _textField.bottomScrollV) {
                scrollBar.scrollPosition++;
                _textField.scrollV++;
            }
        }
        dispatchEvent(e);
    }

}
