/*
Design based on Bukobot Fly by Diego Porqueras - Deezmaker (http://deezmaker.com)
*/

$fn= 60; // Smoothness setting

wing_front_thickness = 0.45; // Wing thickness
wing_back_thickness = 0.45; // Tail Thickness
wing_span = 160/2; // half of the wing span actually
wing_rib_angle = 23.5;
wing_rib_angle_r = 25.5;
nose_distance = 42;
nose_size = 8;

module wing_front_assembly_r() {
    for ( i = [0 , 1 ] ) {
        mirror([0,i,0]) wing_front_r();
    }
}

module wing_front_r() {
    hull() {
		cylinder(r=1,h=wing_front_thickness,center=0);
		translate([-60,wing_span,0])scale([1,2,1])cylinder(r=17,h=wing_front_thickness,center=0);
		translate([-70,0,0])cylinder(r=1,h=wing_front_thickness,center=0);
    }
    translate([-0.1,0,0.2]) rotate([-90,0,wing_rib_angle_r])
        scale([1,.6,1])cylinder(r=2,h=wing_span*1.45,center=0);
}

module wing_front_assembly_s() {
    for ( i = [0 , 1 ] ) {
        mirror([0,i,0]) wing_front_r();
    }
}

module wing_front_s() {
    hull() {
        cylinder(r=1,h=wing_front_thickness,center=0);
        translate([-wing_span+5,(wing_span + wing_span/4),0])
            cube([wing_span/4+5,wing_span/4,wing_front_thickness],center=false);
        translate([-70,0,0]) cylinder(r=1,h=wing_front_thickness,center=0);
    }
    //Leading Edge
    translate([-0.1,0,0.2]) rotate([-90,0,wing_rib_angle])
        scale([1,.6,1])cylinder(r=2,h=wing_span*1.45,center=0);
}

module wing_tail_assembly_r() {
    for ( i = [0 , 1 ] ) {
        mirror([0,i,0]) wing_tail_r();
    }
}

module wing_tail_r() {
	hull() {
		cylinder(r=1,h=wing_back_thickness,center=0);
		translate([-32,40,0])cylinder(r=7,h=wing_back_thickness,center=0);
		translate([-32,0,0])cylinder(r=7,h=wing_back_thickness,center=0);
	}
}

module wing_tail_assembly_s() {
    for ( i = [0 , 1 ] ) {
        mirror([0,i,0]) wing_tail_r();
    }
}

module wing_tail_s() {
	hull() {
		translate([-15,0,0])cylinder(r=1,h=wing_back_thickness,center=0);
		translate([-40,25,0])cube([10,10,wing_back_thickness],center=0);
		translate([-40, 0,0])cube([10,10,wing_back_thickness],center=0);
	}
}


// Tail Assembly
translate([-80,0,0]) {
    //Tail
    wing_tail_assembly_s();
    
    //Rudder
    translate([-35,0,0])
    hull() {
        translate([0,0,30])rotate([90,0,0])cylinder(r=5, h=1,true);
        translate([0,0,1])cube([10,1,1],true);
        translate([37,0,1])cube([1,1,1],true);
    }

    // Flap
	translate([-44,0,0]){
        hull() {
            translate([0,25,0])cylinder(r=3,h=wing_back_thickness,center=0);
            translate([0,-25,0])cylinder(r=3,h=wing_back_thickness,center=0);
        }
        translate([5,25,.2])cube([10,5,.3],true);
        translate([5,-25,.2])cube([10,5,.3],true);
        translate([5,0,.2])cube([10,5,.3],true);
    }
} // End Tail Assembly - Translate

// Fuselage
difference() {
	union() {
        // Wings
        translate([20,0,0])wing_front_assembly_s();
        // Fuselage Nose and beam
        hull() {
            translate([55,0,1])sphere(r=1.5);
            translate([45,0,3])rotate([0,90,0])cylinder(r=4,h=1,center=true);
            translate([35,0,3])rotate([0,90,0])cylinder(r=4,h=1,center=true);
            translate([-119,0,1])sphere(r=1.5);
        }
	} // End Union

    // Remove Hook Hole
	translate([40,0,3])rotate([0,0,0])cylinder(r=1.5,h=25,center=true);

    // Remove Nose and bottom trimmer
	translate([-20,0,-25])cube([200,300,50],true);
	//#translate([50,0,16])cube([100,50,20],true);
}

// Fuselage - Orig
//difference() {
//	union() {
//        // Wings
//        wing_front_assembly_s();
//        // Nose
//        hull() {
//            translate([42,0,2.5])scale([1,1.1,.6])sphere(r=8);
//            translate([-10,0,1])sphere(r=1.5);
//        }
//
//        // Fuselage beam
//        hull() {
//            translate([-10,0,1])sphere(r=1.5);
//            translate([-116,0,1])sphere(r=1.5);
//        }
//	} // End Union
//
//    // Remove Hook Hole
//	translate([38,0,3])rotate([0,15,0])cylinder(r=1.5,h=25,center=true);
//
//    // Remove Nose and bottom trimmer
//	translate([-20,0,-25])cube([200,300,50],true);
//	translate([50,0,16])cube([100,50,20],true);
//}