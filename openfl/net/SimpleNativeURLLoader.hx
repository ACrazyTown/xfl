package openfl.net;

import haxe.io.Bytes;
import haxe.Timer;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import sys.Http;
import sys.thread.Thread;

class SimpleNativeURLLoader extends EventDispatcher {
	public static inline var GET:String = "GET";
	public static inline var POST:String = "POST";

	public var data:Dynamic;
	public var dataFormat:URLLoaderDataFormat;

	private var request:URLRequest;
	private var http:Http;
	private var responseCode:Int;
	private var responseHeaders:Array<URLRequestHeader>;
	private var uri:String;

	private var timer:Timer;
	private var ioThread:Thread;
	private var ioThreadFinished:Bool;

	public function new(request:URLRequest = null) {
		super();
		dataFormat = URLLoaderDataFormat.TEXT;
		ioThreadFinished = true;
		if (request != null) {
			load(request);
		}
	}

	public function close():Void {}

	public function load(request:URLRequest):Void {
		if (ioThreadFinished == false) {
			trace("load(): a request is already pending: " + uri);
			return;
		}
		this.request = request;
		ioThreadFinished = false;
		data = null;
		responseCode = 0;
		responseHeaders = [];
		uri = null;

		uri = request.url;
		var postData:String = null;
		var query:String = "";
		if (Std.is(request.data, Dynamic) == true) {
			for (key in Reflect.fields(request.data)) {
				if (query.length > 0)
					query += "&";
				query += StringTools.urlEncode(key) + "=" + StringTools.urlEncode(Std.string(Reflect.field(request.data, key)));
			}
			if (query != "") {
				if (request.method == GET) {
					if (uri.indexOf("?") > -1) {
						uri += "&" + query;
					} else {
						uri += "?" + query;
					}
					query = "";
				} else {
					postData = query;
				}
			}
		} else {
			postData = request.data;
		}

		//
		http = new Http(uri);
		http.onError = onError;
		http.onData = onData;
		http.onStatus = onStatus;

		//
		switch (request.method) {
			case GET:
			case POST:
				if (postData != null) {
					http.setPostData(postData);
				}
		}

		var headers = [];
		headers.push("Expect: ");

		var contentType = null;
		for (header in request.requestHeaders) {
			if (header.name == "Content-Type") {
				contentType = header.value;
			} else {
				http.setHeader(header.name, header.value);
			}
		}
		if (request.contentType != null) {
			contentType = request.contentType;
		}
		if (contentType == null) {
			if (query != "") {
				contentType = "application/x-www-form-urlencoded";
			} else if (request.data != null) {
				contentType = "application/octet-stream";
			}
		}
		if (contentType != null) {
			http.setHeader("Content-Type", contentType);
		}
		http.setHeader("User-Agent", request.userAgent == null ? "libcurl-agent/1.0" : request.userAgent);

		timer = new Timer(Math.ceil(1000.0 / 60.0));
		timer.run = timerRun;

		ioThread = Thread.create(threadRun);
	}

	private function dispatchStatus():Void {
		var event = new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS, false, false, responseCode);
		event.responseURL = uri;
		event.responseHeaders = responseHeaders;
		dispatchEvent(event);
	}

	// Event Handlers
	private function dispatchError():Void {
		dispatchStatus();
		if (responseCode == 403) {
			var event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
			event.text = Std.string(responseCode);
			dispatchEvent(event);
		} else {
			var event = new IOErrorEvent(IOErrorEvent.IO_ERROR);
			event.text = Std.string(responseCode);
			dispatchEvent(event);
		}
	}

	private function onError(msg:String):Void {
		trace("onError(): " + msg);
		responseCode = -1;
		ioThreadFinished = true;
	}

	private function onStatus(status:Int):Void {
		responseCode = status;
	}

	private function onData(data:String):Void {
		this.data = data;
		ioThreadFinished = true;
	}

	private function threadRun():Void {
		http.request(request.method == POST ? true : false);
		ioThreadFinished = true;
		ioThread = null;
	}

	private function timerRun():Void {
		if (ioThreadFinished == false) {
			/*
				var event = new ProgressEvent(ProgressEvent.PROGRESS);
				event.bytesLoaded = writeBytesLoaded;
				event.bytesTotal = writeBytesTotal;
				dispatchEvent(event);
			 */
			return;
		}
		//
		timer.stop();
		timer = null;
		if (responseCode < 200 || responseCode >= 399) {
			dispatchError();
		} else {
			if (dataFormat == BINARY) {
				dispatchStatus();
				var event = new Event(Event.COMPLETE);
				dispatchEvent(event);
			} else {
				dispatchStatus();
				var event = new Event(Event.COMPLETE);
				dispatchEvent(event);
			}
		}
	}
}
