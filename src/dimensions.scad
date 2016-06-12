// globals

// The bit that sticks in the chuck
bit_radius=7/2;
bit_depth=13;

// The chuck of the driver
chuck_radius=11.1/2;
chuck_length=18;

// The Spool the hold the string
spool_radius=20;
spool_length=40;
spool_lip_height=6;

// Drill parts
ring_start=chuck_length;
ring_radius1=28/2;
ring_radius2=36/2;
ring_length=17.5;

collar_start=ring_start+ring_length;
collar_radius1=ring_radius2;
collar_radius2=41/2;
collar_length=37.5;

handle_start=collar_start+collar_length;
handle_radius1=collar_radius2;
handle_radius2=46.5/2;
handle_length=53.9;

battery_start=handle_start+handle_length;
battery_length=45;

drill_length=battery_start+battery_length;

// The indention on the spool
collar_radius=spool_lip_height/2;
collar_height=spool_length-spool_lip_height*2-collar_radius;

// String radius
string_radius=1;
knot_radius=2;

// Screw hole
recess_radius=9/2;
screw_radius=4/2;
screw_head=4;
