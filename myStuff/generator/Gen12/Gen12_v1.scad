/*
    GEN THREE-PHASE AXIAL FLUX GENERATOR
    ------------------------------------

    Supports:

    1. 8-pole / 6-coil three-phase
       - 8 magnets
       - 6 coils per stator
       - phase sequence: A B C A B C
       - easier first prototype

    2. 12-pole / 9-coil three-phase
       - 12 magnets
       - 9 coils per stator
       - phase sequence: A B C A B C A B C
       - smoother output, more winding work

    Architecture:
       - 2 stators
       - 1 rotor
       - axial-flux layout
       - 608 bearing-ready stators
       - M8 shaft / nut trap rotor
       - flux-return plate holder
       - spacer set
       - matching coil winder

    Recommended first build:
       configuration = "8_6";

    Notes:
       - Magnets must alternate polarity: N S N S...
       - Coils should be wired experimentally for additive phase voltage.
       - Wye/star connection is recommended first.
*/


/*
    =====================================================
    WIRING INSTRUCTIONS FOR 8/6 AND 12/9 THREE-PHASE
    =====================================================

    This generator uses a 3-phase winding pattern.

    Supported configurations:

        8-pole / 6-coil:
            Rotor magnets: 8
            Coils per stator: 6
            Phase sequence:
                A B C A B C

            Coil positions:
                0 deg     A1
                60 deg    B1
                120 deg   C1
                180 deg   A2
                240 deg   B2
                300 deg   C2

            Each stator has:
                Phase A: A1 + A2
                Phase B: B1 + B2
                Phase C: C1 + C2

            With two stators:
                Phase A total: A1_top + A2_top + A1_bottom + A2_bottom
                Phase B total: B1_top + B2_top + B1_bottom + B2_bottom
                Phase C total: C1_top + C2_top + C1_bottom + C2_bottom


        12-pole / 9-coil:
            Rotor magnets: 12
            Coils per stator: 9
            Phase sequence:
                A B C A B C A B C

            Coil positions:
                0 deg     A1
                40 deg    B1
                80 deg    C1
                120 deg   A2
                160 deg   B2
                200 deg   C2
                240 deg   A3
                280 deg   B3
                320 deg   C3

            Each stator has:
                Phase A: A1 + A2 + A3
                Phase B: B1 + B2 + B3
                Phase C: C1 + C2 + C3

            With two stators:
                Phase A total:
                    A1_top + A2_top + A3_top
                    + A1_bottom + A2_bottom + A3_bottom

                Phase B total:
                    B1_top + B2_top + B3_top
                    + B1_bottom + B2_bottom + B3_bottom

                Phase C total:
                    C1_top + C2_top + C3_top
                    + C1_bottom + C2_bottom + C3_bottom


    =====================================================
    MAGNET POLARITY
    =====================================================

    Magnets must alternate polarity around the rotor.

    Example for 8-pole rotor:

        Position    Top Face Polarity
        0 deg       N
        45 deg      S
        90 deg      N
        135 deg     S
        180 deg     N
        225 deg     S
        270 deg     N
        315 deg     S

    Example for 12-pole rotor:

        Position    Top Face Polarity
        0 deg       N
        30 deg      S
        60 deg      N
        90 deg      S
        120 deg     N
        150 deg     S
        180 deg     N
        210 deg     S
        240 deg     N
        270 deg     S
        300 deg     N
        330 deg     S

    If the top face of a magnet is North, the bottom face is South.
    This is correct for the two-stator / one-rotor layout.


    =====================================================
    COIL WINDING DIRECTION
    =====================================================

    Pick one physical winding convention and keep it consistent.

    Example:
        - Wind every coil clockwise when viewed from the rotor side.
        - Mark the starting lead of every coil as "S".
        - Mark the finishing lead of every coil as "F".

    Suggested labels:

        A1_S, A1_F
        B1_S, B1_F
        C1_S, C1_F
        A2_S, A2_F
        etc.

    Do not permanently solder everything until voltage testing confirms
    the coils are additive.


    =====================================================
    FIRST TEST: INDIVIDUAL COILS
    =====================================================

    Before connecting coils together:

        1. Install rotor magnets with alternating polarity.
        2. Install one stator.
        3. Spin rotor at a repeatable speed.
        4. Measure AC voltage from each individual coil.
        5. Confirm all coils produce similar voltage.

    If one coil is much lower:
        - Check coil alignment.
        - Check magnet polarity.
        - Check winding continuity.
        - Check air gap.


    =====================================================
    SERIES CONNECTION TEST FOR EACH PHASE
    =====================================================

    For each phase, connect coils in series.

    Example for 8/6 single stator:

        Phase A:
            A1_F connect to A2_S
            Phase A output leads are:
                A1_S and A2_F

        Phase B:
            B1_F connect to B2_S
            Phase B output leads are:
                B1_S and B2_F

        Phase C:
            C1_F connect to C2_S
            Phase C output leads are:
                C1_S and C2_F


    Example for 12/9 single stator:

        Phase A:
            A1_F connect to A2_S
            A2_F connect to A3_S
            Phase A output leads are:
                A1_S and A3_F

        Phase B:
            B1_F connect to B2_S
            B2_F connect to B3_S
            Phase B output leads are:
                B1_S and B3_F

        Phase C:
            C1_F connect to C2_S
            C2_F connect to C3_S
            Phase C output leads are:
                C1_S and C3_F


    IMPORTANT:
        After connecting two coils in series, spin the rotor and measure AC voltage.

        If the voltage increases:
            The connection is additive. Good.

        If the voltage drops or nearly cancels:
            Reverse one coil's leads.


    =====================================================
    TWO-STATOR CONNECTION
    =====================================================

    Because the top and bottom stators face opposite sides of the rotor,
    the bottom stator may need its phase strings reversed electrically.

    Recommended procedure:

        1. Build Phase A on the top stator.
        2. Build Phase A on the bottom stator.
        3. Connect top Phase A in series with bottom Phase A.
        4. Spin rotor and measure AC voltage.

        If voltage increases:
            Keep the connection.

        If voltage decreases:
            Reverse the bottom Phase A string.

        Repeat for Phase B and Phase C.


    =====================================================
    RECOMMENDED FINAL CONNECTION: WYE / STAR
    =====================================================

    For the first prototype, use WYE / STAR.

    After each phase string is confirmed additive, you will have:

        A_start and A_finish
        B_start and B_finish
        C_start and C_finish

    Connect:

        A_finish
        B_finish
        C_finish

    together as the neutral junction.

    The three output wires are:

        A_start
        B_start
        C_start

    These go to the three AC inputs of a 3-phase bridge rectifier.

    WYE connection diagram:

            A_start ---------------> AC input 1

            B_start ---------------> AC input 2

            C_start ---------------> AC input 3


            A_finish ----\
                          \
            B_finish ------+------ Neutral junction
                          /
            C_finish ----/

    The neutral junction usually does not connect to the rectifier.


    =====================================================
    THREE-PHASE BRIDGE RECTIFIER
    =====================================================

    Use a 3-phase bridge rectifier with terminals like:

        ~    ~    ~    +    -

    Connect:

        A_start  ->  ~
        B_start  ->  ~
        C_start  ->  ~

    Then:

        +  -> DC positive
        -  -> DC negative

    For low-voltage hand-cranked testing, Schottky diodes are preferred
    because they waste less voltage than normal silicon diodes.


    =====================================================
    DELTA CONNECTION - OPTIONAL, NOT FIRST TEST
    =====================================================

    Delta can produce more current at lower voltage, but it is less forgiving.

    Do not start with delta unless the three phases are well matched.

    Delta connection:

        A_finish connects to B_start
        B_finish connects to C_start
        C_finish connects to A_start

    The three output nodes are the three junctions.

    Start with WYE first.


    =====================================================
    EXPECTED FREQUENCY
    =====================================================

    Electrical frequency depends on rotor pole pairs.

    For 8 poles:

        pole pairs = 4

        f = 4 * RPM / 60

        f = RPM / 15

        150 RPM -> 10 Hz
        300 RPM -> 20 Hz
        600 RPM -> 40 Hz


    For 12 poles:

        pole pairs = 6

        f = 6 * RPM / 60

        f = RPM / 10

        100 RPM -> 10 Hz
        300 RPM -> 30 Hz
        600 RPM -> 60 Hz


    =====================================================
    PRACTICAL LABELING RECOMMENDATION
    =====================================================

    Label every coil before installing.

    For 8/6:

        Top stator:
            A1T_S, A1T_F
            B1T_S, B1T_F
            C1T_S, C1T_F
            A2T_S, A2T_F
            B2T_S, B2T_F
            C2T_S, C2T_F

        Bottom stator:
            A1B_S, A1B_F
            B1B_S, B1B_F
            C1B_S, C1B_F
            A2B_S, A2B_F
            B2B_S, B2B_F
            C2B_S, C2B_F


    For 12/9:

        Top stator:
            A1T_S, A1T_F
            B1T_S, B1T_F
            C1T_S, C1T_F
            A2T_S, A2T_F
            B2T_S, B2T_F
            C2T_S, C2T_F
            A3T_S, A3T_F
            B3T_S, B3T_F
            C3T_S, C3T_F

        Bottom stator:
            A1B_S, A1B_F
            B1B_S, B1B_F
            C1B_S, C1B_F
            A2B_S, A2B_F
            B2B_S, B2B_F
            C2B_S, C2B_F
            A3B_S, A3B_F
            B3B_S, B3B_F
            C3B_S, C3B_F


    =====================================================
    BEST FIRST BUILD
    =====================================================

    Recommended first configuration:

        configuration = "8_6";

    Reasons:
        - fewer coils
        - easier winding
        - more space per coil
        - easier debugging
        - still gives true 3-phase output

    After validating the design, try:

        configuration = "12_9";

    The 12/9 version gives smoother output and higher frequency at the
    same RPM, but requires more winding and tighter packaging.
*/


// =====================================================
// 1. USER CONFIGURATION
// =====================================================

// Choose: "8_6", "12_9", or "both"
configuration = "8_6";

// Choose: "print", "assembly", "verify", or "phase_overlay"
view_mode = "print";

// If configuration = "both", this controls spacing between the two sets.
both_layout_spacing = 380;


// =====================================================
// 2. MASTER PARAMETERS
// =====================================================

// --- Magnet dimensions ---
bar_mag_length = 29.2;      // radial length
bar_mag_width  = 9.4;       // tangential width
bar_mag_depth  = 6.0;       // axial thickness

// --- Air gap and magnetic stack ---
mechanical_air_gap = 1.25;

// Rotor is intentionally close to magnet thickness.
// This helps keep magnets nearly flush to both sides.
rotor_total_h = 6.8;

// Coil pocket and stator
coil_thickness = 7.8;
thin_floor = 1.0;
stator_h = 9.2;

// Flux-return holder
flux_insert_depth = 2.4;
flux_plate_back_cap = 1.0;

// Desired flux insert radius.
// The file automatically reduces this if inserts would overlap.
desired_flux_insert_r = 15.2;

// --- Shaft, nut, bearing ---
axel_r = 4.2;               // M8 clearance-ish
nut_hex_dist = 13.5;        // across flats for M8 nut
bearing_od = 22.2;          // 608 bearing pocket clearance
bearing_h = 7.1;

// --- Mounting and spacers ---
alignment_bolt_r = 2.6;
spacer_inset_depth = 2.0;
spacer_count = 4;

// --- General geometry ---
magnet_gap_buffer = 4.0;
rotor_edge_margin = 6.0;
stator_edge_margin = 15.0;
mount_offset_from_rotor = 8.0;

// Optional radius boost.
// The 12/9 layout is more crowded, so a small radius boost helps.
phase3_radius_boost_8_6  = 0.0;
phase3_radius_boost_12_9 = 4.0;

// Quality
main_fn = 140;
medium_fn = 80;
small_fn = 40;


// =====================================================
// 3. CONFIGURATION ROUTER
// =====================================================

if (configuration == "both") {
    translate([-both_layout_spacing/2, 0, 0])
        print_layout(8, 6, "8P / 6C");

    translate([both_layout_spacing/2, 0, 0])
        print_layout(12, 9, "12P / 9C");

} else {
    let(
        nm = configuration == "12_9" ? 12 : 8,
        nc = configuration == "12_9" ? 9  : 6
    )
    route_view(nm, nc, configuration);
}


module route_view(nm, nc, label_text) {
    if (view_mode == "assembly") {
        render_full_assembly(nm, nc);
    } else if (view_mode == "verify") {
        verify_alignment(nm, nc);
    } else if (view_mode == "phase_overlay") {
        phase_overlay_view(nm, nc);
    } else {
        print_layout(nm, nc, label_text);
    }
}


// =====================================================
// 4. DERIVED GEOMETRY FUNCTIONS
// =====================================================

function radius_boost(nm, nc) =
    (nm == 12 && nc == 9) ? phase3_radius_boost_12_9 : phase3_radius_boost_8_6;

function magnet_center_r_for(nm, nc) =
    (nm * (bar_mag_width + magnet_gap_buffer) / (2 * PI))
    + (bar_mag_length / 2)
    + radius_boost(nm, nc);

function rotor_r_for(nm, nc) =
    magnet_center_r_for(nm, nc) + (bar_mag_length / 2) + rotor_edge_margin;

function stator_r_for(nm, nc) =
    rotor_r_for(nm, nc) + stator_edge_margin;

function mount_r_for(nm, nc) =
    rotor_r_for(nm, nc) + mount_offset_from_rotor;

function pole_pitch_angle(nm) =
    360 / nm;

function coil_spacing_angle(nc) =
    360 / nc;

function spacer_h_for() =
    rotor_total_h + (2 * mechanical_air_gap) + (2 * spacer_inset_depth);

function flux_plate_h_for() =
    flux_insert_depth + flux_plate_back_cap;

// Auto-limit round flux insert radius so adjacent inserts do not overlap.
function auto_flux_insert_r(nm, nc) =
    min(
        desired_flux_insert_r,
        magnet_center_r_for(nm, nc) * sin(180 / nc) * 0.90
    );


// =====================================================
// 5. PRINT LAYOUT
// =====================================================

module print_layout(nm, nc, label_text) {
    layout_gap = stator_r_for(nm, nc) * 2.45;

    // Rotor
    translate([0, 0, rotor_total_h / 2]) {
        color("Gold")
            bar_rotor(nm, nc);

        translate([0, -stator_r_for(nm, nc) * 1.10, rotor_total_h / 2 + 0.4])
            part_label(str(label_text, " ROTOR"));
    }

    // Stator
    translate([layout_gap, 0, 0]) {
        color("RoyalBlue")
            bar_stator(nm, nc);

        translate([0, -stator_r_for(nm, nc) * 1.10, stator_h + 0.4])
            part_label(str(label_text, " STATOR"));
    }

    // Flux plate holder
    translate([layout_gap * 2, 0, 0]) {
        color("CadetBlue")
            flux_plate(nm, nc);

        translate([0, -stator_r_for(nm, nc) * 1.10, flux_plate_h_for() + 0.4])
            part_label(str(label_text, " FLUX PLATE"));
    }

    // Spacer set
    translate([layout_gap, -layout_gap * 0.85, 0]) {
        color("Orange")
            spacer_set(nm, nc);

        translate([0, -stator_r_for(nm, nc) * 0.55, spacer_h_for() + 0.4])
            part_label("SPACERS");
    }

    // Coil winder
    translate([0, -layout_gap * 0.90, 0]) {
        color("LightGreen")
            bar_winder_set(nm, nc);

        translate([0, -stator_r_for(nm, nc) * 0.75, coil_thickness + 14])
            part_label("COIL WINDER");
    }
}


module part_label(txt) {
    color("Black")
        linear_extrude(height = 0.4)
            text(txt, size = 7, halign = "center", valign = "center");
}


// =====================================================
// 6. FULL ASSEMBLY VIEW
// =====================================================

module render_full_assembly(nm, nc) {
    arm_dist = (rotor_total_h / 2) + mechanical_air_gap;
    fp_h = flux_plate_h_for();

    // Shaft
    color("Silver")
        cylinder(h = 130, r = axel_r, center = true, $fn = medium_fn);

    // Rotor
    color("Gold", 0.85)
        bar_rotor(nm, nc);

    // Nut visualization
    color("DimGray", 0.85)
        translate([0, 0, 0])
            rotate([0, 0, 30])
                m8_nut();

    // Top stator, pocket side facing rotor
    translate([0, 0, arm_dist + stator_h])
        rotate([180, 0, 0]) {
            color("RoyalBlue", 0.38)
                bar_stator(nm, nc);

            color("LightGrey")
                translate([0, 0, -0.5])
                    bearing_608();
        }

    // Bottom stator, pocket side facing rotor
    translate([0, 0, -arm_dist - stator_h]) {
        color("RoyalBlue", 0.38)
            bar_stator(nm, nc);

        color("LightGrey")
            translate([0, 0, -0.5])
                bearing_608();
    }

    // Top flux plate holder, pockets open toward stator
    translate([0, 0, arm_dist + stator_h])
        color("CadetBlue", 0.45)
            flux_plate(nm, nc);

    // Bottom flux plate holder, pockets open toward stator
    translate([0, 0, -arm_dist - stator_h])
        rotate([180, 0, 0])
            color("CadetBlue", 0.45)
                flux_plate(nm, nc);

    // Spacers and alignment bolts
    for (i = [0 : spacer_count - 1]) {
        rotate([0, 0, i * 360 / spacer_count + 45])
            translate([mount_r_for(nm, nc), 0, 0]) {
                color("Orange")
                    stator_spacer();

                color("Silver")
                    cylinder(h = 120, r = alignment_bolt_r, center = true, $fn = small_fn);
            }
    }
}


// =====================================================
// 7. ALIGNMENT / VERIFICATION VIEW
// =====================================================

module verify_alignment(nm, nc) {
    /*
        Slice view showing:
        - stator coil cutouts
        - flux plate pockets
        - rotor magnet positions
    */

    intersection() {
        union() {
            color("Gold", 0.45)
                translate([0, 0, -rotor_total_h / 2])
                    bar_rotor(nm, nc);

            color("RoyalBlue", 0.35)
                translate([0, 0, mechanical_air_gap])
                    bar_stator(nm, nc);

            color("CadetBlue", 0.45)
                translate([0, 0, mechanical_air_gap + stator_h])
                    flux_plate(nm, nc);

            color("Red", 0.50)
                magnet_visuals(nm, nc);
        }

        // Wedge slice
        rotate([0, 0, -18])
            cube([180, 180, 80]);
    }
}


// =====================================================
// 8. PHASE OVERLAY VIEW
// =====================================================

module phase_overlay_view(nm, nc) {
    color("RoyalBlue", 0.25)
        bar_stator(nm, nc);

    // Colored coil overlays
    for (i = [0 : nc - 1]) {
        rotate([0, 0, i * coil_spacing_angle(nc)])
            translate([magnet_center_r_for(nm, nc), 0, stator_h + 0.8])
                color(phase_color(i))
                    trap_shape(nm, nc, h = 1.0, extra_l = 3, extra_w = 2);
    }

    // Coil labels: A1, B1, C1, etc.
    for (i = [0 : nc - 1]) {
        rotate([0, 0, i * coil_spacing_angle(nc)])
            translate([magnet_center_r_for(nm, nc), 0, stator_h + 2.2])
                rotate([0, 0, 90])
                    color("Black")
                        linear_extrude(height = 0.4)
                            text(
                                coil_label(i),
                                size = 7,
                                halign = "center",
                                valign = "center"
                            );
    }
}


function phase_color(i) =
    (i % 3 == 0) ? [1.0, 0.1, 0.1, 0.55] :
    (i % 3 == 1) ? [0.1, 0.8, 0.1, 0.55] :
                   [0.1, 0.2, 1.0, 0.55];

function coil_phase_letter(i) =
    (i % 3 == 0) ? "A" :
    (i % 3 == 1) ? "B" :
                   "C";

function coil_phase_number(i) =
    floor(i / 3) + 1;

function coil_label(i) =
    str(coil_phase_letter(i), coil_phase_number(i));


// =====================================================
// 9. CORE PRINTED PARTS
// =====================================================

module bar_rotor(nm, nc) {
    mcr = magnet_center_r_for(nm, nc);
    rr  = rotor_r_for(nm, nc);

    difference() {
        // Main rotor disk
        cylinder(h = rotor_total_h, r = rr, center = true, $fn = main_fn);

        // Magnet slots
        for (i = [0 : nm - 1]) {
            rotate([0, 0, i * pole_pitch_angle(nm)])
                translate([mcr, 0, 0])
                    cube(
                        [
                            bar_mag_length + 0.45,
                            bar_mag_width  + 0.45,
                            rotor_total_h + 1.0
                        ],
                        center = true
                    );
        }

        // M8 nut trap, through rotor
        cylinder(
            h = rotor_total_h + 2,
            r = nut_hex_dist / 2 / cos(30),
            center = true,
            $fn = 6
        );

        // Shaft clearance
        cylinder(
            h = rotor_total_h + 3,
            r = axel_r,
            center = true,
            $fn = medium_fn
        );
    }
}


module bar_stator(nm, nc) {
    sr = stator_r_for(nm, nc);
    mcr = magnet_center_r_for(nm, nc);
    mr = mount_r_for(nm, nc);

    difference() {
        cylinder(h = stator_h, r = sr, $fn = main_fn);

        // Coil pockets
        for (i = [0 : nc - 1]) {
            rotate([0, 0, i * coil_spacing_angle(nc)])
                translate([mcr, 0, thin_floor])
                    trap_shape(
                        nm,
                        nc,
                        h = stator_h + 3,
                        extra_l = 3,
                        extra_w = 2
                    );
        }

        // Center relief above bearing
        translate([0, 0, 1.5])
            cylinder(h = stator_h + 2, r = 13.5, $fn = medium_fn);

        // Bearing pocket
        translate([0, 0, -1])
            cylinder(h = bearing_h + 1.2, r = bearing_od / 2, $fn = medium_fn);

        // Shaft clearance
        translate([0, 0, -1])
            cylinder(h = stator_h + 4, r = axel_r + 0.5, $fn = medium_fn);

        // Spacer seats and alignment bolt holes
        for (i = [0 : spacer_count - 1]) {
            rotate([0, 0, i * 360 / spacer_count + 45]) {
                translate([mr, 0, stator_h - spacer_inset_depth])
                    cylinder(h = spacer_inset_depth + 1.2, r = 6.6, $fn = small_fn);

                translate([mr, 0, -2])
                    cylinder(h = stator_h + 5, r = alignment_bolt_r, $fn = small_fn);
            }
        }
    }
}


module flux_plate(nm, nc) {
    /*
        This is a printable holder for steel flux-return inserts.

        Pockets open on z = 0 side.
        In assembly, this open side should face the stator.

        Use mild steel disks/washers/inserts.
        Avoid stainless unless verified magnetic.
    */

    sr = stator_r_for(nm, nc);
    mcr = magnet_center_r_for(nm, nc);
    mr = mount_r_for(nm, nc);
    h_plate = flux_plate_h_for();
    insert_r = auto_flux_insert_r(nm, nc);

    difference() {
        cylinder(h = h_plate, r = sr, $fn = main_fn);

        // Flux insert pockets, open toward stator
        for (i = [0 : nc - 1]) {
            rotate([0, 0, i * coil_spacing_angle(nc)])
                translate([mcr, 0, -0.1])
                    cylinder(
                        h = flux_insert_depth + 0.2,
                        r = insert_r,
                        $fn = medium_fn
                    );
        }

        // Alignment bolt holes
        for (i = [0 : spacer_count - 1]) {
            rotate([0, 0, i * 360 / spacer_count + 45])
                translate([mr, 0, -1])
                    cylinder(h = h_plate + 3, r = alignment_bolt_r, $fn = small_fn);
        }

        // Center shaft clearance
        translate([0, 0, -1])
            cylinder(h = h_plate + 3, r = axel_r + 4, $fn = medium_fn);
    }
}


module stator_spacer() {
    difference() {
        cylinder(h = spacer_h_for(), r = 6.5, center = true, $fn = medium_fn);

        cylinder(
            h = spacer_h_for() + 2,
            r = alignment_bolt_r,
            center = true,
            $fn = small_fn
        );
    }
}


module spacer_set(nm, nc) {
    spacing = 18;

    for (x = [-1.5, -0.5, 0.5, 1.5]) {
        translate([x * spacing, 0, spacer_h_for() / 2])
            stator_spacer();
    }
}


// =====================================================
// 10. COIL WINDER
// =====================================================

module bar_winder_set(nm, nc) {
    spacing = bar_mag_length + 50;

    translate([-spacing / 2, 0, 0])
        winder_bottom(nm, nc);

    translate([spacing / 2, 0, 0])
        winder_top(nm, nc);
}


module winder_bottom(nm, nc) {
    flange_h = 6.0;
    core_h = coil_thickness + 3.0;

    difference() {
        union() {
            trap_shape(nm, nc, h = flange_h, extra_l = 10, extra_w = 8);

            translate([0, 0, flange_h])
                trap_shape(nm, nc, h = core_h, extra_l = -0.5, extra_w = -1);
        }

        // Center screw hole
        translate([0, 0, -1])
            cylinder(h = 60, r = alignment_bolt_r, $fn = small_fn);

        // Wire release slit
        translate([0, 0, flange_h / 2])
            cube([bar_mag_length * 5, 1.4, flange_h + 0.4], center = true);
    }
}


module winder_top(nm, nc) {
    flange_h = 6.0;

    difference() {
        trap_shape(nm, nc, h = flange_h, extra_l = 10, extra_w = 8);

        translate([0, 0, flange_h - 3.0])
            scale([1.1, 1.1, 1])
                trap_shape(nm, nc, h = 4.2, extra_l = -0.5, extra_w = -1);

        translate([0, 0, -1])
            cylinder(h = 60, r = alignment_bolt_r, $fn = small_fn);
    }
}


// =====================================================
// 11. SHAPE HELPERS
// =====================================================

module trap_shape(nm, nc, h, extra_l = 0, extra_w = 0) {
    /*
        Trapezoidal coil/window shape.

        Important:
        - Coil centers are spaced by 360 / nc.
        - Coil active span is based on magnet pole pitch: 360 / nm.

        For 8/6:
            coil spacing = 60 deg
            coil span    = 45 deg

        For 12/9:
            coil spacing = 40 deg
            coil span    = 30 deg
    */

    pitch = pole_pitch_angle(nm);
    mcr = magnet_center_r_for(nm, nc);

    l = bar_mag_length + extra_l;
    r_in = mcr - l / 2;
    r_out = mcr + l / 2;

    wi = (2 * r_in  * sin(pitch / 2)) + extra_w;
    wo = (2 * r_out * sin(pitch / 2)) + extra_w;

    translate([-l / 2, 0, 0])
        linear_extrude(h)
            polygon([
                [0, -wi / 2],
                [0,  wi / 2],
                [l,  wo / 2],
                [l, -wo / 2]
            ]);
}


module m8_nut() {
    difference() {
        cylinder(
            h = 6.5,
            r = nut_hex_dist / 2 / cos(30),
            center = true,
            $fn = 6
        );

        cylinder(
            h = 9,
            r = axel_r,
            center = true,
            $fn = small_fn
        );
    }
}


module bearing_608() {
    difference() {
        cylinder(h = 7, r = 22 / 2, center = false, $fn = medium_fn);

        translate([0, 0, -1])
            cylinder(h = 9, r = 8 / 2, center = false, $fn = small_fn);

        translate([0, 0, 1])
            difference() {
                cylinder(h = 5, r = 20 / 2, $fn = medium_fn);
                cylinder(h = 6, r = 10 / 2, $fn = small_fn);
            }
    }
}


module magnet_visuals(nm, nc) {
    mcr = magnet_center_r_for(nm, nc);

    for (i = [0 : nm - 1]) {
        rotate([0, 0, i * pole_pitch_angle(nm)])
            translate([mcr, 0, 0])
                color((i % 2 == 0) ? "Red" : "Blue", 0.55)
                    cube(
                        [
                            bar_mag_length,
                            bar_mag_width,
                            bar_mag_depth
                        ],
                        center = true
                    );
    }
}