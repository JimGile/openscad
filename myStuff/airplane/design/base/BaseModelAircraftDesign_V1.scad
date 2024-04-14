/*

Jim Gile
Base Model Aircraft Design

-------------------
Calculations from:
https://www.flitetest.com/articles/easy-aircraft-design
https://www.airfieldmodels.com/information_source/math_and_science_of_model_aircraft/formulas/mean_aerodynamic_chord.htm
-------------------
CWL = This value is chosen by the designer. It is the the Cubic Wing Loading (CWL) of the plane.
    Similar aircraft have a range of CWL which dictates their flight abilities:
    0-4 oz/ft^3 = Gliders
    4-7 oz/ft^3 = Trainers
    7-13 oz/ft^3 = Sport/Aerobatic
    13+ oz/ft^3 = Racing
    Depending on what type of plane you are designing, pick a value to use. This will help
    determine the target weight of your plane in oz.
targetWeight = CWL * (wingArea * sqrt(wingArea)). This is the target weight of your palne in ounces.

MAC = Mean Aerodynamic Chord (MAC) or Geometric Mean Chord (GMC). 
        This  is where all the aerodynamic forces act on a wing.
AC =  This is the Aerodynamic Center of a wing. It is the location along cordRoot.
LAC = This value is chosen by the designer and is the fuselage length between the wingAC and the hStabAC

VH = (hStabArea*(LAC - D + SM)) / (wingArea * MAC). This is the Horizontal Stabilizer Volume (VH).
    Typical values for this are between .35 and .8. Where .35 is less effective and .8 is very effective.

D = LAC * (hStabArea/(wingArea+hStabArea))    This is a measurement to help find the Neutral Point (NP).
SM = MAC / ~10      Static Margin should be from 5% to 15% of the MAC Size. 15% being highly stable
NP = This is the Neutral Point of the plane, it  is like the AC of your entire airplane.
CG = NP - SM. This is the center of gravity of the plane (planeCG). 
    The CG must always be foreward of the NP.

LCG = This value is calculated after the CG is chosen by the designer. 
    It is the fuselage length between the planeCG and the vStabAC.
VV = (vStabArea*LCG)/(wingArea*wingSpan). This is the Vertical Stabilizer Volume (VV).
    Typical values for VV are between .02 and .05. Where .05 is a very effective tail.

-------------------
Other calculations from here:
https://www.flitetest.com/articles/Design_Parameters_for_Scratch_Built_Airframes
-------------------

Everything is based off of the Root Cord (cordRoot) of the main wing.
fuselageForeLen = 1 to 1.5 times the Root Cord. This is the length of the fuselage in front of main wing.
    This should be 30 to 35% of fuselageTotLen in front of the CG.
fuselageAftLen = 2 to 2.4 times the Root Cord. This is the length of the fuselage behind the main wing.
    This should be 65 to 70% of fuselageTotLen behind the CG.
fuselageTotLen = fuselageForeLen + cordRoot + fuselageAftLen

-------------------
Other notes:
-------------------
https://www.radiocontrolinfo.com/rc-calculators/rc-airplane-design-calculator/

https://rcplanes.online/cg_calc.htm
    For an aircraft to be stable in pitch, its CG must be forward of the
    Neutral Point NP by a safety factor called the Static Margin, which
    is a percentage of the MAC (Mean Aerodynamic Chord).
    Static Margin should be between 5% and 15% for a good stability.

    Low Static Margin gives less static stability but greater elevator
    authority, whereas a higher Static Margin results in greater static
    stability but reduces elevator authority.
    Too much Static Margin makes the aircraft nose-heavy, which
    may result in elevator stall at take-off and/or landing.
    Whereas a low Static Margin makes the aircraft tail-heavy and
    susceptible to stall at low speed, e. g. during the landing approach.
    * Choose Low Stabilizer Efficiency if the stab is close to the wing's wake
    or behind a fat fuselage in disturbed flow. Choose T-tail for most gliders.

*/

$fn= 80; // Smoothness setting

// Constants
gramsToOunce = 0.035274;
mmToInch = 0.0393701;
mmToFoot = 0.00328084;

// Big knobs
wingThick = .45;
wingSpan = 120;         //Total length of both wings
cordRoot = 25;          //Width of wing at the root
taperRatio = .6;        //Determines the cord lenght at the tip (cordTip). Normal range is 45% to 100%
leadSweepAngle = 15;    //Leading edge sweep angle of main wing. Normal range is 0 to 20 degrees.
dihedralAngle = 12;     

// Calculated Values
cordTip = cordRoot * taperRatio;
cordSum = cordRoot + cordTip;
wingArea = wingSpan * (cordSum/2);
wingSemiSpan = wingSpan/2;
wingSemiArea = wingArea/2;
wingSemiX1 = cos(90-leadSweepAngle)*wingSemiSpan;
wingSemiX2 = wingSemiX1 + cordTip;
macSize = (2/3)*(cordSum - (cordRoot*cordTip/cordSum)) + wingThick;
macY = (1/3)*((cordRoot + 2*cordTip)/cordSum)*wingSemiSpan;   //0.0 = Root, wingSemiSpan = tip
macX = (cos(90-leadSweepAngle)*macY) - wingThick/2;
aeroCenterX = macX + (macSize/4);

//echo("macSize=",macSize);

mainWing();
showMacAndAcLines();

module showMacAndAcLines() {
    // Calculated MAC or GMC line
    #translate([macX,macY,0])cube([macSize,.1,wingThick+.5]);
    // Geometric MAC Location 1
    #hull() {
        translate([-cordTip,0,0])cube([.1,.1,wingThick+.5]);
        translate([wingSemiX2+cordRoot,wingSemiSpan,0])cube([.1,.1,wingThick+.5]);
    }
    // Geometric MAC Location 2
    #hull() {
        translate([cordRoot+cordTip,0,0])cube([.1,.1,wingThick+.5]);
        translate([wingSemiX1-cordRoot,wingSemiSpan,0])cube([.1,.1,wingThick+.5]);
    }
    // AC Line (Aerodynamic Center)
    #hull() {
        translate([aeroCenterX,0,0])cube([.1,.1,wingThick+.5]);
        translate([aeroCenterX,macY,0])cube([.1,.1,wingThick+.5]);
    }
}

module mainWing() {
    hull() {
        cube(wingThick);
        translate([wingSemiX1,wingSemiSpan,0])cylinder(r=wingThick,h=wingThick,center=true);
        translate([wingSemiX2,wingSemiSpan,0])cylinder(r=wingThick,h=wingThick,center=true);
        translate([cordRoot-wingThick,0,0])cube(wingThick);
    }
}


tk = .45;
base = 150;
minHtRatio = 6;
cir = sqrt(pow(base,2)+pow(base,2));
rad = cir/(2*PI);
diam = 2*rad;
ht = cir/3;
minHt = ht/minHtRatio;
sliceAngle = atan2(ht-minHt,diam);
//echo("cir=",cir,"ht=",ht,"minHt=",minHt,"sliceAngle=",sliceAngle);

//scale([1,1,1]) {
//    //Main Cylinder
//    difference() {
//        cylinder(r=rad,h=ht,center=false);
//        translate([0,0,-1])cylinder(r=rad-(2*tk),h=ht+2,center=false);
//        translate([0,0,minHt])cylinder(r=rad-tk,h=ht,center=false);
//        translate([-(diam+1)/2,-rad,minHt])rotate([sliceAngle,0,0])cube([diam+2,base+2,ht],center=false);
//    }
//    //Upper Wing
//    difference() {
//        translate([0,tk-diam*2.5,0])cylinder(r=diam*2,h=minHt,center=false);
//        translate([0,tk-diam*2.5,-1])cylinder(r=diam*2-tk,h=minHt+2,center=false);
//        translate([diam*2+base/2,-diam*2.5,minHt/2])cube([diam*4,diam*4,minHt*2],center=true);
//        translate([-diam*2-base/2,-diam*2.5,minHt/2])cube([diam*4,diam*4,minHt*2],center=true);
//        translate([0,-diam*3,minHt/2])cube([diam*4,diam*4,minHt*2],center=true);
//    }
//    //Rudder
//    hull() {
//        translate([0,rad,minHt/2])cube([tk,rad/8,minHt],center=true);
//        translate([0,rad,ht-minHt/2])cube([tk,rad/8,minHt],center=true);
//    }    
//}
