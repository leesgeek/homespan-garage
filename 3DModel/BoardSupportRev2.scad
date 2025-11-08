

module boardsupportBack(){

    pcbX = 38;
    pcbY = 41;
    pcbZ = 1.6;
    supZ = 5.0;
    supX = 2;
    supY = 15;
    wall_thick = 3;

    difference(){
        cube([wall_thick+supX, wall_thick+supY, pcbZ+supZ]);
        translate([wall_thick, wall_thick, supZ])
            cube([supX, supY, pcbZ]);
    }

    translate([0,pcbY+wall_thick,0])
    rotate([0,0,270])
    difference(){
        cube([wall_thick+supY, wall_thick+supX, pcbZ+supZ]);
        translate([wall_thick, wall_thick, supZ])
            cube([supY, supX, pcbZ]);
    }
}

module boardsupportFront(){
    
    pcbX = 38;
    pcbY = 41;
    pcbZ = 1.6;
    supZ = 5.0;
    supX = 4;
    supY = 15;
    wall_thick = 3;

    translate([pcbX+wall_thick,0,0])
    rotate([0,0,90])
    difference(){
        cube([wall_thick+supX, supY, pcbZ+supZ]);
        translate([wall_thick, 0, supZ])
            cube([supX, supY, pcbZ]);
    }

    translate([pcbX+wall_thick,pcbY+wall_thick,0])
    rotate([0,0,180])
    difference(){
        cube([supY, wall_thick+supX, pcbZ+supZ]);
        translate([0, wall_thick, supZ])
            cube([supY, supX, pcbZ]);
    }



}