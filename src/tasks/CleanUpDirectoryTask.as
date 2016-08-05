/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.MultiTask;
    import com.agnither.tasks.abstract.SimpleTask;

    import flash.filesystem.File;

    public class CleanUpDirectoryTask extends MultiTask
    {
        private var _directory: File;
        private var _checkIfExist: Boolean;

        public function CleanUpDirectoryTask(directory: File, checkIfExist: Boolean)
        {
            _directory = directory;
            _checkIfExist = checkIfExist;

            super();

            // TODO: update for a new SimpleTask notation
        }

        override public function execute(token: Object):void
        {
            cleanUpRecursively(PlayFabConfig.config);
            
            super.execute(token);
        }

        private function cleanUpRecursively(node: Object, path: String = ""):void
        {
            for (var key: String in node)
            {
                if (node[key] is String)
                {
                    var file: File = _directory.resolvePath(path + key);
                    if (!_checkIfExist || !file.exists)
                    {
                        addTask(new DeleteFileTask(path + key))
                    }
                } else {
                    cleanUpRecursively(node[key], path + key + "/");
                }
            }
        }

        override protected function taskComplete(task: SimpleTask):void
        {
            var path: String = task.result as String;
            trace(path + " removed");
            PlayFabConfig.setMD5(path, null);
            PlayFabConfig.save();
        }
    }
}
