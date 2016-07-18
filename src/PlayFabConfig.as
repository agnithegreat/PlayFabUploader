/**
 * Created by agnither on 05.05.16.
 */
package
{
    import flash.net.SharedObject;

    public class PlayFabConfig
    {
        public static var CDN: Boolean = true;
        public static var manifest: Object;
        public static var newManifest: Object;
        
        private static var _config: Object = {};
        public static function get config():Object
        {
            return _config;
        }
        
        public static function set config(data: Object):void
        {
            trace("set config");
            _config = data || {};
        }

        public static function get created():Boolean
        {
            return _config != null && _config["created"];
        }

        public static function load():void
        {
            var config: SharedObject = SharedObject.getLocal("config.json");
            _config = config.data["data"];
        }

        public static function save():void
        {
            _config["created"] = true;
            var config: SharedObject = SharedObject.getLocal("config.json");
            config.data["data"] = _config;
            config.flush();
        }

        public static function upgrade():void
        {
            for (var path: String in _config)
            {
                if (path.search("/") > 0)
                {
                    var md5: String = _config[path];
                    setMD5(path, md5);
                    delete _config[path];
                }
            }
        }

        public static function getMD5(path: String):String
        {
            var nodes: Array = path.split("/");
            var child: Object = _config;
            for (var i:int = 0; i < nodes.length; i++)
            {
                var node: String = nodes[i];
                if (!child.hasOwnProperty(node))
                {
                    return null;
                }
                child = child[node];
            }
            return child as String;
        }

        public static function setMD5(path: String, md5: String):void
        {
            var nodes: Array = path.split("/");
            var child: Object = _config;
            for (var i:int = 0; i < nodes.length; i++)
            {
                var node: String = nodes[i];
                if (!child.hasOwnProperty(node))
                {
                    child[node] = {};
                }
                if (i < nodes.length-1)
                {
                    child = child[node];
                } else if (md5 != null) {
                    child[node] = md5;
                } else {
                    delete child[node];
                }
            }
        }
        
        public static function hasFile(path: String):Boolean
        {
            return getMD5(path) != null;
        }
    }
}
