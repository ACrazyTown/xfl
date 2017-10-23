package xfl.symbol;

import xfl.dom.DOMRectangle;

class Rectangle extends ShapeBase {

	public var domRectangle: DOMRectangle;

	public function new(domRectangle: DOMRectangle) {
		super ();
		this.domRectangle = domRectangle;
		/*
		commands = [];
		fillStyles = readFillStyles(domRectangle);
		lineStyles = readLineStyles(domRectangle);
		var penX = 0.0;
		var penY = 0.0;
		var currentFill0 = -1;
		var currentFill1 = -1;
		var currentLine = -1;
		var edges = new Array<RenderCommand>();
		var fills = new Array<ShapeEdge>();
		for (edge in domShape.edges) {
			var newLineStyle = (edge.strokeStyle > -1 && edge.strokeStyle != currentLine);
			var newFillStyle0 = (edge.fillStyle0 > -1 && edge.fillStyle0 != currentFill0);
			var newFillStyle1 = (edge.fillStyle1 > -1 && edge.fillStyle1 != currentFill1);			
			if (newFillStyle0) {
				currentFill0 = edge.fillStyle0;
			}
			if (newFillStyle1) {
				currentFill1 = edge.fillStyle1;
			}
			if (newLineStyle) {
				var lineStyle = edge.strokeStyle;
				var func = lineStyles[lineStyle];
				edges.push (func);
				currentLine = lineStyle;
			}
			var data = edge.edges;
			if (data != null && data != "") {
				data = StringTools.replace (data, "!", " ! ");
				data = StringTools.replace (data, "|", " | ");
				data = StringTools.replace (data, "/", " | ");
				data = StringTools.replace (data, "[", " [ ");
				data = StringTools.replace (data, "]", " [ ");
				var cmds = data.split (" ");
				for (i in 0...cmds.length) {
					switch (cmds[i]) {
						case "!":
							var px = Std.parseInt (cmds[i + 1]) / 20;
							var py = Std.parseInt (cmds[i + 2]) / 20;
							edges.push (function (g:Graphics) {
								g.moveTo (px, py);
							});
							penX = px;
							penY = py;
						case "|":
							var px = Std.parseInt (cmds[i + 1]) / 20;
							var py = Std.parseInt (cmds[i + 2]) / 20;
							if (currentLine > 0) {
								edges.push (function (g:Graphics) {
									g.lineTo (px, py);
								});
							} else {
								edges.push (function (g:Graphics) {
									g.moveTo (px, py);
								});
							}
							if (currentFill0 > 0) {
								fills.push (ShapeEdge.line (currentFill0, penX, penY, px, py));
							}
							if (currentFill1 > 0) {
								fills.push (ShapeEdge.line (currentFill1, px, py, penX, penY));
							}
							penX = px;
							penY = py;
						case "[":
							var cx = parseHexCmd(cmds[i + 1].split (".")[0]) / 20;
							var cy = parseHexCmd(cmds[i + 2].split (".")[0]) / 20;
							var px = parseHexCmd(cmds[i + 3].split (".")[0]) / 20;
							var py = parseHexCmd(cmds[i + 4].split (".")[0]) / 20;
							if (currentLine > 0) {
								edges.push (function (g:Graphics) {
									g.curveTo (cx, cy, px, py);
								});
							}
							if (currentFill0 > 0) {	
								fills.push (ShapeEdge.curve (currentFill0, penX, penY, cx, cy, px, py));
							}
							if (currentFill1 > 0) {	
								fills.push (ShapeEdge.curve (currentFill1, px, py, cx, cy, penX, penY));
							}
							penX = px;
							penY = py;
					}
				}
			}
		}
		flushCommands (edges, fills);
		for (command in commands) {
			command (this.graphics);
		}
		*/
		trace("DOMRectangle: " + domRectangle.x + ", " +  domRectangle.y + ", " + domRectangle.width + ", " + domRectangle.height);
		graphics.beginFill(0xFF0000, 1.0);
		graphics.drawRect(domRectangle.x, domRectangle.y, domRectangle.width, domRectangle.height);
		graphics.endFill();
	}

}
