/**
 * Created by agnither on 05.05.16.
 */
package
{
    import by.blooddy.crypto.MD5;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;

    public class FileData
    {
        public var file: File;
        public var path: String;
        public var version: int;
        public var mimeType: String;
        public var bytes: ByteArray;
        public var md5: String;
        public var oldMD5: String;
        
        public function get pathWithVersion():String
        {
            return version > 0 ? path + "." + version : path;
        }

        public function load():void
        {
            bytes = new ByteArray();
            var stream: FileStream = new FileStream();
            stream.open(file, FileMode.READ);
            stream.readBytes(bytes);
            stream.close();

            md5 = MD5.hashBytes(bytes);
        }
        
        public function clear():void
        {
            bytes.clear();
            bytes = null;
        }
        
        public static function getFileData(file: File, relative: File, manifest: Object):FileData
        {
            var data: FileData = new FileData();
            data.file = file;
            data.path = relative.getRelativePath(file);
            data.mimeType = getMimeType(file.name);
            data.version = getVersion(manifest[data.path]);
            
            return data;
        }

        public static function getFileDataFromBytes(path: String, bytes: ByteArray):FileData
        {
            var data: FileData = new FileData();
            data.path = path;
            data.bytes = bytes;
            data.mimeType = getMimeType(path);

            return data;
        }
        
        private static function getMimeType(name: String):String
        {
            var mimeTypes: Object = {};
            mimeTypes["DS_Store"] = "";
            mimeTypes["zip"] = "application/zip";
            mimeTypes["xml"] = "application/xml";
            mimeTypes["json"] = "application/json";
            mimeTypes["png"] = "image/png";
            mimeTypes["atf"] = "application/octet-stream";
            mimeTypes["gaf"] = "application/octet-stream";
            mimeTypes["mp3"] = "audio/mpeg";

            for (var type:String in mimeTypes)
            {
                if (name.search("."+type) >= 0)
                {
                    return mimeTypes[type];
                }
            }
            trace("no MimeType for ", name);
            return null;
        }
        
        private static function getVersion(path: String):int
        {
            return path == null ? 0 : path.split(".").reverse()[0];
        }
    }
}
