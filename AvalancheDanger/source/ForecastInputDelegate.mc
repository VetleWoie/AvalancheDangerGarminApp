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
        var avProblems = Application.getApp().avProblems;
        var problemId;
        System.println("Select button pressed!");
        if(avProblems.size() != 0){
            problemId = avProblems[0]["AvalancheProblemTypeId"];
        }else{
            return false;
        }
        WatchUi.pushView(new AvalancheProblemView(problemId), new ProblemInputDelegate(0), WatchUi.SLIDE_LEFT);
        return true;
    }
    
    function onNextPage(){
        System.println("NextPage pressed!");
    }

    function onNextMode(){
        System.println("NextMode pressed!");
    }
}

