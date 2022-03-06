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

    var height;
    var width;
    
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {

        var height = dc.getHeight();
        var width = dc.getWidth();

        self.width = width;
        self.height = height;

        var height_02 = height*0.2;
        
        textDangerRegion = new WatchUi.TextArea({
            :text=>"",
            :color=>Graphics.COLOR_BLACK,
            :font=>[Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY],
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_START,
            :width=>width*0.5,
            :height=>height*0.2,
        });

        textDanger = new WatchUi.TextArea({
            :text=>"",
            :color=>Graphics.COLOR_WHITE,
            :font=>[Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_MEDIUM],
            // :font=>[Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL],
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>height*0.15,
            :width=>width,
            :height=>height*0.45,
        });

        textDangerName = new WatchUi.TextArea({
            :text=>"",
            :color=>Graphics.COLOR_BLACK,
            :font=>[Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY],
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>height*0.5 ,
            :width=>width,
            :height=>height*0.2,
        });

        textDate = new WatchUi.TextArea({
            :text=>"",
            :color=>Graphics.COLOR_BLACK,
            :font=>[Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY],
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=> height*0.7,
            :width=>width,
            :height=>height*0.15,
        });

        textVarsom = new WatchUi.TextArea({
            :text=>"Data from Varsom.no",
            :color=>Graphics.COLOR_BLACK,
            :font=>[Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY],
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=> height*0.85,
            :width=>width * 0.6,
            :height=>height*0.15,
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

            textDate.setText(date);
        }

        textDangerRegion.setText(Application.getApp().avDangerRegion.toString());

    }

    function setAreaJustification() {
        textDangerRegion.setJustification(Graphics.TEXT_JUSTIFY_CENTER);
        textDanger.setJustification(Graphics.TEXT_JUSTIFY_CENTER);
        textDangerName.setJustification(Graphics.TEXT_JUSTIFY_CENTER);
        textDate.setJustification(Graphics.TEXT_JUSTIFY_CENTER);
        textVarsom.setJustification(Graphics.TEXT_JUSTIFY_CENTER);

    }

    // Update the view
    function onUpdate(dc) {

        // Call the parent onUpdate function to redraw the layout
        self.setVariables();
        self.setAreaJustification();

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
        textDangerName.draw(dc);
        textDanger.draw(dc);
        textDangerRegion.draw(dc);
        textDate.draw(dc);
        textVarsom.draw(dc);

        // Helping lines for positioning
        // dc.drawLine(0, self.height*0.2, self.width, self.height*0.2);
        // dc.drawLine(0, self.height*0.5, self.width, self.height*0.5);
        // dc.drawLine(0, self.height*0.7, self.width, self.height*0.7);
        // dc.drawLine(0, self.height*0.85, self.width, self.height*0.85);
        // dc.drawLine(0, self.height*0.90, self.width, self.height*0.90);

        // textDanger.setFont(Graphics.FONT_NUMBER_THAI_HOT);

        return;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
