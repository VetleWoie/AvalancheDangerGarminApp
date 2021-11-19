using Toybox.System;
using Toybox.WatchUi;

using Toybox.Graphics;
using Toybox.WatchUi;

class AppInitView extends WatchUi.View {

    hidden var myTextArea;

    function initialize() {
        System.println("Initializing text area...");
        View.initialize();
        // View.pushView(view, delegate, transition)
    }

    function onLayout(dc) {
        myTextArea = new WatchUi.TextArea({
            :text=>"Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_XTINY,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
            :width=>180,
            :height=>180
        });

        // WatchUi.requestUpdate();

    }

    function onShow() {
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // dc.clear();
        // myTextArea.draw(dc);

        // return;
    }

    function onUpdate(dc) {
        myTextArea.setText(Application.getApp().avMainText.toString());
        // var width = dc.getWidth();
        // var height = dc.getHeight();
        // System.println("Width: "+ width);
        // System.println("Height: "+ height);
        // myTextArea.setWidth(width);
        // myTextArea.setHeight


        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        myTextArea.draw(dc);

        return;
    }
}

// class AppInitView extends WatchUi.BehaviorDelegate {

//     function initialize() {
//         BehaviorDelegate.initialize();
//         System.println("Initializing behavior delegate 2");
//     }

//     // Detect Menu behavior
//     function onMenu() {
//         System.println("Menu behavior triggered");
//         return false; // allow InputDelegate function to be called
//     }


//     // Detect Menu button input
//     function onSelect() {
//         System.println("Select button pressed! 2");

//         // System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
//         return true;
//     }
// }