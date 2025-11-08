
//module boardsupport(width, length){
//    
//    GW = 4;
//    // corner
//    translate([0,0,3.5]) {
//        difference(){
//            //cube([width+2,length+2,5.5], center=true);
//            cube([width+GW,length+GW,5.5], center=true);
//            cube([width,length,5.51],center=true);
//            //cube([width+2.1,length-4,5.51],center=true);
//            cube([width+GW+0.1,length-GW*2,5.51],center=true);
//            //cube([width-4,length+2.1,5.51],center=true);
//            cube([width-2*GW,length+GW+0.1,5.51],center=true);
//            translate([0,-4,0]) {
//                cube([width,length+GW/2+0.1,5.51],center=true);
//            }
//        }
//    }
//    
//    // screw hole
////    translate([37.2/2-5.7-3.5/2,25.3/2-1.3-3.5/2,2]){
////        difference(){
////            cylinder(d=5.0,h=4,$fn=64,center=true);
////            cylinder(d=3.0,h=4.1,$fn=64,center=true);
////        }
////    }
//    
//    // support for corner
//    for (y = [length/2-1, -length/2+1]) {
//        for (x = [width/2-1, -width/2+1]) {
//            translate([x,y,2]){
//                cube([3,3,4], center=true);
//            }        
//        }
//    }
//}

//            boardsupportFront();
//            color([1,0,0])
//            boardsupportBack();

module boardsupportBack(){

    pcbX = 38;
    pcbY = 41;
    pcbZ = 1.6;
    supZ = 4;
    supX = 2;
    supY = 15;
    wall_thick = 3;

    difference(){
        cube([wall_thick+supX, wall_thick+supY, pcbZ+supZ]);
        translate([wall_thick, wall_thick, supZ])
            cube([supX+1, supY+1, pcbZ+1]);
    }

    translate([0,pcbY+wall_thick-1,0])
    rotate([0,0,270])
    difference(){
        cube([wall_thick+supY, wall_thick+supX, pcbZ+supZ]);
        translate([wall_thick-1, wall_thick, supZ])
            cube([supY+1, supX+1, pcbZ+1]);
    }
}

module boardsupportFront(){
    
    pcbX = 38;
    pcbY = 41;
    pcbZ = 1.6;
    supZ = 4;
    supX = 4;
    supY = 10;
    wall_thick = 2;

    translate([pcbX+wall_thick,1,0])
    rotate([0,0,90])
    difference(){
        cube([wall_thick+supX, supY, pcbZ+supZ]);
        translate([wall_thick, -0.1, supZ])
            cube([supX+1, supY+1, pcbZ+1]);
    }

    translate([pcbX,pcbY+wall_thick,0])
    rotate([0,0,180])
    difference(){
        cube([supY, wall_thick+supX, pcbZ+supZ]);
        translate([-0.1, wall_thick, supZ])
            cube([supY+1, supX+1, pcbZ+1]);
    }



}