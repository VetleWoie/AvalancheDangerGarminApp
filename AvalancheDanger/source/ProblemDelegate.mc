using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class ProblemDelegate extends WatchUi.BehaviorDelegate {
    
    // var problems;
    var arr = [];
    var test;
    var index = 0;

    function initialize(view, problemInfo) {
        // Menu2InputDelegate.initialize();
        self.arr.add(view);
        self.arr.add(new ProblemCompassView(problemInfo));
    }

    // On select button pressed handling
    function onSelect() {
        
        System.println("Selected.. " + self.arr);

    }

    function onNextPage() {
        System.println("Nextpage");

        // Calculates new index
        self.index = (self.index + 1) % self.arr.size();
        System.println("Current index: " + self.index);

        // Fetching the next view
        var newView = self.arr[self.index];

        WatchUi.switchToView(newView, self, WatchUi.SLIDE_UP);

        return true;
    }

    function onPreviousPage(){
        System.println("Prevpage");

        // Calculates new index
        self.index = (self.index - 1) % self.arr.size();

        // Because modolus dont work with negative numbers
        if (self.index < 0) {
            self.index = self.arr.size() - 1;
        }

        System.println("Current index: " + self.index);

        // Fetching the next view
        var newView = self.arr[self.index];

        WatchUi.switchToView(newView, self, WatchUi.SLIDE_DOWN);

        return true;
    }

    
}