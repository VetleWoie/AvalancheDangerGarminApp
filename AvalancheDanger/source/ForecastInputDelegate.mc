using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;

class ForecastInputDelegate extends WatchUi.BehaviorDelegate{
    function initialize() {
        BehaviorDelegate.initialize();
        System.println("Initializing forecast behavior delegate");
    }
    function onMenu(){
        System.println("Menu button pressed!");
    }

    function onSelect(){
        System.println("Select button pressed!");
        var problemId = Application.getApp().avProblems;
        System.println(problemId);
        WatchUi.pushView(new AvalancheProblemView(10), new ProblemInputDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }
    
    function onNextPage(){
        System.println("NextPage pressed!");
    }

    function onNextMode(){
        System.println("NextMode pressed!");
    }
}

