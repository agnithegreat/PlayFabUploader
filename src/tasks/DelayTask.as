/**
 * Created by agnither on 06.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;

    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    public class DelayTask extends SimpleTask
    {
        private var _delay: Number;
        
        private var _id: int;
        
        public function DelayTask(delay: Number)
        {
            _delay = delay;
            
            super();
        }
        
        override public function execute():void
        {
            super.execute();
            
            _id = setTimeout(complete, _delay * 1000);
            progress(1);
        }
        
        override protected function complete():void
        {
            clearTimeout(_id);
            
            super.complete();
        }
    }
}
