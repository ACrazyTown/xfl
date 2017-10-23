package openfl.controls;

import openfl.display.Sprite;
import openfl.text.TextField;

class LabelButton extends Sprite {

	public var label(get, set): String;
 	public var labelPlacement(get, set): String;
 	public var selected: Bool;
 	public var textField(get, never): TextField;
 	public var toggle : Bool;

    private var _labelPlacement: String;
    private var _selected: Bool;
    private var _textField: TextField;

    private var _width: Float;
    private var _height: Float;

    public function new() {
        super();
        _textField = new TextField();
        _textField.text = "label";
        _textField.x = 2;
        _textField.y = 2;
        _textField.width = textField.textWidth + 4;
        _textField.height = textField.textHeight + 4;
        _width = _textField.width;
        _height = _textField.height;
        mouseChildren = false;
        buttonMode = true;
        addChild(_textField);
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

    override private function get_width(): Float {
        return _width;
    }

    override private function set_width(width: Float): Float {
        _width = width;
        _textField.width = textField.textWidth + 4;
        return _width;
    }

    override private function get_height(): Float {
        return _height;
    }

    override private function set_height(height: Float): Float {
        _height = height;
        _textField.height = textField.textHeight + 4;
        _textField.y = (_height - _textField.height) / 2;
        return _height;
    }

}
