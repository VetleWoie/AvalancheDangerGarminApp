using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class AvalancheProblemView extends WatchUi.View {
    hidden var textProblem;
    hidden var problems;
    hidden var bitmap;
    function initialize(problemId) {
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
            :locX=>0,
            :locY=>0
        });
        System.print("Problem view initialized with ID: ");
        System.println(problemId);
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
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
        dc.clear();
        bitmap.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
