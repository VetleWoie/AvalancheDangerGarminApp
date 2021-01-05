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
        var problemId = Application.getApp().avProblems[0]["AvalancheProblemTypeId"];
        WatchUi.pushView(new AvalancheProblemView(problemId), new ProblemInputDelegate(0), WatchUi.SLIDE_RIGHT);
        return true;
    }
    
    function onNextPage(){
        System.println("NextPage pressed!");
    }

    function onNextMode(){
        System.println("NextMode pressed!");
    }
}

