package openfl.controls;

import openfl.containers.BaseScrollPane;
import openfl.controls.dataGridClasses.HeaderRenderer;
import openfl.controls.dataGridClasses.DataGridColumn;
import openfl.controls.listClasses.CellRenderer;
import openfl.controls.listClasses.ICellRenderer;
import openfl.controls.listClasses.ListData;
import openfl.core.UIComponent;
import openfl.data.DataProvider;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.events.ListEvent;
import openfl.text.TextFormat;
import xfl.XFL;
import xfl.XFLAssets;

/**
 * Data grid
 */
class DataGrid extends BaseScrollPane {

    public var columns : Array<DataGridColumn>;

    private var rendererStyles : Map<String, Dynamic>;

    public var sortableColumns : Bool;
    public var resizableColumns : Bool;

    public var dataProvider(get, set): DataProvider;
    private var _dataProvider: DataProvider;

    public var rowHeight(default, set): Float;

    public var length: Int;

    private var headerDisplayObjects: Array<DisplayObject>;
    private var dataDisplayObjects: Array<DisplayObject>;
    private var scrollPaneSource: Sprite;

    /**
     * Public constructor
     **/
    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments/* != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.DataGrid")*/);
        headerDisplayObjects = new Array<DisplayObject>();
        dataDisplayObjects = new Array<DisplayObject>();
        columns = new Array<DataGridColumn>();
        rendererStyles = new Map<String, Dynamic>();
        _width = 0;
        _height = 0;
        x = 0;
        y = 0;
        width = 0;
        height = 0;
        rowHeight = 0.0;
        mouseChildren = true;
        scrollPaneSource = new Sprite();
        source = scrollPaneSource;
        draw();
    }

    /**
     * Set style
     * @param arg0 - Not yet
     * @param arg1 - Not yet
     */
    public function setRendererStyle(key: String, value: Dynamic): Void {
        rendererStyles.set(key, value);
        draw();
    }

    /**
     * Add column
     * @param arg0 - name
     */
    public function addColumn(dataField: String): Void {
        var column: DataGridColumn = new DataGridColumn();
        column.dataField = dataField;
        column.headerText = dataField;
        columns.push(column);
        draw();
    }

    public function getCellRendererAt(row: Int, column: Int): ICellRenderer {
        return cast(dataDisplayObjects[columns.length + ((row - 1) * columns.length + column)], ICellRenderer);
    }

    public function getItemAt(rowIdx: Int): Dynamic {
        return dataProvider.getItemAt(rowIdx);
    }

    private function get_dataProvider(): DataProvider {
        return _dataProvider;
    }

    private function set_dataProvider(dataProvider: DataProvider): DataProvider {
        _dataProvider = dataProvider;
        setColumnWidth(_width);
        draw();
        return _dataProvider;
    }

    override private function draw() {
        for (displayObject in headerDisplayObjects) {
            removeChild(displayObject);
        }
        headerDisplayObjects.splice(0, headerDisplayObjects.length);
        for (displayObject in dataDisplayObjects) {
            scrollPaneSource.removeChild(displayObject);
        }
        dataDisplayObjects.splice(0, dataDisplayObjects.length);
        var headerRenderer: Class<Dynamic> = styles.get("headerRenderer") != null?cast(styles.get("headerRenderer"), Class<Dynamic>):null;
        var cellRenderer: Class<Dynamic> = styles.get("cellRenderer") != null?cast(styles.get("cellRenderer"), Class<Dynamic>):null;
        for (column in columns) {
            column.headerRenderer = headerRenderer;
            column.cellRenderer = cellRenderer;
        }
        if (headerRenderer == null || cellRenderer == null) return;
        var _x: Float = 0.0;
        var columnIdx: Int = 0;
        var headerTextFormat: TextFormat = styles.get("headerTextFormat") != null?cast(styles.get("headerTextFormat"), TextFormat):null;
        for (column in columns) {
            var headerRenderer: HeaderRenderer = Type.createInstance(column.headerRenderer, []);
            headerRenderer.name = "datagrid.header." + columnIdx;
            headerRenderer.column = columnIdx++;
            if (headerTextFormat != null) {
                headerRenderer.textField.setTextFormat(headerTextFormat);
                headerRenderer.textField.defaultTextFormat = headerTextFormat;
            }
            headerRenderer.label = StringTools.ltrim(StringTools.rtrim(column.headerText));
            headerRenderer.x = _x;
            headerRenderer.y = 0.0;
            headerRenderer.setSize(column.width, headerRenderer.textField.height);
            headerRenderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseEventMove);
            headerRenderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseEventMove);
            headerRenderer.addEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
            headerRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventMove);
            addChild(headerRenderer);
            headerDisplayObjects.push(headerRenderer);
            _x+= column.width;
        }
        if (_dataProvider != null) {
            var cellTextFormat: TextFormat = rendererStyles.get("textFormat") != null?cast(rendererStyles.get("textFormat"), TextFormat):null;
            for (i in 0..._dataProvider.length) {
                _x = 0;
                var rowData: Dynamic = _dataProvider.getItemAt(i);
                var columnIdx = 0; 
                for (column in columns) {
                    var cellRenderer: CellRenderer = Type.createInstance(column.cellRenderer, []);
                    var listData: ListData = new ListData();
                    listData.column = columnIdx;
                    listData.index = i + 1;
                    listData.icon = null;
                    listData.label = null;
                    listData.owner = cellRenderer;
                    listData.row = i;
                    cellRenderer.name = "datagrid.cell." + columnIdx + "," + i;
                    if (cellTextFormat != null) {
                        cellRenderer.textField.setTextFormat(cellTextFormat);
                        cellRenderer.textField.defaultTextFormat = cellTextFormat;
                    }
                    cellRenderer.label = StringTools.ltrim(StringTools.rtrim(column.itemToLabel(rowData)));
                    cellRenderer.x = _x;
                    cellRenderer.y = 0.0;
                    var cellHeight: Float = cellRenderer.textField.height;
                    if (cellHeight > rowHeight) rowHeight = cellHeight;
                    if (cellHeight < rowHeight) cellHeight = rowHeight;
                    cellRenderer.setSize(column.width, cellHeight);
                    cellRenderer.data = rowData;
                    cellRenderer.listData = listData;
                    cellRenderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseEventMove);
                    cellRenderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseEventMove);
                    cellRenderer.addEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
                    cellRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventMove);
                    cellRenderer.addEventListener(MouseEvent.CLICK, onMouseEventClick);
                    scrollPaneSource.addChild(cellRenderer);
                    dataDisplayObjects.push(cellRenderer);
                    _x+= column.width;
                    columnIdx++;
                }
            }
        }
        scrollPaneSource.y = alignDisplayObjects(headerDisplayObjects);
        alignDisplayObjects(dataDisplayObjects);
        update();
        if (verticalScrollBar.visible == true) {
            realignDisplayObjectsWidth(headerDisplayObjects, verticalScrollBar.width);
            realignDisplayObjectsWidth(dataDisplayObjects, verticalScrollBar.width);
        }
    }

    private function alignDisplayObjects(displayObjects: Array<DisplayObject>, verticalScrollBarSize: Float = 0.0): Float {
        var _y: Float = 0.0;
        if (displayObjects.length > 0) {
            for (i in 0...Std.int(displayObjects.length / columns.length)) {
                var cellHeight: Float = 0.0;
                for (j in 0...columns.length) {
                    var cell: DisplayObject = displayObjects[(i * columns.length) + j];
                    if (cell.height > cellHeight) cellHeight = cell.height;
                }
                if (rowHeight > cellHeight) cellHeight = rowHeight;
                var _x: Float = 0.0;
                for (j in 0...columns.length) {
                    var cell: DisplayObject = displayObjects[(i * columns.length) + j];
                    cell.x = _x;
                    cell.y = _y;
                    cell.height = cellHeight;
                    if (Std.is(cell, HeaderRenderer)) {
                        cast(cell, HeaderRenderer).init();
                    } else {
                        cast(cell, CellRenderer).init();
                    }
                    cell.width-= verticalScrollBarSize / columns.length;
                    _x+= cell.width;
                }
                _y+= cellHeight;
            }
        }
        return _y;
    }

    private function realignDisplayObjectsWidth(displayObjects: Array<DisplayObject>, verticalScrollBarSize: Float = 0.0): Void {
        if (displayObjects.length > 0) {
            for (i in 0...Std.int(displayObjects.length / columns.length)) {
                var _x: Float = 0.0;
                for (j in 0...columns.length) {
                    var cell: DisplayObject = displayObjects[(i * columns.length) + j];
                    cell.x = _x;
                    cell.width-= verticalScrollBarSize / columns.length;
                    _x+= cell.width;
                }
            }
        }
    }

    private function set_rowHeight(rowHeight: Float): Float {
        this.rowHeight = rowHeight;
        draw();
        return rowHeight;
    }

    private function setColumnWidth(_width: Float): Void {
        if (_width <= 0) return;
        var columnsWithoutWidth: Int = 0;
        var columnsWidth: Float = 0;
        for (column in columns) {
            if (column.width != -1) {
                columnsWidth+= column.width;
            } else {
                columnsWithoutWidth++;
            }
        }
        var columnsWidthLeft: Float = _width - columnsWidth;
        for (column in columns) {
            if (column.width == -1) {
                column.width = columnsWidthLeft / columnsWithoutWidth;
            } else {
                column.width*= _width / columnsWidth;
            }
        }
        draw();
    }

    override public function setSize(_width: Float, _height: Float): Void {
        super.setSize(_width, _height);
        setColumnWidth(width);
        draw();
    }

    private function onMouseEventMove(event: MouseEvent) : Void {
        if (Std.is(cast(event.target, DisplayObject), HeaderRenderer) == true) {
            var mouseHeaderRenderer: HeaderRenderer = cast(event.target, HeaderRenderer);
            for (columnIdx in 0...columns.length) {
                cast(headerDisplayObjects[columnIdx], HeaderRenderer).setMouseState(event.type.charAt("mouse".length).toLowerCase() + event.type.substr("mouse".length + 1));
            }
        }
        if (Std.is(cast(event.target, DisplayObject), CellRenderer) == true) {
            var mouseCellRenderer: CellRenderer = cast(event.target, CellRenderer);
            for (columnIdx in 0...columns.length) {
                var cellColumnRenderer: CellRenderer = cast(dataDisplayObjects[((mouseCellRenderer.listData.index - 1) * columns.length) + columnIdx], CellRenderer);
                cellColumnRenderer.setMouseState(event.type.charAt("mouse".length).toLowerCase() + event.type.substr("mouse".length + 1));
            }
        }
    }

    private function onMouseEventClick(event: MouseEvent) : Void {
        if (Std.is(cast(event.target, DisplayObject), CellRenderer) == true) {
            var cell: CellRenderer = cast(event.target, CellRenderer);
            var listData = cell.listData;
            dispatchEvent(
                new ListEvent(
                    ListEvent.ITEM_CLICK,
                    false,
                    false,
                    listData.column,
                    listData.row,
                    listData.index,
                    cast(listData.owner, CellRenderer).data
                )
            );
        }
    }

}
