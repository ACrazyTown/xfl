package openfl.net;

import lime.net.curl.CURLInfo;
import haxe.io.Bytes;

import lime.net.curl.CURL;
import lime.net.curl.CURLCode;
import lime.net.curl.CURLOption;

import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;

class SimpleNativeURLLoader extends EventDispatcher
{
	public static inline var HEAD: String = "HEAD";
	public static inline var GET: String = "GET";
	public static inline var POST: String = "POST";
	public static inline var PUT: String = "PUT";

	public var bytesLoaded: Int;
	public var bytesTotal: Int;
	public var writeBytesLoaded: Int;
	public var writeBytesTotal: Int;
	public var writePosition: Int;

	public var data: Dynamic;
	public var dataFormat: URLLoaderDataFormat;

	private var curl: CURL;
	private var bytes: Bytes;
	private var responseCode: Int;
	private var responseHeaders: Array<URLRequestHeader>;
	private var uri: String;

	public function new(request: URLRequest = null)
	{
		super();

		bytesLoaded = 0;
		bytesTotal = 0;
		dataFormat = URLLoaderDataFormat.TEXT;
		responseHeaders = [];

		if (request != null)
		{
			load(request);
		}
	}

	public function close():Void
	{
	}

	public function load(request: URLRequest):Void
	{
		bytes = Bytes.alloc(0);

		bytesLoaded = 0;
		bytesTotal = 0;
		writeBytesLoaded = 0;
		writeBytesTotal = 0;
		writePosition = 0;

		if (curl == null)
		{
				curl = new CURL();
		}
		else
		{
				curl.reset();
		}

		uri = request.url;
		var data: Bytes = null;
		var query: String = "";
		if (Std.is(request.data, Dynamic) == true)
		{
				for (key in Reflect.fields(request.data))
				{
						if (query.length > 0) query += "&";
						query += StringTools.urlEncode(key) + "=" + StringTools.urlEncode(Std.string(Reflect.field(request.data, key)));
				}
				if (query != "")
				{
						if (request.method == GET)
						{
								if (uri.indexOf("?") > -1)
								{
										uri += "&" + query;
								}
								else
								{
										uri += "?" + query;
								}
								query = "";
						}
						else
						{
								data = Bytes.ofString(query);
						}
				}
		} else {
			data = cast request.data;
		}
		curl.setOption(URL, uri);
		switch (request.method)
		{
				case HEAD:
						curl.setOption(CURLOption.NOBODY, true);
				case GET:
						curl.setOption(CURLOption.HTTPGET, true);
				case POST:
						curl.setOption(CURLOption.POST, true);
						if (data != null)
						{
								curl.setOption(CURLOption.INFILE, data);
								curl.setOption(CURLOption.INFILESIZE, data.length);
								curl.setOption(CURLOption.POSTFIELDSIZE, data.length);
						}
						else
						{
								curl.setOption(CURLOption.POSTFIELDSIZE, 0);
						}
				case PUT:
						curl.setOption(CURLOption.UPLOAD, true);
						if (data != null)
						{
								curl.setOption(CURLOption.INFILE, data);
								curl.setOption(CURLOption.INFILESIZE, data.length);
						}
				default:
						curl.setOption(CURLOption.CUSTOMREQUEST, Std.string(request.method));

						if (data != null)
						{
								curl.setOption(CURLOption.INFILE, data);
								curl.setOption(CURLOption.INFILESIZE, data.length);
						}
		}
		curl.setOption(CURLOption.FOLLOWLOCATION, request.followRedirects);
		curl.setOption(CURLOption.AUTOREFERER, true);

		var headers = [];
		headers.push("Expect: ");

		var contentType = null;
		for (header in cast(request.requestHeaders, Array<Dynamic>))
		{
				if (header.name == "Content-Type")
				{
						contentType = header.value;
				}
				else
				{
						headers.push('${header.name}: ${header.value}');
				}
		}
		if (request.contentType != null)
		{
				contentType = request.contentType;
		}
		if (contentType == null)
		{
				if (query != "")
				{
						contentType = "application/x-www-form-urlencoded";
				} else
				if (request.data != null)
				{
						contentType = "application/octet-stream";
				}
	
		}
		if (contentType != null)
		{
				headers.push("Content-Type: " + contentType);
		}
		curl.setOption(CURLOption.HTTPHEADER, headers);
		curl.setOption(CURLOption.PROGRESSFUNCTION, curl_onProgress);
		curl.setOption(CURLOption.WRITEFUNCTION, curl_onWrite);
		curl.setOption(HEADERFUNCTION, curl_onHeader);
		curl.setOption(CURLOption.SSL_VERIFYPEER, false);
		curl.setOption(CURLOption.SSL_VERIFYHOST, 0);
		curl.setOption(CURLOption.USERAGENT, request.userAgent == null?"libcurl-agent/1.0":request.userAgent);
		curl.setOption (CONNECTTIMEOUT, 30);
		curl.setOption(CURLOption.NOSIGNAL, true);
		curl.setOption(CURLOption.TRANSFERTEXT, dataFormat != URLLoaderDataFormat.BINARY);
		// curl.setOption(CURLOption.VERBOSE, true);
		curl.perform();
		responseCode = curl.getInfo(CURLInfo.RESPONSE_CODE);
		if (responseCode < 200 || responseCode >= 399) {
			dispatchError();
		} else {
			if (dataFormat == BINARY)
			{
				dispatchStatus();
				this.data = bytes;
				var event = new Event(Event.COMPLETE);
				dispatchEvent(event);
			}
			else
			{
				dispatchStatus();
				this.data = bytes.toString();
				var event = new Event(Event.COMPLETE);
				dispatchEvent(event);
			}
		}
		curl.reset();
	}

	private function growBuffer(length:Int)
	{
		if (length > bytes.length)
		{
			var cacheBytes = bytes;
			bytes = Bytes.alloc(length);
			bytes.blit(0, cacheBytes, 0, cacheBytes.length);
		}
	}

	private function dispatchStatus(): Void
	{
		var event = new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS, false, false, responseCode);
		event.responseURL = uri;
		event.responseHeaders = responseHeaders;
		dispatchEvent(event);
	}

	// Event Handlers
	private function dispatchError(): Void
	{
		dispatchStatus();
		if (responseCode == 403)
		{
			var event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
			event.text = Std.string(responseCode);
			dispatchEvent(event);
		}
		else
		{
			var event = new IOErrorEvent(IOErrorEvent.IO_ERROR);
			event.text = Std.string(responseCode);
			dispatchEvent(event);
		}
	}

	private function curl_onHeader(curl:CURL, header:String):Void
	{
		var parts = header.split(': ');
		if (parts.length == 2)
		{
			responseHeaders.push(new URLRequestHeader(StringTools.trim(parts[0]), StringTools.trim(parts[1])));
		}
	}

	private function curl_onWrite(curl : CURL, output: Bytes): Int
	{
		growBuffer(writePosition + output.length);
		bytes.blit(writePosition, output, 0, output.length);
		writePosition += output.length;
		return output.length;
	}
	
	private function curl_onProgress(curl: CURL, dltotal: Float, dlnow: Float, uptotal: Float, upnow: Float): Void
	{
		if (upnow > writeBytesLoaded || dlnow > writeBytesLoaded || uptotal > writeBytesTotal || dltotal > writeBytesTotal)
		{
			if (upnow > writeBytesLoaded) writeBytesLoaded = Std.int(upnow);
			if (dlnow > writeBytesLoaded) writeBytesLoaded = Std.int(dlnow);
			if (uptotal > writeBytesTotal) writeBytesTotal = Std.int(uptotal);
			if (dltotal > writeBytesTotal) writeBytesTotal = Std.int(dltotal);
			/*
			var event = new ProgressEvent(ProgressEvent.PROGRESS);
			event.bytesLoaded = bytesLoaded;
			event.bytesTotal = bytesTotal;
			dispatchEvent(event);
			*/
		}
	}
}
