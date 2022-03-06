using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class AvalancheProblemView extends WatchUi.View {
    hidden var textProblem;
    hidden var problems;
    hidden var bitmap;
    hidden var textProblemName;
    hidden var problemName;



    function initialize(problemId, name) {
        problems = {
            0	=> null,//Ikke gitt
            3	=> Rez.Drawables.NewSnow,//Loose dry avalanches
            5	=> Rez.Drawables.WetSnow,//Loose wet avalanches
            7	=> Rez.Drawables.NewSnow,//New snow slab
            10	=> Rez.Drawables.DriftingSnow,//Wind slab avalanches
            20	=> Rez.Drawables.NewSnow,//New snow
            30	=> Rez.Drawables.OldSnow,//Persistent slab avalanches
            40	=> Rez.Drawables.WetSnow,//Wet snow
            45	=> Rez.Drawables.WetSnow,//Wet slab avalanches
            50	=> Rez.Drawables.GlidingSnow//Glide avalanche
        };
        bitmap = new WatchUi.Bitmap({
            :rezId=>problems[problemId],
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
        });

        System.println("Problem view initialized with ID: " + problemId);

        problemName = name;
        System.println(name);
        
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {


        // textProblemName = new WatchUi.Text({
        //     :text=>"",
        //     :color=>Graphics.COLOR_WHITE,
        //     :font=>Graphics.FONT_SMALL,
        //     :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
        //     :locY=>WatchUi.LAYOUT_VALIGN_START
        // });

        var height = dc.getHeight();
        var width = dc.getWidth();

        textProblemName = new WatchUi.TextArea({
            :text=>"",
            :color=>Graphics.COLOR_WHITE,
            :font=>[Graphics.FONT_SMALL, Graphics.FONT_XTINY],
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_START,
            :width=>width*0.5,
            :height=>height*0.4,
        });

        // Remove old content
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        
        WatchUi.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        
    }

    // Update the view
    function onUpdate(dc) {

        textProblemName.setText(problemName);
        // Center the text inside the text area
        textProblemName.setJustification(Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        dc.clear();
        // dc.drawScaledBitmap(0, 0, 100, 100, bitmap);
        // dc.drawBitmap(10, 10, bitmap);
        // bitmap.scaleRelativeTo(dc);
        // bitmap.scaleX(10);
        // bitmap.scaleY(10);
        bitmap.draw(dc);
        textProblemName.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}