/*
    GEN THREE-PHASE AXIAL FLUX GENERATOR
    WITH CONFIGURABLE RECTANGULAR STEEL FLUX BARS

    Supports:
        8-pole / 6-coil three-phase
        12-pole / 9-coil three-phase

    Recommended first build:
        configuration = "8_6";
        steel_bar_mode = "coil_legs";
        coil_leg_bar_placement = "local";

    Steel bar modes:
        "coil"          = one bar behind each coil center
        "magnet"        = one bar behind each magnet position
        "coil_legs"     = two bars per coil, behind active coil legs
        "coil_and_legs" = coil center bars + coil leg bars
        "both"          = coil center bars + magnet-position bars
        "all"           = coil center + magnet-position + coil-leg bars
        "custom"        = user-defined bar count/spacing
        "none"          = no steel pockets

    Important correction:
        coil_leg_bar_placement = "local" places each pair of coil-leg bars
        in the local coordinate frame of each coil. This prevents the
        bad starburst/ray pattern.
*/


/*
    =====================================================
    WIRING INSTRUCTIONS
    =====================================================

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

        Each stator:
            Phase A: A1 + A2
            Phase B: B1 + B2
            Phase C: C1 + C2

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

        Each stator:
            Phase A: A1 + A2 + A3
            Phase B: B1 + B2 + B3
            Phase C: C1 + C2 + C3

    Magnet polarity:
        Magnets must alternate polarity around the rotor:
            N S N S N S ...

    Coil winding:
        Pick one winding direction and keep it consistent.
        Example:
            Wind every coil clockwise when viewed from the rotor side.
            Mark start as S.
            Mark finish as F.

    Series test:
        Do not permanently solder until testing.

        For 8/6:
            A1_F -> A2_S
            B1_F -> B2_S
            C1_F -> C2_S

        For 12/9:
            A1_F -> A2_S -> A3_S sequence by finish-to-start
            B1_F -> B2_S -> B3_S
            C1_F -> C2_S -> C3_S

        After each connection:
            If voltage increases, connection is additive.
            If voltage drops/cancels, reverse one coil.

    Two-stator connection:
        Top and bottom stators face opposite sides of the rotor.
        Bottom phase strings may need to be reversed.
        Test one phase at a time.

    Recommended final connection:
        WYE / STAR

            A_finish ----\
                          \
            B_finish ------+------ neutral junction
                          /
            C_finish ----/

            A_start -> rectifier ~
            B_start -> rectifier ~
            C_start -> rectifier ~

        Use a three-phase bridge rectifier:
            ~  ~  ~  +  -

    Expected frequency:
        8 poles:
            pole pairs = 4
            f = RPM / 15

        12 poles:
            pole pairs = 6
            f = RPM / 10
*/


// =====================================================
// 1. USER CONFIGURATION
// =====================================================

// Choose: "8_6", "12_9", or "both"
configuration = "8_6";

// Choose: "print", "assembly", "verify", or "phase_overlay"
view_mode = "print";

// If configuration = "both", this controls spacing between the two sets.
both_layout_spacing = 390;


// =====================================================
// 2. STEEL BAR FLUX RETURN CONFIGURATION
// =====================================================

/*
    Recommended first check:

        configuration = "8_6";
        steel_bar_mode = "coil_legs";
        coil_leg_bar_placement = "local";
        view_mode = "phase_overlay";

    Then print with:

        view_mode = "print";
*/

steel_bar_mode = "coil_legs";

// Corrected/default coil-leg placement.
// "local"   = correct, bars are placed inside each coil's local coordinate frame.
// "angular" = old/debug method, creates ray/starburst style placement.
coil_leg_bar_placement = "local";


// --- Standard steel bars for "coil", "magnet", and "custom" modes ---
steel_bar_length = 30.0;
steel_bar_width = 10.0;
steel_bar_thickness = 3.0;


// --- Narrower bars for "coil_legs" mode ---
coil_leg_bar_length = 30.0;
coil_leg_bar_width = 6.0;


// Clearance for actual steel bars.
steel_bar_clearance = 0.35;


// Plastic behind steel bars.
// Pockets open toward z = 0.
flux_plate_back_cap = 0.8;


// Radial offset of steel bar centers relative to magnet/coil center radius.
steel_bar_center_r_offset = 0.0;


// Angular offset for the whole steel-bar pattern.
steel_bar_angle_offset_deg = 0.0;


// Local skew of each steel bar.
// Try 3 to 5 degrees if cogging is too strong.
steel_bar_skew_deg = 0.0;


// Coil-leg local placement controls.
// Bars are placed at local y = +/- y_offset inside each coil pocket.
coil_leg_bar_width_fraction = 0.78;
coil_leg_bar_y_offset_adjust = 0.0;
coil_leg_bar_x_offset = 0.0;


// Old angular method control.
// Only used if coil_leg_bar_placement = "angular".
coil_leg_angle_inset_deg = 0.0;


// Custom mode settings.
custom_steel_bar_count = 8;
custom_steel_bar_angle_step = 45;
custom_steel_bar_start_angle = 0;


// =====================================================
// 3. MASTER PARAMETERS
// =====================================================

// --- Magnet dimensions ---
bar_mag_length = 29.2;      // radial length
bar_mag_width  = 9.4;       // tangential width
bar_mag_depth  = 6.0;       // axial thickness


// --- Air gap and magnetic stack ---
mechanical_air_gap = 1.25;
rotor_total_h = 6.8;


// --- Coil pocket and stator ---
coil_thickness = 7.8;
thin_floor = 1.0;
stator_h = 9.2;


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


// Radius boost.
// 12/9 is more crowded, so it gets a small boost.
phase3_radius_boost_8_6  = 0.0;
phase3_radius_boost_12_9 = 4.0;


// Visualize steel bars in assembly/verify views.
show_steel_bar_visuals = true;


// Quality
main_fn = 140;
medium_fn = 80;
small_fn = 40;


// =====================================================
// 4. CONFIGURATION ROUTER
// =====================================================

if (configuration == "both") {
    translate([-both_layout_spacing / 2, 0, 0])
        print_layout(8, 6, "8P / 6C");

    translate([both_layout_spacing / 2, 0, 0])
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
// 5. DERIVED GEOMETRY FUNCTIONS
// =====================================================

function radius_boost(nm, nc) =
    (nm == 12 && nc == 9) ? phase3_radius_boost_12_9 : phase3_radius_boost_8_6;


function magnet_center_r_for(nm, nc) =
    (nm * (bar_mag_width + magnet_gap_buffer) / (2 * PI))
    + (bar_mag_length / 2)
    + radius_boost(nm, nc);


function steel_bar_center_r_for(nm, nc) =
    magnet_center_r_for(nm, nc) + steel_bar_center_r_offset;


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


function coil_leg_half_angle(nm) =
    (pole_pitch_angle(nm) / 2) - coil_leg_angle_inset_deg;


function coil_leg_bar_y_offset_for(nm, nc) =
    (
        steel_bar_center_r_for(nm, nc)
        * sin(pole_pitch_angle(nm) / 2)
        * coil_leg_bar_width_fraction
    )
    + coil_leg_bar_y_offset_adjust;


function spacer_h_for() =
    rotor_total_h + (2 * mechanical_air_gap) + (2 * spacer_inset_depth);


function flux_plate_h_for() =
    steel_bar_thickness + flux_plate_back_cap;


// =====================================================
// 6. PRINT LAYOUT
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
            part_label(str(label_text, " BAR FLUX PLATE"));
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
// 7. FULL ASSEMBLY VIEW
// =====================================================

module render_full_assembly(nm, nc) {
    arm_dist = (rotor_total_h / 2) + mechanical_air_gap;

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

    // Top flux plate holder
    translate([0, 0, arm_dist + stator_h]) {
        color("CadetBlue", 0.45)
            flux_plate(nm, nc);

        if (show_steel_bar_visuals)
            color("DimGray", 0.85)
                steel_bar_visuals(nm, nc);
    }

    // Bottom flux plate holder
    translate([0, 0, -arm_dist - stator_h])
        rotate([180, 0, 0]) {
            color("CadetBlue", 0.45)
                flux_plate(nm, nc);

            if (show_steel_bar_visuals)
                color("DimGray", 0.85)
                    steel_bar_visuals(nm, nc);
        }

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
// 8. ALIGNMENT / VERIFICATION VIEW
// =====================================================

module verify_alignment(nm, nc) {
    intersection() {
        union() {
            color("Gold", 0.45)
                translate([0, 0, -rotor_total_h / 2])
                    bar_rotor(nm, nc);

            color("RoyalBlue", 0.35)
                translate([0, 0, mechanical_air_gap])
                    bar_stator(nm, nc);

            translate([0, 0, mechanical_air_gap + stator_h]) {
                color("CadetBlue", 0.40)
                    flux_plate(nm, nc);

                if (show_steel_bar_visuals)
                    color("DimGray", 0.80)
                        steel_bar_visuals(nm, nc);
            }

            color("Red", 0.45)
                magnet_visuals(nm, nc);
        }

        rotate([0, 0, -18])
            cube([190, 190, 90]);
    }
}


// =====================================================
// 9. PHASE OVERLAY VIEW
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

    // Steel bar overlay
    translate([0, 0, stator_h + 1.2])
        color("DimGray", 0.60)
            steel_bar_visuals_flat(nm, nc, 0.8);

    // Coil labels
    for (i = [0 : nc - 1]) {
        rotate([0, 0, i * coil_spacing_angle(nc)])
            translate([magnet_center_r_for(nm, nc), 0, stator_h + 2.6])
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
// 10. CORE PRINTED PARTS
// =====================================================

module bar_rotor(nm, nc) {
    mcr = magnet_center_r_for(nm, nc);
    rr  = rotor_r_for(nm, nc);

    difference() {
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

        // M8 nut trap
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

        // Center relief
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
    sr = stator_r_for(nm, nc);
    mr = mount_r_for(nm, nc);
    h_plate = flux_plate_h_for();

    difference() {
        cylinder(h = h_plate, r = sr, $fn = main_fn);

        // Rectangular steel bar pockets
        steel_bar_pockets(nm, nc);

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


// =====================================================
// 11. STEEL BAR POCKETS
// =====================================================

module steel_bar_pockets(nm, nc) {
    if (steel_bar_mode == "coil") {
        steel_bar_pocket_coil_centers(nm, nc);

    } else if (steel_bar_mode == "magnet") {
        steel_bar_pocket_magnet_positions(nm, nc);

    } else if (steel_bar_mode == "coil_legs") {
        steel_bar_pocket_coil_legs(nm, nc);

    } else if (steel_bar_mode == "coil_and_legs") {
        steel_bar_pocket_coil_centers(nm, nc);
        steel_bar_pocket_coil_legs(nm, nc);

    } else if (steel_bar_mode == "both") {
        steel_bar_pocket_coil_centers(nm, nc);
        steel_bar_pocket_magnet_positions(nm, nc);

    } else if (steel_bar_mode == "all") {
        steel_bar_pocket_coil_centers(nm, nc);
        steel_bar_pocket_magnet_positions(nm, nc);
        steel_bar_pocket_coil_legs(nm, nc);

    } else if (steel_bar_mode == "custom") {
        steel_bar_pocket_custom(nm, nc);
    }
}


module steel_bar_pocket_coil_centers(nm, nc) {
    steel_bar_pocket_ring(
        count = nc,
        angle_step = coil_spacing_angle(nc),
        start_angle = steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width
    );
}


module steel_bar_pocket_magnet_positions(nm, nc) {
    steel_bar_pocket_ring(
        count = nm,
        angle_step = pole_pitch_angle(nm),
        start_angle = steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width
    );
}


module steel_bar_pocket_custom(nm, nc) {
    steel_bar_pocket_ring(
        count = custom_steel_bar_count,
        angle_step = custom_steel_bar_angle_step,
        start_angle = custom_steel_bar_start_angle + steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width
    );
}


module steel_bar_pocket_coil_legs(nm, nc) {
    if (coil_leg_bar_placement == "angular") {
        steel_bar_pocket_coil_legs_angular_old(nm, nc);
    } else {
        steel_bar_pocket_coil_legs_local(nm, nc);
    }
}


// Corrected local-coordinate coil-leg placement.
module steel_bar_pocket_coil_legs_local(nm, nc) {
    r = steel_bar_center_r_for(nm, nc);
    yoff = coil_leg_bar_y_offset_for(nm, nc);

    for (i = [0 : nc - 1]) {
        center_a = steel_bar_angle_offset_deg + i * coil_spacing_angle(nc);

        rotate([0, 0, center_a])
            translate([r + coil_leg_bar_x_offset, yoff, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    steel_bar_pocket_shape(
                        bar_l = coil_leg_bar_length,
                        bar_w = coil_leg_bar_width
                    );

        rotate([0, 0, center_a])
            translate([r + coil_leg_bar_x_offset, -yoff, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    steel_bar_pocket_shape(
                        bar_l = coil_leg_bar_length,
                        bar_w = coil_leg_bar_width
                    );
    }
}


// Old/debug method.
module steel_bar_pocket_coil_legs_angular_old(nm, nc) {
    r = steel_bar_center_r_for(nm, nc);
    half_a = coil_leg_half_angle(nm);

    for (i = [0 : nc - 1]) {
        center_a = steel_bar_angle_offset_deg + i * coil_spacing_angle(nc);

        rotate([0, 0, center_a - half_a])
            translate([r, 0, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    steel_bar_pocket_shape(
                        bar_l = coil_leg_bar_length,
                        bar_w = coil_leg_bar_width
                    );

        rotate([0, 0, center_a + half_a])
            translate([r, 0, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    steel_bar_pocket_shape(
                        bar_l = coil_leg_bar_length,
                        bar_w = coil_leg_bar_width
                    );
    }
}


module steel_bar_pocket_ring(count, angle_step, start_angle, nm, nc, bar_l, bar_w) {
    r = steel_bar_center_r_for(nm, nc);

    for (i = [0 : count - 1]) {
        rotate([0, 0, start_angle + i * angle_step])
            translate([r, 0, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    steel_bar_pocket_shape(
                        bar_l = bar_l,
                        bar_w = bar_w
                    );
    }
}


module steel_bar_pocket_shape(bar_l, bar_w) {
    pocket_l = bar_l + steel_bar_clearance;
    pocket_w = bar_w + steel_bar_clearance;
    pocket_h = steel_bar_thickness + 0.25;

    translate([0, 0, steel_bar_thickness / 2])
        cube([pocket_l, pocket_w, pocket_h], center = true);
}


// =====================================================
// 12. STEEL BAR VISUALS
// =====================================================

module steel_bar_visuals(nm, nc) {
    if (steel_bar_mode == "coil") {
        steel_bar_visual_coil_centers(nm, nc);

    } else if (steel_bar_mode == "magnet") {
        steel_bar_visual_magnet_positions(nm, nc);

    } else if (steel_bar_mode == "coil_legs") {
        steel_bar_visual_coil_legs(nm, nc);

    } else if (steel_bar_mode == "coil_and_legs") {
        steel_bar_visual_coil_centers(nm, nc);
        steel_bar_visual_coil_legs(nm, nc);

    } else if (steel_bar_mode == "both") {
        steel_bar_visual_coil_centers(nm, nc);
        steel_bar_visual_magnet_positions(nm, nc);

    } else if (steel_bar_mode == "all") {
        steel_bar_visual_coil_centers(nm, nc);
        steel_bar_visual_magnet_positions(nm, nc);
        steel_bar_visual_coil_legs(nm, nc);

    } else if (steel_bar_mode == "custom") {
        steel_bar_visual_custom(nm, nc);
    }
}


module steel_bar_visual_coil_centers(nm, nc) {
    steel_bar_visual_ring(
        count = nc,
        angle_step = coil_spacing_angle(nc),
        start_angle = steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width,
        bar_h = steel_bar_thickness
    );
}


module steel_bar_visual_magnet_positions(nm, nc) {
    steel_bar_visual_ring(
        count = nm,
        angle_step = pole_pitch_angle(nm),
        start_angle = steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width,
        bar_h = steel_bar_thickness
    );
}


module steel_bar_visual_custom(nm, nc) {
    steel_bar_visual_ring(
        count = custom_steel_bar_count,
        angle_step = custom_steel_bar_angle_step,
        start_angle = custom_steel_bar_start_angle + steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width,
        bar_h = steel_bar_thickness
    );
}


module steel_bar_visual_coil_legs(nm, nc) {
    if (coil_leg_bar_placement == "angular") {
        steel_bar_visual_coil_legs_angular_old(nm, nc);
    } else {
        steel_bar_visual_coil_legs_local(nm, nc);
    }
}


// Corrected local-coordinate visual placement.
module steel_bar_visual_coil_legs_local(nm, nc) {
    r = steel_bar_center_r_for(nm, nc);
    yoff = coil_leg_bar_y_offset_for(nm, nc);

    for (i = [0 : nc - 1]) {
        center_a = steel_bar_angle_offset_deg + i * coil_spacing_angle(nc);

        rotate([0, 0, center_a])
            translate([r + coil_leg_bar_x_offset, yoff, steel_bar_thickness / 2])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            coil_leg_bar_length,
                            coil_leg_bar_width,
                            steel_bar_thickness
                        ],
                        center = true
                    );

        rotate([0, 0, center_a])
            translate([r + coil_leg_bar_x_offset, -yoff, steel_bar_thickness / 2])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            coil_leg_bar_length,
                            coil_leg_bar_width,
                            steel_bar_thickness
                        ],
                        center = true
                    );
    }
}


// Old/debug visual method.
module steel_bar_visual_coil_legs_angular_old(nm, nc) {
    r = steel_bar_center_r_for(nm, nc);
    half_a = coil_leg_half_angle(nm);

    for (i = [0 : nc - 1]) {
        center_a = steel_bar_angle_offset_deg + i * coil_spacing_angle(nc);

        rotate([0, 0, center_a - half_a])
            translate([r, 0, steel_bar_thickness / 2])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            coil_leg_bar_length,
                            coil_leg_bar_width,
                            steel_bar_thickness
                        ],
                        center = true
                    );

        rotate([0, 0, center_a + half_a])
            translate([r, 0, steel_bar_thickness / 2])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            coil_leg_bar_length,
                            coil_leg_bar_width,
                            steel_bar_thickness
                        ],
                        center = true
                    );
    }
}


module steel_bar_visual_ring(count, angle_step, start_angle, nm, nc, bar_l, bar_w, bar_h) {
    r = steel_bar_center_r_for(nm, nc);

    for (i = [0 : count - 1]) {
        rotate([0, 0, start_angle + i * angle_step])
            translate([r, 0, bar_h / 2])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            bar_l,
                            bar_w,
                            bar_h
                        ],
                        center = true
                    );
    }
}


// =====================================================
// 13. FLAT STEEL BAR OVERLAYS
// =====================================================

module steel_bar_visuals_flat(nm, nc, flat_h) {
    if (steel_bar_mode == "coil") {
        steel_bar_visual_flat_coil_centers(nm, nc, flat_h);

    } else if (steel_bar_mode == "magnet") {
        steel_bar_visual_flat_magnet_positions(nm, nc, flat_h);

    } else if (steel_bar_mode == "coil_legs") {
        steel_bar_visual_flat_coil_legs(nm, nc, flat_h);

    } else if (steel_bar_mode == "coil_and_legs") {
        steel_bar_visual_flat_coil_centers(nm, nc, flat_h);
        steel_bar_visual_flat_coil_legs(nm, nc, flat_h);

    } else if (steel_bar_mode == "both") {
        steel_bar_visual_flat_coil_centers(nm, nc, flat_h);
        steel_bar_visual_flat_magnet_positions(nm, nc, flat_h);

    } else if (steel_bar_mode == "all") {
        steel_bar_visual_flat_coil_centers(nm, nc, flat_h);
        steel_bar_visual_flat_magnet_positions(nm, nc, flat_h);
        steel_bar_visual_flat_coil_legs(nm, nc, flat_h);

    } else if (steel_bar_mode == "custom") {
        steel_bar_visual_flat_custom(nm, nc, flat_h);
    }
}


module steel_bar_visual_flat_coil_centers(nm, nc, flat_h) {
    steel_bar_visual_flat_ring(
        count = nc,
        angle_step = coil_spacing_angle(nc),
        start_angle = steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width,
        flat_h = flat_h
    );
}


module steel_bar_visual_flat_magnet_positions(nm, nc, flat_h) {
    steel_bar_visual_flat_ring(
        count = nm,
        angle_step = pole_pitch_angle(nm),
        start_angle = steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width,
        flat_h = flat_h
    );
}


module steel_bar_visual_flat_custom(nm, nc, flat_h) {
    steel_bar_visual_flat_ring(
        count = custom_steel_bar_count,
        angle_step = custom_steel_bar_angle_step,
        start_angle = custom_steel_bar_start_angle + steel_bar_angle_offset_deg,
        nm = nm,
        nc = nc,
        bar_l = steel_bar_length,
        bar_w = steel_bar_width,
        flat_h = flat_h
    );
}


module steel_bar_visual_flat_coil_legs(nm, nc, flat_h) {
    if (coil_leg_bar_placement == "angular") {
        steel_bar_visual_flat_coil_legs_angular_old(nm, nc, flat_h);
    } else {
        steel_bar_visual_flat_coil_legs_local(nm, nc, flat_h);
    }
}


// Corrected flat overlay placement.
module steel_bar_visual_flat_coil_legs_local(nm, nc, flat_h) {
    r = steel_bar_center_r_for(nm, nc);
    yoff = coil_leg_bar_y_offset_for(nm, nc);

    for (i = [0 : nc - 1]) {
        center_a = steel_bar_angle_offset_deg + i * coil_spacing_angle(nc);

        rotate([0, 0, center_a])
            translate([r + coil_leg_bar_x_offset, yoff, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            coil_leg_bar_length,
                            coil_leg_bar_width,
                            flat_h
                        ],
                        center = true
                    );

        rotate([0, 0, center_a])
            translate([r + coil_leg_bar_x_offset, -yoff, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            coil_leg_bar_length,
                            coil_leg_bar_width,
                            flat_h
                        ],
                        center = true
                    );
    }
}


// Old/debug flat overlay.
module steel_bar_visual_flat_coil_legs_angular_old(nm, nc, flat_h) {
    r = steel_bar_center_r_for(nm, nc);
    half_a = coil_leg_half_angle(nm);

    for (i = [0 : nc - 1]) {
        center_a = steel_bar_angle_offset_deg + i * coil_spacing_angle(nc);

        rotate([0, 0, center_a - half_a])
            translate([r, 0, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            coil_leg_bar_length,
                            coil_leg_bar_width,
                            flat_h
                        ],
                        center = true
                    );

        rotate([0, 0, center_a + half_a])
            translate([r, 0, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            coil_leg_bar_length,
                            coil_leg_bar_width,
                            flat_h
                        ],
                        center = true
                    );
    }
}


module steel_bar_visual_flat_ring(count, angle_step, start_angle, nm, nc, bar_l, bar_w, flat_h) {
    r = steel_bar_center_r_for(nm, nc);

    for (i = [0 : count - 1]) {
        rotate([0, 0, start_angle + i * angle_step])
            translate([r, 0, 0])
                rotate([0, 0, steel_bar_skew_deg])
                    cube(
                        [
                            bar_l,
                            bar_w,
                            flat_h
                        ],
                        center = true
                    );
    }
}


// =====================================================
// 14. SPACERS
// =====================================================

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
// 15. COIL WINDER
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

        translate([0, 0, -1])
            cylinder(h = 60, r = alignment_bolt_r, $fn = small_fn);

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
// 16. SHAPE HELPERS
// =====================================================

module trap_shape(nm, nc, h, extra_l = 0, extra_w = 0) {
    /*
        Trapezoidal coil/window shape.

        Coil centers:
            360 / nc

        Coil active span:
            360 / nm

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