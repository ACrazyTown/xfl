package openfl.controls.listClasses;

/**
 *  ICellRenderer
 */
interface ICellRenderer {

    public var data(get, set): Dynamic;
    public var listData(get, set): ListData;
 	public var selected : Bool;
    public function setMouseState(state: String): Void;

}
