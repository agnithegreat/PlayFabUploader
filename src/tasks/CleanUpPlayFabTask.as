/**
 * Created by agnither on 05.05.16.
 */
package tasks
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.playfab.AdminModels.BlankResult;
    import com.playfab.AdminModels.ContentInfo;
    import com.playfab.AdminModels.DeleteContentRequest;
    import com.playfab.AdminModels.GetContentListRequest;
    import com.playfab.AdminModels.GetContentListResult;
    import com.playfab.PlayFabAdminAPI;
    import com.playfab.PlayFabError;

    public class CleanUpPlayFabTask extends SimpleTask
    {
        private var _list: Vector.<ContentInfo>;
        
        public function CleanUpPlayFabTask()
        {
            super();
        }

        override public function execute():void
        {
            super.execute();

            var request: GetContentListRequest = new GetContentListRequest();
            PlayFabAdminAPI.GetContentList(request, onGetContentComplete, onError);
        }

        private function onGetContentComplete(result: GetContentListResult):void
        {
            _list = result.Contents;
            onDeleteContentComplete(null);
        }

        private function onDeleteContentComplete(result: BlankResult):void
        {
            if (result != null)
            {
                trace("deleted");
            }
            if (_list.length > 0)
            {
                var file: ContentInfo = _list.shift();
                var request: DeleteContentRequest = new DeleteContentRequest();
                request.Key = file.Key;
                trace(request.Key);
                PlayFabAdminAPI.DeleteContent(request, onDeleteContentComplete, onError);
            } else {
                complete();
            }
        }

        private function onError(err: PlayFabError):void
        {
            error(err.errorMessage);
        }
    }
}
