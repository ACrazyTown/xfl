package openfl.controls;

import openfl.controls.dataGridClasses.HeaderRenderer;
import openfl.controls.dataGridClasses.DataGridColumn;
import openfl.controls.listClasses.CellRenderer;
import openfl.controls.listClasses.ICellRenderer;
import openfl.controls.listClasses.ListData;
import openfl.data.DataProvider;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.events.ListEvent;
import openfl.text.TextFormat;

/**
 * Data grid
 */
class DataGrid extends Sprite {

    public var columns : Array<DataGridColumn>;

    private var styles : Map<String, Dynamic>;
    private var rendererStyles : Map<String, Dynamic>;

    public var sortableColumns : Bool;
    public var resizableColumns : Bool;

    public var dataProvider(get, set): DataProvider;
    private var _dataProvider: DataProvider;

    public var rowHeight: Int;

    public var length: Int;

    private var _width: Float;
    private var _height: Float;

    private var displayObjects: Array<DisplayObject>;

    /**
     * Public constructor
     **/
    public function new()
    {
        displayObjects = new Array<DisplayObject>();
        columns = new Array<DataGridColumn>();
        styles = new Map<String, Dynamic>();
        rendererStyles = new Map<String, Dynamic>();
        super();
        _width = 0;
        _height = 0;
        x = 0;
        y = 0;
        width = 0;
        height = 0;
        mouseChildren = true;
    }

    /**
     * Set style
     * @param key - key
     * @param value - value
     */
    public function setStyle(key: String, value: Dynamic): Void {
        styles.set(key, value);
        setupRendererClasses();
    }

    /**
     * Set style
     * @param arg0 - Not yet
     * @param arg1 - Not yet
     */
    public function setRendererStyle(key: String, value: Dynamic): Void {
        rendererStyles.set(key, value);
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
        setupRendererClasses();
    }

    private function setupRendererClasses() {
        for (column in columns) {
            column.headerRenderer = styles.get("headerRenderer") != null?cast(styles.get("headerRenderer"), Class<Dynamic>):null;
            column.cellRenderer = styles.get("cellRenderer") != null?cast(styles.get("cellRenderer"), Class<Dynamic>):null;
        }
    }

    /**
     * Validate now
     */
    public function validateNow(): Void {
    }

    public function getCellRendererAt(row: Int, column: Int): ICellRenderer {
        return cast(getChildAt(row * columns.length + column), ICellRenderer);
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
        createCells();
        return _dataProvider;
    }

    private function createCells() {
        for (displayObject in displayObjects) {
            removeChild(displayObject);
        }
        displayObjects = new Array<DisplayObject>();
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
            headerRenderer.label = column.headerText;
            headerRenderer.x = _x;
            headerRenderer.y = 0.0;
            headerRenderer.width = column.width;
            headerRenderer.height = headerRenderer.height;
            headerRenderer.init();
            headerRenderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseEventMove);
            headerRenderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseEventMove);
            headerRenderer.addEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
            headerRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventMove);
            addChild(headerRenderer);
            displayObjects.push(headerRenderer);
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
                    cellRenderer.label = column.itemToLabel(rowData);
                    cellRenderer.x = _x;
                    cellRenderer.y = 0.0;
                    cellRenderer.width = column.width;
                    cellRenderer.height = cellRenderer.height;
                    cellRenderer.data = rowData;
                    cellRenderer.listData = listData;
                    cellRenderer.init();
                    cellRenderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseEventMove);
                    cellRenderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseEventMove);
                    cellRenderer.addEventListener(MouseEvent.MOUSE_UP, onMouseEventMove);
                    cellRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEventMove);
                    cellRenderer.addEventListener(MouseEvent.CLICK, onMouseEventClick);
                    addChild(cellRenderer);
                    displayObjects.push(cellRenderer);
                    _x+= column.width;
                    columnIdx++;
                }
            }
        }
        var _y: Float = 0.0;
        for (i in 0...Std.int(numChildren / columns.length)) {
            var cellHeight: Float = 0.0;
            for (j in 0...columns.length) {
                var cell: DisplayObject = displayObjects[(i * columns.length) + j];
                if (cell.height > cellHeight) cellHeight = cell.height;
            }
            for (j in 0...columns.length) {
                var cell: DisplayObject = displayObjects[(i * columns.length) + j];
                cell.y = _y;
                cell.height = cellHeight;
            }
            _y+= cellHeight;
        }
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
    }

    override private function get_width(): Float {
        return _width;
    }

    override private function set_width(width: Float): Float {
        setColumnWidth(width);
        _width = width;
        createCells();
        return _width;
    }

    override private function get_height(): Float {
        return _height;
    }

    override private function set_height(height: Float): Float {
        _height = height;
        return _height;
    }

    private function onMouseEventMove(event: MouseEvent) : Void {
        if (Std.is(cast(event.target, DisplayObject), HeaderRenderer) == true) {
            for (columnIdx in 0...columns.length) {
                cast(displayObjects[columnIdx], HeaderRenderer).setMouseState(event.type);
            }
        }
        if (Std.is(cast(event.target, DisplayObject), CellRenderer) == true) {
            var cell: CellRenderer = cast(event.target, CellRenderer);
            for (columnIdx in 0...columns.length) {
                cast(displayObjects[(cell.listData.index * columns.length) + columnIdx], CellRenderer).setMouseState(event.type);
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
