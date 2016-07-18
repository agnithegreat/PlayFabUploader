/**
 * Created by agnither on 05.05.16.
 */
package
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.events.TaskEvent;
    import com.playfab.PlayFabSettings;

    import flash.display.Sprite;
    import flash.filesystem.File;

    import tasks.CheckDirectoryTask;
    import tasks.CleanUpPlayFabTask;
    import tasks.LoadFileTask;

    public class PFUploader extends Sprite
    {
        private var _config: Object;
        private var _manifest: Object;
        private var _directory: File;

        public function PFUploader()
        {
            var task: LoadFileTask = new LoadFileTask(File.applicationDirectory.resolvePath("PlayFab_config.json"), false);
            task.addEventListener(TaskEvent.COMPLETE, handleLoadConfig);
            task.execute();
        }

        private function handleLoadConfig(event: TaskEvent):void
        {
            var task: SimpleTask = event.currentTarget as SimpleTask;
            _config = JSON.parse(task.result as String);
            task.removeEventListener(TaskEvent.COMPLETE, handleLoadConfig);
            task.destroy();

            PlayFabSettings.TitleId = _config["appID"];
            PlayFabSettings.DeveloperSecretKey = _config["secret"];

            _directory = File.applicationDirectory.resolvePath(_config["assets"]);

            task = new LoadFileTask(File.applicationDirectory.resolvePath("config/manifest.json"), false);
            task.addEventListener(TaskEvent.COMPLETE, handleLoadManifest);
            task.execute();
        }

        private function handleLoadManifest(event: TaskEvent):void
        {
            var task: SimpleTask = event.currentTarget as SimpleTask;
            _manifest = JSON.parse(task.result as String);
            task.removeEventListener(TaskEvent.COMPLETE, handleLoadManifest);
            task.destroy();

            init();
        }

        private function init():void
        {
            var task: CheckDirectoryTask = new CheckDirectoryTask(_directory, _manifest);
            task.execute();

            // WARNING: IT DELETES ALL CONTENTS FROM PLAYFAB CDN
//            var task: CleanUpPlayFabTask = new CleanUpPlayFabTask();
//            task.execute();
        }
    }
}
