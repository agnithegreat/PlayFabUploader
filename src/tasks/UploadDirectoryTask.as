/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.MultiTask;
    import com.agnither.tasks.abstract.SimpleTask;

    import flash.filesystem.File;

    public class UploadDirectoryTask extends MultiTask
    {
        private var _directory: File;
        private var _manifest: Object;

        public function UploadDirectoryTask(directory: File, manifest: Object)
        {
            _directory = directory;
            _manifest = manifest;

            super();
        }
        
        override public function execute():void
        {
            uploadRecursively(_directory);
            
            super.execute();
        }

        private function uploadRecursively(file: File):void
        {
            if (file.isDirectory)
            {
                var list: Array = file.getDirectoryListing();
                for (var i:int = 0; i < list.length; i++)
                {
                    uploadRecursively(list[i]);
                }
            } else if (file.name.search(".DS_Store") < 0)
            {
                var fileData: FileData = FileData.getFileData(file, _directory, _manifest);
                fileData.oldMD5 = PlayFabConfig.getMD5(fileData.path);
                addTask(new CheckFileTask(fileData));
            }
        }
        
        override protected function taskComplete(task: SimpleTask):void
        {
            var file: FileData = task.result as FileData;
            if (file.oldMD5 != file.md5)
            {
                _manifest[file.path] = file.pathWithVersion;

                trace(file.pathWithVersion + " uploaded");
                PlayFabConfig.setMD5(file.path, file.md5);
                PlayFabConfig.save();
                file.clear();
            }
            super.taskComplete(task);
        }
    }
}
