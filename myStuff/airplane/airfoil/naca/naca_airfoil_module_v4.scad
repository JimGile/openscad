echo(version=version());

function naca_half_thickness(x,t) = 5*t*(0.2969*sqrt(x) - 0.1260*x - 0.3516*pow(x,2) + 0.2843*pow(x,3) - 0.1015*pow(x,4));

function naca_top_coordinates(t,n) = [ for (x=[0:1/(n-1):1]) [x, naca_half_thickness(x,t)]];
    
function naca_top_chord_line(t,n) = [ for (x=[0:1/(n-1):1]) naca_half_thickness(x,t)];
function naca_top_chord_line_list(t,n) = [ for (x=[0:1/(n-1):1]) [x, naca_half_thickness(x,t)]];
    
function naca_bottom_coordinates(t,n) = [ for (x=[1:-1/(n-1):0]) [x, - naca_half_thickness(x,t)]];
    
function naca_bottom_coordinates_flat(t,n) = [ for (x=[1:-1/(n-1):0]) [x, 0]];

function naca_coordinates(t,n) = concat(naca_top_coordinates(t,n), naca_bottom_coordinates(t,n));

function naca_coordinates_flat(t,n) = concat(naca_top_coordinates(t,n), naca_bottom_coordinates_flat(t,n));

module naca_airfoil(chord,t,n,flat=false) {
    points = flat ? naca_coordinates_flat(t,n) : naca_coordinates(t,n);
    hull() {
        scale([chord,chord,1]) polygon(points);
    }
}

module naca_airfoil_hollow(chord,t,n,h,flat=false) {
    half_height = chord*t/2;
    x_off = (half_height)*pow(h,4);
    y_off = flat ? half_height*(1-h)*h : 0;
    bot_min = min((half_height/3), 0.5);
    difference() {
        naca_airfoil(chord=chord,t=t,n=n,flat=flat);
        translate([x_off,y_off,0])
        scale([h,pow(h,2),1]) naca_airfoil(chord=chord,t=t,n=n,flat=flat);
    }
    if (flat == true) {
        translate([x_off,0,0]) square([chord*h, bot_min]);
    }
}

module naca_airfoil_holes(chord,t,n,h,num_holes=10,flat=false) {
    half_height = chord*t/2;
    //min_height = (half_height*pow(h,5));
    min_height = half_height*pow(h,5);
    echo(min_height);
    top_chord_line_list = naca_top_chord_line_list(t=t,n=num_holes*2/3);
    if (flat == true) {
        top_chord_line_list = naca_top_chord_line_list(t=t,n=num_holes);
    }
    difference() {
        naca_airfoil(chord=chord,t=t,n=n,flat=flat);
        for (chord_list = top_chord_line_list) {
            if (flat == true) {
                if (chord_list[1]*c/2 > min_height) {
                    echo(chord_list[1]*c/2);
                    translate([chord_list[0]*c, chord_list[1]*c/2, 0]) 
                    circle((chord_list[1]*c/2)/2);
                }
            } else {
                if (chord_list[1]*c/2 > min_height) {
                    translate([chord_list[0]*c, 0, 0]) 
                    circle((chord_list[1]*c/2));
                }
            }
        }
    }
}


module naca_wing(span,chord,t,n,scale=[1,1],flat=false,center=false) {
    linear_extrude(height=span,center=center,scale=scale,slices=10,convexity=3) {
        rotate([0,0,180])
        naca_airfoil(chord,t,n,flat);
    }
}

module naca_wing_hollow(span,chord,t,n,h,scale,flat,center=false) {
    linear_extrude(height=span,center=center,scale=scale,slices=10,convexity=3) {
        rotate([0,0,180])
        naca_airfoil_hollow(chord=chord,t=t,n=n,h=h,flat=flat);
    }
}

module naca_wing_holes(span,chord,t,n,h,num_holes,scale,flat,center=false) {
    linear_extrude(height=span,center=center,scale=scale,slices=10,convexity=3) {
        rotate([0,0,180])
        naca_airfoil_holes(chord=chord,t=t,n=n,h=h,num_holes=num_holes,flat=flat);
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


s=30;   //span
c=40;   //chord
t=0.2;  //airfoil thickness
n=500;  //number of points to define airfoil
h=0.8;  // percent hollow
holes=15;
scale=[1,1];
flat=true;
$fn=100;

//naca_wing_hollow_supports(span=s,chord=c,t=t,n=n,h=h,num_holes=holes,scale=scale,flat=flat);


//naca_wing_supports(span=s,chord=c,t=t,n=n,num_holes=holes,scale=scale,flat=flat);

#naca_airfoil_holes(chord=c,t=t,n=n,h=h,num_holes=holes,flat=flat);
naca_airfoil_hollow(chord=c,t=t,n=n,h=h,flat=flat);

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
