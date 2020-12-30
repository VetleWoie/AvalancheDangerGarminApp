using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
class AvalancheDangerView extends WatchUi.View {
    hidden var textDanger;
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        textDanger = new WatchUi.Text({
            :text=>"",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_NUMBER_THAI_HOT,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
        WatchUi.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        
    }

    // Update the view
    function onUpdate(dc) {

        // Call the parent onUpdate function to redraw the layout
        //Get avalange danger from application
        textDanger.setText(Application.getApp().avDanger.toString());
        //Set color according to avalanche danger.
        if(Application.getApp().avDanger == 1){
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_GREEN);
        }else if(Application.getApp().avDanger == 2){
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_YELLOW);
        }else if(Application.getApp().avDanger == 3){
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_ORANGE);
        }else if(Application.getApp().avDanger == 4){
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_RED);
        }else if(Application.getApp().avDanger == 5){
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }else{
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            textDanger.setFont(Graphics.FONT_SMALL);
            textDanger.setText("No data recieved");
        }
        //Clear screen and draw avalanche danger again
        dc.clear();
        textDanger.draw(dc);
        textDanger.setFont(Graphics.FONT_NUMBER_THAI_HOT);
        return;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
