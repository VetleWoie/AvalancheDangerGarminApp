using Toybox.Application;
using Toybox.Position;
using Toybox.Communications;
using Toybox.WatchUi;

class AvalancheDangerApp extends Application.AppBase {

    var url="https://api01.nve.no/hydrology/forecast/avalanche/v6.0.0/api/AvalancheWarningByCoordinates/Simple/"; //{X}/{Y}/2/{Startdato}/{Sluttdato};
    var langkey=2;
    var date;
    var loc;
    var avDanger=-1;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        var pos = Position.getInfo();
        System.println(pos.position.toDegrees());
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
    }

    function onPosition(info){
        self.loc = info.position.toDegrees();
        System.println(self.loc);
        self.url += self.loc[0].toString() + "/" + self.loc[1].toString() + "/" + self.langkey.toString() + "/";
        Communications.makeWebRequest(self.url, null, {:method => Communications.HTTP_REQUEST_METHOD_GET}, method(:onRecieve));
        return;
    }

    function onRecieve(responseCode, data){
        if(responseCode == 200){
            System.println("Response recieved!");
            System.println("Dangerlevel is: " + data[0]["DangerLevel"]);
            self.avDanger = data[0]["DangerLevel"].toNumber();
        }else{
            self.avDanger = -1;
        }
        WatchUi.requestUpdate();
        return;
    }
    
    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new AvalancheDangerView() ];

    }

}