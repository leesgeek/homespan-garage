include<BoardSupport.scad>
include<esp01.scad>
include<ESP32C_WebCam.scad>


    XDim = 37.25;
    YDim = 42.0;
    ZDim = 1.5;

module BoardsPlacement(){
    rotate([180,0,0])
    translate([XDim/2+0.5, -YDim/2,-ZDim/2]) {
            ESP32_ASSM();
        }

    translate([66,0,0]){
        rotate([0,0,90]){
            esp01s_relay();
            }
        }
}



module ESP32_ASSM(){
    translate([0, 0,-11.7]) {
        ESP32CAM();
    }
    ESP32CAM_DEV();
}




