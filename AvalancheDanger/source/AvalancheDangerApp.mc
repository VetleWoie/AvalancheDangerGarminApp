using Toybox.Application;
using Toybox.Position;
using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;

class AvalancheDangerApp extends Application.AppBase {

    var url="https://api01.nve.no/hydrology/forecast/avalanche/v6.0.0/api/AvalancheWarningByCoordinates/Detail/"; //{X}/{Y}/2/{Startdato}/{Sluttdato};
    var langkey=2;
    var date;
    var loc;

    // Storing data
    var avDanger=-1;
    var avDangerName = "";
    var avDangerRegion = "";
    var avMainText = "";
    // var

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {

        // var test = new AppInitView();
        // WatchUi.pushView(test, null, WatchUi.SLIDE_DOWN);

        // System.println("On start...");
        var pos = Position.getInfo();
        // var pos = new Position.Location.initialize({:latitude => 69.6613, :longitude => 18.9503, :format => :radians});

        System.println(pos.position.toDegrees());
        if(pos.position.toDegrees()[0] == 0){
            // Creating test pos in Tromsø
            System.println("No valid recorded position, requesting gps");
            // Creates a position in Tromsø
            var locString = "69.6613, 18.9503";
            var myLoc = Position.parse(locString, Position.GEO_DEG); // -> Location
            System.println("Tromsø loc: " + myLoc.toDegrees());
            self.makeRequest(myLoc.toDegrees());
            // Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        }else{
            System.println("Using recorded position");
            self.makeRequest(pos.position.toDegrees());
        }
    }

    function makeRequest(loc){
        self.url += loc[0].toString() + "/" + loc[1].toString() + "/" + langkey.toString() + "/" + "2021-05-12/2021-05-12"; // Hardcored date for testing
        // self.url = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.0/api/AvalancheWarningByCoordinates/Simple/69.6489/18.9551/1/2021-05-12/2021-05-12";
        Communications.makeWebRequest(self.url, null, {:method => Communications.HTTP_REQUEST_METHOD_GET}, method(:onRecieve));
    }

    function onPosition(info){
        System.println("onPosition");
        self.loc = info.position.toDegrees();
        System.println("Latitude: " + self.loc[0]);
        self.makeRequest(self.loc);
        return;
    }

    function onRecieve(responseCode, data){
        if(responseCode == 200 and data != null){
            System.println("Response recieved!");
            System.println("-> Dangerlevel is: " + data[0]["DangerLevel"]);
            // System.println("-> Dangerlevel name is: " + data[0]["DangerLevelName"]);

            // self.avDanger = data[0]["DangerLevel"].toNumber();
            // self.avDangerName = data[0]["DangerLevelName"].toString();
            // System.println("Test -> " + self.avDangerName);

            // self.avDangerRegion = data[0]["RegionName"].toString();
            self.setVariables(data);

        }else{
            System.print(responseCode);
            System.print(" ");
            System.println(data);
            self.avDanger = -1;
            self.avDangerName = "None";
        }
        WatchUi.requestUpdate();
        return;
    }

    function setVariables(data){
        self.avDanger = data[0]["DangerLevel"].toNumber();
        self.avDangerName = data[0]["DangerLevelName"].toString();
        System.println("Test -> " + self.avDangerName);

        self.avDangerRegion = data[0]["RegionName"].toString();

        self.avMainText = data[0]["MainText"].toString();
    }
    
    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new AvalancheDangerView(), new InputDelegate()];

    }

}