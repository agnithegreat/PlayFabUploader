/**
 * Created by agnither on 05.05.16.
 */
package requests
{
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;

    public class UploadFileRequest extends AbstractRequest
    {
        public function UploadFileRequest(url: String, fileData: ByteArray, mimeType: String)
        {
            var headers: Array = [
                new URLRequestHeader("Content-Type", mimeType),
                new URLRequestHeader("Cache-Control", 'no-cache')
            ];
            
            super(url, fileData, headers, URLRequestMethod.PUT);
        }
    }
}
