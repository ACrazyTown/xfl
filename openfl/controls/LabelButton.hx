package openfl.controls;

import openfl.core.UIComponent;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import xfl.XFL;
import xfl.dom.DOMTimeline;

class LabelButton extends UIComponent {

	public var label(get, set): String;
 	public var labelPlacement(get, set): String;
 	public var textField(get, never): TextField;
    public var textPadding(get, set): Float;
    public var selected(get, set): Bool;
    public var toggle: Bool;

    private var _textPadding: Float;
    private var _labelPlacement: String;
    private var _textField: TextField;
    private var _selected: Bool;

    private var mouseState: String;
    private var currentIcon: DisplayObject;
    private var currentSkin: DisplayObject;

    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null) {
        super(name, xflSymbolArguments);
        _textPadding = 5.0;
        _textField = new TextField();
        _textField.text = "label";
        _textField.x = _textPadding;
        _textField.y = 2;
        _textField.width = textField.textWidth + 4;
        _textField.height = textField.textHeight + 4;
        _selected = false;
        toggle = false;
        mouseChildren = false;
        buttonMode = true;
        styles = new Map<String, Dynamic>();
        currentIcon = null;
        currentSkin = null;
        addChild(_textField);
        addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
        addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
        addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
        addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
        setMouseState("up");
    }

    private function get_textField(): TextField {
        return _textField;
    }

    private function get_label(): String {
        return _textField.text;
    }

    private function set_label(label: String): String {
        _textField.text = label;
        _textField.width = _textField.textWidth + 4;
        _textField.height = _textField.textHeight + 4;
        return label;       
    }

    private function get_labelPlacement(): String {
        return _labelPlacement;
    }

    private function set_labelPlacement(labelPlacement: String): String {
        _labelPlacement = labelPlacement;
        return _labelPlacement;
    }

    public function get_textPadding(): Float {
        return _textPadding;
    }

    public function set_textPadding(_textPadding: Float): Float {
        _textField.x = _textPadding;
        return this._textPadding = _textPadding;
    }

    private function get_selected(): Bool {
        return _selected;
    }

    private function set_selected(selected: Bool): Bool {
        _selected = selected;
        draw();
        return _selected;
    }

    public function setMouseState(newMouseState: String): Void {
        mouseState = newMouseState == "out"?"up":newMouseState;
        draw();
    }

    override private function draw() {
        if (currentIcon != null) currentIcon.visible = false;
        var styleName: String = (_selected == true?"selected" + mouseState.charAt(0).toUpperCase() + mouseState.substr(1).toLowerCase():mouseState) + "Icon";
        var newIcon: DisplayObject = styles.get(styleName);
        if (newIcon != null) {
            newIcon.visible = true;
            currentIcon = newIcon;
        }

        if (currentSkin != null) {
            currentSkin.visible = false;
            removeChild(currentSkin);
        }
        var newSkin: DisplayObject = styles.get(mouseState + "Skin");
        if (newSkin == null) styles.get("upSkin");
        if (newSkin != null) {
            addChildAt(newSkin, 0);
            newSkin.x = 0.0;
            newSkin.y = 0.0;
            newSkin.width = width;
            newSkin.height = height;
            newSkin.visible = true;
            currentSkin = newSkin;
        }
    }

    override public function setSize(_width: Float, _height: Float): Void {
        super.setSize(_width, _height);
        _textField.width = textField.textWidth + 4;
        _textField.height = textField.textHeight + 4;
        _textField.y = (_height - _textField.height) / 2;
    }

    private function onMouseEvent(event: MouseEvent): Void {
        switch(event.type) {
            case MouseEvent.MOUSE_OVER:
                setMouseState("over");
            case MouseEvent.MOUSE_OUT:
                setMouseState("out");
            case MouseEvent.MOUSE_UP:
                if (toggle == true) _selected = !_selected;
                setMouseState("up");
            case MouseEvent.MOUSE_DOWN:
                setMouseState("down");
            default:
                trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
        }
    }

}
