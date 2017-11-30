package openfl.core;

import openfl.display.XFLSprite;
import xfl.XFL;
import xfl.dom.DOMTimeline;

/**
 * UI component
 */
class UIComponent extends XFLSprite {

    public var disabled(get,set): Bool;

    private var _disabled: Bool;
    private var _width: Float;
    private var _height: Float;

    private var _scrolling: Bool;
    private var _scrollY: Float;

    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreBlocked: Bool = false)
    {
        super(xfl, timeline, parametersAreBlocked);

        // defaults
        _disabled = false;

        // size
        // TODO: a.drewke
        if (getXFLDisplayObject("Component_avatar") == null) return;
        _width = getXFLDisplayObject("Component_avatar").width;
        _height = getXFLDisplayObject("Component_avatar").height;
        removeChild(getXFLDisplayObject("Component_avatar"));
    }

    public function get_disabled(): Bool {
        return _disabled;
    }

    public function set_disabled(_disabled: Bool): Bool {
        return this._disabled = _disabled;
    }

    override public function get_width(): Float {
        return _width;
    }

    override public function set_width(_width: Float): Float {
        setSize(_width, _height);
        return _width;
    }

    override public function get_height(): Float {
        return _height;
    }

    override public function set_height(_height: Float): Float {
        setSize(_width, _height);
        return _height;
    }

    public function drawFocus(draw: Bool): Void {
    }

    public function setStyle(style: String, value: Dynamic): Void {
    }

    public function setSize(_width: Float, _height: Float): Void {
        this._width = _width;
        this._height = _height;
    }

}
