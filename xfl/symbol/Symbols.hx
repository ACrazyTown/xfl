package xfl.symbol;

import openfl.Assets;
import xfl.dom.DOMBitmapInstance;
import xfl.dom.DOMComponentInstance;
import xfl.dom.DOMDynamicText;
import xfl.dom.DOMShape;
import xfl.dom.DOMRectangle;
import xfl.dom.DOMStaticText;
import xfl.dom.DOMSymbolInstance;
import xfl.dom.DOMSymbolItem;
import openfl.display.DisplayObject;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.XFLMovieClip;
import openfl.display.XFLSprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class Symbols {

	public static function createShape(xfl: XFL, instance: DOMShape): Shape {
		var shape = new Shape(instance);
		if (instance.matrix != null) {
			shape.transform.matrix = instance.matrix;
		}
		return shape;
	}

	public static function createRectangle(xfl: XFL, instance: DOMRectangle): Rectangle {
		var rectangle = new Rectangle(instance);
		if (instance.matrix != null) {
			rectangle.transform.matrix = instance.matrix;
		}
		return rectangle;
	}

	public static function createBitmap(xfl: XFL, instance: DOMBitmapInstance): Bitmap {
		var bitmap = null;
		var bitmapData = null;
		for (document in xfl.documents) {
			if (document.media.exists(instance.libraryItemName)) {
				var bitmapItem = document.media.get(instance.libraryItemName);
				var assetUrl: String = document.path + "/LIBRARY/" + bitmapItem.name;
				if (Assets.exists(assetUrl) == true) bitmapData = Assets.getBitmapData(assetUrl);
				if (bitmapData != null) break;
			}
		}
		if (bitmapData == null) {
			trace("createBitmap(): " + instance.libraryItemName + ": not found");
			bitmapData = new BitmapData(1, 1, false, 0xFFFFFF);
		}
 		bitmap = new Bitmap(bitmapData);
		if (instance.matrix != null) {
			bitmap.transform.matrix = instance.matrix;
		}
		return bitmap;
	}

	public static function createDynamicText(instance: DOMDynamicText): TextField {
		var textField = new TextField();
		textField.width = instance.width;
		textField.height = instance.height;
		textField.name = instance.name;
		textField.selectable = instance.isSelectable;
		textField.multiline = instance.multiLine;
		if (textField.multiline == true) {
			textField.wordWrap = true;
		}
		if (instance.matrix != null) {
			textField.transform.matrix = instance.matrix;
		}
		textField.x+= instance.left;
		var format = new TextFormat();
		for (textRun in instance.textRuns) {
			var pos = textField.text.length;
			textField.appendText(textRun.characters);
			if (textRun.textAttrs.face != null) format.font = textRun.textAttrs.face;
			if (textRun.textAttrs.alignment != null) format.align = Reflect.field(TextFormatAlign, textRun.textAttrs.alignment.toUpperCase());
			if (textRun.textAttrs.size != null) format.size = Std.int(textRun.textAttrs.size);
			if (textRun.textAttrs.fillColor != 0) {
				if (textRun.textAttrs.alpha != 0) {
					// need to add alpha to color
					format.color = textRun.textAttrs.fillColor;
				} else {
					format.color = textRun.textAttrs.fillColor;
				}
			}
			textField.setTextFormat (format, pos, textField.text.length);
		}		
		return textField;
	}

	public static function createStaticText(instance: DOMStaticText): TextField {
		var textField = new TextField();
		textField.width = instance.width;
		textField.height = instance.height;
		textField.selectable = instance.isSelectable;
		textField.multiline = instance.multiLine;
		if (textField.multiline == true) {
			textField.wordWrap = true;
		}
		if (instance.matrix != null) {
			textField.transform.matrix = instance.matrix;
		}
		textField.x+= instance.left;
		var format = new TextFormat();
		for (textRun in instance.textRuns) {
			var pos = textField.text.length;
			textField.appendText(textRun.characters);
			if (textRun.textAttrs.face != null) format.font = textRun.textAttrs.face;
			if (textRun.textAttrs.alignment != null) format.align = Reflect.field(TextFormatAlign, textRun.textAttrs.alignment.toUpperCase());
			if (textRun.textAttrs.size != null) format.size = Std.int(textRun.textAttrs.size);
			if (textRun.textAttrs.fillColor != 0) {
				if (textRun.textAttrs.alpha != 0) {
					// need to add alpha to color
					format.color = textRun.textAttrs.fillColor;
				} else {
					format.color = textRun.textAttrs.fillColor;
				}
			}
			textField.setTextFormat(format, pos, textField.text.length);
		}
		return textField;
	}

	public static function createSymbol(xfl: XFL, instance: DOMSymbolInstance): DisplayObject {
		for (document in xfl.documents) {
			if (document.symbols.exists(instance.libraryItemName)) {
				var symbolItem: DOMSymbolItem = document.symbols.get(instance.libraryItemName);
				switch (symbolItem.linkageBaseClass) {
					case "flash.display.Sprite":
						return createSprite(xfl, instance);
					default:
						return createMovieClip(xfl, instance);
				}
			}
		}
		return null;
	}

	private static function createMovieClip(xfl: XFL, instance: DOMSymbolInstance): XFLMovieClip {
		var movieClip: XFLMovieClip = null;
		for (document in xfl.documents) {
			if (document.symbols.exists(instance.libraryItemName)) {
				var symbolItem: DOMSymbolItem = document.symbols.get(instance.libraryItemName);
				movieClip = new XFLMovieClip(xfl, symbolItem.timeline);
				// TODO: a.drewke, hack to inject timeline name into symbol instance if it has no name
				if ((instance.name == null || instance.name == "") && symbolItem.timeline.name != null && symbolItem.timeline.name != "") {
					instance.name = symbolItem.timeline.name;
				}
				if (instance.name != null && instance.name != "") {
					movieClip.name = instance.name;
				}
				break;
			}
		}
		if (movieClip != null) {
			if (instance.matrix != null) {
				movieClip.transform.matrix = instance.matrix;
			}
			if (instance.color != null) {	
				movieClip.transform.colorTransform = instance.color;
			}
			movieClip.cacheAsBitmap = instance.cacheAsBitmap;
			if (instance.exportAsBitmap) {
				movieClip.flatten();
			}
		}
		return movieClip;
	}

	private static function createSprite(xfl: XFL, instance: DOMSymbolInstance): XFLSprite {
		var sprite: XFLSprite = null;
		for (document in xfl.documents) {
			if (document.symbols.exists(instance.libraryItemName)) {
				var symbolItem = document.symbols.get(instance.libraryItemName);
				sprite = new XFLSprite(xfl, symbolItem.timeline);
				// TODO: a.drewke, hack to inject timeline name into symbol instance if it has no name
				if ((instance.name == null || instance.name == "") && symbolItem.timeline.name != null && symbolItem.timeline.name != "") {
					instance.name = symbolItem.timeline.name;
				}
				if (instance.name != null && instance.name != "") {
					sprite.name = instance.name;
				}
				break;
			}
		}
		if (sprite != null) {
			if (instance.matrix != null) {
				sprite.transform.matrix = instance.matrix;
			}
			if (instance.color != null) {	
				sprite.transform.colorTransform = instance.color;
			}
			sprite.cacheAsBitmap = instance.cacheAsBitmap;
			if (instance.exportAsBitmap) {
				sprite.flatten();
			}
		}
		return sprite;
	}

	public static function createComponent(xfl: XFL, instance: DOMComponentInstance): DisplayObject {
		var component: DisplayObject = null;
		for (document in xfl.documents) {
			if (document.symbols.exists(instance.libraryItemName)) {
				var symbolItem = document.symbols.get(instance.libraryItemName);
				var className: String = symbolItem.linkageClassName;
				if (StringTools.startsWith(className, "fl.")) className = "openfl." + className.substr("fl.".length);
				var classType: Class<Dynamic> = Type.resolveClass(className);
				component = Type.createInstance(classType, [xfl, symbolItem.timeline]);
				if (instance.name != null && instance.name != "") {
					component.name = instance.name;
				}
				// TODO: a.drewke, take parent classes into account
				var instanceFields: Array<String> = Type.getInstanceFields(classType);
				for (variable in instance.variables) {
					if (instanceFields.indexOf(variable.variable) == -1) {
						trace("createComponent(): component has no variable '" + variable.variable + "'");
					} else {
						switch(variable.type) {
							case "List":
								Reflect.setProperty(component, variable.variable, variable.defaultValue);
							case "Boolean":
								Reflect.setProperty(component, variable.variable, variable.defaultValue == "true");
							case "Number": 
								Reflect.setProperty(component, variable.variable, Std.parseFloat(variable.defaultValue));
							default:
								trace("createComponent(): unknown variable type '" + variable.type + "'");
						}
					}
				}
				break;
			}
		}
		if (component != null) {
			if (instance.matrix != null) {
				component.transform.matrix = instance.matrix;
			}
		}
		return component;
	}

}
