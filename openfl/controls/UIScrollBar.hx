package openfl.controls;

import openfl.containers.ScrollPane;
import openfl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import xfl.XFL;
import xfl.dom.DOMTimeline;

/**
 * UI scroll bar
 */
class UIScrollBar extends UIComponent {

    public var scrollTarget(get, set): ScrollPane;

    public var scrollBarWidth(get, never): Float;

    private var _scrollBarWidth: Float;
    private var scrollArrowUpHeight: Float;
    private var scrollArrowDownHeight: Float;
    private var scrollThumbHeight: Float;

    private var _scrollTarget: ScrollPane;
    private var scrollThumbState: String = "up";
    private var scrollArrowUpState: String = "up";
    private var scrollArrowDownState: String = "up";

    /**
     * Public constructor
     **/
    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreBlocked: Bool = false) {
        super(xfl, timeline, parametersAreBlocked);
        removeChild(getXFLMovieClip("ScrollTrack_skin"));
        removeChild(getXFLMovieClip("ScrollTrack_skin"));
        removeChild(getXFLMovieClip("ScrollTrack_skin"));

        var tmp: Float = 0.0;
        _scrollBarWidth = getXFLMovieClip("ScrollTrack_skin").width;
        scrollArrowUpHeight = (tmp = getXFLMovieClip("ScrollArrowUp_upSkin").height) > scrollArrowUpHeight?tmp:scrollArrowUpHeight;
        scrollArrowUpHeight = (tmp = getXFLMovieClip("ScrollArrowUp_overSkin").height) > scrollArrowUpHeight?tmp:scrollArrowUpHeight;
        scrollArrowUpHeight = (tmp = getXFLMovieClip("ScrollArrowUp_downSkin").height) > scrollArrowUpHeight?tmp:scrollArrowUpHeight;
        scrollArrowUpHeight = (tmp = getXFLMovieClip("ScrollArrowUp_disabledSkin").height) > scrollArrowUpHeight?tmp:scrollArrowUpHeight;
        scrollArrowDownHeight = (tmp = getXFLMovieClip("ScrollArrowDown_upSkin").height) > scrollArrowUpHeight?tmp:scrollArrowUpHeight;
        scrollArrowDownHeight = (tmp = getXFLMovieClip("ScrollArrowDown_overSkin").height) > scrollArrowUpHeight?tmp:scrollArrowUpHeight;
        scrollArrowDownHeight = (tmp = getXFLMovieClip("ScrollArrowDown_downSkin").height) > scrollArrowUpHeight?tmp:scrollArrowUpHeight;
        scrollArrowDownHeight = (tmp = getXFLMovieClip("ScrollArrowDown_disabledSkin").height) > scrollArrowUpHeight?tmp:scrollArrowUpHeight;

        getXFLMovieClip("ScrollTrack_skin").visible = true;
        getXFLMovieClip("focusRectSkin").visible = false;
        getXFLMovieClip("ScrollThumb_upSkin").visible = false;
        getXFLMovieClip("ScrollThumb_upSkin").mouseChildren = false;
        getXFLMovieClip("ScrollThumb_overSkin").visible = false;
        getXFLMovieClip("ScrollThumb_overSkin").mouseChildren = false;
        getXFLMovieClip("ScrollThumb_downSkin").visible = false;
        getXFLMovieClip("ScrollThumb_downSkin").mouseChildren = false;
        getXFLMovieClip("ScrollArrowUp_upSkin").visible = false;
        getXFLMovieClip("ScrollArrowUp_upSkin").mouseChildren = false;
        getXFLMovieClip("ScrollArrowUp_overSkin").visible = false;
        getXFLMovieClip("ScrollArrowUp_overSkin").mouseChildren = false;
        getXFLMovieClip("ScrollArrowUp_downSkin").visible = false;
        getXFLMovieClip("ScrollArrowUp_downSkin").mouseChildren = false;
        getXFLMovieClip("ScrollArrowUp_disabledSkin").visible = false;
        getXFLMovieClip("ScrollArrowUp_disabledSkin").mouseChildren = false;
        getXFLMovieClip("ScrollArrowDown_upSkin").visible = false;
        getXFLMovieClip("ScrollArrowDown_upSkin").mouseChildren = false;
        getXFLMovieClip("ScrollArrowDown_overSkin").visible = false;
        getXFLMovieClip("ScrollArrowDown_overSkin").mouseChildren = false;
        getXFLMovieClip("ScrollArrowDown_downSkin").visible = false;
        getXFLMovieClip("ScrollArrowDown_downSkin").mouseChildren = false;
        getXFLMovieClip("ScrollArrowDown_disabledSkin").visible = false;
        getXFLMovieClip("ScrollArrowDown_disabledSkin").mouseChildren = false;

        getXFLMovieClip("ScrollBar_thumbIcon").visible = true;
        getXFLMovieClip("ScrollBar_thumbIcon").mouseChildren = false;

        getXFLMovieClip("ScrollArrowUp_upSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowUp_overSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowUp_downSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);

        getXFLMovieClip("ScrollArrowDown_upSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowDown_overSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowDown_downSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollArrowMouseEvent);

        getXFLMovieClip("ScrollArrowUp_upSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowUp_overSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowUp_downSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);

        getXFLMovieClip("ScrollArrowDown_upSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowDown_overSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowDown_downSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollArrowMouseEvent);

        getXFLMovieClip("ScrollArrowUp_upSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowUp_overSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowUp_downSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);

        getXFLMovieClip("ScrollArrowDown_upSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowDown_overSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);
        getXFLMovieClip("ScrollArrowDown_downSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollArrowMouseEvent);

        getXFLMovieClip("ScrollThumb_upSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollThumbMouseEvent);
        getXFLMovieClip("ScrollThumb_overSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollThumbMouseEvent);
        getXFLMovieClip("ScrollThumb_downSkin").addEventListener(MouseEvent.MOUSE_UP, onScrollThumbMouseEvent);

        getXFLMovieClip("ScrollThumb_upSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollThumbMouseEvent);
        getXFLMovieClip("ScrollThumb_overSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollThumbMouseEvent);
        getXFLMovieClip("ScrollThumb_downSkin").addEventListener(MouseEvent.MOUSE_OVER, onScrollThumbMouseEvent);

        getXFLMovieClip("ScrollThumb_upSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollThumbMouseEvent);
        getXFLMovieClip("ScrollThumb_overSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollThumbMouseEvent);
        getXFLMovieClip("ScrollThumb_downSkin").addEventListener(MouseEvent.MOUSE_DOWN, onScrollThumbMouseEvent);

        setScrollArrowUpState(scrollArrowUpState);
        setScrollArrowDownState(scrollArrowDownState);
        setScrollThumbState(scrollThumbState);
    }

    public function get_scrollTarget(): ScrollPane {
        return this._scrollTarget;
    }

    public function set_scrollTarget(_scrollTarget: ScrollPane): ScrollPane {
        this._scrollTarget = _scrollTarget;
        setScrollThumbPosition();
        return this._scrollTarget;
    }

    public function get_scrollBarWidth(): Float {
        return _scrollBarWidth;
    }

    private function setScrollArrowUpState(scrollArrowUpState: String) {
        getXFLDisplayObject("ScrollArrowUp_" + this.scrollArrowUpState + "Skin").visible = false;
        this.scrollArrowUpState = scrollArrowUpState;
        getXFLDisplayObject("ScrollArrowUp_" + this.scrollArrowUpState + "Skin").visible = true;
    }

    private function setScrollArrowDownState(scrollArrowDownState: String) {
        getXFLDisplayObject("ScrollArrowDown_" + this.scrollArrowDownState + "Skin").visible = false;
        this.scrollArrowDownState = scrollArrowDownState;
        getXFLDisplayObject("ScrollArrowDown_" + this.scrollArrowDownState + "Skin").visible = true;
    }

    private function setScrollThumbState(scrollThumbState: String) {
        if (this.scrollThumbState != scrollThumbState) {
            getXFLDisplayObject("ScrollThumb_" + this.scrollThumbState + "Skin").visible = false;
        }
        this.scrollThumbState = scrollThumbState;
        getXFLDisplayObject("ScrollThumb_" + this.scrollThumbState + "Skin").visible = true;
        setScrollThumbPosition();
    }

    private function setScrollThumbPosition() {
        var thumbYPosition = 0.0;
        if (_scrollTarget != null && _scrollTarget.source != null) {
            thumbYPosition = _scrollTarget.scrollY / (_scrollTarget.source.height - _scrollTarget.height);
        }
        getXFLDisplayObject("ScrollThumb_" + this.scrollThumbState + "Skin").y = 
            scrollArrowUpHeight + 
            (thumbYPosition * (height - scrollArrowUpHeight - scrollArrowDownHeight - getXFLDisplayObject("ScrollThumb_" + this.scrollThumbState + "Skin").height)); 
        getXFLMovieClip("ScrollBar_thumbIcon").y = 
            getXFLDisplayObject("ScrollThumb_" + this.scrollThumbState + "Skin").y +
            ((getXFLDisplayObject("ScrollThumb_" + this.scrollThumbState + "Skin").height - getXFLMovieClip("ScrollBar_thumbIcon").height) / 2.0);
    }

    private function layoutChild(child: DisplayObject, alignToVertical: String) {
        if (child == null) {
            trace("layoutChild(): " + child.name + ": child not found");
            return;
        }
        child.x = width - child.width;
        switch (alignToVertical) {
            case "scrollthumb":
                child.x = width - scrollBarWidth + ((scrollBarWidth - child.width) / 2.0);
            case "scrolltrack":
                child.y = scrollArrowUpHeight;
                child.height = height - scrollArrowUpHeight - scrollArrowDownHeight;
            case "top":
                child.y = 0.0;
            case "bottom":
                child.y = height - child.height;
        }
    }

    override public function setSize(_width: Float, _height: Float) {
        super.setSize(_width, _height);

        layoutChild(getXFLMovieClip("ScrollArrowUp_upSkin"), "top");
        layoutChild(getXFLMovieClip("ScrollArrowUp_overSkin"), "top");
        layoutChild(getXFLMovieClip("ScrollArrowUp_downSkin"), "top");
        layoutChild(getXFLMovieClip("ScrollArrowUp_disabledSkin"), "top");
        layoutChild(getXFLMovieClip("ScrollArrowDown_upSkin"), "bottom");
        layoutChild(getXFLMovieClip("ScrollArrowDown_overSkin"), "bottom");
        layoutChild(getXFLMovieClip("ScrollArrowDown_downSkin"), "bottom");
        layoutChild(getXFLMovieClip("ScrollArrowDown_disabledSkin"), "bottom");
        layoutChild(getXFLMovieClip("ScrollTrack_skin"), "scrolltrack");
        layoutChild(getXFLMovieClip("ScrollBar_thumbIcon"), "scrollthumb");
        layoutChild(getXFLMovieClip("ScrollThumb_upSkin"), "scrollthumb");
        layoutChild(getXFLMovieClip("ScrollThumb_overSkin"), "scrollthumb");
        layoutChild(getXFLMovieClip("ScrollThumb_downSkin"), "scrollthumb");

        setScrollThumbPosition();
    }

    private function onScrollArrowMouseEvent(event: MouseEvent) : Void {
        if (disabled == true && (scrollArrowUpState != "disabled" || scrollArrowDownState != "disabled")) {
            setScrollArrowUpState("disabled");
            setScrollArrowDownState("disabled");
            return;
        }
        var subComponent: String = cast(event.target, DisplayObject).name.split("_")[0];
        switch(subComponent) {
            case "ScrollArrowUp":
                var newState: String = "up";
                switch(event.type) {
                    case MouseEvent.MOUSE_OVER:
                        newState = "over";
                    case MouseEvent.MOUSE_UP:
                        newState = "up";
                        openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameScrollUp);
                    case MouseEvent.MOUSE_DOWN:
                        newState = "down";
                        openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameScrollUp);
                    default:
                        trace("onScrollArrowMouseEvent(): unsupported mouse event type '" + event.type + "'");
                }
                setScrollArrowUpState(newState);
            case "ScrollArrowDown":
                var newState: String = "up";
                switch(event.type) {
                    case MouseEvent.MOUSE_OVER:
                        newState = "over";
                    case MouseEvent.MOUSE_UP:
                        newState = "up";
                        openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameScrollDown);
                    case MouseEvent.MOUSE_DOWN:
                        newState = "down";
                        openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameScrollDown);
                    default:
                        trace("onScrollArrowMouseEvent(): unsupported mouse event type '" + event.type + "'");
                }
                setScrollArrowDownState(newState);
            default:
                trace("onScrollArrowMouseEvent(): unsupported sub component '" + subComponent + "'");
        }
    }

    public function onEnterFrameScrollUp(event: Event): Void {
        if (_scrollTarget != null) {
            _scrollTarget.scrollY = _scrollTarget.scrollY - 2.0;
            setScrollThumbPosition();
        }
    }

    public function onEnterFrameScrollDown(event: Event): Void {
        if (_scrollTarget != null) {
            _scrollTarget.scrollY = _scrollTarget.scrollY + 2.0;
            setScrollThumbPosition();
        }
    }

    private function onScrollThumbMouseEvent(event: MouseEvent): Void {
        if (disabled == true) {
            return;
        }
        switch(event.type) {
            case MouseEvent.MOUSE_OVER:
                setScrollThumbState("over");
            case MouseEvent.MOUSE_UP:
                setScrollThumbState("up");
                removeEventListener(MouseEvent.MOUSE_MOVE, onScrollThumbMouseMove);
            case MouseEvent.MOUSE_DOWN:
                setScrollThumbState("down");
                addEventListener(MouseEvent.MOUSE_MOVE, onScrollThumbMouseMove);
            default:
                trace("onScrollThumbMouseEvent(): unsupported mouse event type '" + event.type + "'");
        }
    }

    private function onScrollThumbMouseMove(event: MouseEvent) : Void {
        if (disabled == true) {
            removeEventListener(MouseEvent.MOUSE_MOVE, onScrollThumbMouseMove);
            setScrollThumbState("up");
            return;
        }
        setScrollThumbState("down");
        var localPoint = getXFLDisplayObject("ScrollThumb_" + this.scrollThumbState + "Skin").globalToLocal(new Point(event.stageX, event.stageY));
        trace(localPoint);
    }

}
