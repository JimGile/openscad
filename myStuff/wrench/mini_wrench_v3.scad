include <MCAD/shapes.scad>
include <MCAD/bitmap/bitmap.scad>
include <smooth_prim/smooth_prim.scad>

kerf = 0.4;
smooth_r = 1.6;

D = 6 + kerf; 	// DIAMETER OF NUT
M = D/1.75; 	// MARGIN
H = 5; 	        // HEIGHT (THICKNESS) OF TOOL
W = D*2;     // Width
Ltot = D * 10; 	// TOTAL LENGTH OF TOOL


// Length from Center of One Side to Center of Other Side
L = Ltot-2*(D/2+M);


//rotate([0, 0, -45])
difference() {
	union() {
		translate([0,L/2.2,0]) {
			//cylinder(r = (D/2+M), h = H,center = true);
            SmoothCylinder((D/2+M), H*1.75, smooth_r);
		}
		translate([0,-L/2.2,0]) {
			//cylinder(r = (D/2), h = H,center = true);
            SmoothCylinder(W/2, H, smooth_r);
		}
		translate([-1*W/2,-L/2,0]) {
			//cube([D,L,H], center=false);
            SmoothCube([W,L,H], smooth_r);
		}
	}
	translate([0,L/2.2,H/2]) {
        hexagon(D, H*3);
	}
}
