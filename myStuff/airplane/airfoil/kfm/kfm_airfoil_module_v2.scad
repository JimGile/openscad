use <BendScad/bend.scad>

module kfm0_airfoil(chord,holes=true,t_pct=0.04) {
    thick=chord*t_pct;
    echo("kfm0_airfoil t_pct =",t_pct);
    if (holes==true) {
        echo("kfm0 base thickness=",thick);
    }
    translate([0,-chord,0]) {
        difference() {
            union() {
                //leading edge
                translate([thick/2,thick/2,0]) circle(thick/2);
                //base
                translate([0,thick/2,0]) square([thick,chord-thick/2]);
            }
            if (holes==true && thick/2 > .99) {
                for (y=[thick:1.5*thick:chord-1]) {
                    translate([thick/2,y,0]) circle(thick/4);
                }
            }
        }
    }
}

module kfm0_wing_extrude(span,chord,scale=[1,1],holes=true,center=false,t_pct=0.04) {
    echo("kfm0_wing_extrude t_pct =",t_pct);
    rotate([0,-90,180])
    linear_extrude(height=span,center=center,scale=scale,slices=15,convexity=3) {
        kfm0_airfoil(chord,holes,t_pct=t_pct);
    }
}

module kfm0_wing_endcaps(span,chord,scale=[1,1],center=false,t_pct=0.04) {
    echo("kfm0_wing_endcaps t_pct =",t_pct);
    z=chord*.2;
    width = 1;
    difference() {
        kfm0_wing_extrude(span,chord,scale,holes=false,center,t_pct=t_pct);
        translate([width,-width,-((z/2)+1)]) cube([span-(2*width),chord+2,z+2]);
    }
}

module kfm0_wing(span,chord,scale=[1,1],center=false,t_pct=0.04) {
    echo("kfm0_wing t_pct =",t_pct);
    kfm0_wing_extrude(span,chord,scale,center,t_pct=t_pct);
    kfm0_wing_endcaps(span,chord,scale,center,t_pct=t_pct);
}

module kfm0_wing_assembly(span,chord,scale=[1,1],t_pct=0.04) {
    echo("kfm0_wing_assembly t_pct=", t_pct);
    kfm0_wing(span,chord,scale,center=false,t_pct=t_pct);
    mirror([1,0,0])
    kfm0_wing(span,chord,scale,center=false,t_pct=t_pct);
}


module kfm2_airfoil(chord,holes=true) {
    thick=chord*.04;
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
            if (holes==true && thick >= 2) {
                for (y=[thick:2*thick:chord/2]) {
                    translate([thick,y,0]) circle(thick/2);
                }
            }
        }
    }
}

module kfm2_wing_extrude(span,chord,scale=[1,1],holes=true,center=false) {
    rotate([0,-90,180])
    linear_extrude(height=span,center=center,scale=scale,slices=15,convexity=3) {
        kfm2_airfoil(chord=chord,holes=holes);
    }
}

module kfm2_wing_endcaps(span,chord,scale=[1,1],center=false) {
    z=chord*.2;
    width = 1;
    difference() {
        kfm2_wing_extrude(span,chord,scale,holes=false);
        translate([width,-width,-((z/2)+1)]) cube([span-(2*width),chord+2,z+2]);
    }
}

module kfm2_wing(span,chord,scale=[1,1],center=false) {
    union() {
        kfm2_wing_extrude(span,chord,scale);
        kfm2_wing_endcaps(span,chord,scale);
    }
}

module kfm2_wing_bent_tip(span,chord,scale=[1,1],pctSpanFlat=1.0) {
    if (pctSpanFlat >= 1) {
        kfm2_wing(span,chord,scale);
    } else {
        t = chord*.04*2;
        s_flat = span*pctSpanFlat;
        s_bent = span*(1-pctSpanFlat);
        echo("s_bent=",s_bent);
        translate([s_flat,chord,0]) rotate(-90, [0,0,1]) {
            cylindric_bend([chord, s_bent, t], s_bent, nsteps=35)
                translate([chord, -s_flat, 0]) rotate(90, [0,0,1])
                    difference() {
                        kfm2_wing(span,chord,scale);
                        translate([-1,-1,-1]) cube([s_flat,chord+2,t+2]);
                    }
//            parabolic_bend([chord, s_bent/(1.2/pctSpanFlat), t], 0.15, nsteps=35)
//                translate([chord, -s_flat, 0]) rotate(90, [0,0,1])
//                    difference() {
//                        kfm2_wing(span,chord,scale);
//                        translate([-1,-1,-1]) cube([s_flat+1,chord+2,t+2]);
//                    }
        }
        difference() {
            kfm2_wing(span,chord,scale);
            translate([s_flat,-1,-1]) cube([s_bent+2,chord+2,t+2]);
        }
    }
}

module kfm2_wing_assembly(span,chord,scale=[1,1],pctSpanFlat=1.0) {
    kfm2_wing_bent_tip(span,chord,scale,pctSpanFlat);
    mirror([1,0,0])
    kfm2_wing_bent_tip(span,chord,scale,pctSpanFlat);
}


//s=80;   //span
//c=25;   //chord
//scale=[.75,.33];
//pct=0.85;
//$fn=35;

//kfm0_airfoil(c);
//kfm0_wing_endcaps(s,c,scale);
//kfm0_wing(s,c,scale);
//kfm0_wing_assembly(s,c,scale);

//kfm2_airfoil(c);
//kfm2_wing_endcaps(s,c,scale);
//kfm2_wing(s,c,scale);
//kfm2_wing_assembly(s,c,scale,pct);

//x=150;
//y=30;
//z=y*2;
//t=2;
//translate([0,-t,z/4]) rotate([-90,0,0])
//difference() {
//    resize(newsize=[x,y,z]) cylinder(r=1,h=1);
//    translate([0,0,-t/2]) resize(newsize=[x-t,y-t,z+t]) cylinder(r=1,h=1);
//    translate([0,0,z+t]) rotate([65,0,0]) cube([x*2,y,z*2],center=true);
//    translate([0,-y/5,z/(t*4.5)]) rotate([33,0,0]) cube([x*2,y,z*2],center=true);
//}
//%rotate([-90,0,0]) translate([0,-t,0])
//    difference() {
//        resize(newsize=[t*2,t*2,x-y]) cylinder(r=1,h=1,center=true);
//        #resize(newsize=[t,t,x]) cylinder(r=1,h=1,center=true);
//    }
//
//#translate([0,y+20,0]) rotate([0,-90,180]) 
//    kfm0_wing(span=y,chord=20,scale=[1,.23],center=false);

