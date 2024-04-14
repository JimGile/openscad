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

// --------------------------------
// Constants
// --------------------------------
gramsToOunce = 0.035274;
mmToInch = 0.0393701;
mmToFoot = 0.00328084;

// --------------------------------
// Design Variables
// --------------------------------
// Wing
wingThick = .3;
wingSpan = 190; //Total length of both wings
cordRoot = 50; //Width of wing at the root
taperRatio = .6; //Determines the cord lenght at the tip. Range is 45% to 100%
leadSweepAngle = 20; //Leading edge sweep angle of main wing. Range is 0 to 20 degrees.
dihedralAngle = 12; //Wing dihedral in degrees. 6=Controled, 12=FreeFlight

//Stabilizer Efficiency (Standard=0.85,TTail=0.95,Low=0.65) 
stabEff = 0.85;    

// Horizontal Stabilizer
hStabSweepAngle = 20;
hStabCordRootPctOfWing = .5;
hStabCordTaperRatio = .7;
hStabAreaPctOfWing = .15;

// Vertical Stabilizer
vStabThick = .65;
vStabSweepAngle = 20;
vStabCordTaperRatio = .7;
vStabAreaPctOfHStab = 3/4;

// Fuselage
fuselageH = 6;
fuselageW = 3;
fuselageTaperRatio = .75;
fuselageForeLenPctOfCord = 1;   //Between 1 and 1.5
fuselageAftLenPctOfCord = 1.5;   //Between 2 and 2.4

// --------------------------------
// Calculated Values
// --------------------------------
// Wing
cordTip = cordRoot * taperRatio;
cordSum = cordRoot + cordTip;
wingArea = wingSpan * (cordSum/2);
wingSemiSpan = wingSpan/2;

// H Stab
hStabCordRoot = cordRoot*hStabCordRootPctOfWing;
hStabCordTip = hStabCordRoot*hStabCordTaperRatio;
hStabCordSum = hStabCordRoot+hStabCordTip;
hStabArea = wingArea*hStabAreaPctOfWing;
hStabSpan = hStabArea/(hStabCordSum/2);
hStabSemiSpan = hStabSpan/2;

// V Stab
vStabCordRoot = hStabCordRoot;
vStabCordTip = vStabCordRoot*vStabCordTaperRatio;
vStabCordSum = vStabCordRoot+vStabCordTip;
vStabArea = hStabArea*vStabAreaPctOfHStab;
vStabSpan = vStabArea/(vStabCordSum/2);
vStabSemiSpan = vStabSpan/2;

// Fuselage
fuselageForeL = cordRoot*fuselageForeLenPctOfCord;
fuselageAftL = cordRoot*fuselageAftLenPctOfCord;
fuselageL = fuselageForeL+cordRoot+fuselageAftL;

//echo("macSize=",macSize);

// --------------------------------
// Base rendering code
// --------------------------------
sl = false;
mainWingAssembly(showLines=sl);
horizontalStabilizerAssembly(showLines=sl);
verticalStabilizerAssembly(showLines=sl);
fuselageAssembly(showLines=sl);


// --------------------------------
// Modules
// --------------------------------
// Render full main wing assembly
module mainWingAssembly(showLines=false) {
    for ( i = [0 , 1 ] ) {
        mirror([0,i,0]) mainWing(showLines);
    }
}

//Render right half of main wing planform
module mainWing(showLines=false) {
    renderHalfPlanform(
        cordRoot, 
        cordTip, 
        wingSemiSpan, 
        leadSweepAngle, 
        wingThick, 
        flat=false, 
        showLines=showLines);
}

// Render full horizontal stabilizer assembly
module horizontalStabilizerAssembly(showLines=false) {
    for ( i = [0 , 1 ] ) {
        mirror([0,i,0]) horizontalStabilizer(showLines);
    }
}

//Render right half of horizontal stabilizer planform
module horizontalStabilizer(showLines=false) {
    translate([fuselageL-fuselageForeL-hStabCordRoot,0,0])
    renderHalfPlanform(
        hStabCordRoot, 
        hStabCordTip, 
        hStabSemiSpan, 
        hStabSweepAngle, 
        wingThick, 
        flat=true, 
        showLines=showLines);
}


//Render vertical stabilizer planform
module verticalStabilizerAssembly(showLines=false) {
    x = fuselageL-fuselageForeL-vStabCordRoot;
    y = vStabThick/2;
    z = (fuselageH*fuselageTaperRatio)-.1;
    translate([x, y, z])
    rotate([90,0,0])
    renderHalfPlanform(
        vStabCordRoot, 
        vStabCordTip, 
        vStabSemiSpan, 
        vStabSweepAngle, 
        vStabThick, 
        flat=true, 
        showLines=showLines);
}

//Render right half of a wing planform
module renderHalfPlanform(cRoot, cTip, span, sweep, thick, flat=false, showLines=false) {
    calcValuesList = calcMacAndAeroCenter(cRoot, cTip, span, sweep, thick);
    cSum = calcValuesList[0];
    cTipX1 = calcValuesList[1];
    cTipX2 = calcValuesList[2];
    edgeLen = calcValuesList[3];
    macSize = calcValuesList[4];
    macY = calcValuesList[5];
    macX = calcValuesList[6];
    aeroCenterX = calcValuesList[7];
    
    // Base planform
    hull() {
        cube(thick);
        translate([cTipX1,span,0])cylinder(r=thick,h=thick,center=true);
        translate([cTipX2,span,0])cylinder(r=thick,h=thick,center=true);
        translate([cRoot-thick,0,0])cube(thick);
    }
    // Leading edge support/airfoil
    if (!flat) {
        rad = 2;
        yPct = .6;
        x0 = rad;
        x1 = cTipX1+rad-thick;
        difference() {
            // Cylinder Support
            hull() {
                translate([x0,0,0])rotate([-90,0,0])
                    scale([1,yPct,1])cylinder(r=rad,h=thick,center=false);
                translate([x1,span,0])rotate([-90,0,0])
                    scale([1,yPct,1])cylinder(r=rad,h=thick,center=false);
            }
            // Remove bottom of cylinder support
            translate([-2,-2,-5-(thick/2)])cube([cTipX2,span+4,5]);
            // Remove excess at tip
            translate([-cTipX2,span+thick,-1])cube([cTipX2*2,2,5]);
        }
    }
    // Render MAC and AC lines
    if (showLines) {
        z = thick+.5;
        // Calculated MAC or GMC line
        #translate([macX,macY,0])cube([macSize,.1,z]);
//        // Geometric MAC Location 1
//        #hull() {
//            translate([-cTip,0,0])cube([.1,.1,z]);
//            translate([cTipX2+cRoot,span,0])cube([.1,.1,z]);
//        }
//        // Geometric MAC Location 2
//        #hull() {
//            translate([cSum,0,0])cube([.1,.1,z]);
//            translate([cTipX1-cRoot,span,0])cube([.1,.1,z]);
//        }
        // AC Line (Aerodynamic Center)
        #hull() {
            translate([aeroCenterX,0,0])cube([.1,.1,z]);
            translate([aeroCenterX,macY,0])cube([.1,.1,z]);
        }
    }
}

module fuselageAssembly(showLines=false) {
    z = wingThick+.5;
    radCG = fuselageH/2;
    radN = radCG * fuselageTaperRatio;
    radT = radN;
    //xCG = cordRoot/2; //TOD: eed to calualte this!!!!
    xN = -fuselageForeL+radN/2;
    xT = fuselageL-fuselageForeL-radT/2;
    
    wingCalcValuesList = calcMacAndAeroCenter(
        cordRoot, 
        cordTip, 
        wingSemiSpan, 
        leadSweepAngle, 
        wingThick);
    hStabCalcValuesList = calcMacAndAeroCenter(
        hStabCordRoot, 
        hStabCordTip, 
        hStabSemiSpan, 
        hStabSweepAngle, 
        wingThick);
        
    wingMacSize = wingCalcValuesList[4];
    wingMacY = wingCalcValuesList[5];
    wingAcX = wingCalcValuesList[7];
    hStabAcX = hStabCalcValuesList[7]+fuselageL-fuselageForeL-hStabCordRoot;
    LAC = hStabAcX - wingAcX;
    D = LAC * (hStabArea/(wingArea+hStabArea));
    NP = wingAcX + D;
    SM = D/(wingMacSize*2);
    xCG = wingAcX + (D/2);
    
    echo("hStabAcX=",hStabAcX,"wingAcX=",wingAcX,"LAC=",LAC,"D=",D,"NP=",NP,"SM=",SM,"wingArea=",wingArea,"hStabArea=",hStabArea, "wingMacSize=",wingMacSize);

    if(showLines) {
        // Neutral Point
        color("blue")
        hull() {
            translate([NP,wingMacY,0])cube([.1,.1,z]);
            translate([NP,-wingMacY,0])cube([.1,.1,z]);
        }
        // Center of Gravity
        color("green")
        hull() {
            translate([xCG,wingMacY,0])cube([.1,.1,z]);
            translate([xCG,-wingMacY,0])cube([.1,.1,z]);
        }
    }

    difference() {
        hull() {
            translate([xN,0,radN])rotate([-90,0,0])
                cylinder(r=radN,h=fuselageW,center=true);
            translate([xCG,0,radCG])rotate([-90,0,0])
                cylinder(r=radCG,h=fuselageW,center=true);
            translate([xT,0,radT])rotate([-90,0,0])
                cylinder(r=radT,h=fuselageW,center=true);
        }
        // Hole for CG
        translate([xCG,0,radCG])rotate([-90,0,0])
            cylinder(r=1,h=fuselageW+2,center=true);
        // Hole in nose for weight
        translate([xN+2,0,radN])rotate([-90,0,0])
            cylinder(r=1,h=fuselageW+2,center=true);
        // Hole in tail
        translate([xT-2,0,radT])rotate([-90,0,0])
            cylinder(r=1,h=fuselageW+2,center=true);
        
    }


    
}

// --------------------------------
//Functions
// --------------------------------
function calcMacAndAeroCenter(cRoot, cTip, span, sweep, thick) =
    let(cSum=cRoot+cTip)
    let(cTipX1 = sin(sweep)*span)
    let(cTipX2 = cTipX1 + cTip)
    let(edgeLen = sqrt(pow(span,2) + pow(cTipX1,2)))
    let(macSize = (2/3)*(cSum - (cRoot*cTip/cSum)) + thick)
    let(macY = (1/3)*((cRoot + 2*cTip)/cSum)*span)
    let(macX = (sin(sweep)*macY) - thick/2)
    let(acX = macX + (macSize/4))
    [cSum, cTipX1, cTipX2, edgeLen, macSize, macY, macX, acX];
