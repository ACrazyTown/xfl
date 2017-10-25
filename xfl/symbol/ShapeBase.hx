package xfl.symbol;

import xfl.symbol.Symbol;
import xfl.symbol.ShapeEdge;
import xfl.dom.DOMShapeBase;
import xfl.fill.LinearGradient;
import xfl.fill.SolidColor;
import xfl.fill.RadialGradient;
import xfl.stroke.SolidStroke;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.GraphicsPath;
import openfl.display.GraphicsPathWinding;

class ShapeBase extends openfl.display.Shape {

	private var commands: Array<RenderCommand>;
	private var fillStyles: Array<RenderCommand>;
	private var lineStyles: Array<RenderCommand>;

    private function new() {
        super();
	    commands = [];
	    fillStyles = [];
	    lineStyles = [];
    }

	private function flushCommands(edges: Array<RenderCommand>, fills: Array<ShapeEdge>) {
		var graphicsPathCommands: Array<GraphicsPathCommand> = new Array<GraphicsPathCommand>();
		var left = fills.length;
		while (left > 0) {
			var first = fills[0];
			fills[0] = fills[--left];
			if (first.fillStyle >= fillStyles.length) {
				continue;
			}
			commands.push(fillStyles[first.fillStyle]);
			graphicsPathCommands.push(function(graphicsPath: GraphicsPath) { 
				graphicsPath.moveTo(first.x0, first.y0);
			});
			graphicsPathCommands.push(first.asCommand());
			var prev = first;
			var done = false;
			while (!done) {
				var found = false;
				for (i in 0...left) {
					if (prev.connects(fills[i])) {
						prev = fills[i];
						fills[i] = fills[--left];
						graphicsPathCommands.push(prev.asCommand());
						found = true;
						if (prev.connects(first)) {
							done = true;
						}
						break;
					}
				}
				if (!found) {
					break;
				}
			}
		}
		if (graphicsPathCommands.length > 0) {
			var graphicsPath: GraphicsPath = new GraphicsPath();
			graphicsPath.winding = GraphicsPathWinding.EVEN_ODD;
			for (graphicsPathCommand in graphicsPathCommands) {
				graphicsPathCommand(graphicsPath);
			}
			commands.push(function(gfx: Graphics) {
				gfx.drawPath(graphicsPath.commands, graphicsPath.data, graphicsPath.winding);
			});
		}
		if (fills.length > 0) {
			commands.push(function(gfx: Graphics) {
				gfx.endFill();
			});
		}
		commands = commands.concat(edges);
		if (edges.length > 0) {
			commands.push(function(gfx: Graphics) {
				gfx.lineStyle();
			});
		}
	}

	private function readFillStyles(domShape: DOMShapeBase): Array<RenderCommand> {
		var result = [];
		result.push(function(g:Graphics) {
			g.endFill();
		});
		for (fillStyle in domShape.fills) {
			if (Std.is(fillStyle.data, SolidColor)) {
				var color = fillStyle.data.color;
				var alpha = fillStyle.data.alpha;
				result.push(function (g:Graphics) {
					g.beginFill(color, alpha);
				});
			} else 
			if (Std.is(fillStyle.data, LinearGradient)) {
				var data: LinearGradient = cast fillStyle.data;
				var colors : Array<UInt> = [];
				var alphas : Array<Float> = [];
				var ratios : Array<Int> = [];
				for (entry in data.entries) {
					colors.push(entry.color);
					alphas.push(entry.alpha);
					ratios.push(Std.int(0xFF * entry.ratio));
				}
				result.push(function(g:Graphics) {	
					g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, data.matrix);
				});
			} else 
			if (Std.is(fillStyle.data, RadialGradient)) {
				#if !html5
				var data: RadialGradient = cast fillStyle.data;
				var colors : Array<UInt> = [];
				var alphas : Array<Float> = [];
				var ratios : Array<Int> = [];
				for (entry in data.entries) {
					colors.push(entry.color);
					alphas.push(entry.alpha);
					ratios.push(Std.int(0xFF * entry.ratio));
				}
				result.push(function(g: Graphics) {	
					g.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, data.matrix);
				});
				#end
			}
		}
		return result;
	}

	private function readLineStyles(domShape: DOMShapeBase): Array<RenderCommand> {
		var result = [];
		result.push(function(g: Graphics) {
			g.lineStyle();
		});
		for (strokeStyle in domShape.strokes) {
			if (Std.is(strokeStyle.data, SolidStroke)) {
				if (Std.is(strokeStyle.data.fill, SolidColor)) {
					var weight = strokeStyle.data.weight;
					var color = strokeStyle.data.fill.color;
					var alpha = strokeStyle.data.fill.alpha;
					result.push(function (g: Graphics) { g.lineStyle(weight, color, alpha); } );
				}
			}
		}
		return result;
	}

	public function render(graphics: Graphics) {
		for (command in commands) {
			command(graphics);
		}
	}

}
