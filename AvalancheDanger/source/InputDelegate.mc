using Toybox.System;
using Toybox.WatchUi;

class MyMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            System.println("Item 1");
        } else if (item == :item_2) {
            System.println("Item 2");
        } else if (item == :item_3) {
            System.println("Item 3");
        }
    }
}

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
        var menu = new WatchUi.Menu();
        var delegate;
        menu.setTitle("My Menu");
        menu.addItem("Item One", :item_1);
        menu.addItem("Item Two", :item_2);
        menu.addItem("Item Three", :item_3);
        delegate = new  MyMenuDelegate(); // a WatchUi.MenuInputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
        
    }
}

