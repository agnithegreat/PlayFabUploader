/**
 * Created by agnither on 05.05.16.
 */
package requests
{
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequestMethod;

    public class DownloadFileRequest extends AbstractRequest
    {
        public function DownloadFileRequest(url: String, dataFormat: String = URLLoaderDataFormat.TEXT)
        {
            super(url, null, null, URLRequestMethod.GET, dataFormat);
        }
    }
}
