using Toybox.Application;
using Toybox.Position;
using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.Time;
using Toybox.Lang as Lang;

class AvalancheDangerApp extends Application.AppBase {

    var url="https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/"; //{X}/{Y}/2/{Startdato}/{Sluttdato};
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

        System.println(pos.position.toDegrees());

        if(pos.position.toDegrees()[0] == 0){
            // Creating test pos in Tromsø
            System.println("No valid recorded position, requesting gps");

            // Creates a position in Tromsø
            var locString = "69.6489, 18.9551";
            var myLoc = Position.parse(locString, Position.GEO_DEG); // -> Location
            System.println("Tromsø loc: " + myLoc.toDegrees());
            self.makeRequest(myLoc.toDegrees());
            // Position.enableLocationEvents({
            //                                 :acquisitionType => Position.LOCATION_ONE_SHOT, 
            //                                 :constellations => [Position.CONSTELLATION_GPS], 
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

        var date  = self.getDate();

        // self.url += loc[0].toString() + "/" + loc[1].toString() + "/" + language[:norwegian]+ "/" + date + "/" + date;
        // Location is the "weakest link"
        self.url += "69.648900/18.955100"+ "/" + language[:norwegian]+ "/" + date + "/" + date;

        // Converts string to string (works)
        self.url = self.url.toString(); 
        // self.url = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/69.648900/18.955100/1/";
        // self.url = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/69.648900/18.955100/1/";
        // Communications.makeWebRequest(self.url, null, {:method => Communications.HTTP_REQUEST_METHOD_GET}, method(:onRecieve));
        System.println(self.url);

        var url2 = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/69.648900/18.955100/1/2022-02-17/2022-02-17";

        System.println(self.url.equals(url2));

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
            // :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            };

        var params = {};

        Communications.makeWebRequest(self.url, params, options, method(:onRecieve));

        
    }

    function getDate() {
        var day, month;

        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        // Add zero to get correct format of month
        if (today.month < 10) {
            month = "0" + today.month;
        } else {
            month = today.month;
        }

        // Add zero to get correct format of day
        if (today.day < 10) {
            day = "0" + today.day;
        } else {
            day = today.day;
        }

        var str = (today.year +"-"+ month +"-"+ day);

        // System.println(str);
        return str;
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