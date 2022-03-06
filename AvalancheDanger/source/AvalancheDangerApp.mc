using Toybox.Application;
using Toybox.Position;
using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.Time;
using Toybox.Lang as Lang;
using Toybox.BluetoothLowEnergy as BLE;

class AvalancheDangerApp extends Application.AppBase {

    var storageKey = "storageKey";

    var data;

    var url = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/"; //{X}/{Y}/2/{Startdato}/{Sluttdato};
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

        // Creates progressbar object
        // progressBar = new WatchUi.ProgressBar("Press select to get data", null);
        // Pushing view to the screen
        // WatchUi.pushView(self.progressBar);

        // establishConnection();

        appInitView = new AppInitView();

    }

    function checkStorageData() {

        try {
            self.data = Application.Storage.getValue("storageKey");
            // System.println("self.data = " + self.data);

        } catch (e instanceof Lang.Exception) {
            System.println(e.getErrorMessage());
        }

        return;
    }

    function checkDate() {
        self.avDate = self.data[0]["ValidFrom"].toString();
        // System.println(self.avDate);

        var currDate = getDate().toString();
        // var date;

        var index = self.avDate.find("T");
        if (index != null) {
            self.avDate = self.avDate.substring(0, index).toString();
        }

        // System.println(self.avDate);
        // System.println(currDate);
        // System.println(self.avDate.equals(currDate));
        return self.avDate.equals(currDate);
    }

    function establishConnection() {
        // Application.Storage.clearValues();

        try {
            self.data = Application.Storage.getValue("storageKey");
            // System.println("self.data = " + self.data);

        } catch (e instanceof Lang.Exception) {
            System.println(e.getErrorMessage());
        }

        if (self.data != null) {

            if (self.checkDate()) {

                self.dataExists();

            } else {
                progressBar.setDisplayString("Checking Wifi...");
                // System.println(BLE.getAvailableConnectionCount().toString());

                // Communications.checkWifiConnection(method(:connectionStatusCallback));
                self.getPosition();

            }

        } else {

            progressBar.setDisplayString("Checking Wifi...");
            // System.println(BLE.getAvailableConnectionCount().toString());

            // Communications.checkWifiConnection(method(:connectionStatusCallback));
            self.getPosition();

        }

        // var mySettings = System.getDeviceSettings();
        // var phone = mySettings.phoneConnected;

        // progressBar.setDisplayString("Phone connected: " + phone.toString());



        // SOME BLE TESTING
        // var test = BLE.getAvailableConnectionCount();
        // // var test = BLE.cccdUuid();

        // progressBar.setDisplayString("BLE count: " + test);

        // if (test != 0) {
        //     var obj = BLE.getPairedDevices().next();

        //     // var obj = iter.next();

        //     progressBar.setDisplayString("Name: " + obj.isConnected().toString());

        // }



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

        System.println(loc.toString());

        // self.url += loc[0].toString() + "/" + loc[1].toString() + "/" + language[:norwegian]+ "/" + date + "/" + date;
        // Location is the "weakest link"
        var path2 = ("69.648900/18.955100" + "/" + language[:norwegian]+ "/" + date + "/" + date);
        // var path = (loc[0].toString() + "/" + loc[1].toString() + "/" + language[:norwegian]+ "/" + date + "/" + date);
        self.url += path2.toString();

        // Converts string to string (works)
        self.url = self.url.toString(); 

        // self.url = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/69.648900/18.955100/1/";
        // self.url = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/69.648900/18.955100/1/";

        System.println(self.url);
        // System.println(path);

        // var url2 = "https://api01.nve.no/hydrology/forecast/avalanche/v6.0.1/api/AvalancheWarningByCoordinates/Detail/69.648900/18.955100/1/2022-02-17/2022-02-17";

        // System.println(path.equals(path2));

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
            System.println("Data size = " + data.size());
            System.println("-> Dangerlevel is: " + data[0]["DangerLevel"]);
            // System.println("-> Dangerlevel name is: " + data[0]["DangerLevelName"]);

            self.data = data;

            // self.avDanger = data[0]["DangerLevel"].toNumber();
            // self.avDangerName = data[0]["DangerLevelName"].toString();
            // System.println("Test -> " + self.avDangerName);

            // self.avDangerRegion = data[0]["RegionName"].toString();
            self.setVariables(data);
            
            Application.Storage.setValue("storageKey", self.data);

            // WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);

            WatchUi.requestUpdate();
            WatchUi.switchToView(new AvalancheDangerView(), new InputDelegate(), WatchUi.SLIDE_IMMEDIATE);

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

    function dataExists() {

        self.setVariables(self.data);
        
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);

        WatchUi.requestUpdate();
        WatchUi.pushView(new AvalancheDangerView(), new InputDelegate(), WatchUi.SLIDE_IMMEDIATE);
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

        // var test = ["test value"];
        // if (self.checkDate() == 0) {
        //     // Application.Storage.deleteValue("storageKey");
        //     // Application.Storage.setValue("storageKey", self.data);
        // }

    }

    // Return the initial view of your application here
    function getInitialView() {
        // return [ new AvalancheDangerView(), new InputDelegate()];
        return [self.appInitView, new InitDelegate()];

    }

}