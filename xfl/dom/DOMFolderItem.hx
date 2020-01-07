package xfl.dom;

import haxe.xml.Access;

class DOMFolderItem {

	public var itemID: String;
	public var name: String;

	public function new () {
	}

	public static function parse(xml: Access): DOMFolderItem {
		var folderItem = new DOMFolderItem ();
		folderItem.name = xml.att.name;
		folderItem.itemID = xml.att.itemID;
		return folderItem;
	}

}
