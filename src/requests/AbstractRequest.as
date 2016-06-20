/**
 * Created by agnither on 05.05.16.
 */
package requests
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;

    public class AbstractRequest extends EventDispatcher
    {
        private var _urlLoader: URLLoader;
        private var _urlRequest: URLRequest;

        public function get data():Object
        {
            return _urlLoader.data;
        }

        public function AbstractRequest(url: String, data: * = null, headers: Array = null, method: String = URLRequestMethod.GET, dataFormat: String = URLLoaderDataFormat.TEXT)
        {
            _urlRequest = new URLRequest(url);
            if (data != null)
                _urlRequest.data = data;
            if (headers != null)
                _urlRequest.requestHeaders = headers;
            _urlRequest.method = method;

            _urlLoader = new URLLoader();
            _urlLoader.dataFormat = dataFormat;
            _urlLoader.addEventListener(Event.COMPLETE, handleComplete);
            _urlLoader.addEventListener(ProgressEvent.PROGRESS, handleProgress);
            _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
            _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
        }

        public function load():void
        {
            _urlLoader.load(_urlRequest);
        }

        private function handleComplete(event: Event):void
        {
            dispatchEvent(event);
        }

        private function handleProgress(event: ProgressEvent):void
        {
            dispatchEvent(event);
        }

        private function handleSecurityError(event: SecurityErrorEvent):void
        {
            trace("securityErrorHandler:" + event);
        }

        private function handleIOError(event: IOErrorEvent):void
        {
            trace("ioErrorHandler: " + event);
            dispatchEvent(event);
        }

        public function destroy():void
        {
            _urlLoader.close();
            _urlLoader.removeEventListener(Event.COMPLETE, handleComplete);
            _urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
            _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
            _urlLoader = null;

            _urlRequest = null;
        }
    }
}
