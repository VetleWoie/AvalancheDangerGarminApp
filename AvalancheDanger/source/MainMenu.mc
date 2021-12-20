using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class MainMenu extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect() {
        
        // System.println("Selected " + item.getLabel());
        // System.println("Selected " + item.getSubLabel());
        // System.println("Selected id " + item.getId());
        
        
        return true;
    }
}