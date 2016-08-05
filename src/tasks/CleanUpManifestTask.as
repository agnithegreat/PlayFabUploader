/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;

    import flash.filesystem.File;

    public class CleanUpManifestTask extends SimpleTask
    {
        private var _directory: File;
        private var _manifest: Object;

        public function CleanUpManifestTask(directory: File, manifest: Object)
        {
            _directory = directory;
            _manifest = manifest;

            super();
        }

        override public function execute(token: Object):void
        {
            super.execute(token);

            for (var key: String in _manifest)
            {
                var file: File = _directory.resolvePath(key);
                if (!file.exists)
                {
                    if (_manifest[key].charAt(0) != "-")
                    {
                        _manifest[key] = "-" + _manifest[key];
                    }
                } else if (_manifest[key].charAt(0) == "-")
                {
                    _manifest[key] = _manifest[key].substr(1);
                }
            }

            complete();
        }
    }
}
