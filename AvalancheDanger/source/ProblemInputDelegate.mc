using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class ProblemInputDelegate extends WatchUi.BehaviorDelegate{

    var index;
    var problems;

    function initialize(idx) {
        BehaviorDelegate.initialize();
        System.println("Initializing problem behavior delegate");
        System.println(idx);
        self.problems = Application.getApp().avProblems;
        self.index = idx;
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
        self.index = self.index + 1;
        self.index = self.index % self.problems.size();
        var problemId = problems[self.index]["AvalancheProblemTypeId"];
        WatchUi.switchToView(new AvalancheProblemView(problemId), new ProblemInputDelegate(self.index), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage(){
        System.println("PrevPage pressed");
        self.index--;
        if(self.index < 0){
            self.index = self.problems.size() - 1;
        }
        var problemId = problems[self.index]["AvalancheProblemTypeId"];
        WatchUi.switchToView(new AvalancheProblemView(problemId), new ProblemInputDelegate(self.index), WatchUi.SLIDE_DOWN);
        return true;
    }

    function onNextMode(){
        System.println("NextMode pressed!");
    }
}

