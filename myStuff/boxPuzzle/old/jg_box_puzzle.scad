
//$fa = 1;
//$fs = 0.4;
//$fn=50;

// Puzzle Constants
P1 = 0;
P2 = 1;
P3 = 2;
P4 = 3;
P5 = 4;
P6 = 5;

Top = 0;
Lft = 1;
Bot = 2;
Rht = 3;

DirPos = "P";
DirNeg = "N";
OrdStd = "S";
OrdRev = "R";

// Puzzle variables
thickness = 5;
num_pieces = 6;
num_edges  = 4;
num_joining_edges  = 12;
num_notches_per_edge = 7;
seed=3.1459;    // This determines the notch pattern for all edges

// puzzle defn:
//                     P6
// piece layout: P1 P2 P3 P4
//                     P5
//
// each puzzle has 6 pieces (0-5): Level 1
// each piece has 4 edges (0=top, 1=left, 2=bot, 3=right): Level 2
// each edge has 7 possible notches: Level 3
// there are 12 joining edges that relate 
//  a specific edge of one piece to a specific 
//  edge of another piece. A postive edge on the 
//  first piece will mate with the negative edge
//  on the second piece.
//  Level 1: joining edge number (0-11)
//  Level 2: relates piece1/edge to piece2/edge
//  [[piece#,edge#], [piece#,edge#]]
joining_edge_list = [
    [[P1,Top], [P6,Top]], //P1,Top to P6,Top      1 [0] Reverse
    [[P2,Top], [P6,Lft]], //P2,Top to P6,Left     2 [1]
    [[P3,Top], [P6,Bot]], //P3,Top to P6,Bot      3 [2]
    [[P4,Top], [P6,Rht]], //P4,Top to P6,Right    4 [3]
    
    [[P1,Lft], [P4,Rht]], //P1,Left to P4,Right   5 [4] Reverse
    
    [[P1,Bot], [P5,Bot]], //P1,Bot to P5,Bot      6 [5] Reverse
    [[P2,Bot], [P5,Lft]], //P2,Bot to P5,Left     7 [6]
    [[P3,Bot], [P5,Top]], //P3,Bot to P5,Top      8 [7]
    [[P4,Bot], [P5,Rht]], //P4,Bot to P5,Right    9 [8]
    
    [[P1,Rht], [P2,Lft]], //P1,Right to P2,Left   10 [9]
    [[P2,Rht], [P3,Lft]], //P2,Right to P3,Left   11 [10]
    [[P3,Rht], [P4,Lft]], //P3,Right to P4,Left   12 [11]
];

// Seeds for random list of notches
joining_edge_seed_list = rands(0, 100, num_joining_edges, seed);
echo( "joining_edge_seed_list: ", joining_edge_seed_list);

// Indices match with joining_edge_list
joining_edge_notch_list = [ 
    for (s = joining_edge_seed_list) 
        [ for (n = rands(0,1,num_notches_per_edge,s)) round(n) ] 
];
echo( "joining_edge_notch_list: ", joining_edge_notch_list);

// Relates each edge of each puzzle piece to 
// a top level element of the joining_edge_list
// with appropriate notch direction and ordering.
piece_edge_to_joining_edge_list = [
    [ [Top, 0,DirPos,OrdStd], [Lft, 4,DirPos,OrdStd], [Bot, 5,DirPos,OrdStd], [Rht, 9,DirPos,OrdStd] ], //P1 
    [ [Top, 1,DirPos,OrdStd], [Lft, 9,DirNeg,OrdStd], [Bot, 6,DirPos,OrdStd], [Rht,10,DirPos,OrdStd] ], //P2 
    [ [Top, 2,DirPos,OrdStd], [Lft,10,DirNeg,OrdStd], [Bot, 7,DirPos,OrdStd], [Rht,11,DirPos,OrdStd] ], //P3 
    [ [Top, 3,DirPos,OrdStd], [Lft,11,DirNeg,OrdStd], [Bot, 8,DirPos,OrdStd], [Rht, 4,DirNeg,OrdRev] ], //P4 
    [ [Top, 7,DirNeg,OrdStd], [Lft, 6,DirNeg,OrdStd], [Bot, 5,DirNeg,OrdRev], [Rht, 8,DirNeg,OrdStd] ], //P5 
    [ [Top, 0,DirNeg,OrdRev], [Lft, 1,DirNeg,OrdStd], [Bot, 2,DirNeg,OrdStd], [Rht, 3,DirNeg,OrdStd] ], //P6 
];

// Returns a new list with the order reversed from the given list.
function funcReverseOrder(list) = [
    for (i=[len(list)-1:-1:0]) list[i]
];

// Returns a new list with 0's changed to 1's and 1's changed to 0's.
function funcSwitchDir(list) = [
    for (i=[0:len(list)-1]) list[i] == 1 ? 0 : 1
];

// Returns a list of notches with the appropriate direction and order.
function getNotchList(list, direction, order) = 
    direction==DirNeg && order==OrdRev ?
        funcSwitchDir(funcReverseOrder(list)) :
        direction==DirNeg && order==OrdStd ?
            funcSwitchDir(list) :
            direction==DirPos && order==OrdRev ?
                funcReverseOrder(list) :
                list;
;


list = [ for (i = rands(0,1,num_notches_per_edge,seed)) round(i) ];
echo( "list: ", list);
revList = funcReverseOrder(list);
echo( "revList: ", revList);
switchList = funcSwitchDir(revList);
echo( "switchList: ", switchList);
listNR = getNotchList(list, "N", "R");
echo( "listNR: ", listNR);

piece_edge_notch_list = [ 
        for (p=[0:num_pieces-1]) [
            for (e=[0:num_edges-1])
               getNotchList( 
                joining_edge_notch_list[piece_edge_to_joining_edge_list[p][e][1]],
                piece_edge_to_joining_edge_list[p][e][2],
                piece_edge_to_joining_edge_list[p][e][3]
               )
        ] 
];
echo( "piece_edge_notch_list: ", piece_edge_notch_list);

for (p=[0:num_pieces-1]) {
    piece_edge_notch_list = [];
}



//Old Junk
//random_vect=rands(0,1,7,seed);
//echo( "Random Vector: ",random_vect);
//
//list = [ for (i = rands(0,1,num_notches_per_edge,seed)) round(i) ];
//echo( "list: ", list);

//edge_notch_list = [ for (i = rands(0,1,num_notches_per_edge,seed)) round(i) ];
//echo( "edge_notch_list: ",edge_notch_list);

//joining_edge_list_old = [
//    [[0,0], [5,0]], //P1,Top to P6,Top      1 [0]
//    [[1,0], [5,1]], //P2,Top to P6,Left     2 [1]
//    [[2,0], [5,2]], //P3,Top to P6,Bot      3 [2]
//    [[3,0], [5,3]], //P4,Top to P6,Right    4 [3]
//    
//    [[0,1], [3,3]], //P1,Left to P4,Right   5 [4]
//    
//    [[0,2], [4,2]], //P1,Bot to P5,Bot      6 [5]
//    [[1,2], [4,1]], //P2,Bot to P5,Left     7 [6]
//    [[2,2], [4,0]], //P3,Bot to P5,Top      8 [7]
//    [[3,2], [4,3]], //P4,Bot to P5,Right    9 [8]
//    
//    [[0,3], [1,1]], //P1,Right to P2,Left   10 [9]
//    [[1,3], [2,1]], //P2,Right to P3,Left   11 [10]
//    [[2,3], [3,1]], //P3,Right to P4,Left   12 [11]
//];

//function reverse (a, i=0) =
//    len(a) > i ?
//        concat(a[i],  reverse(a, i+1)) :
//        []
//;
//
//echo([for(i=[0:10]) if(i%2==0) (if(i%4==0) -1 ) else i]);



//
//n1 = mm_per_tooth*4; //red gear number of teeth
//n5 = length/mm_per_tooth;  //gray rack
//d1 = pitch_radius(mm_per_tooth, n1);
//
//hole            = n1/2;
//height          = mm_per_tooth * 1.5;
//rack_y_offset   = height-(mm_per_tooth * PI/10);
//bottom_w        = mm_per_tooth * 2;
//end_cap_x_offset= length-thickness/2;
//end_cap_y       = (d1+height)*2;
//
////Gear
//translate([0, d1+rack_y_offset, thickness/2])    
//    gear(mm_per_tooth,n1,thickness,hole);
//
////Rack
//translate([mm_per_tooth/2, rack_y_offset, thickness/2])    
//    rack(mm_per_tooth, n5, thickness, height); 
//    
////Triangle
//translate([0, height, thickness*2])
//    rotate([180,0,0])
//    prism(length, height, thickness);
//        
////Back
//translate([length/2, rack_y_offset/4, thickness/2])
//    cube([length, rack_y_offset/2, thickness*3],center=true);
//
////Bottom
//translate([length/2, d1/2, -thickness/2])
//    cube([length, d1, thickness],center=true);
//
////End Cap 1
//translate([end_cap_x_offset, d1/2, -thickness/2])
//    cube([thickness, d1, thickness*5],center=true);
//
////End Cap 2
//translate([end_cap_x_offset, end_cap_y/2, -thickness*2.5])
//    cube([thickness, end_cap_y, thickness*3],center=true);
//
//Prism Module
module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module box_piece(thickness, piece_num, edge_notch_list) {
    num_notches = len(edge_notch_list[0]);
    side_len = thickness*num_notches;
    cube([side_len, side_len, thickness],center=true);
}


joining_edge_list_2 = [
    [[0,0], [5,0]], //P1,Top to P6,Top
    [[1,0], [5,1]], //P2,Top to P6,Left
    [[2,0], [5,2]], //P3,Top to P6,Bot
    [[3,0], [5,3]], //P4,Top to P6,Right
    
    [[2,2], [4,0]], //P3,Bot to P5,Top
    [[1,2], [4,1]], //P2,Bot to P5,Left
    [[0,2], [4,2]], //P1,Bot to P5,Bot
    [[3,2], [4,3]], //P4,Bot to P5,Right
    
    [[2,3], [3,1]], //P3,Right to P4,Left
    [[0,1], [3,3]], //P1,Left  to P4,Right
    
    [[1,3], [2,1]], //P2,Right to P3,Left
    
    [[0,3], [1,1]], //P1,Right to P2,Left
];