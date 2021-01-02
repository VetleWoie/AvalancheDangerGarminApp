using Toybox.System;
using Toybox.WatchUi;

class InputDelegate extends WatchUi.BehaviorDelegate{
    function initialize() {
        BehaviorDelegate.initialize();
        System.println("Initializing behavior delegate");
    }
    function onMenu(){
        System.println("Menu button pressed!");
    }

    function onSelect(){
        System.println("Select button pressed!");
        return true;
        
    }
}

