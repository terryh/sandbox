package {
    import flash.external.ExternalInterface;
    public class Debug
    {
        public function log(msg:String):void{
            ExternalInterface.call("console.log",msg);
        } 
        public function info(msg:String):void{
            ExternalInterface.call("console.info",msg);
        } 
        public function error(msg:String):void{
            ExternalInterface.call("console.error",msg);
        } 
        public function debug(msg:String):void{
            ExternalInterface.call("console.debug",msg);
        } 
        public function warn(msg:String):void{
            ExternalInterface.call("console.warn",msg);
        } 
        public function trace(msg:String):void{
            ExternalInterface.call("console.trace",msg);
        } 
    }
}
