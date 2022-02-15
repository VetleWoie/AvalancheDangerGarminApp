using Toybox.Application;
using Toybox.Position;
using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Lang as Lang;

class AvalancheDangerApp extends Application.AppBase {

    var url="https://api01.nve.no/hydrology/forecast/avalanche/v6.0.0/api/AvalancheWarningByCoordinates/Detail/"; //{X}/{Y}/2/{Startdato}/{Sluttdato};
    // var langkey=2;
    var date;
    var loc;

    var language = { :norwegian => "1", :english => "2"};

    // Storing data
    var avDanger=-1;
    var avDangerName = "";
    var avDangerRegion = "";
    var avMainText = "";
    
    var avDate = "";

    var avProblems = [];
    // var

    var appInitView;
    var progressBar;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {

        System.println("On start...");

        appInitView = new AppInitView();
        // var test = new AppInitView();
        // WatchUi.pushView(test, null, WatchUi.SLIDE_DOWN);

        // self.establishConnection();

        // var pos = Position.getInfo();
        // // var pos = new Position.Location.initialize({:latitude => 69.6613, :longitude => 18.9503, :format => :radians});

        // System.println(pos.position.toDegrees());
        // if(pos.position.toDegrees()[0] == 0){
        //     // Creating test pos in Tromsø
        //     System.println("No valid recorded position, requesting gps");
        //     // Creates a position in Tromsø
        //     var locString = "69.6613, 18.9503";
        //     var myLoc = Position.parse(locString, Position.GEO_DEG); // -> Location
        //     System.println("Tromsø loc: " + myLoc.toDegrees());
        //     self.makeRequest(myLoc.toDegrees());
        //     // Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        // }else{
        //     System.println("Using recorded position");
        //     self.makeRequest(pos.position.toDegrees());
        // }
    }


    function establishConnection() {
        
        progressBar.setDisplayString("Checking Wifi...");

        Communications.checkWifiConnection(method(:connectionStatusCallback));

    }

    function connectionStatusCallback(info) {
        System.println("Wifi Available: "+ info[:wifiAvailable]);
        System.println("Wifi error code: "+ info[:errorCode]);

        if (info[:wifiAvailable] == true) {
            progressBar.setDisplayString("Wifi connection OK");
            // progressBar.setProgress(25);

            getPosition();
        }
        else {
            progressBar.setDisplayString("No Wifi connection");
            return;
        }

        return;
    }

    function getPosition() {
        progressBar.setDisplayString("Checking position...");
        
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
            // Position.enableLocationEvents({
            //                                 :acquisitionType => Position.LOCATION_ONE_SHOT, 
            //                                 :constellations => [Position.CONSTELLATION_GPS, Position.CONSTELLATION_GALILEO], 
            //                             },
            //                                 method(:onPosition)
            //                         );
        }else{
            System.println("Using recorded position");

            self.makeRequest(pos.position.toDegrees());
        }
    }

    function makeRequest(loc){
        progressBar.setDisplayString("Making request...");

        // self.url += loc[0].toString() + "/" + loc[1].toString() + "/" + language["norwegian"]; // Hardcored date for testing
        self.url = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/69.6489/18.9551/1/2022-02-15/2022-02-15";
        // Communications.makeWebRequest(self.url, null, {:method => Communications.HTTP_REQUEST_METHOD_GET}, method(:onRecieve));

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
            // :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            };

        var params = {};

        Communications.makeWebRequest(self.url, params, options, method(:onRecieve));

        
    }

    function onPosition(info){
        progressBar.setDisplayString("New position...");

        System.println("onPosition");
        self.loc = info.position.toDegrees();
        System.println("Latitude: " + self.loc[0]);
        self.makeRequest(self.loc);
        return;
    }

    function onRecieve(responseCode, data){
        if(responseCode == 200 and data != null){
            
            progressBar.setDisplayString("Data received!");

            System.println("Response recieved!");
            System.println("-> Dangerlevel is: " + data[0]["DangerLevel"]);
            // System.println("-> Dangerlevel name is: " + data[0]["DangerLevelName"]);

            // self.avDanger = data[0]["DangerLevel"].toNumber();
            // self.avDangerName = data[0]["DangerLevelName"].toString();
            // System.println("Test -> " + self.avDangerName);

            // self.avDangerRegion = data[0]["RegionName"].toString();
            self.setVariables(data);
        
            WatchUi.requestUpdate();
            WatchUi.pushView(new AvalancheDangerView(), new InputDelegate(), WatchUi.SLIDE_IMMEDIATE);

        }else{

            progressBar.setDisplayString("Error: " + responseCode);

            System.print(responseCode);
            System.print(" ");
            System.println(data);
            self.avDanger = -1;
            self.avDangerName = "None";
        }
        


        return;
    }

    function setVariables(data){

        self.avDanger = data[0]["DangerLevel"].toNumber();
        self.avDangerName = data[0]["DangerLevelName"].toString();
        System.println("Test ");
        System.println("Test -> " + self.avDangerName);

        self.avDangerRegion = data[0]["RegionName"].toString();

        self.avMainText = data[0]["MainText"].toString();

        self.avDate = data[0]["ValidFrom"].toString();

        self.avProblems = data[0]["AvalancheProblems"];
    }

    function testFunc() {
        System.print("Test call");
        return 1;
    }
    
    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        // return [ new AvalancheDangerView(), new InputDelegate()];
        return [ appInitView, new InitDelegate()];

    }

}