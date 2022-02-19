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
            :text=>"Press Select button to fetch data",
            :color=>Graphics.COLOR_WHITE,
            :font=>[Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY],
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

        // var str = Application.getApp().avMainText.toString();

        // var index = str.find(".");
        // System.println("Text length: " + index);

        // str = str.substring(0, index+1);


        // myTextArea.setText(str);
        myTextArea.setJustification(Graphics.TEXT_JUSTIFY_CENTER);

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