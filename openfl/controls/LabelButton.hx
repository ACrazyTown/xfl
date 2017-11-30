package openfl.controls;

import openfl.core.UIComponent;
import openfl.display.Sprite;
import openfl.text.TextField;

class LabelButton extends UIComponent {

	public var label(get, set): String;
 	public var labelPlacement(get, set): String;
 	public var selected: Bool;
 	public var textField(get, never): TextField;
 	public var toggle : Bool;

    private var _labelPlacement: String;
    private var _selected: Bool;
    private var _textField: TextField;

    public function new() {
        super();
        _textField = new TextField();
        _textField.text = "label";
        _textField.x = 2;
        _textField.y = 2;
        _textField.width = textField.textWidth + 4;
        _textField.height = textField.textHeight + 4;
        setSize(_textField.width, _textField.height);
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
        setSize(_textField.width, _textField.height);
        return label;       
    }

    private function get_labelPlacement(): String {
        return _labelPlacement;
    }

    private function set_labelPlacement(labelPlacement: String): String {
        _labelPlacement = labelPlacement;
        return _labelPlacement;
    }

    override public function setSize(_width: Float, _height: Float): Void {
        super.setSize(_width, _height);
        _textField.width = textField.textWidth + 4;
        _textField.height = textField.textHeight + 4;
        _textField.y = (_height - _textField.height) / 2;
    }

}
