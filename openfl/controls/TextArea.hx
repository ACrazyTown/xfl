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
	public var maxVerticalScrollPosition(get, never):Int;
	public var verticalScrollPosition(get, set):Int;

	public var maxChars(get, set):Int;
	public var htmlText(get, set):String;
	public var text(get, set):String;
	public var editable(get, set):Bool;
	public var textField(get, never):TextField;

	private var _scrollBar:ScrollBar;
	private var _textFieldNumLinesLast:Int;
	private var _textField:TextField;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null) {
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.TextArea"));
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
		_textFieldNumLinesLast = _textField.numLines;
		addChild(_textField);
		_scrollBar = getXFLScrollBar("UIScrollBar");
		_scrollBar.visible = false;
		_scrollBar.x = width - _scrollBar.width;
		_scrollBar.y = 0.0;
		_scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollEvent);
		removeChild(_scrollBar);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		validateNow();
	}

	private function get_textField():TextField {
		return _textField;
	}

	override public function drawFocus(draw:Bool):Void {
		trace("drawFocus(): " + draw);
	}

	override public function setStyle(style:String, value:Dynamic):Void {
		if (style == "textFormat") {
			var textFormat:TextFormat = cast(value, TextFormat);
			_textField.setTextFormat(textFormat);
			validateNow();
		}
	}

	public function get_maxVerticalScrollPosition():Int {
		return _textField.numLines - _textField.bottomScrollV + 1;
	}

	public function get_verticalScrollPosition():Int {
		return _textField.scrollV;
	}

	public function set_verticalScrollPosition(verticalScrollPosition:Int):Int {
		_textField.scrollV = verticalScrollPosition;
		_scrollBar.scrollPosition = verticalScrollPosition - 1;
		return _textField.scrollV;
	}

	public function get_maxChars():Int {
		return _textField.maxChars;
	}

	public function set_maxChars(maxChars:Int):Int {
		return _textField.maxChars = maxChars;
	}

	public function set_htmlText(_htmlText:String):String {
		_textField.htmlText = _htmlText;
		validateNow();
		return _textField.htmlText;
	}

	public function get_htmlText():String {
		return _textField.htmlText;
	}

	public function set_text(_text:String):String {
		_textField.text = _text;
		validateNow();
		return _textField.text;
	}

	public function get_text():String {
		return _textField.text;
	}

	public function get_editable():Bool {
		return _textField.type == TextFieldType.INPUT;
	}

	public function set_editable(editable:Bool):Bool {
		_textField.type = editable == true ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		return editable;
	}

	override public function setSize(_width:Float, _height:Float) {
		super.setSize(_width, _height);
		_textField.width = width - _scrollBar.width;
		_textField.height = height;
		_scrollBar.x = width - _scrollBar.width;
		_scrollBar.height = height;
		update_textField();
		update_scrollBar();
		layoutChildren();
	}

	private function update_textField():Void {
		_textField.width = width - (_scrollBar != null ? _scrollBar.width : 0.0);
	}

	private function update_scrollBar():Void {
		_textFieldNumLinesLast = _textField.numLines;
		_scrollBar.visibleScrollRange = _textField.bottomScrollV - _textField.scrollV + 1;
		_scrollBar.pageScrollSize = _textField.numLines / _scrollBar.visibleScrollRange;
		_scrollBar.maxScrollPosition = _textField.numLines - _scrollBar.visibleScrollRange;
		_scrollBar.visible = _scrollBar.maxScrollPosition > 0.0;
		if (_scrollBar.visible == true) {
			if (getChildByName(_scrollBar.name) == null)
				addChild(_scrollBar);
		} else {
			if (getChildByName(_scrollBar.name) != null)
				removeChild(_scrollBar);
		}
		/*
			trace("_textField.numLines: " + _textField.numLines);
			trace("_textField.scrollV: " + _textField.scrollV);
			trace("_textField.bottomScrollV: " + _textField.bottomScrollV);
			trace("_scrollBar.visibleScrollRange: " + _scrollBar.visibleScrollRange);
			trace("_scrollBar.pageScrollSize: " + _scrollBar.pageScrollSize);
			trace("_scrollBar.maxScrollPosition: " + _scrollBar.maxScrollPosition);
		 */
	}

	private function layoutChildren() {
		if (getXFLDisplayObject("TextArea_disabledSkin") != null)
			getXFLDisplayObject("TextArea_disabledSkin").visible = true;
		if (getXFLDisplayObject("TextArea_upSkin") != null)
			getXFLDisplayObject("TextArea_upSkin").visible = true;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null)
			getXFLDisplayObject("TextArea_disabledSkin").visible = true;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null)
			getXFLDisplayObject("TextArea_disabledSkin").x = 0.0;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null)
			getXFLDisplayObject("TextArea_disabledSkin").y = 0.0;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null)
			getXFLDisplayObject("TextArea_disabledSkin").width = width;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null)
			getXFLDisplayObject("TextArea_disabledSkin").height = height;
		if (getXFLDisplayObject("TextArea_upSkin") != null)
			getXFLDisplayObject("TextArea_upSkin").x = 0.0;
		if (getXFLDisplayObject("TextArea_upSkin") != null)
			getXFLDisplayObject("TextArea_upSkin").y = 0.0;
		if (getXFLDisplayObject("TextArea_upSkin") != null)
			getXFLDisplayObject("TextArea_upSkin").width = width;
		if (getXFLDisplayObject("TextArea_upSkin") != null)
			getXFLDisplayObject("TextArea_upSkin").height = height;
	}

	private function onScrollEvent(event:ScrollEvent):Void {
		_textField.scrollV = Std.int(_scrollBar.scrollPosition) + 1;
	}

	private function onMouseWheel(event:MouseEvent):Void {
		_textField.scrollV = _textField.scrollV - event.delta;
		if (_scrollBar != null)
			_scrollBar.scrollPosition = _textField.scrollV - 1;
	}

	private function _textFieldChangeHandler(e:Event):Void {
		if (_textFieldNumLinesLast != _textField.numLines) {
			update_textField();
			update_scrollBar();
			var maxScrollPosition:Int = Std.int(_scrollBar.maxScrollPosition);
			var cursorLine = _textField.getLineIndexOfChar(_textField.caretIndex) + 1;
			if (_scrollBar.maxScrollPosition > 0.0 && cursorLine >= _textField.scrollV + _textField.bottomScrollV) {
				_scrollBar.scrollPosition++;
				_textField.scrollV++;
			}
		}
		dispatchEvent(e);
	}

	override public function dispose():Void {
		_textField.removeEventListener(Event.CHANGE, _textFieldChangeHandler);
		_scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollEvent);
		removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}
}
