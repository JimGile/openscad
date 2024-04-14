use <jg_box_puzzle_module_v4.scad>;

$fa = 1;
$fs = 0.4;
$fn=50;

// Puzzle variables
thickness = 4;
num_notches_per_edge = 7;
seed=3.1459; // This determines the notch pattern for all edges (not working)
boxLetters = "123456";
spacing = thickness*num_notches_per_edge+.75;
slop = 0.16;
rounding_radius = 1.5;

edge_notch_list = getPieceEdgeNotchList(seed, num_notches_per_edge);
for (p=[0:len(edge_notch_list)-1]) {
    //echo("piece: ",p);
    translate([((p-(p%2))*spacing)/2, -(p%2)*spacing, 0])
    box_piece(p, thickness, edge_notch_list[p], boxLetters, slop, rounding_radius);
}

//for (p=[0:len(edge_notch_list)-1]) {
//    echo("piece: ",p);
//    translate([p*spacing, 0, 0])
//    box_piece(p, thickness, edge_notch_list[p], boxLetters, slop, rounding_radius);
//}