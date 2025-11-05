// ESP-01S Relay Board (common design)
module esp01s_relay(board_w=36.5, board_h=25, board_t=1.6,
                    relay_w=19, relay_h=15, relay_t=16,
                    esp_w=10, esp_h=5, esp_t=8,
                    term_w1=11, term_h1=7, term_t1=7,
                    term_w2=7.5, term_h2=7, term_t2=7,
                    jumper_w=6, jumper_h=6, jumper_t=5,
                    hole_d=3, hole_offset=3) {

    // PCB
    color("green")
    cube([board_w, board_h, board_t]);

    // Relay block (right side)
    translate([2, (board_h - relay_h-0.75), board_t])
        color("blue")
        cube([relay_w, relay_h, relay_t]);

    // ESP-01S socket (left side)
    translate([board_w-esp_w-1.6, 0, board_t])
        color("yellow")
        cube([esp_w, esp_h, esp_t]);

    // Screw terminal (near relay)
    translate([1, 0, board_t])
        color("#92cf6c")
        cube([term_w1, term_h1, term_t1]);
    
    // Screw terminal (near relay)
    translate([term_w1+4, 0, board_t])
        color("#92cf6c")
        cube([term_w2, term_h2, term_t2]);

}

