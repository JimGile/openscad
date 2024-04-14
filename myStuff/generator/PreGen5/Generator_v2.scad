// Smooth rendering
$fa = 1;
$fs = 0.4;

// Variables
num_disks = 5;
metal_w = 4;
magnet_w = 4;
coil_w = 4;
disk_defs = [
    ["METAL",metal_w,-2],
    ["COIL",coil_w,-1],
    ["MAGNET",magnet_w,0],
    ["COIL",coil_w,1],
    ["METAL",metal_w,2]
];
//disk_w = 4;
disk_r = 40;
axel_r = disk_r/10;
axel_h = 40;
gap = 1;

for (disk_def=disk_defs) {
    echo(disk_def);
}
// Main rendering code
translate([0,0,0]) {
    for (disk_def=disk_defs) {
        disk_type = disk_def[0];
        disk_w = disk_def[1];
        disk_y = disk_def[2]*(disk_w+gap);
        translate([0,disk_y,0])
            disk(disk_type, disk_w);
        echo(disk_def);
    }    
//    // Rotating Disk with magnets
//    translate([0,0,0])
//        disk();
//    // Stationary Disk with coils 1
//    translate([0,disk_w+gap,0])
//        stationaryDisk();
//    // Stationary Disk with coils 2
//    translate([0,-(disk_w+gap),0])
//        stationaryDisk();
//    // Rotating Disk with metal 1
//    translate([0,(disk_w+gap)*2,0])
//        disk();
//    // Rotating Disk with metal 2
//    translate([0,-(disk_w+gap)*2,0])
//        disk();
    // Axel
    translate([0,0,0])
        axel();
}

module disk(type, w) {
    if (type == "METAL") {
        metalDisk(w);
    } else if (type == "MAGNET") {
        magnetDisk(w);
    } else if (type == "COIL") {
        coilDisk(w);
    }
}
// Rotating Disk with magnets
module magnetDisk(w) {
    // Disk
    rotate([90,0,0])cylinder(h=w,r=disk_r,center=true);
}
// Rotating Disk with metal
module metalDisk(w) {
    // Disk
    rotate([90,0,0])cylinder(h=w,r=disk_r,center=true);
}
// Stationary Disk with coils
module coilDisk(w) {
    base_x = ((disk_r*2)-(disk_r/4));
    base_y = w;
    base_z = disk_r+(disk_r/4);
    
    // Disk
    rotate([90,0,0])cylinder(h=w,r=disk_r,center=true);
    // Base
    translate([0,0,-(disk_r/2)])
    cube([base_x,base_y,base_z],center=true);
}
    
// Axel
module axel() {
    rotate([90,0,0])cylinder(h=axel_h,r=axel_r,center=true);
}