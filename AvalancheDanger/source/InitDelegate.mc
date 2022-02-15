using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;

class MyProgressDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        return true;
    }
}

class InitDelegate extends WatchUi.BehaviorDelegate{

    var progressBar;


    function initialize() {
        BehaviorDelegate.initialize();
        System.println("Initializing behavior delegate");

    }

    function onMenu(){
        System.println("Menu button pressed!");
        // return true;
        // Application.getApp().establishConnection();
    }

    function onSelect(){
        System.println("Select button pressed!");
        
        // Creates progressbar object
        Application.getApp().progressBar = new WatchUi.ProgressBar("Processing...", null);
        // Pushing view to the screen
        WatchUi.pushView(Application.getApp().progressBar, new MyProgressDelegate(), WatchUi.SLIDE_DOWN);

        Application.getApp().establishConnection();


        return true;

    }

    function test () {
        // progressBar.setDisplayString("test");
        // progressBar.setProgress(15);
        System.println("test");

        return;
    }

}