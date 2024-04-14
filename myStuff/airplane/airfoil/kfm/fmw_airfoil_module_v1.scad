echo(version=version());


module kfm2_airfoil(chord,holes=true) {
    thick=chord*.04;
    echo("base thickness ",thick);
    translate([0,-chord,0]) {
        difference() {
            union() {
                //leading edge
                translate([thick,thick,0]) circle(thick);
                //base
                translate([0,thick,0]) square([thick,chord-thick]);
                //top step
                translate([thick,thick,0]) square([thick,(chord/2)-thick]); 
            }
            if (holes==true && thick > .99) {
                for (y=[thick:2*thick:chord/2]) {
                    translate([thick,y,0]) circle(thick/2);
                }
            }
        }
    }
}

module kfm2_wing(span,chord,scale=[1,1],center=false) {
    rotate([0,-90,180])
    translate([0,0,0])
    linear_extrude(height=span,center=center,scale=scale,slices=10,convexity=3) {
        rotate([0,0,0])
        translate([0,0,0])
        kfm2_airfoil(chord);
    }
}


module naca_wing_supports(span,chord,t,n,h,num_holes,scale,flat,center=false) {
    z=chord*t;
    width = .4;
    step = 5;
    //End Caps
    difference() {
        rotate([-90,0,0])
        naca_wing(span=span,chord=chord,t=t,n=n,scale=scale,flat=flat);
        translate([-(chord+1),width,-((z/2)+1)]) cube([chord+2,span-(2*width),z+2]);
    }
    difference() {
        rotate([-90,0,0])
        if (z/2 > 4) {
            naca_wing_holes(span=span,chord=chord,t=t,n=n,h=h,num_holes=num_holes,scale=scale,flat=flat);
        } else {
            naca_wing(span=span,chord=chord,t=t,n=n,scale=scale,flat=flat);
        }
        for (y=[0:step:span-step]) {
            translate([-(chord+1),y+width/2,-((z/2)+1)]) cube([chord+2,step-width,z+2]);
        }
    }
}

module naca_wing_hollow_supports(span,chord,t,n,h,num_holes,scale,flat,center=false) {
    rotate([-90,0,0])
    #naca_wing_hollow(span=span,chord=chord,t=t,n=n,h=h,scale=scale,flat=flat);
    naca_wing_supports(span=span,chord=chord,t=t,n=n,h=h,num_holes=num_holes,scale=scale,flat=flat);
}

module naca_wing_section(span,chord,t,n,scale,flat,center,y_pos,width) {
    rotate([-90,0,0])
    naca_wing(span=s,chord=c,t=t,n=n,scale=scale,flat=flat);
}

module dihedral_wing_assembly() {
}


s=60;   //span
c=25;   //chord
t=0.2;  //airfoil thickness
n=500;  //number of points to define airfoil
h=0.8;  // percent hollow
holes=15;
scale=[.75,.33];
flat=true;
$fn=100;

//rotate([0,0,180])
//kfm2_airfoil(c);
kfm2_wing(s,c,scale);

//naca_wing_hollow_supports(span=s,chord=c,t=t,n=n,h=h,num_holes=holes,scale=scale,flat=flat);


//naca_wing_supports(span=s,chord=c,t=t,n=n,num_holes=holes,scale=scale,flat=flat);

//#naca_airfoil_holes(chord=c,t=t,n=n,h=h,num_holes=holes,flat=flat);
//naca_airfoil_hollow(chord=c,t=t,n=n,h=h,flat=flat);

//rotate([-90,0,0])
//naca_wing_holes(span=s,chord=c,t=t,n=n,num_holes=holes,scale=scale,flat=flat);


//rotate([-90,0,0])
//#naca_wing_hollow(span=s,chord=c,t=t,n=n,h=h,scale=scale,flat=flat);

//rotate([-90,0,0])
//naca_wing(span=s,chord=c,t=t,n=n,scale=scale,flat=flat);


////Wings
//rotate([0,0,0])
//rotate([-90,0,0])
//    naca_wing_hollow(span=s,chord=c,t=t,n=n,h=h,scale=scale,flat=flat,center=false);
//mirror([0,1,0])
//rotate([0,0,0])
//rotate([-90,0,0])
//    naca_wing_hollow(span=s,chord=c,t=t,n=n,h=h,scale=scale,flat=flat,center=false);
//
////Body
//translate([-25,0,0])
//resize(newsize=[115,5,4]) cylinder(r=5,h=4);
//translate([31,0,0])
//cylinder(r=2,h=4);
//
////Rear Stablizers
//translate([-67,0,0])
//rotate([0,0,8])
//rotate([-90,0,0])
//    naca_wing(span=s/3,chord=c/2,t=t,n=n,scale=[.75,.85],flat=flat,center=false);
//mirror([0,1,0])
//translate([-67,0,0])
//rotate([0,0,8])
//rotate([-90,0,0])
//    naca_wing(span=s/3,chord=c/2,t=t,n=n,scale=[.75,.85],flat=flat,center=false);
//
//// Tail    
//translate([-67,0,3.5])
//rotate([0,-15,0])
//naca_wing(span=s/4,chord=c/2,t=t/2,n=n,scale=[.75,1],flat=false,center=false);
//
//    
////translate([-42.5,0,2])
////#cube([85,4,4], center=true);
//
//
////rotate([0,180,0])
////naca_airfoil(chord=20,t=0.15,n=500);
////translate([1.5,0,0])
////#naca_airfoil(chord=15,t=0.1,n=500);
//
////naca_airfoil(chord=c,t=t,n=500,flat=flat);
////translate([c/(h*25),.3,0])
////#naca_airfoil(chord=c*h,t=t*h,n=500,flat=flat);
//
//
//
//
//
//
//
//
////import("D:/Documents/OpenSCAD/downloads/SUPERSIZED_SPARROW.stl");
