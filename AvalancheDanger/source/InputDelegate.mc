using Toybox.System;
using Toybox.WatchUi;

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
        
        // If id == 1
        if (item.getId().equals(1)) {
            System.println("Selected " + item.getLabel());

            // var test = new AppInitView();
            // WatchUi.pushView(test, null, WatchUi.SLIDE_DOWN);
        }
        else if (item.getId().equals(2)){
            System.println("Selected " + item.getLabel());

        }
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

    function onSelect(){
        System.println("Select button pressed!");
        // var menu = new WatchUi.Menu();
        // var delegate;

        // menu.setTitle("My Menu");
        // menu.addItem("New view", :item_1);
        // menu.addItem("Item Two", :item_2);
        // menu.addItem("Item Three", :item_3);

        // delegate = new  MyMenuDelegate(); // a WatchUi.MenuInputDelegate
        // // test = new AppInitView();
        // WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);

        var menu = new WatchUi.Menu2({:title=>"My Menu2"});
        var delegate;
        menu.addItem(
            new MenuItem(
                "Hovedbudskap",
                "Main Text",
                1,
                {}
            )
        );
        menu.addItem(
            new MenuItem(
                "Item 2 Label",
                "Item 2 subLabel",
                2,
                {}
            )
        );
        delegate = new MyMenu2InputDelegate(); // a WatchUi.Menu2InputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);

        return true;
        
    }

    function onNextPage() {
        System.println("Nextpage");
        // System.println("Creating new view");


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