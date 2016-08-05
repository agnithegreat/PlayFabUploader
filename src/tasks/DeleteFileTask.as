/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.playfab.AdminModels.BlankResult;
    import com.playfab.AdminModels.DeleteContentRequest;
    import com.playfab.PlayFabAdminAPI;
    import com.playfab.PlayFabError;

    public class DeleteFileTask extends SimpleTask
    {
        private var _path: String;
        
        public function DeleteFileTask(path: String)
        {
            _path = path;
            
            super();

            // TODO: update for a new SimpleTask notation
        }

        override public function execute(token: Object):void
        {
            super.execute(token);

            PlayFabAdminAPI.DeleteContent(new DeleteContentRequest({
                "Key": _path
            }), handleSuccess, handleError);
        }

        private function handleSuccess(result: BlankResult):void
        {
            _result = _path;
            complete();
        }

        private function handleError(error: PlayFabError):void
        {
            throw new Error(error.errorMessage);
        }
    }
}
