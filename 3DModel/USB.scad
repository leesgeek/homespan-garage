// OV2640 Camera Sensor + Lens + Detailed FPC
module ov2640_sensor(lens_d=8, lens_h=3.3,
                     housing_w=8.25, housing_h=8.2, housing_t=2.54,
                     fpc_w=5.7, fpc_thickness=0.3, fpc_length=8,
                     pad_count=12, pad_pitch=0.45, pad_w=0.35, pad_h=0.2) {

    // Sensor housing
    color("darkgray")
    cube([housing_w, housing_h, housing_t]);

    // Lens barrel
    translate([housing_w/2, housing_h/2, housing_t])
        color("black")
        cylinder(h=lens_h, d=lens_d, $fn=60);

    // FPC ribbon tail
    translate([(housing_w - fpc_w)/2, housing_h, 0])
        color("orange")
        cube([fpc_w, fpc_length, fpc_thickness]);

    // Gold contact pads on FPC
    for (i=[0:pad_count-1])
        translate([(housing_w - fpc_w)/2 + 0.3 + i*pad_pitch, housing_h + fpc_length - 1, fpc_thickness])
            color("gold")
            cube([pad_w, 1, pad_h]);
}




// MicroSD Card Receptacle (Push-Push Type)
module microsd_receptacle(shell_w=15, shell_h=14, shell_t=1.8,
                          slot_w=11.5, slot_h=1.2, slot_depth=14,
                          pin_count=8, pin_w=0.5, pin_h=0.3, pin_spacing=1.1) {

    // Outer metal shell
    difference() {
        color("silver")
        cube([shell_w, shell_h, shell_t]);

        // Slot opening for card
        translate([(shell_w - slot_w)/2, 0, 0])
            cube([slot_w, slot_depth, slot_h]);
    }

    // Plastic base inside
    translate([1, 1, 0])
        color("gray")
        cube([shell_w - 2, shell_h - 2, 0.8]);

    // Pins for PCB soldering
    for (i=[0:pin_count-1])
        translate([2 + i*pin_spacing, shell_h - 1, -0.0])
            color("gold")
            cube([pin_w, 1, pin_h]);
}


// USB-C Connector with realistic oval shape (X = width, Y = height)
module usbc(shell_w=8.4, shell_h=2.6, shell_d=6.5,
                       tongue_w=6.0, tongue_h=0.8, tongue_d=5.0) {
    
    
    rotate([90,0,180]){
    translate([-shell_w/2+shell_h/2,shell_h/2,-shell_d]){
        difference() {
        // Outer shell: rounded rectangle along X-axis
        color("silver")
        
        hull() {
            translate([0, 0, 0])
                cylinder(h=shell_d, r=shell_h/2, $fn=50);
            translate([shell_w - shell_h, 0, 0])
                cylinder(h=shell_d, r=shell_h/2, $fn=50);
        }

        // Inner cavity
        translate([0, 0, 1.01])
            hull() {
                translate([0, 0, 0])
                    cylinder(h=shell_d - 1, r=(shell_h - 1)/2, $fn=50);
                translate([shell_w - shell_h, 0, 0])
                    cylinder(h=shell_d - 1, r=(shell_h - 1)/2, $fn=50);
            }
        
    }

//    // Tongue inside
    translate([0, - tongue_h/2, 1]){
        color("White")
        cube([tongue_w, tongue_h, tongue_d], center=false);
        rotate([90,0,0]){
            color("Gold")    
            translate([shell_w/2-6*0.65/2,3.65,-tongue_h/2-0.25]){
            for (i=[0:1:6])
                translate([-2.60/2+i*0.65, 0.001, -(0.60-0.20)/2-0.001])
                    cube([0.50, 2.70, 0.20], center=true);
            }
            translate([shell_w/2-6*0.65/2,3.65,+tongue_h/2-.1]){
            for (i=[0:1:6])
                translate([-2.60/2+i*0.65, 0.001, -(0.60-0.20)/2-0.001])
                    cube([0.50, 2.70, 0.20], center=true);
            }
        }   
    }
    }
}
}

module mUSBF() {
    // Typical micro USB female PCB connector
    // Rendered as centered on X, connector mouth on axis origins and pointing towards Y+, laying over the XY plane

    mUWAng = 25;
    mUF = [
            [-2.70, 0.00],
            [-3.45, 0.75],
            [-3.45, 1.85],
            [3.45,  1.85],
            [3.45,  0.75],
            [2.70,  0.00],
          ];

    translate([0, 0, 0.75+0.25]) {
        color("Silver")
        difference() {
            union() {
                // Connector body
                translate([0, -5.0/2, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = 5.0, center=true, convexity = 6)
                        translate([0, -0.75, 0])
                            offset(r=0.25)
                                polygon(points = mUF, convexity = 6);
                // Bottom wing
                translate([0, 0, -(0.75+0.25/2)])
                rotate([-mUWAng,0,0])
                translate([0, -2.0/2+0.63, 0])
                    cube([5.40, 2.0, 0.25], center=true);
                // Top wing
                translate([0, 0, (1.85-0.75+0.25/2)])
                rotate([mUWAng,0,0])
                translate([0, -2.0/2+0.63, 0])
                    cube([6.70, 2.0, 0.25], center=true);
                // Left wing
                translate([3.45+0.25/2, 0, 1.85-0.75-1.0/2-0.05])
                rotate([0,0,-mUWAng])
                translate([0, -2.0/2+0.63, 0])
                    cube([0.25, 2.0, 1.00], center=true);
                // Right wing
                translate([-3.45-0.25/2, 0, 1.85-0.75-1.0/2-0.05])
                rotate([0,0,mUWAng])
                translate([0, -2.0/2+0.63, 0])
                    cube([0.25, 2.0, 1.00], center=true);
            }
            // Connector hole
            translate([0, -3.50/2+0.001, 0])
            rotate([90, 0, 0])
                linear_extrude(height = 3.50, center=true, convexity = 6)
                    translate([0, -0.75, 0])
                        polygon(points = mUF, convexity = 6);
        }
        // Contacts
        translate([0, 2.70/2-3.50, 1.85-0.75-0.60/2-0.1]) {
            // Contacts block
            color("DarkGrey")
            translate([0, 0, 0])
                cube([2.60+0.5+0.2, 2.70, 0.60], center=true);
            color("Gold")
            for (i=[0:1:4])
                translate([-2.60/2+i*0.65, 0.001, -(0.60-0.20)/2-0.001])
                    cube([0.50, 2.70, 0.20], center=true);
        }
    }
}