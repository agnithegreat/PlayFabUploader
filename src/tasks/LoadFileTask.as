/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;

    import flash.events.Event;
    import flash.events.ProgressEvent;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;

    public class LoadFileTask extends SimpleTask
    {
        private var _file: File;
        private var _binary: Boolean;

        private var _stream: FileStream;

        public function LoadFileTask(file: File, binary: Boolean)
        {
            _file = file;
            _binary = binary;

            super();
        }

        override public function execute(token: Object):void
        {
            super.execute(token);
            
            if (_file.exists)
            {
                _stream = new FileStream();
                _stream.addEventListener(ProgressEvent.PROGRESS, handleProgress);
                _stream.addEventListener(Event.COMPLETE, handleComplete);
                _stream.openAsync(_file, FileMode.READ);
            } else {
                complete();
            }
        }

        private function handleProgress(event:ProgressEvent):void
        {
            progress(event.bytesLoaded / event.bytesTotal);
        }

        private function handleComplete(event:Event):void
        {
            if (_binary)
            {
                var bytes: ByteArray = new ByteArray();
                _stream.readBytes(bytes);
                _result = bytes;
            } else {
                var text: String = _stream.readUTFBytes(_stream.bytesAvailable);
                _result = text;
            }

            _stream.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
            _stream.removeEventListener(Event.COMPLETE, handleComplete);
            _stream.close();
            _stream = null;

            trace(_file.name + " loaded");

            complete();
        }
    }
}
