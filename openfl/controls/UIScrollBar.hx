package openfl.controls;

import com.slipshift.engine.helpers.Utils;
import openfl.containers.ScrollPane;
import openfl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import xfl.XFL;
import xfl.dom.DOMTimeline;

/**
 * UI scroll bar
 */
class UIScrollBar extends UIComponent {

    public var scrollTarget(get, set): ScrollPane;

    private var _scrollTarget: ScrollPane;
    private var scrollTrackSkins: Array<Dynamic>;
    private var scrollArrowUpState: String = "up";
    private var scrollArrowDownState: String = "up";

    /**
     * Public constructor
     **/
    public function new(name: String = null, xfl: XFL = null, timeline: DOMTimeline = null, parametersAreBlocked: Bool = false) {
        super(xfl, timeline, parametersAreBlocked);
        scrollTrackSkins = [];
        for (i in 0...numChildren) {
            var child: DisplayObject = getChildAt(i);
            if (child.name == "ScrollTrack_skin") {
                scrollTrackSkins.push(child);
            }
        }
        for (scrollTrackSkin in scrollTrackSkins) {
            scrollTrackSkin.visible = false;
        }

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
        getXFLMovieClip("ScrollBar_thumbIcon").visible = false;
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

        setScrollArrowUpState(scrollArrowUpState);
        setScrollArrowDownState(scrollArrowDownState);
    }

    public function get_scrollTarget(): ScrollPane {
        return this._scrollTarget;
    }

    public function set_scrollTarget(_scrollTarget: ScrollPane): ScrollPane {
        return this._scrollTarget = _scrollTarget;
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

    private function layoutChild(child: DisplayObject, alignToVertical: String) {
        if (child == null) {
            trace("layoutChild(): " + child.name + ": child not found");
            return;
        }
        child.x = width - child.width;
        switch (alignToVertical) {
            case "both":
                trace("layoutChild(): not yet");
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
                        openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrakeScrollUp);
                    case MouseEvent.MOUSE_DOWN:
                        newState = "down";
                        openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrakeScrollUp);
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
                        openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrakeScrollDown);
                    case MouseEvent.MOUSE_DOWN:
                        newState = "down";
                        openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrakeScrollDown);
                    default:
                        trace("onScrollArrowMouseEvent(): unsupported mouse event type '" + event.type + "'");
                }
                setScrollArrowDownState(newState);
            default:
                trace("onScrollArrowMouseEvent(): unsupported sub component '" + subComponent + "'");
        }
    }

    public function onEnterFrakeScrollUp(event: Event): Void {
        if (_scrollTarget != null) _scrollTarget.scrollY = _scrollTarget.scrollY + 2.0;
    }

    public function onEnterFrakeScrollDown(event: Event): Void {
        if (_scrollTarget != null) _scrollTarget.scrollY = _scrollTarget.scrollY - 2.0;
    }

}
