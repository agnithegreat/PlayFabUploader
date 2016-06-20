/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.playfab.AdminModels.GetContentUploadUrlRequest;
    import com.playfab.AdminModels.GetContentUploadUrlResult;
    import com.playfab.PlayFabAdminAPI;
    import com.playfab.PlayFabError;

    import flash.events.Event;

    import requests.AbstractRequest;
    import requests.UploadFileRequest;

    public class UploadFileTask extends SimpleTask
    {
        private var _file: FileData;
        
        public function UploadFileTask(file: FileData)
        {
            _file = file;
            
            super();
        }

        override public function execute():void
        {
            super.execute();

            PlayFabAdminAPI.GetContentUploadUrl(new GetContentUploadUrlRequest({
                "Key": _file.pathWithVersion,
                "ContentType": _file.mimeType
            }), handleSuccess, handleError);
        }

        private function handleSuccess(result: GetContentUploadUrlResult):void
        {
            var request: AbstractRequest = new UploadFileRequest(result.URL, _file.bytes, _file.mimeType);
            request.addEventListener(Event.COMPLETE, handleUploadComplete);
            request.load();
        }

        private function handleError(error: PlayFabError):void
        {
            throw new Error(error.errorMessage);
        }

        private function handleUploadComplete(event: Event):void
        {
            var request: AbstractRequest = event.currentTarget as AbstractRequest;
            request.removeEventListener(Event.COMPLETE, handleUploadComplete);
            request.destroy();

            _result = _file;
            complete();
        }
    }
}
