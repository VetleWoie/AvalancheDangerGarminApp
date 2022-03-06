using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.Math;

class ProblemCompassView extends WatchUi.View {
    
    var validExpositions;
    var north = [];
    var northWest = [];
    var west = [];
    var southWest = [];
    var south = [];
    var southEast = [];
    var east = [];
    var northEast = [];

    var allDirections = [];

    function initialize(problemInfo) {
        self.validExpositions = problemInfo["ValidExpositions"];
    }

    // Load your resources here
    function onLayout(dc) {
        var height = dc.getHeight();
        var width = dc.getWidth();

        var radius = (width/2)*1;
        System.println(test);

        // self.points3.add([height/2, test]); // center
        // self.points3.add([self.cartesian_x(Math.PI/4, test), self.cartesian_y(Math.PI/4, test)]);
        // self.points3.add([self.cartesian_x((Math.PI/2), test), self.cartesian_y((Math.PI/2), test)]);

        self.north = createPointsList((Math.PI/2), (Math.PI/4), width/2, height/2, radius);
        
        self.northEast = createPointsList((Math.PI/4), (2*Math.PI), width/2, height/2, radius);

        self.east = createPointsList(((7*Math.PI)/4), (2*Math.PI), width/2, height/2, radius);

        self.southEast = createPointsList(((7*Math.PI)/4), ((3*Math.PI)/2), width/2, height/2, radius);

        self.south = createPointsList(((5*Math.PI)/4), ((3*Math.PI)/2), width/2, height/2, radius);

        self.southWest = createPointsList(((5*Math.PI)/4), (Math.PI), width/2, height/2, radius);

        self.west = createPointsList((Math.PI), ((3*Math.PI)/4), width/2, height/2, radius);
        
        self.northWest = createPointsList((Math.PI/2), ((3*Math.PI)/4), width/2, height/2, radius);

        // Adding to wrapper list
        self.allDirections.add(self.north);
        self.allDirections.add(self.northEast);
        self.allDirections.add(self.east);
        self.allDirections.add(self.southEast);
        self.allDirections.add(self.south);
        self.allDirections.add(self.southWest);
        self.allDirections.add(self.west);
        self.allDirections.add(self.northWest);
    }

    function createPointsList(polarCoord1, polarCoord2, halfWidth, halfHeight, radius) {

        var list = [];

        list.add([halfWidth, halfHeight]); // center
        list.add([self.cartesian_x(polarCoord1, halfWidth, radius), self.cartesian_y(polarCoord1, halfHeight, radius)]);
        list.add([self.cartesian_x(polarCoord2, halfWidth, radius), self.cartesian_y(polarCoord2, halfHeight, radius)]);
        // self.list.add([self.cartesian_x((Math.PI/2), test), self.cartesian_y((Math.PI/2), test)]);

        return list;

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        
    }

    // Update the view
    function onUpdate(dc) {
        dc.clear();

        var directionString = self.validExpositions;

        var directionArray = directionString.toCharArray();
        System.println(directionArray);

        var i;
        var currentList;
        
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        // Filling triangle
        for (i = 0; i < self.allDirections.size(); i++) {
            
            currentList = self.allDirections[i];

            if (directionArray[i].toString().equals("1")) {
                dc.fillPolygon(currentList);
            }
        }
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // Drawing triangle lines
        for (i = 0; i < self.allDirections.size(); i++) {
            
            currentList = self.allDirections[i];
            self.drawLineTriangle(dc, currentList);
        }


    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {

    }

    // function rotateCoordinate(point) {

    //     // tbc
    // }

    function drawLineTriangle(dc, points) {

        dc.drawLine(points[0][0], points[0][1], points[1][0], points[1][1]);
        dc.drawLine(points[1][0], points[1][1], points[2][0], points[2][1]);
        dc.drawLine(points[2][0], points[2][1], points[0][0], points[0][1]);
    }

    function cartesian_x (theta, halfWidth, radius) {

        var phi = Math.PI/8;

        var offset = 2*Math.PI - phi;

        var x = (Math.cos(theta-offset)*(radius)) + halfWidth;

        return x;
    }

    function cartesian_y (theta, halfHeight, radius) {
        var phi = Math.PI/8;

        var offset = 2*Math.PI - phi;

        var y = (Math.sin(theta-offset)*(radius*-1)) + halfHeight;

        return y;
    }

}