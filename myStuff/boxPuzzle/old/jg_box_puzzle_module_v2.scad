// Puzzle variables
//thickness = 5;
//num_notches_per_edge = 7;
//seed=3.1459;    // This determines the notch pattern for all edges

// ------------------------
// Box Puzzle Module Constants
// ------------------------
// Pieces
P1 = 0;
P2 = 1;
P3 = 2;
P4 = 3;
P5 = 4;
P6 = 5;

// Edges
TOP = 0;
LFT = 1;
BOT = 2;
RHT = 3;

// Notch directions
DIR_POS = "P";
DIR_NEG = "N";

// Notch order
ORD_STD = "S";
ORD_REV = "R";

// Box specific values
NUM_PIECES = 6;
NUM_EDGES  = 4;
NUM_JOINING_EDGES  = 12;


// ------------------------
// Box Puzzle Global Functions
// ------------------------

// Box puzzle defn:
//                     P6
// piece layout: P1 P2 P3 P4
//                     P5
//
// each puzzle has 6 pieces (0-5): Level 1
// each piece has 4 edges (0=TOP, 1=left, 2=BOT, 3=right): Level 2
// each edge has 7 possible notches: Level 3
// there are 12 joining edges that relate 
//  a specific edge of one piece to a specific 
//  edge of another piece. A postive edge on the 
//  first piece will mate with the negative edge
//  on the second piece.
//  Level 1: joining edge number (0-11)
//  Level 2: relates piece1/edge to piece2/edge
//  [[piece#,edge#], [piece#,edge#]]
function getJoiningEdgeList() = [
    [[P1,TOP], [P6,TOP]], //P1,TOP to P6,TOP      1 [0] Reverse
    [[P2,TOP], [P6,LFT]], //P2,TOP to P6,Left     2 [1]
    [[P3,TOP], [P6,BOT]], //P3,TOP to P6,BOT      3 [2]
    [[P4,TOP], [P6,RHT]], //P4,TOP to P6,Right    4 [3]
    
    [[P1,LFT], [P4,RHT]], //P1,Left to P4,Right   5 [4] Reverse
    
    [[P1,BOT], [P5,BOT]], //P1,BOT to P5,BOT      6 [5] Reverse
    [[P2,BOT], [P5,LFT]], //P2,BOT to P5,Left     7 [6]
    [[P3,BOT], [P5,TOP]], //P3,BOT to P5,TOP      8 [7]
    [[P4,BOT], [P5,RHT]], //P4,BOT to P5,Right    9 [8]
    
    [[P1,RHT], [P2,LFT]], //P1,Right to P2,Left   10 [9]
    [[P2,RHT], [P3,LFT]], //P2,Right to P3,Left   11 [10]
    [[P3,RHT], [P4,LFT]], //P3,Right to P4,Left   12 [11]
];

// Indices match with getJoiningEdgeList
function getJoiningEdgeNotchList_old(seed, edge_notches) = [ 
    for (s = rands(0, 100, NUM_JOINING_EDGES, seed)) 
        [ for (n = rands(0,1,edge_notches,s)) round(n) ] 
];

// Indices match with getJoiningEdgeList
function getJoiningEdgeNotchList(seed, edge_notches) = [
        [0,0,1,1,1,0,1], //1
        [0,0,1,0,1,0,0], //2
        [1,0,1,0,1,0,1], //3
        [0,1,1,0,1,1,1], //4
        [0,0,0,1,0,0,0], //5
        [0,1,0,1,0,1,1], //6
        [1,1,0,1,1,0,1], //7
        [1,1,0,1,0,1,1], //8
        [1,0,1,1,1,0,1], //9
        [1,0,0,1,0,0,1], //10
        [1,0,1,1,0,0,0], //11
        [1,1,1,0,0,1,1], //12
];


// Relates each edge of each puzzle piece to 
// a top level element of the joining_edge_list
// with appropriate notch direction and ordering.
function getPieceEdgeToJoiningEdgeList() = [
    [ [TOP, 0,DIR_POS,ORD_STD], [LFT, 4,DIR_POS,ORD_STD], [BOT, 5,DIR_POS,ORD_STD], [RHT, 9,DIR_POS,ORD_STD] ], //P1 
    [ [TOP, 1,DIR_POS,ORD_STD], [LFT, 9,DIR_NEG,ORD_STD], [BOT, 6,DIR_POS,ORD_STD], [RHT,10,DIR_POS,ORD_STD] ], //P2 
    [ [TOP, 2,DIR_POS,ORD_STD], [LFT,10,DIR_NEG,ORD_STD], [BOT, 7,DIR_POS,ORD_STD], [RHT,11,DIR_POS,ORD_STD] ], //P3 
    [ [TOP, 3,DIR_POS,ORD_STD], [LFT,11,DIR_NEG,ORD_STD], [BOT, 8,DIR_POS,ORD_STD], [RHT, 4,DIR_NEG,ORD_REV] ], //P4 
    [ [TOP, 7,DIR_NEG,ORD_STD], [LFT, 6,DIR_NEG,ORD_STD], [BOT, 5,DIR_NEG,ORD_REV], [RHT, 8,DIR_NEG,ORD_STD] ], //P5 
    [ [TOP, 0,DIR_NEG,ORD_REV], [LFT, 1,DIR_NEG,ORD_STD], [BOT, 2,DIR_NEG,ORD_STD], [RHT, 3,DIR_NEG,ORD_STD] ], //P6 
];

// Returns a new list with the order reversed from the given list.
function getReversedOrderList(list) = [
    for (i=[len(list)-1:-1:0]) list[i]
];

// Returns a new list with 0's changed to 1's and 1's changed to 0's.
function getSwitchedDirectionList(list) = [
    for (i=[0:len(list)-1]) list[i] == 1 ? 0 : 1
];

// Returns a list of notches with the appropriate direction and order.
function getNotchList(list, direction, order) =
    direction==DIR_NEG && order==ORD_REV ?
        getSwitchedDirectionList(getReversedOrderList(list)) :
        direction==DIR_NEG && order==ORD_STD ?
            getSwitchedDirectionList(list) :
            direction==DIR_POS && order==ORD_REV ?
                getReversedOrderList(list) :
                list;
;

// Returns a list of 6 pieces, each piece has 4 edges 
// and each edge has a notch list length of edge_notches.
function getPieceEdgeNotchList(seed, edge_notches) =
    let (je_notch_list = getJoiningEdgeNotchList(seed, edge_notches))
    let (pe_to_je_list = getPieceEdgeToJoiningEdgeList())
    [
    for (p=[0:NUM_PIECES-1]) 
        [
        for (e=[0:NUM_EDGES-1])
            getNotchList( 
                je_notch_list[pe_to_je_list[p][e][1]],  // Notch List
                pe_to_je_list[p][e][2],                 // Direction
                pe_to_je_list[p][e][3]                  // Order
            )
        ] 
    ]
;

module box_piece(piece_num, thickness, edge_notch_list, boxLetters, slop = 0.05) {
    num_notches = len(edge_notch_list[0]);
    side_len = thickness*num_notches;
    font_size = side_len/2;

    //TOP Edge: translate([-slop/2, side_len-thickness, -slop/2]) rotate([0,0,0])
    //Left Edge: translate([thickness-slop/2, -slop/2, -slop/2]) rotate([0,0,90])
    //Bottom Edge: translate([-slop/2, -slop/2, -slop/2]) rotate([0,0,0])
    //Right Edge: translate([side_len, -slop/2, -slop/2]) rotate([0,0,90])
    //Translations List
    t = [
        [-slop,         side_len-thickness+slop,    -slop/2], //Top
        [thickness-slop,-slop,                      -slop/2], //Left
        [-slop,         -slop,                      -slop/2], //Bot
        [side_len+slop, -slop,                      -slop/2]  //Right
    ];
    //Rotations List
    r = [
        [0,0,0],    //Top
        [0,0,90],   //Left
        [0,0,0],    //Bot
        [0,0,90]    //Right
    ];
    
    difference() {
        cube([side_len, side_len, thickness]);
        //Remove edge notches
        for (e=[0:NUM_EDGES-1]) {
            translate(t[e])
            rotate(r[e])
            notched_edge(e, thickness, edge_notch_list[e], slop);
        }
        //Remove Letter
        translate([side_len/4.5, side_len/3.5, thickness/2]) 
            linear_extrude(thickness*2) text(boxLetters[piece_num], size=font_size, font="Arial:style=Black");
    }
    
}

module notched_edge(edge_num, thickness, notch_list, slop) {
    notch_len = thickness+(slop*2);
    union() {
        for (i=[0:len(notch_list)-1]) {
            translate([i*(thickness), -slop/2, -slop/2])
            cube([notch_list[i]*(notch_len), notch_len, notch_len]);
        }
    }
}
