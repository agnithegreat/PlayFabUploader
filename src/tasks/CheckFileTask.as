/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.events.TaskEvent;
    import com.agnither.tasks.global.TaskSystem;

    public class CheckFileTask extends SimpleTask
    {
        private var _file: FileData;
        
        public function CheckFileTask(file: FileData)
        {
            _file = file;
            
            super();
        }

        override public function execute(token: Object):void
        {
            _file.load();

            if (_file.oldMD5 != _file.md5)
            {
                _file.version++;
                var task: UploadFileTask = new UploadFileTask(_file);
                task.addEventListener(TaskEvent.COMPLETE, handleUploadComplete);
                TaskSystem.getInstance().addTask(task);
            } else {
                handleUploadComplete(null);
            }

            super.execute(token);
        }

        private function handleUploadComplete(event: TaskEvent):void
        {
            if (event != null)
            {
                var task: UploadFileTask = event.currentTarget as UploadFileTask;
                task.removeEventListener(TaskEvent.COMPLETE, handleUploadComplete);
            }
            
            _result = _file;
            complete();
        }
    }
}
