/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.events.TaskEvent;

    import flash.filesystem.File;
    import flash.utils.ByteArray;

    public class CheckDirectoryTask extends SimpleTask
    {
        private var _directory: File;
        private var _manifest: Object;

        public function CheckDirectoryTask(directory: File, manifest: Object)
        {
            _directory = directory;
            _manifest = manifest;

            super();
        }

        override public function execute():void
        {
            super.execute();
            
            PlayFabConfig.load();
            trace(JSON.stringify(PlayFabConfig.config));
            if (PlayFabConfig.created)
            {
                handleConfigLoaded(null);
            } else {
                var task: DownloadFileTask = new DownloadFileTask("config.json");
                task.addEventListener(TaskEvent.COMPLETE, handleConfigLoaded);
                task.execute();
            }
        }

        private function handleConfigLoaded(event: TaskEvent):void
        {
            if (event != null)
            {
                PlayFabConfig.config = JSON.parse(event.data as String);
                PlayFabConfig.save();
            }

            var task: UploadDirectoryTask = new UploadDirectoryTask(_directory, _manifest);
            task.addEventListener(TaskEvent.COMPLETE, handleUploadDirectoryComplete);
            task.execute();
        }

        private function handleUploadDirectoryComplete(event: TaskEvent):void
        {
            var task: CleanUpManifestTask = new CleanUpManifestTask(_directory, _manifest);
            task.addEventListener(TaskEvent.COMPLETE, handleCleanUpManifestComplete);
            task.execute();
        }
                               
        private function handleCleanUpManifestComplete(event: TaskEvent):void
        {
            var bytes: ByteArray = new ByteArray();
            bytes.writeUTFBytes(JSON.stringify(PlayFabConfig.config));

            var fileData: FileData = FileData.getFileDataFromBytes("config.json", bytes);

            var task: UploadFileTask = new UploadFileTask(fileData);
            task.addEventListener(TaskEvent.COMPLETE, handleUploadConfigComplete);
            task.execute();
        }

        private function handleUploadConfigComplete(event: TaskEvent):void
        {
            var saveFile: File = File.applicationDirectory.resolvePath("config/manifest.json");
            saveFile = new File(saveFile.nativePath);
            
            var task: SaveFileTask = new SaveFileTask(JSON.stringify(_manifest), saveFile);
            task.addEventListener(TaskEvent.COMPLETE, handleSaveManifestComplete);
            task.execute();
        }

        private function handleSaveManifestComplete(event: TaskEvent):void
        {
            trace("DONE");
            complete();
        }
    }
}
