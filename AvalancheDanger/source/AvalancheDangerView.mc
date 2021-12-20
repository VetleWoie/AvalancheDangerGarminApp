using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.StringUtil as Str;


class AvalancheDangerView extends WatchUi.View {
    hidden var textDanger;
    hidden var textDangerName;
    hidden var textDangerRegion;
    hidden var textDate;
    hidden var textVarsom;
    
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {

        var height = dc.getHeight();

        textDanger = new WatchUi.Text({
            :text=>"",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_NUMBER_THAI_HOT,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>(WatchUi.LAYOUT_VALIGN_TOP + 20)
        });

        textDangerName = new WatchUi.Text({
            :text=>"",
            :color=>Graphics.COLOR_BLACK,
            :font=>Graphics.FONT_SMALL,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
        });

        textDangerRegion = new WatchUi.Text({
            :text=>"",
            :color=>Graphics.COLOR_BLACK,
            :font=>Graphics.FONT_TINY,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_TOP
        });

        textDate = new WatchUi.Text({
            :text=>"Date: ",
            :color=>Graphics.COLOR_BLACK,
            :font=>Graphics.FONT_XTINY,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>(height * 0.7)
        });

        textVarsom = new WatchUi.Text({
            :text=>"Data from Varsom.no",
            :color=>Graphics.COLOR_BLACK,
            :font=>Graphics.FONT_XTINY,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=> (height * 0.8),
        });

        WatchUi.requestUpdate();
    }

    /* 
     * Called when this View is brought to the foreground. Restore
     * the state of this View and prepare it to be shown. This includes
     * loading resources into memory. 
     */
    function onShow() {
        System.println("Onshow");
        
    }

    function setVariables() {
        //Get avalange danger from application
        textDanger.setText(Application.getApp().avDanger.toString());

        // Fetching avalanche danger name
        var name = Application.getApp().avDangerName.toString();

        if (name != "") {
            // Converts to array and sliceing the array
            var arr = name.toCharArray().slice(2, null);
            // Converts back to string
            name = Str.charArrayToString(arr);
            // System.println(name);

            textDangerName.setText(name);
        } 

        var date = Application.getApp().avDate.toString();
        var index = date.find("T");
        if (index != null) {
            
            // System.println(date);
            // System.println("Text length: " + index);

            date = date.substring(0, index);
            // System.println(date);

            textDate.setText("Date: " + date);
        }

        textDangerRegion.setText(Application.getApp().avDangerRegion.toString());

    }

    // Update the view
    function onUpdate(dc) {

        // Call the parent onUpdate function to redraw the layout
        self.setVariables();

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
            textDanger.setText("Press button to fetch data");
            // textDangerName.setText("");
            // textDangerRegion.setText("");


        }
        
        //Clear screen and draw avalanche danger again
        dc.clear();
        textDanger.draw(dc);
        textDangerName.draw(dc);
        textDangerRegion.draw(dc);
        textDate.draw(dc);
        textVarsom.draw(dc);

        textDanger.setFont(Graphics.FONT_NUMBER_THAI_HOT);

        return;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
