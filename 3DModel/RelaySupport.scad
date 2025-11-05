
module boardsupport(width, length){
    // corner
    translate([0,0,3.5]) {
        difference(){
            cube([width+2,length+2,5.5], center=true);
            cube([width,length,5.51],center=true);
            cube([width+2.1,length-4,5.51],center=true);
            cube([width-4,length+2.1,5.51],center=true);
            translate([0,-4,0]) {
                cube([width,length+2.1,5.51],center=true);
            }
        }
    }
    
    // screw hole
//    translate([37.2/2-5.7-3.5/2,25.3/2-1.3-3.5/2,2]){
//        difference(){
//            cylinder(d=5.0,h=4,$fn=64,center=true);
//            cylinder(d=3.0,h=4.1,$fn=64,center=true);
//        }
//    }
    
    // support for corner
    for (y = [length/2-0.5, -length/2+0.5]) {
        for (x = [width/2-0.5, -width/2+0.5]) {
            translate([x,y,2]){
                cube([3,3,4], center=true);
            }        
        }
    }
}