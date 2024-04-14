/*

Made by Diego Porqueras - Deezmaker (http://deezmaker.com)

The Bukobot Fly was originally made to test out some features of my Bukobot 3D printer and experiment with thin layers. Then I got curious to see if I can actually make it fly..and I did!

Bukobot Information: http://deezmaker.com/bukobot

The default variables are the original values used to make an actual flying glider.

Slicing recommendations with Slic3r:

First Layer Height= 3 (ratio, so first layer is 0.3mm)
Layer Height = 0.1mm
Perimeters (Shells) = 2
Fill = about 20% (Might need to experiment with this to get good balance)
Print Speed = about 40mm (Try to print it at a safe speed, if weird things happen you might need to slow down the feed rate)

If you place the Bukobot Fly on the platform at 45 deg, make sure you match the Fill angle to the direction of the body so the pattern follow the path of flight (more aerodynamic).

See latest instructions at: http://www.thingiverse.com/thing:22268

This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

$fn= 60; // Smoothness setting

wing_front_thickness = 0.45; // Wing thickness
wing_back_thickness = 0.45; // Tail Thickness
wing_span = 160/2; // half of the wing span actually
wing_rib_angle = 23.5;
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
    translate([-0.1,0,0.2]) rotate([-90,0,wing_rib_angle])
        scale([1,.6,1])cylinder(r=2,h=wing_span*1.45,center=0);
}

module wing_front_assembly_s() {
    for ( i = [0 , 1 ] ) {
        mirror([0,i,0]) wing_front_s();
    }
}

module wing_front_s() {
    hull() {
        cylinder(r=1,h=wing_front_thickness,center=0);
        translate([-wing_span+5,(wing_span + wing_span/4),0])
            cube([wing_span/4+5,wing_span/4,wing_front_thickness],center=false);
        translate([-65,0,0]) cylinder(r=1,h=wing_front_thickness,center=0);
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
		translate([-30,40,0])cylinder(r=10,h=wing_back_thickness,center=0);
		translate([-30,0,0])cylinder(r=10,h=wing_back_thickness,center=0);
	}
}

module wing_tail_assembly_s() {
    for ( i = [0 , 1 ] ) {
        mirror([0,i,0]) wing_tail_s();
    }
}

module wing_tail_s() {
	hull() {
		translate([-5,0,0])cylinder(r=1,h=wing_back_thickness,center=0);
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
        translate([0,0,30])cube([10,1,1],true);
        translate([0,0,1])cube([10,1,1],true);
        translate([30,0,1])cube([1,1,1],true);
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
            #translate([35,0,3])rotate([0,90,0])cylinder(r=4,h=1,center=true);
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