using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class ProblemMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    
    var problems;

    function initialize() {
        // Menu2InputDelegate.initialize();

        problems = {
            0	=> null,//Ikke gitt
            3	=> Rez.Drawables.NewSnow2,//Loose dry avalanches
            5	=> Rez.Drawables.WetSnow2,//Loose wet avalanches
            7	=> Rez.Drawables.NewSnow2,//New snow slab
            10	=> Rez.Drawables.DriftingSnow2,//Wind slab avalanches
            20	=> Rez.Drawables.NewSnow2,//New snow
            30	=> Rez.Drawables.OldSnow2,//Persistent slab avalanches
            40	=> Rez.Drawables.WetSnow2,//Wet snow
            45	=> Rez.Drawables.WetSnow2,//Wet slab avalanches
            50	=> Rez.Drawables.GlidingSnow2//Glide avalanche
        };
    }

    // On select button pressed handling
    function onSelect(item) {
        
        System.println("Selected " + item.getLabel());
        System.println("Selected " + item.getSubLabel());
        System.println("Selected id " + item.getId());
        var view = new AvalancheProblemView(item.getId(), item.getLabel()+item.getSubLabel());
        WatchUi.pushView(view, null, WatchUi.SLIDE_IMMEDIATE);

        // Create new view based on the selected id, no delegate atm

    }

    function addItemsToMenu(menu) {

        // self.setTitle("Skred- problem");
        
        var str, label, subLabel;
        var i, index, length, problemId;
        var bitmap;

        var avProblems = Application.getApp().avProblems;
        
        for (i = 0; i < avProblems.size(); i++) {
            
            // Fetch avalanche problem id
            problemId = Application.getApp().avProblems[i]["AvalancheProblemTypeId"];

            // Fetch avalanche problem name 
            str = Application.getApp().avProblems[i]["AvalancheProblemTypeName"];
            length = str.length();

            // Split name into label and sublabel
            index = str.find("(");
            label = str.substring(0, index);
            subLabel = str.substring(index, length);

            // Fetch image from bitmap
            bitmap = new WatchUi.Bitmap({
                :rezId=>problems[problemId],
                :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_CENTER,

            });

            // Add item into self menu
            menu.addItem(
                new IconMenuItem(
                    label,
                    subLabel,
                    problemId,
                    bitmap,
                    {:alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT,}
                )
            );
        }

    }
}