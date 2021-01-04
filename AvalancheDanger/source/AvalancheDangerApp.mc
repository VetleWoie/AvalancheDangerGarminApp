using Toybox.Application;
using Toybox.Position;
using Toybox.Communications;
using Toybox.WatchUi;

class AvalancheDangerApp extends Application.AppBase {

    var url="https://api01.nve.no/hydrology/forecast/avalanche/v6.0.0/api/AvalancheWarningByCoordinates/Detail/"; //{X}/{Y}/2/{Startdato}/{Sluttdato};
    var langkey=2;
    var date;
    var loc;
    var avDanger=-1;
    var avProblems=[];

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        var pos = Position.getInfo();
        System.println(pos.position.toDegrees());
        if(pos.position.toDegrees()[0] == 0){
            System.println("No valid recorded position, requesting gps");
            Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        }else{
            System.println("Using recorded position");
            self.makeRequest(pos.position.toDegrees());
        }
    }

    function makeRequest(loc){
        self.url += loc[0].toString() + "/" + loc[1].toString() + "/" + langkey.toString() + "/";
        Communications.makeWebRequest(self.url, null, {:method => Communications.HTTP_REQUEST_METHOD_GET}, method(:onRecieve));
    }

    function onPosition(info){
        self.loc = info.position.toDegrees();
        self.makeRequest(self.loc);
        return;
    }

    function onRecieve(responseCode, data){
        if(responseCode == 200 and data != null){
            System.println("Response recieved!");
            System.println("Dangerlevel is: " + data[0]["DangerLevel"]);
            self.avDanger = data[0]["DangerLevel"].toNumber();
            self.avProblems = data[0]["AvalancheProblems"];
        }else{
            System.print(responseCode);
            System.print(" ");
            System.println(data);
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
        return [ new AvalancheForecastView(), new ForecastInputDelegate() ];

    }

}