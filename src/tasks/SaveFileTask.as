/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;

    import flash.events.Event;
    import flash.events.OutputProgressEvent;
    import flash.events.ProgressEvent;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;

    public class SaveFileTask extends SimpleTask
    {
        private var _file: Object;
        private var _saveTo: File;
        private var _binary: Boolean;

        private var _stream: FileStream;

        public function SaveFileTask(file: Object, saveTo: File = null, binary: Boolean = false)
        {
            _file = file;
            _saveTo = saveTo;
            _binary = binary;

            super();
        }

        override public function execute():void
        {
            super.execute();

            _stream = new FileStream();
            _stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, handleProgress);
            _stream.addEventListener(Event.COMPLETE, handleComplete);
            _stream.openAsync(_saveTo, FileMode.WRITE);
            if (_binary)
            {
                _stream.writeBytes(_file as ByteArray);
            } else {
                _stream.writeUTFBytes(_file as String);
            }
        }

        private function handleProgress(event:OutputProgressEvent):void
        {
            var value: Number = 1 - event.bytesPending / event.bytesTotal;
            progress(value);
            if (value == 1)
            {
                handleComplete(null);
            }
        }

        private function handleComplete(event:Event):void
        {
            _stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, handleProgress);
            _stream.removeEventListener(Event.COMPLETE, handleComplete);
            _stream.close();
            _stream = null;

            trace(_saveTo.name + " saved");

            complete();
        }
    }
}
