
include<USB.scad>


module ESP32CAM_DEV(pins=true, atorg=0, showtext=true){

    // atorg:
    //  0: Alignement on device's center
    //  1: PCB is aligned over XY plane, border onver the X and Y axis
    //  2: PCB is aligned over XY plane, with the lower left pin on XY origins

    XDim = 37.25;
    YDim = 42.0;
    ZDim = 1.5;
    P1X = 11.25;
    P1Y = 16.30; //11.3;
    PBXO = 1.1;
    PBYO = YDim/2;

    P2X = 17.0;
    P2Y = 16.3; //11.3;
    PB2XO = 1.1;
    PB2YO = YDim/2;



    ORGV = [
        // 0: Alignement on device's center
        [0, 0, 0],
        //  1: PCB is aligned over XY plane, border onver the X and Y axis
        [XDim/2, YDim/2, ZDim/2],
        //  2: PCB is aligned over XY plane, with the lower left pin on XY origins
        [P1X, P1Y, ZDim/2],
    ];

    translate([ORGV[atorg][0], ORGV[atorg][1], ORGV[atorg][2]]) {
        // PCB
        color("DimGrey")
        difference() {
            cube([XDim, YDim, ZDim], center=true);
            if (!pins)
                // Pinheads pins holes
                for (i=[-1:2:1])
                    translate([i*14.05, -11.3, -ZDim])
                        PINHEADHOLES(n=8);
        }
        
        // Top layer
        translate([0, 0, ZDim/2]) {
            // Pinheads
            if (pins)
                for (i=[-1:2:1])
                    translate([i*P1X, -P1Y, -ZDim ])
                    rotate([0,180,0])
                        PINHEADF(n=8, col="DarkGrey");
            // Pinheads
            if (pins)
                for (i=[-1:2:1])
                    translate([i*P2X, -P2Y, -ZDim ])
                    rotate([0,180,0])
                        PINHEADM(n=8, col="Black");
            translate([0, YDim/2, -ZDim])                
                rotate([0, 180, 0]) {
                    usbc();
                }   
            }
            
        // Bottom layer
        translate([0, 0, -ZDim/2])
        rotate([0, 180, 0]) {
//            translate([-10, 10, 0])
//
//            
//            translate([-15/2, -YDim/2, 0])
//                rotate([0, 0, 0]) {
//                    microsd_receptacle();
//                }
//            translate([-8.25/2,-YDim/2+5.75, 1.81])
//                ov2640_sensor();
        }

    }
}

module ESP32CAM(pins=true, atorg=0, showtext=true) {
    // Witty Wifi Base Module

    // atorg:
    //  0: Alignement on device's center
    //  1: PCB is aligned over XY plane, border onver the X and Y axis
    //  2: PCB is aligned over XY plane, with the lower left pin on XY origins

    XDim = 27.28;
    YDim = 40.0;
    ZDim = 1.2;
    P1X = 11.25;
    P1Y = 16.30; //11.3;
    PBXO = 1.1;
    PBYO = YDim/2;

    ORGV = [
        // 0: Alignement on device's center
        [0, 0, 0],
        //  1: PCB is aligned over XY plane, border onver the X and Y axis
        [XDim/2, YDim/2, ZDim/2],
        //  2: PCB is aligned over XY plane, with the lower left pin on XY origins
        [P1X, P1Y, ZDim/2],
    ];

    translate([ORGV[atorg][0], ORGV[atorg][1], ORGV[atorg][2]]) {
        // PCB
        color("DimGray")
        difference() {
            cube([XDim, YDim, ZDim], center=true);
            if (!pins)
                // Pinheads pins holes
                for (i=[-1:2:1])
                    translate([i*14.05, -11.3, -ZDim])
                        PINHEADHOLES(n=8);
        }
        // Top layer
        translate([0, 0, ZDim/2]) {
            // Led 5050
            //translate([11.8, 11.2, 0])
            //   LED5050();
            // LDR
            //translate([-12.5, 11.2, 0])
            //    LDR();
            // Pinheads
            if (pins)
                for (i=[-1:2:1])
                    translate([i*P1X, -P1Y, -ZDim/2 ])
                    rotate([0,0,0])
                        PINHEADM(n=8, col="Black");
            // ESP12F
            translate([0, YDim/2, 0])
                ESP32S();

             // Texts
             if (showtext)
                for (i=[0:1:1])
                for (j=[0:1:8])
                color("White")
                translate([(i*2-1)*(P1X-0.5), j*2.54-P1Y, 0])
                    linear_extrude(height=0.001, center=true, convexity=10)
                        text(WBPRT[i][j], size=1.0, font="Arial:style=Regular", halign=i?"right":"left", valign="center");
        }

        // Bottom layer
        translate([0, 0, -ZDim/2])
        rotate([0, 180, 0]) {
            translate([-10, 10, 0])
                LED5050();
            
            translate([-15/2, -YDim/2, 0])
                rotate([0, 0, 0]) {
                    microsd_receptacle();
                }
            translate([-8.25/2,-YDim/2+5.75, 1.81])
                ov2640_sensor();
        }
    }
}



// --- Utilities --------------------------------
/*
 * Used to make rounded edges on objects
 * This 'edge' function is from http://www.thingiverse.com/thing:393890
 */
module edge(radius, height){
    difference()
	{
		translate([radius/2-0.5, radius/2-0.5, 0])
			cube([radius+1, radius+1, height], center = true);

		translate([radius, radius, 0])
			cylinder(h = height+1, r1 = radius, r2 = radius, center = true, $fn = 100);
	}
}

// Adds the coordinates in a vector table of type [ [X,Y] ] and returns the result
// base: 0=X, 1=Y
// lim: Index of the maximum row to add (0 means return the first row result)
function addCoord(v, base=0, lim=0, i=0, r=0) = i<=lim ?
    addCoord(v, base, lim, i+1, r + v[i][base]) :
    r;

module DrawPath(path=[], w=0.8, h=0.2) {
    // Draw a continuous 'PCB trace' by following a series of coordinate 'moves'
    // path: [ [X new pos, Y new pos], ... ]
    // w: width of the trace
    // h: height of the 'copper'

    for (i=[0:1:len(path)-1]) {
        translate([ addCoord(v=path, base=0, lim=i-1),
                    addCoord(v=path, base=1, lim=i-1),
                    h/2]) {
            translate([ path[i][0] ? path[i][0]/2 : 0,
                        path[i][1] ? path[i][1]/2 : 0,
                        0 ])
                cube([  path[i][0] ? abs(path[i][0])+w : w,
                        path[i][1] ? abs(path[i][1])+w : w,
                        h ], center=true);
                        }
    }
}


WBPRT = [
 [ "Vcc","G13","G12","G14","G16","CHPD","ADC","REST" ],
 [ "Gnd","G15","G2","G0","G4","G5","RX","TX" ],
];

ESP12ANT = 0;
ESP1ANT  = 1;

// Components
module LED5050() {
    // LED 5050
    // Rendered as centered on origin, laying over the XY plane

    translate([0,0,0]) {
        difference() {
            union() {
                // +++
                color("Ivory")
                translate([0,0,1.4/2+0.1])
                    cube([5.0, 5.0, 1.4], center=true);
                color("Silver")
                translate([0,0,0])
                    for (i=[-1:2:1])
                        for (j=[-1:1:1])
                            translate([i*((5.0-1.4+0.1)/2), j*1.5, 0.5])
                                cube([1.4, 1.0, 1.0], center=true);
            }
            color("Snow", 0.1)
            translate([0, 0, 1.5-0.75/2+0.001])
                cylinder(d=4.0, h=0.75, center=true);
        }
    }
}





module ESP32S(col="Black") {
    // ESP-12F
    // Only the essential parts are drawn (no resistors/capacitors, no regulator)
    // Rendered as centered on X, antenna side on X axis, laying over the XY plane

    XDim = 18;
    YDim = 25.5;
    ZDim = 0.8;

    translate([0, -YDim/2,ZDim/2]) {
        // PCB
        color(col)
        cube([XDim, YDim, ZDim], center=true);
        translate([0, -(YDim-15.0)/2 + 1.3, (ZDim+2.4)/2])
        rotate([0,0,-90])
            ESP32S_CAN();
        // Antenna
        color("Gold")
            translate([XDim/2-2, YDim/2-7.0, ZDim/2])
            mirror([1, 0, 0])
            ESPAnt(ESP12ANT);

        // Sides Pins
        color("Gold")
        for (i=[-1:2:1])
        for (j=[0:1:7])
            translate([i*(XDim-1.5+0.001)/2, -YDim/2+1.5+2*j, 0])
                cube([1.5, 1.0, ZDim+0.02], center=true);
        color("Gold")
        for (i=[0:1:5])
            translate([-5+i*2, -YDim/2+1.0/2-0.001, 0])
                cube([1.0, 1.0, ZDim+0.02], center=true);
        // Antenna Connector
        color("Silver", 0.7)
        translate([XDim/2-4, YDim/2-6.08, (ZDim+0.58)/2])
            cube([2.8, 2.8, 0.58], center=true);
    }
}

module ESP8266MOD(txt=["ESP8266MOD","AI-THINKER","","ISM  2.4GHz","PA  +25dBm","802.11b/g/n"], XDim=15.0, YDim=12.1, ZDim=2.4) {
    // Shielded ESP8266 module (common to most shielded mods)
    // Rendered X,Y and Z centered on the axis, text bottom towards Y-

//    XDim = 15.0;
//    YDim = 12.1;
//    ZDim = 2.4;
    MD = 0.2;
    TS = 0.8;

    color("Silver")
    cube([XDim, YDim, ZDim], center=true);
    color("white")
    for (i=[0:1:len(txt)-1])
        translate([-0.5,0.5-(TS+0.2)*i,(ZDim-MD)/2+0.001])
            linear_extrude(height=MD, center=true, convexity=10)
                            text(txt[i], size=TS, font="Arial:style=Bold", halign="left", valign="center");
}

module ESP32S_CAN(txt=["ESP32S","AI-THINKER","","ISM  2.4GHz","PA  +25dBm","802.11b/g/n"], XDim=17.2, YDim=15.7, ZDim=2.16) {
    // Shielded ESP32 module (common to most shielded mods)
    // Rendered X,Y and Z centered on the axis, text bottom towards Y-

//    XDim = 15.0;
//    YDim = 12.1;
//    ZDim = 2.4;
    MD = 0.2;
    TS = 0.8;

    color("Silver")
    cube([XDim, YDim, ZDim], center=true);
    color("white")
    for (i=[0:1:len(txt)-1])
        translate([-0.5,0.5-(TS+0.2)*i,(ZDim-MD)/2+0.001])
            linear_extrude(height=MD, center=true, convexity=10)
                            text(txt[i], size=TS, font="Arial:style=Bold", halign="left", valign="center");
}

module DrawPath(path=[], w=0.8, h=0.2) {
    // Draw a continuous 'PCB trace' by following a series of coordinate 'moves'
    // path: [ [X new pos, Y new pos], ... ]
    // w: width of the trace
    // h: height of the 'copper'

    for (i=[0:1:len(path)-1]) {
        translate([ addCoord(v=path, base=0, lim=i-1),
                    addCoord(v=path, base=1, lim=i-1),
                    h/2]) {
            translate([ path[i][0] ? path[i][0]/2 : 0,
                        path[i][1] ? path[i][1]/2 : 0,
                        0 ])
                cube([  path[i][0] ? abs(path[i][0])+w : w,
                        path[i][1] ? abs(path[i][1])+w : w,
                        h ], center=true);
                        }
    }
}



module ESPAnt(antIdx=0) {
    // ESP Antenna (not a precise drawing)

    AntWW  = [ 0.6, 0.6 ];
    AntXD1 = [ 2.3, 6.4 ];
    AntXD2 = [ 2.3, 1.6 ];
    AntXD3 = [ 0,   3.9 ];
    AntYD1 = [ 5.4, 6.1 ];
    AntYD2 = [ 2.8, 3.9 ];
    AntYD3 = [ 3.6, 0   ];
    Ant = [
        // 0: ESP12F Antenna
       [
        [0,         AntYD1[0]],
        [AntXD2[0], 0],
        [0,         -AntYD1[0]],
        [0,         AntYD1[0]],
        [AntXD1[0], 0],
        [0,         -AntYD2[0]],
        [AntXD1[0], 0],
        [0,         AntYD2[0]],
        [AntXD1[0], 0],
        [0,         -AntYD2[0]],
        [AntXD1[0], 0],
        [0,         AntYD2[0]],
        [AntXD1[0], 0],
        [0,         -AntYD3[0]]
       ],
        // 1: ESP1 Antenna
       [
        [AntXD1[1], 0],
        [-AntXD1[1],0],
        [0,         AntYD1[1]],
        [AntXD2[1], 0],
        [0,         -AntYD2[1]],
        [AntXD2[1], 0],
        [0,         AntYD2[1]],
        [AntXD2[1], 0],
        [0,         -AntYD2[1]],
        [AntXD2[1], 0],
        [0,         AntYD2[1]],
        [AntXD3[1], 0]
       ]
    ];

    DrawPath(path=Ant[antIdx], w=AntWW[antIdx], h=0.2);
}



module LDR( LD=5.0, LH=2.2 ) {
    // LDR (small)
    // Rendered as centered on origin, pins on Y axis, laying over the XY plane

    CO = LD/10;

    translate([0,0,LH/2])
        difference() {
            union() {
                color("SaddleBrown")
                cylinder(d=LD, h=LH, center=true);
            }
            for (i=[-1:2:1])
                translate([i*(LD+5.0-CO)/2, 0, 0])
                    cube([5.0, LD+0.2, LH+CO], center=true);
        }
}


module PINHEADM(n=2, col="DarkGrey") {
    // Pinhead male
    // n is the pins number
    // Rendered as pin '1', pointing towards Z+, base on axis origin towards Y+,

    PH = 2.5+2.4+6.0;

    for (i=[0:1:n-1])
        translate([0, i*2.54, PH/2-2.5]) {
            // Pins
            color([0.55,0.55,0.55])
            difference() {
                rotate([0,0,45])
                cylinder(d=0.64, h=PH, center=true, $fn=4);
                for (i=[1:-2:-1])
                for (j=[0:1:3])
                    rotate([i*180, 0, j*90])
                    translate([0.64/2+0.35,0, i*PH/2])
                    rotate([0, i*60, 0])
                        cube([1,1,1], center=true);
            }
            // Bases
            color(col)
            translate([0, 0, (2.4-PH)/2+2.5])
                difference() {
                    cube([2.54, 2.54, 2.4], center=true);
                    for (i=[0:1:3])
                        rotate([0, 0, i*90])
                        translate([(2.54+0.75)/2, (2.54+0.75)/2, 0])
                        rotate([0, 0, 45])
                            cube([2,2,3], center=true);
                }
    }
}

module PINHEADF(n=2, BH = 8.5, col="DarkGrey") {
    // Pinhead female
    // n is the pins number. BH is the plastic housing height (8.5:common, 8.0:rare)
    // Rendered as pin '1', pointing towards Z+, base on axis origin towards Y+,

    PH = 3.3;

    for (i=[0:1:n-1])
        translate([0, i*2.54, -PH/2]) {
            // Pins
            color("gold")
            difference() {
                rotate([0,0,45])
                cylinder(d=0.64, h=PH, center=true, $fn=4);
                for (i=[0:1:3])
                    rotate([180, 0, i*90])
                    translate([0.64/2+0.35,0, PH/2])
                    rotate([0, 60, 0])
                        cube([1,1,1], center=true);
            }
            // Bases
            color(col)
            translate([0, 0, (BH+PH)/2])
                difference() {
                    cube([2.54, 2.54, BH], center=true);
                    translate([0,0,0.2])
                        cube([0.8, 0.8, BH], center=true);
                    translate([0,0, BH/2])
                    difference() {
                        cube([2,2,2], center=true);
                        for (i=[0:1:3])
                            rotate([0, 0, i*90])
                            translate([0,-1*sqrt(2),-1])
                            rotate([45, 0, 0])
                                cube([4,2,2], center=true);
                    }
                }
    }
}


module PINHEADHOLES(n=1, pitch=2.54, hd=0.8, hh=4.0) {
    // Pinhead male
    // n is the pins number, hd=hole diameter, hh=hole 'tube' height
    // Rendered as pin '1', pointing toward Z+, base on axis origin towards Y+,

    for (i=[0:1:n-1])
        translate([0, i*pitch, 0]) {
            cylinder(d=hd, h=hh, center=true);
    }
}

module PUSHBS(XDim = 6.8, YDim = 2.2, ZDim = 3.5, BXDim = 3.0, BYDim = 1.0, BZDim = 1.5, BType=1, BBColor="Ivory", BPColor="Black", Cent=false) {
    // Small 90° SMD push button

    rotate([Cent?90:0, 0, 0])
    translate([0, (Cent?1:-1)*YDim/2, Cent?0:ZDim/2]) {
        color(BBColor)
        cube([XDim, YDim, ZDim], center=true);
        color(BPColor)
        translate([0, (YDim+BYDim)/2, 0])
        if (BType==0)
            cube([BXDim, BYDim, BZDim], center=true);
        else
            rotate([90, 0, 0])
                cylinder(d=BXDim, h=BYDim, center=true);
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



module QFN32(txt="ESP8266EX", chipc="DimGray") {
    // QFN-32 SMD IC Package
    // Rendered as centered on axis origin, laying over the XY plane, pin 1 in sector X-Y+

    MD = 0.2;

    translate([0,0,(0.8+0.1)/2]) {
        // Package
        color(chipc)
        cube([5.0, 5.0, 0.8], center=true);
        // Markings
        color("White")
        translate([-5.0/2+0.8, 5.0/2-0.8,(0.8-MD)/2+0.001])
            cylinder(d=0.3, h=MD, center=true);
        color("White")
        translate([0, -0.4,(0.8-MD)/2+0.001])
            linear_extrude(height=MD, center=true, convexity=10)
                text(txt, size=0.5, font="Arial:style=Regular", halign="center", valign="center");
        // Pins
        color("Silver")
        for (i=[0:1:3])
            for (j=[0:1:7])
                rotate([0, 0, i*90])
                translate([(0.5-5.0)/2-0.001, 0.5*3.5-0.5*j, -(0.8-0.2)/2-0.05])
                    cube([0.5, 0.25, 0.2], center=true);
    }

}

module WSON(pins=4, txt="8C429", chipc="DimGray") {
    // WSONx package (WSON8)
    // Rendered as centered on axis origin, laying over the XY plane, pin 1 in sector X-Y+

    MD = 0.2;
    XDim = 6.0;
    YDim = 1.19 + 1.27*(pins-1);
    ZDim = 0.8;

    translate([0,0,(ZDim+0.1)/2]) {
        // Package
        color(chipc)
        cube([XDim, YDim, 0.8], center=true);
        // Markings
        color("White")
        translate([-XDim/2+0.8, YDim/2-0.8,(0.8-MD)/2+0.001])
            cylinder(d=0.3, h=MD, center=true);
        color("White")
        translate([0, 0,(ZDim-MD)/2+0.001])
            linear_extrude(height=MD, center=true, convexity=10)
                text(txt, size=0.5, font="Arial:style=Regular", halign="center", valign="center");
        // Pins
        color("Gold")
        for (i=[0:1:1])
            for (j=[0:1:pins-1])
                rotate([0, 0, i*180])
                translate([(0.6-XDim)/2-0.001, (1.19-YDim)/2+1.27*j, -(ZDim-0.2)/2-0.05])
                    cube([0.6, 0.42, 0.2], center=true);
    }

}

module DFN(pins=4, txt="8C429", chipc="DimGray") {
    // DFN (DFN8 based)
    // Rendered as centered on axis origin, laying over the XY plane, pin 1 in sector X-Y-

    MD = 0.2;
    XDim = 0.25 + 0.5*(pins-1);
    YDim = 3.0;
    ZDim = 0.8;
    PX = 0.25;
    PXO = 0.25/2;
    PY = 0.40;
    PZ = 0.2;
    PZO = 0.02;

    translate([0,0,ZDim/2+PZO]) {
        // Package
        color(chipc)
        cube([XDim, YDim, 0.8], center=true);
        // Markings
        color("White")
        translate([-XDim/2+0.3, -YDim/2+0.3,(0.8-MD)/2+0.001])
            cylinder(d=0.3, h=MD, center=true);
        color("White")
        translate([0, 0,(ZDim-MD)/2+0.001])
            linear_extrude(height=MD, center=true, convexity=10)
                rotate([0,0,90])
                text(txt, size=0.5, font="Arial:style=Regular", halign="center", valign="center");
        // Pins
        color("Gold")
        for (i=[0:1:1])
            for (j=[0:1:pins-1])
                rotate([0, 0, i*180])
                translate([(-XDim)/2+PXO+0.5*j, (PY-YDim)/2-0.001, -(ZDim-PZ)/2-PZO])
                    cube([PX, PY, PZ], center=true);
    }

}


module SOIC(pins=4, type=0, txt="25Q08A", chipc="DimGray" ) {
    // SOIC 154/208mils SMD IC Package
    // Rendered as centered on axis origin, laying over the XY plane, pin 1 in sector X-Y+
    // pins: number of pins ON ONE SIDE
    // type: 0=154 (large), 1=208

    CX = 0.735*2 + 1.27*(pins-1);
    CY = [0.0254*154, 0.0254*208]; // 154, 208 mils
    CZ = 1.8;
    CA = 10;
    PX = 0.48;
    PY = 1.36;
    PZO = 0.25;
    PZ = CZ/2+1.5*PZO;
    PA = 60;
    MD = 0.2;

    translate([0,0,CZ/2+PZO]) {
        color(chipc)
        difference() {
            // Main body
            cube([CX, CY[type], CZ], center=true);
            // Cutouts
            for (i=[0:1:1])
                rotate([0,0,i*180]) {
                    translate([0, -CY[type]/2, 0.25/2])
                    rotate([-CA,0,0])
                    translate([0, -CY[type]/2, CZ/2])
                        cube([CX+0.2, CY[type], CZ], center=true);
                    translate([0, -CY[type]/2, -0.25/2])
                    rotate([CA,0,0])
                    translate([0, -CY[type]/2, -CZ/2])
                        cube([CX+0.2, CY[type], CZ], center=true);
                }
        }
        // Pins
        color("Silver")
        for (i=[0:1:1])
            rotate([0,0,i*180])
            for (j=[0:1:pins-1])
            translate([1.27*(-(pins-1)/2+j), (-PY-CY[type])/2, -(PZ-PZO)/2])
            intersection() {
                cube([PX, PY, PZ], center=true);
                union() {
                    translate([0, PY/2-(PY*0.3)/2,(PZ-PZO)/2])
                        cube([PX, PY*0.3, PZO], center=true);
                    rotate([180,0,0])
                    translate([0, PY/2-(PY*0.3)/2,(PZ-PZO)/2])
                        cube([PX, PY*0.3, PZO], center=true);
                    translate([0, 0, 0])
                    rotate([PA,0,0])
                        cube([PX, PY*1.5, PZO], center=true);
                }
            }
        // Markings
        color("White")
        translate([1.27*(-(pins-1)/2), -(CY[type]-MD)/2+0.6, (CZ-MD)/2+0.001])
            cylinder(d=0.3, h=MD, center=true);
        color("White")
        translate([0, 0,(CZ-MD)/2+0.001])
            linear_extrude(height=MD, center=true, convexity=10)
                text(txt, size=0.8, font="Arial:style=Regular", halign="center", valign="center");
    }
}

module uFl() {
    // uFl antenna connector
    // Rendered as centered on axis origin, laying over the XY plane, central contact pin towards Y-

    CPH = 1.25-0.35;

    translate([0, 0, 0.35/2]) {
        // Connector
        color("Gold")
        translate([0, 0, (0.35+CPH)/2]) {
            difference() {
                cylinder(d=2.0, h=CPH, center=true);
                color("Ivory")
                cylinder(d=2.0-0.4, h=CPH+0.1, center=true);
            }
            color("Gold")
            cylinder(d=0.5, h=CPH, center=true);
        }
        // Base
        color("Ivory")
        difference() {
            cube([2.6, 2.6, 0.35], center=true);
            translate([2.6/2-0.2, 2.6/2-0.2, 0])
            rotate([0,0,-45])
            translate([0,0.5,0])
                cube([1,1,1], center=true);
        }
        // Pins
        color("Silver") {
            translate([0, -2.6/4-0.2/2, (0.15-0.35)/2-0.001])
                cube([0.6, 0.2+2.6/2, 0.15], center=true);
            PGY = 2.6/2-0.8;
            translate([0, (2.6-PGY)/2+0.2/2, (0.35-0.15)/2+0.001])
                cube([0.6, PGY, 0.15], center=true);
            translate([-2.6/2, 0, (0.15-0.35)/2])
                cube([0.4, 1.8, 0.15], center=true);
            translate([2.6/2, 0, (0.15-0.35)/2])
                cube([0.4, 1.8, 0.15], center=true);
        }
    }
}

// --- ESP-X Modules Sub-circuits