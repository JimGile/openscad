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

use <smooth_prim\smooth_prim.scad>
$fn= 80; // Smoothness setting

// --------------------------------
// Constants
// --------------------------------
gramsToOunce = 0.035274;
mmToInch = 0.0393701;
mmToFoot = 0.00328084;
sqMmToSqFeet = 1.07639e-5;

// --------------------------------
// Design Variables
// --------------------------------
// Wing
wingThick = .6;
wingSpan = 220; //Total length of both wings
cordRoot = 50; //Width of wing at the root
taperRatio = .45; //Determines the cord lenght at the tip. Range is 45% to 100%
leadSweepAngle = 20; //Leading edge sweep angle of main wing. Range is 0 to 20 degrees.
dihedralAngle = 12; //Wing dihedral in degrees. 6=Controled, 12=FreeFlight
topWing = false;
wingSupportAtMac = false;

//Stabilizer Efficiency (Standard=0.85,TTail=0.95,Low=0.65) 
stabEff = 0.85;    

// Horizontal Stabilizer
hStabSweepAngle = 18;
hStabCordRootPctOfWing = .5;
hStabCordTaperRatio = .55;
hStabAreaPctOfWing = .2;

// Vertical Stabilizer
vStabThick = .6;
vStabSweepAngle = 20;
vStabCordTaperRatio = .7;
vStabAreaPctOfHStab = 13/16;

// Fuselage
fuselageH = 2; //cordRoot/20;
fuselageW = 3;
fuselageTaperRatio = 1;
fuselageForeLenPctOfCord = .5;   //Between 1 and 1.5
fuselageAftLenPctOfCord = 1.75;   //Between 2 and 2.4
noseFactor = 2.5;//2.6667;    //between 2 and 3

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
echo("hStabCordRoot=", hStabCordRoot, "hStabCordTip=", hStabCordTip, "hStabSemiSpan=", hStabSemiSpan);
echo("D between LEs", fuselageL-fuselageForeL-hStabCordRoot);

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

//Cubic Wing Loading
planeWeightG = 8;
planeWeightOz = planeWeightG*gramsToOunce;
wingAreaSqFeet = (wingArea+hStabArea)*sqMmToSqFeet;
CWL = (planeWeightOz/(wingAreaSqFeet*sqrt(wingAreaSqFeet)));
echo("CWL=",CWL,"planeWeightOz=",planeWeightOz,"wingAreaSqFeet=",wingAreaSqFeet);
targetCWL = 4;
targetWeightOz = (targetCWL*(wingAreaSqFeet*sqrt(wingAreaSqFeet)));
targetWeightG = targetWeightOz/gramsToOunce;
echo("targetCWL=",targetCWL,"targetWeightOz=",targetWeightOz,"targetWeightG=",targetWeightG);

// --------------------------------
// Base rendering code
// --------------------------------
sl = false;
viewMode = "ASSEMBLY1"; //"NORMAL", "ASSEMBLY1" or "ASSEMBLY2"
xR = (topWing != true || viewMode == "ASSEMBLY1") ? 0 : 180;

if (viewMode=="NORMAL") {
    union() {
        mainWingAssembly(showLines=sl);
        horizontalStabilizerAssembly(showLines=sl);
        if (topWing && viewMode=="ASSEMBLY") {
            verticalStabilizerAssembly(showLines=false);
        } else {
            verticalStabilizer(showLines=sl);
        }
        fuselageAssembly_full(showLines=sl);
    }
    // remove slot for vert stab
    if (topWing && viewMode=="ASSEMBLY1") {
        translate([0,0,.5]) scale([1,1.2,1]) verticalStabilizer(showLines=false);
    }
} else if (viewMode=="ASSEMBLY1") {
    difference() {
        union() {
            mainWingAssembly(showLines=sl);
            horizontalStabilizerAssembly(showLines=sl);
            if (topWing && viewMode=="ASSEMBLY") {
                verticalStabilizerAssembly(showLines=false);
            } else {
                verticalStabilizer(showLines=sl);
            }
            fuselageAssembly_top(showLines=sl);
        }
        // remove slot for vert stab
        if (topWing) {
            translate([0,0,.5]) scale([1,1.2,1]) verticalStabilizer(showLines=false);
        }
    }
} else if (viewMode=="ASSEMBLY2") {
    pegR = .85;
    translate([0,0,fuselageW/2])rotate([90,0,0])fuselageAssembly_bot(showLines=sl);
    translate([0, -pegR*3, pegR])rotate([0,90,0])cylinder(r=pegR, h=50);
}


//translate([-20,0,-8])
//rotate([90,-12,0]) scale([1,.5,1])cylinder(r=25, h=3, center=true);

//wingValues = calcMacAndAeroCenter(
//        cordRoot, 
//        cordTip, 
//        wingSemiSpan, 
//        leadSweepAngle, 
//        wingThick);
//echo("wingValues=", wingValues);
//
//wingValues2 = calcMacAndAeroCenter2(
//        cordRoot, 
//        cordTip, 
//        wingSemiSpan, 
//        leadSweepAngle, 
//        wingThick);
//echo("wingValues2=", wingValues2);


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


//Render vertical stabilizer assembly for top wing
module verticalStabilizerAssembly(showLines=false) {
    topWingIndent = 2;
    x = fuselageL-fuselageForeL-vStabCordRoot;
    y = topWing ? -vStabThick/2 : vStabThick/2;
    span = topWing ? vStabSemiSpan+topWingIndent : vStabSemiSpan;
    translate([-vStabCordRoot-5, fuselageW+5, vStabThick/2])
    rotate([90,0,0])
    verticalStabilizer(showLines=showLines);
}

//Render vertical stabilizer planform
module verticalStabilizer(showLines=false) {
    topWingIndent = 2;
    x = fuselageL-fuselageForeL-vStabCordRoot;
    y = topWing ? -vStabThick/2 : vStabThick/2;
    z = topWing ? topWingIndent : (fuselageH*fuselageTaperRatio)-.1;
    r = topWing ? 270 : 90;
    span = topWing ? vStabSemiSpan+topWingIndent : vStabSemiSpan;
    translate([x, y, z])
    rotate([r,0,0])
    renderHalfPlanform(
        vStabCordRoot, 
        vStabCordTip, 
        span, 
        vStabSweepAngle, 
        vStabThick, 
        flat=true, 
        showLines=showLines);
}


//Render right half of a wing planform
module renderHalfPlanform(cRoot, cTip, span, sweep, thick, flat=false, showLines=false) {
    calcValuesList = calcMacAndAeroCenter2(cRoot, cTip, span, sweep, thick);
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
        translate([cTipX1,span,0])cube(thick);
        translate([cTipX2,span,0])cube(thick);
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
            translate([-2,-2,-5])cube([cTipX2,span+4,5]);
            // Remove excess at tip
            translate([-cTipX2,span+thick,-1])cube([cTipX2*2,2,5]);
        }
        if (wingSupportAtMac) {
            translate([macX+1,macY,0])cube([macSize-1,.65,rad/2]);
        }
    }
    // Render MAC and AC lines
    if (showLines) {
        z = thick+.5;
        // Calculated MAC or GMC line
        #translate([macX,macY,0])cube([macSize,.1,z]);
        // AC Line (Aerodynamic Center)
        #hull() {
            translate([aeroCenterX,0,0])cube([.1,.1,z]);
            translate([aeroCenterX,macY,0])cube([.1,.1,z]);
        }
    }
}


module fuselageAssembly_top(showLines=false) {
    difference() {
        fuselageAssembly_full(showLines);
        translate([0,0,-fuselageH*10/2])cube([400,fuselageH+2,fuselageH*10], center=true);
    }
}

module fuselageAssembly_bot(showLines=false) {
    difference() {
        fuselageAssembly_full(showLines);
        translate([0,0,fuselageH*5/2])cube([400,fuselageH+2,fuselageH*5], center=true);
    }
}

module fuselageAssembly_full(showLines=false) {
    z = wingThick+.5;
    bumpFactor = 1;
    radCG = fuselageH/bumpFactor; //Radius of hole in fuselage at CG
    radN = radCG * fuselageTaperRatio; //Radius of fuselage nose
    radT = radN; //Radius of fuselage tail
    xN = -fuselageForeL+radN/2; //X position of fuselage nose
    xT = fuselageL-fuselageForeL-radT/2; //X position of fuselage tail
    cgValues = calcCenterOfGravity2();
        
    wingMacSize = cgValues[0];
    wingMacY = cgValues[1];
    wingAcX = cgValues[2];
    hStabAcX = cgValues[3];
    vStabAcX = cgValues[4];
    LAC = cgValues[5];
    D = cgValues[6];
    NP = cgValues[7];
    SM = cgValues[8];
    xCG = cgValues[9];
    LCG = cgValues[10];
    
//    echo("hStabAcX=",hStabAcX,"wingAcX=",wingAcX,"LAC=",LAC,"D=",D,"NP=",NP,"SM=",SM,"wingArea=",wingArea,"hStabArea=",hStabArea, "wingMacSize=",wingMacSize, "xCG=",xCG,"LCG=",LCG);
    
    // Tail Volumes
    hStabVolume = cgValues[11];
    vStabVolume = cgValues[12];
//    echo("hStabVolume=",hStabVolume,"vStabVolume=",vStabVolume);

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
        // Render fuselage
        
        hull() {
            translate([xN*noseFactor,0,xN/noseFactor])rotate([-90,0,0])
                cylinder(r=radN,h=fuselageW,center=true);
            
            translate([xN,0,radN])rotate([-90,0,0])
                cylinder(r=radN,h=fuselageW,center=true);
            translate([0,0,fuselageH*bumpFactor])rotate([-90,0,0])
                cylinder(r=radN,h=fuselageW,center=true);            
            translate([xT,0,radT])rotate([-90,0,0])
                cylinder(r=radT,h=fuselageW,center=true);
        }
        // Hole in nose for weight
        translate([(xN*noseFactor)+2,0,xN/noseFactor])rotate([0,0,0])
            cylinder(r=1,h=fuselageH*noseFactor*noseFactor,center=true);
        // Alignment Holes
        translate([xN+2,0,0])rotate([0,0,0])
            cylinder(r=1,h=abs(fuselageH*xN),center=true);
        translate([xT/2,0,0])rotate([0,0,0])
            cylinder(r=1,h=abs(fuselageH*xN),center=true);
        // Hole for CG
        translate([xCG,0,radCG])rotate([-90,0,0])
            cylinder(r=1,h=fuselageW+2,center=true);
    }
    
}


module fuselageAssembly(showLines=false) {
    z = wingThick+.5;
    bumpFactor = 2;
    radCG = fuselageH/bumpFactor; //Radius of hole in fuselage at CG
    radN = radCG * fuselageTaperRatio; //Radius of fuselage nose
    radT = radN; //Radius of fuselage tail
    xN = -fuselageForeL+radN/2; //X position of fuselage nose
    xT = fuselageL-fuselageForeL-radT/2; //X position of fuselage tail
    cgValues = calcCenterOfGravity2();
        
    wingMacSize = cgValues[0];
    wingMacY = cgValues[1];
    wingAcX = cgValues[2];
    hStabAcX = cgValues[3];
    vStabAcX = cgValues[4];
    LAC = cgValues[5];
    D = cgValues[6];
    NP = cgValues[7];
    SM = cgValues[8];
    xCG = cgValues[9];
    LCG = cgValues[10];
    
    echo("hStabAcX=",hStabAcX,"wingAcX=",wingAcX,"LAC=",LAC,"D=",D,"NP=",NP,"SM=",SM,"wingArea=",wingArea,"hStabArea=",hStabArea, "wingMacSize=",wingMacSize, "xCG=",xCG,"LCG=",LCG);
    
    // Tail Volumes
    hStabVolume = cgValues[11];
    vStabVolume = cgValues[12];
    echo("hStabVolume=",hStabVolume,"vStabVolume=",vStabVolume);

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
        // Render fuselage
        hull() {
            translate([xN,0,radN])rotate([-90,0,0])
                cylinder(r=radN,h=fuselageW,center=true);
            translate([0,0,fuselageH*bumpFactor])rotate([-90,0,0])
                cylinder(r=radN,h=fuselageW,center=true);            
            translate([xT,0,radT])rotate([-90,0,0])
                cylinder(r=radT,h=fuselageW,center=true);
        }
        // Hole in nose for weight
        translate([xN+2,0,radN])rotate([0,0,0])
            cylinder(r=1,h=fuselageW+2,center=true);
        // Big hole in fuselage
        translate([0,0,(fuselageH*bumpFactor/2)+z])rotate([-90,0,0])
            cylinder(r=fuselageH*bumpFactor/3,h=fuselageW+2,center=true);
        // Hole for CG
        translate([xCG,0,radCG+1])rotate([-90,0,0])
            cylinder(r=1,h=fuselageW+2,center=true);
    }
    
}


// --------------------------------
//Functions
// --------------------------------

// ---------------------------------------
// Returns a list of the following calculated values:
// [0] = cSum       same
// [1] = cTipX1     same
// [2] = cTipX2     same
// [3] = edgeLen    same
// [4] = macSize    diff    39.9429, W2=41.25
// [5] = macY       same    47.619,  W3=47.619
// [6] = macX       diff    12.1747, W1=12.3247
// [7] = acX        diff    22.1604, W4=20.2265
// ---------------------------------------
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


// ---------------------------------------
// From Word Doc
// Returns a list of the following calculated values:
// [0] = cSum       same
// [1] = cTipX1     same
// [2] = cTipX2     same
// [3] = edgeLen    same
// [4] = macSize    diff    39.9429, W2=41.25
// [5] = macY       same    47.619,  W3=47.619
// [6] = macX       diff    12.1747, W1=12.3247
// [7] = acX        diff    22.1604, W4=20.2265
// ---------------------------------------
function calcMacAndAeroCenter2(cRoot, cTip, span, sweep, thick) =
    let(cSum=cRoot+cTip)
    let(cTipX1 = sin(sweep)*span)
    let(cTipX2 = cTipX1 + cTip)
    let(edgeLen = sqrt(pow(span,2) + pow(cTipX1,2)))
    let(T = cTip/cRoot) //Taper ratio
    let(macSize = cRoot*(2/3)*((1+T+pow(T,2))/(1+T)) + thick)
    let(macY = span*((1+(2*T))/(3+(3*T))))
    let(macX = (sin(sweep)*macY) - thick/2)
    let(acX = macX + (macSize/4))
    [cSum, cTipX1, cTipX2, edgeLen, macSize, macY, macX, acX];

// ---------------------------------------
// Returns a list of the following calculated values:
// [0] = wingMacSize
// [1] = wingMacY
// [2] = wingAcX
// [3] = hStabAcX
// [4] = vStabAcX
// [5] = LAC
// [6] = D
// [7] = NP
// [8] = SM
// [9] = xCG
// [10] = LCG
// [11] = hStabVolume
// [12] = vStabVolume
// ---------------------------------------
function calcCenterOfGravity() =
    let(wingValues = calcMacAndAeroCenter(
        cordRoot, 
        cordTip, 
        wingSemiSpan, 
        leadSweepAngle, 
        wingThick) )
    let(hStabValues = calcMacAndAeroCenter(
        hStabCordRoot, 
        hStabCordTip, 
        hStabSemiSpan, 
        hStabSweepAngle, 
        wingThick) )
    let(vStabValues = calcMacAndAeroCenter(
        vStabCordRoot, 
        vStabCordTip, 
        vStabSemiSpan, 
        vStabSweepAngle, 
        vStabThick) )
        
    let(wingMacSize = wingValues[4] )
    let(wingMacY = wingValues[5] )
    let(wingAcX = wingValues[7] )
    let(hStabAcX = hStabValues[7]+fuselageL-fuselageForeL-hStabCordRoot )
    let(vStabAcX = vStabValues[7]+fuselageL-fuselageForeL-vStabCordRoot )
    let(LAC = hStabAcX - wingAcX )
    let(D = LAC * (hStabArea/(wingArea+hStabArea)) )
    let(NP = wingAcX + D )
    let(SM = D/(wingMacSize*2) )
    let(xCG = wingAcX + (D/2) )
    let(LCG = vStabAcX - xCG )
    let(hStabVolume = (hStabArea*(LAC-D+SM))/(wingArea*wingMacSize) )
    let(vStabVolume = (vStabArea*LCG)/(wingArea*wingSpan) )
    [wingMacSize, wingMacY, wingAcX, hStabAcX, vStabAcX, LAC, D, NP, SM, xCG, LCG, hStabVolume, vStabVolume];

function calcCenterOfGravity2() =
    let(wingValues = calcMacAndAeroCenter2(
        cordRoot, 
        cordTip, 
        wingSemiSpan, 
        leadSweepAngle, 
        wingThick) )
    let(hStabValues = calcMacAndAeroCenter2(
        hStabCordRoot, 
        hStabCordTip, 
        hStabSemiSpan, 
        hStabSweepAngle, 
        wingThick) )
    let(vStabValues = calcMacAndAeroCenter2(
        vStabCordRoot, 
        vStabCordTip, 
        vStabSemiSpan, 
        vStabSweepAngle, 
        vStabThick) )
    
    let(W2 = wingValues[4] ) // [4] = macSize
    let(W3 = wingValues[5] ) // [5] = macY
    let(W1 = wingValues[6] ) // [6] = macX
    let(W4 = wingValues[7] ) // [7] = acX
    let(hStabAcX = hStabValues[7]+fuselageL-fuselageForeL-hStabCordRoot )
    let(vStabAcX = vStabValues[7]+fuselageL-fuselageForeL-vStabCordRoot )
    let(LAC = hStabAcX - W4 )
    
    let(A = cordRoot) //Wing Root Chord (A)
    let(AA =hStabCordRoot) //Tail Root Cord (AA)
    let(B = cordTip) //Wing Tip Chord (B)
    let(BB = hStabCordTip) //Tail Tip Chord (BB)
    let(Y = wingSemiSpan) //Wing Half Span (Y)
    let(YY = hStabSemiSpan) //Tail Half Span (YY)
    let(S = wingValues[1]) //Wing Sweep Distance (S). 0 means straight leading edge
    let(SS = hStabValues[1]) //Tail Sweep Distance (SS).
    
    let(D = fuselageL-fuselageForeL-hStabCordRoot) //Dist between Wing/Tail LE's

    let(T1 = (SS*(AA+2*BB)) / (3*(AA+BB)) ) //Tail sweep distance
    let(T2 = (AA - ((2*(AA-BB) * (.5*AA+BB)) / (3*(AA+BB)))) ) //Tail MAC
    let(T3 = (0.25*T2)+T1 ) //Tail AC

    //Neutral Point
    let(D2 = (D - W4) + T3 )
    let(Area1 = (Y*A)+(Y*B) )
    let(Area2 = (YY*AA)+(YY*BB) )
    let(Area = Area2 / Area1 )
    let(AR = pow((Y*2),2)/Area1 )
    let(ARs = pow((YY*2),2)/Area2 )
    let(As =  0.095/(1+(18.25/ARs*0.095)) )
    let(Aw = 0.11/(1+(18.25/AR*0.11)) )
    let(Vbar = Area*(D2/W2) )

    let(E = .85)
    let(N1 = (E*Vbar*(As/Aw)*(1-35*(Aw/AR))*W2)+W4 )
    let(SM = (W4-N1)/2) //Static Margin (between 5 and 15)
    let(N2 = N1 + SM ) //CG distance from LE
    let(N3 = Area1 ) //Wing Area
    let(N4 = Area2 ) //Tail Area
    let(N5 = AR )
    let(N6 = Vbar )
    
    [W2, W3, W4, hStabAcX, vStabAcX, LAC, 0, N1, SM, N2, 0, 0, 0];
    
function calcCenterOfGravity2_old() =
    let(wingValues = calcMacAndAeroCenter2(
        cordRoot, 
        cordTip, 
        wingSemiSpan, 
        leadSweepAngle, 
        wingThick) )
    let(hStabValues = calcMacAndAeroCenter2(
        hStabCordRoot, 
        hStabCordTip, 
        hStabSemiSpan, 
        hStabSweepAngle, 
        wingThick) )
    let(vStabValues = calcMacAndAeroCenter2(
        vStabCordRoot, 
        vStabCordTip, 
        vStabSemiSpan, 
        vStabSweepAngle, 
        vStabThick) )
    
    let(W2 = wingValues[4] ) // [4] = macSize
    let(W3 = wingValues[5] ) // [5] = macY
    let(W1 = wingValues[6] ) // [6] = macX
    let(W4 = wingValues[7] ) // [7] = acX
    let(hStabAcX = hStabValues[7]+fuselageL-fuselageForeL-hStabCordRoot )
    let(vStabAcX = vStabValues[7]+fuselageL-fuselageForeL-vStabCordRoot )
    let(LAC = hStabAcX - wingAcX )
    
    let(A = cordRoot) //Wing Root Chord (A)
    let(AA =hStabCordRoot) //Tail Root Cord (AA)
    let(B = cordTip) //Wing Tip Chord (B)
    let(BB = hStabCordTip) //Tail Tip Chord (BB)
    let(Y = wingSemiSpan) //Wing Half Span (Y)
    let(YY = hStabSemiSpan) //Tail Half Span (YY)
    let(S = wingValues[1]) //Wing Sweep Distance (S). 0 means straight leading edge
    let(SS = hStabValues[1]) //Tail Sweep Distance (SS).
    let(CG1 = 10) //Static Margin (between 5 and 15)
    let(D = fuselageL-fuselageForeL-hStabCordRoot) //Dist between Wing/Tail LE's

    let(T1 = (SS*(AA+2*BB)) / (3*(AA+BB)) ) //Tail sweep distance
    let(T2 = (AA - ((2*(AA-BB) * (.5*AA+BB)) / (3*(AA+BB)))) ) //Tail MAC
    let(T3 = (0.25*T2)+T1 ) //Tail AC

    //Neutral Point
    let(D2 = (D - W4) + T3 )
    let(Area1 = (Y*A)+(Y*B) )
    let(Area2 = (YY*AA)+(YY*BB) )
    let(Area = Area2 / Area1 )
    let(AR = pow((Y*2),2)/Area1 )
    let(ARs = pow((YY*2),2)/Area2 )
    let(As =  0.095/(1+(18.25/ARs*0.095)) )
    let(Aw = 0.11/(1+(18.25/AR*0.11)) )
    let(Vbar = Area*(D2/W2) )

    let(E = .85)
    let(N1 = (E*Vbar*(As/Aw)*(1-35*(Aw/AR))*W2)+W4 )
    let(N2 = N1 - ((CG1/100) * W2) ) //CG distance from LE
    let(N3 = Area1 ) //Wing Area
    let(N4 = Area2 ) //Tail Area
    let(N5 = AR )
    let(N6 = Vbar )
    
    [W2, W3, W4, hStabAcX, vStabAcX, 0, 0, N1, CG1, N2, 0, 0, 0];
