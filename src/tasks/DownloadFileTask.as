/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.events.TaskEvent;
    import com.agnither.tasks.global.TaskSystem;
    import com.playfab.PlayFabError;
    import com.playfab.PlayFabServerAPI;
    import com.playfab.ServerModels.GetContentDownloadUrlRequest;
    import com.playfab.ServerModels.GetContentDownloadUrlResult;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.net.URLLoaderDataFormat;

    import requests.AbstractRequest;
    import requests.DownloadFileRequest;

    public class DownloadFileTask extends SimpleTask
    {
        private var _filename: String;
        public function get filename():String
        {
            return _filename;
        }
        
        private var _saveTo: File;
        private var _binary: Boolean;

        public function DownloadFileTask(filename: String, saveTo: File = null, binary: Boolean = false)
        {
            _filename = filename;
            _saveTo = saveTo;
            _binary = binary;

            super();

            // TODO: update for a new SimpleTask notation
        }

        override public function execute():void
        {
            super.execute();

            PlayFabServerAPI.GetContentDownloadUrl(new GetContentDownloadUrlRequest({
                "Key": _filename,
                "ThruCDN": PlayFabConfig.CDN
            }), handleSuccess, handleError);
        }

        private function handleSuccess(result: GetContentDownloadUrlResult):void
        {
            var request: AbstractRequest = new DownloadFileRequest(result.URL, _binary ? URLLoaderDataFormat.BINARY : URLLoaderDataFormat.TEXT);
            request.addEventListener(Event.COMPLETE, handleDownloadComplete);
            request.addEventListener(ProgressEvent.PROGRESS, handleProgress);
            request.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
            request.load();
        }

        private function handleProgress(event: ProgressEvent):void
        {
            progress(event.bytesLoaded / event.bytesTotal);
        }

        private function handleError(error: PlayFabError):void
        {
            trace("error: " + error.errorMessage);
            trace("trying again");
            execute();
        }

        private function handleDownloadComplete(event: Event):void
        {
            var request: AbstractRequest = event.currentTarget as AbstractRequest;
            _result = request.data;
            request.removeEventListener(Event.COMPLETE, handleDownloadComplete);
            request.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
            request.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
            request.destroy();
            
            var task: SaveFileTask = new SaveFileTask(_result, _saveTo, _binary);
            task.addEventListener(TaskEvent.COMPLETE, handleSaveComplete);
            TaskSystem.getInstance().addTask(task);
        }

        private function handleSaveComplete(event: TaskEvent):void
        {
            complete();
        }

        private function handleIOError(event: IOErrorEvent):void
        {
            trace(event.text);
            complete();
        }
    }
}
