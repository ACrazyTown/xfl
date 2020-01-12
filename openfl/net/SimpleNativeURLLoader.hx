package openfl.net;

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

	public function new(request: URLRequest = null)
	{
		super();

		bytesLoaded = 0;
		bytesTotal = 0;
		dataFormat = URLLoaderDataFormat.TEXT;

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

		var data: Bytes = null;
		var query: String = "";
		var uri: String = request.url;
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
		trace("load(): " + uri + ": " + data);
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
		/*
		if (parent.enableResponseHeaders)
		{
				parent.responseHeaders = [];
				curl.setOption(HEADERFUNCTION, curl_onHeader);
		}
		*/
		curl.setOption(CURLOption.SSL_VERIFYPEER, false);
		curl.setOption(CURLOption.SSL_VERIFYHOST, 0);
		curl.setOption(CURLOption.USERAGENT, request.userAgent == null?"libcurl-agent/1.0":request.userAgent);
		// curl.setOption (CONNECTTIMEOUT, 30);
		curl.setOption(CURLOption.NOSIGNAL, true);
		curl.setOption(CURLOption.TRANSFERTEXT, dataFormat != URLLoaderDataFormat.BINARY);
		// curl.setOption(CURLOption.VERBOSE, true);
		curl.perform();
		curl.reset();
		if (dataFormat == BINARY)
			{
				__dispatchStatus();
				this.data = bytes;
				var event = new Event(Event.COMPLETE);
				dispatchEvent(event);
			}
			else
			{
				__dispatchStatus();
				this.data = bytes.toString();
				var event = new Event(Event.COMPLETE);
				dispatchEvent(event);
			}
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

	private function __dispatchStatus(): Void
	{
		/*
		var event = new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS, false, false, __httpRequest.responseStatus);
		event.responseURL = __httpRequest.uri;

		var headers = new Array<URLRequestHeader>();

		#if (lime && !display && !macro && !doc_gen)
		if (__httpRequest.enableResponseHeaders && __httpRequest.responseHeaders != null)
		{
			for (header in __httpRequest.responseHeaders)
			{
				headers.push(new URLRequestHeader(header.name, header.value));
			}
		}
		#end
		event.responseHeaders = headers;
		dispatchEvent(event);
		*/
	}

	// Event Handlers
	private function httpRequest_onError(error: Dynamic): Void
	{
		__dispatchStatus();
		/*
		if (error == 403)
		{
			var event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
			event.text = Std.string(error);
			dispatchEvent(event);
		}
		else
		{
			var event = new IOErrorEvent(IOErrorEvent.IO_ERROR);
			event.text = Std.string(error);
			dispatchEvent(event);
		}
		*/
	}

	private function httpRequest_onProgress(bytesLoaded: Int, bytesTotal: Int): Void
	{
		var event = new ProgressEvent(ProgressEvent.PROGRESS);
		event.bytesLoaded = bytesLoaded;
		event.bytesTotal = bytesTotal;
		dispatchEvent(event);
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
		trace("curl_onProgress(): " + dltotal + " / " + dlnow + " / " + uptotal + " / " + upnow);
		if (upnow > writeBytesLoaded || dlnow > writeBytesLoaded || uptotal > writeBytesTotal || dltotal > writeBytesTotal)
		{
				if (upnow > writeBytesLoaded) writeBytesLoaded = Std.int(upnow);
				if (dlnow > writeBytesLoaded) writeBytesLoaded = Std.int(dlnow);
				if (uptotal > writeBytesTotal) writeBytesTotal = Std.int(uptotal);
				if (dltotal > writeBytesTotal) writeBytesTotal = Std.int(dltotal);
		}
		trace("curl_onProgress(): " + writeBytesLoaded + " / " + writeBytesTotal);
	}
}
