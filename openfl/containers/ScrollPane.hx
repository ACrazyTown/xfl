package openfl.containers;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
 * Textarea
 */
class ScrollPane extends Sprite {

    private var _width: Float;
    private var _height: Float;
    private var _source: DisplayObject;

    public var source(get, set): DisplayObject;

    public var horizontalScrollPolicy: String;
    public var verticalScrollPolicy: String;

    public var verticalScrollPosition: Int;

    public var verticalScrollBar: Dynamic;

    /**
     * Public constructor
     **/
    public function new()
    {
        super();
        _width = 0.0;
        _height = 0.0;
        update();
    }

    /**
     * Set size
     * @param width - Not yet
     * @param height - Not yet
     */
    public function setSize(width: Int, height: Int) : Void {
        _width = width;
        _height = height;
        update();
    }

    /**
     * Update
     */
    public function update() : Void {
    }

    private function get_source(): DisplayObject {
        return _source;
    }

    private function set_source(_source: DisplayObject): DisplayObject {
        if (this._source != null) removeChild(this._source);
        this._source = _source;
        addChild(this._source);
        return this._source;
    }

    override private function get_width(): Float {
        return _width;
    }

    override private function set_width(width: Float): Float {
        _width = width;
        update();
        return _width;
    }

    override private function get_height(): Float {
        return _height;
    }

    override private function set_height(height: Float): Float {
        _height = height;
        update();
        return _height;
    }

}
