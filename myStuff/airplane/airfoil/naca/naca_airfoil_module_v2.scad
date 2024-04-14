echo(version=version());

function naca_half_thickness(x,t) = 5*t*(0.2969*sqrt(x) - 0.1260*x - 0.3516*pow(x,2) + 0.2843*pow(x,3) - 0.1015*pow(x,4));

function naca_top_coordinates(t,n) = [ for (x=[0:1/(n-1):1]) [x, naca_half_thickness(x,t)]];
    
function naca_top_chord_line(t,n) = [ for (x=[0:1/(n-1):1]) naca_half_thickness(x,t)];
    
function naca_bottom_coordinates(t,n) = [ for (x=[1:-1/(n-1):0]) [x, - naca_half_thickness(x,t)]];
    
function naca_bottom_coordinates_flat(t,n) = [ for (x=[1:-1/(n-1):0]) [x, 0]];

function naca_coordinates(t,n) = concat(naca_top_coordinates(t,n), naca_bottom_coordinates(t,n));

function naca_coordinates_flat(t,n) = concat(naca_top_coordinates(t,n), naca_bottom_coordinates_flat(t,n));

module naca_airfoil(chord,t,n,flat=false) {
    points = flat ? naca_coordinates_flat(t,n) : naca_coordinates(t,n);
    scale([chord,chord,1]) polygon(points);
}

module naca_airfoil_hollow_old(chord,t,n,h,flat=false) {
    x_off = chord/(h*15);
    y_off = flat ? .35 : 0;
    difference() {
        naca_airfoil(chord=chord,t=t,n=n,flat=flat);
        translate([x_off,y_off,0])
        naca_airfoil(chord=chord*h,t=t*h,n=n,flat=flat);        
    }
}

module naca_airfoil_hollow(chord,t,n,h,flat=false) {
    x_off = (h/t*t)+h/2;
    y_off = flat ? 2*t*h : 0;
    difference() {
        naca_airfoil(chord=chord,t=t,n=n,flat=flat);
        //translate([6*t*h,y_off,0])
        translate([x_off,y_off,0])
        scale([h,pow(h,2),1]) naca_airfoil(chord=chord,t=t,n=n,flat=flat);
        //naca_airfoil(chord=chord*h,t=t*h/1.1,n=n,flat=flat);        
    }
    translate([x_off,0,0])
    scale([h,1,1])square([chord, .5]);
}


module naca_wing(span,chord,t,n,scale=[1,1],flat=false,center=false) {
    linear_extrude(height=span,center=center,scale=scale) {
        rotate([0,0,180])
        naca_airfoil(chord,t,n,flat);
    }
}

module naca_wing_hollow(span,chord,t,n,h,scale=[1,1],flat=false,center=false) {
    linear_extrude(height=span,center=center,scale=scale) {
        rotate([0,0,180])
        naca_airfoil_hollow(chord,t,n,h,flat);
    }
}

module naca_wing_section(span,chord,t,n,scale,flat,center,y_pos,width) {
    rotate([-90,0,0])
    naca_wing(span=s,chord=c,t=t,n=n,scale=scale,flat=flat);

}



module dihedral_wing_assembly() {
}


s=75;
c=30;
t=0.2;
n=500;
h=0.8;
scale=[0.5,.75];
flat=true;
$fn=100;

lgth=c*3/4;
step=(t*lgth/2)*2/(t*c/2);

top_chord_line_list = naca_top_chord_line(t=t,n=c);
difference() {
    naca_airfoil(chord=c,t=t,n=n,flat=flat);
    for (x =[1:step:lgth-2*step]) {
        if (top_chord_line_list[x*step]*c/2 > .3) {
            translate([x*step, top_chord_line_list[x*step]*c/2, 0]) 
            #circle((top_chord_line_list[x*step]*c/2)*2/3);
        }
    }
}

//naca_airfoil_hollow(chord=c,t=t,n=n,h=h,flat=flat);
//rotate([-90,0,0])
//naca_wing_hollow(span=s,chord=c,t=t,n=n,h=h,scale=scale,flat=flat);

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
