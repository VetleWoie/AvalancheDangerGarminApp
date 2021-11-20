using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class MyMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        System.println("Initializing menu delegate...");

        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            System.println("Creating new view");

            var test = new AppInitView();
            WatchUi.pushView(test, null, WatchUi.SLIDE_DOWN);

        } else if (item == :item_2) {
            System.println("Item 2");
        } else if (item == :item_3) {
            System.println("Item 3");
        }
    }
}

class MyMenu2InputDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        
        System.println("Selected " + item.getLabel());
        System.println("Selected " + item.getSubLabel());
        System.println("Selected id " + item.getId());

        // Create new view based on the selected id, no delegate atm

    }
}

class InputDelegate extends WatchUi.BehaviorDelegate{

    var dangerView = new AvalancheDangerView();
    var initView = new AppInitView();
    var arr = new [0];

    var currentView;

    var index;

    function initialize() {
        BehaviorDelegate.initialize();
        System.println("Initializing behavior delegate");

        self.index = 0;

        self.currentView = self.dangerView;

        // Addinw views to the array
        self.arr.add(self.dangerView);
        self.arr.add(self.initView);

    }

    function onMenu(){
        System.println("Menu button pressed!");
        return true;
    }

    function addItems(menu) {
        var str, label, subLabel;
        var i, index, length;

        var avProblems = Application.getApp().avProblems;

        for (i = 0; i < avProblems.size(); i++) {
            
            str = Application.getApp().avProblems[i]["AvalancheProblemTypeName"];
            length = str.length();

            index = str.find("(");
            label = str.substring(0, index);
            subLabel = str.substring(index, length);

            menu.addItem(
                new MenuItem(
                    label,
                    subLabel,
                    Application.getApp().avProblems[i]["AvalancheProblemTypeId"],
                    {}
                )
            );
        }

    }

    function onSelect(){
        System.println("Select button pressed!");

        var menu = new WatchUi.Menu2({:title=>"Menu"});
        var delegate;

        self.addItems(menu);

        delegate = new MyMenu2InputDelegate(); // a WatchUi.Menu2InputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);

        return true;
        
    }

    function onNextPage() {
        System.println("Nextpage");

        // Calculates new index
        self.index = (self.index + 1) % self.arr.size();
        System.println("Current index: " + self.index);

        // Fetching the next view
        var newView = self.arr[self.index];

        WatchUi.switchToView(newView, self, WatchUi.SLIDE_DOWN);

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