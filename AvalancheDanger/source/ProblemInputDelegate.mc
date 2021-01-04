using Toybox.System;
using Toybox.WatchUi;

class ProblemInputDelegate extends WatchUi.BehaviorDelegate{
    function initialize() {
        BehaviorDelegate.initialize();
        System.println("Initializing problem behavior delegate");
    }

    function onMenu(){
        System.println("Menu button pressed!");
    }

    function onSelect(){
        System.println("Select button pressed!");
        return true;
    }
    
    function onNextPage(){
        System.println("NextPage pressed!");
    }

    function onPreviousPage(){
        System.println("PrevPage pressed");
    }

    function onNextMode(){
        System.println("NextMode pressed!");
    }
}

