include <../common.scad>
include <dimensions.scad>

// globals

// Button holes
button_radius1=17.4/2;
button_radius2=13.4/2;
button_center_down=collar_radius1/2;
button_center_back=21;

// bracket
gap_from_wall=0;
gap_around_drill=1.025;
thickness=1.2;
remove_from_edge=2;
wall_thickness=(handle_radius2*thickness-handle_radius2*gap_around_drill);
mount_width=(screw_head+wall_thickness)*2;
mount_width_factor=1.625;

mount_z_bottom=(handle_radius2-gap_from_wall)*-1;
mount_1_y_center=collar_start+collar_length/2;
mount_3_y_center=drill_length+wall_thickness-collar_length/2;
mount_2_y_center=mount_1_y_center+(mount_3_y_center-mount_1_y_center)/2;

wire_radius=2.6/2;

echo(wall_thickness);

module batteryClamp()
{
    difference()
    {
        union()
        {
            clamp(handle_radius2,handle_radius2,battery_length);
        }

        union()
        {

        }
    }
}

module bracket()
{
    difference()
    {
        union()
        {
            translate([0,collar_start,0])
            clampOutside();

            // Front mount
            translate([0,mount_1_y_center,mount_z_bottom])
            mount();

            // Front mount
            translate([0,mount_2_y_center,mount_z_bottom])
            mount();

            // Rear mount
            translate([0,mount_3_y_center,mount_z_bottom])
            mount();
        }

        union()
        {
            // Inside loop of the parts
            scale([gap_around_drill,1,gap_around_drill])
            translate([0,collar_start,0])
            clampInside();

            // Impression of the drill
            scale([gap_around_drill,1,gap_around_drill])
            drillImpressions();

            %scale([gap_around_drill,1,gap_around_drill])
            drill();

            // Make the gap to the wall
            translate([drill_length,collar_start,handle_radius2*-1])
            cube([drill_length*2,drill_length*2,gap_from_wall]);

            // Mask out strange seams
            // TODO: Look into why this is needed
            scale([gap_around_drill,1,gap_around_drill])
            translate([handle_radius1*-1,handle_start-.01,handle_radius1*2*-1])
            cube([handle_radius1*2,.02,handle_radius1*2]);
            scale([gap_around_drill,1,gap_around_drill])
            translate([handle_radius2*-1,battery_start-.01,handle_radius2*2*-1])
            cube([handle_radius2*2,.02,handle_radius2*2]);
            scale([gap_around_drill,1,gap_around_drill])
            translate([0,battery_start,0])
            rotate([90,0,0])
            cylinder(r=handle_radius2,h=.02,center=true);

            // bottom
            //translate([0,handle_start+handle_length/2+wall_thickness*2,mount_z_bottom])
            translate([drill_length*-1,collar_start,(handle_radius2+wall_thickness*2)*-1+.01])
            cube([drill_length*2,drill_length*2,wall_thickness*2]);

            // Hole for the wire
            translate([handle_radius2,drill_length-wire_radius*2,handle_radius2*-1])
            wireHole();

            // TODO: Put the logo in the end
        }
    }
}

module clamp(radius1,radius2,length)
{
    rotate([270,0,0])
    difference()
    {
        union()
        {
            // The shape of the item being clamped
            cylinder(r1=radius1,r2=radius2,h=length);

            // The extruded depth to the flat surface
            translate([radius2*-1,handle_radius2,length])
            rotate([180,0,0])
            trapezoidal_prism(radius2*2,radius1*2,handle_radius2,length);
        }

        union()
        {

        }
    }
}

module clampInside()
{
    difference()
    {
        // Increase the size to make to make the clamp larger than the drill
        union()
        {
            // TODO: May need to slighly open up the collar bottom some
            /*collarClamp();*/

            translate([0,collar_length,0])
            handleClamp();

            translate([0,collar_length+handle_length,0])
            batteryClamp();

            // Back edge to catch battery tray
            /*translate([handle_radius2*-1,collar_length+handle_length,handle_radius2*2*-1])
            cube([handle_radius2*2,wall_thickness,handle_radius2*2]);*/
        }

        // Trim off a little to make sure that the drill strick through
        union()
        {
            // Front stop
            /*translate([drill_length*-1,collar_length+handle_length,0])
            cube([drill_length*2,wall_thickness,drill_length]);*/

            // Middle stop
            translate([drill_length*-1,collar_length+handle_length+battery_length/2-wall_thickness/2,0])
            cube([drill_length*2,wall_thickness,drill_length]);

            // Rear stop
            translate([drill_length*-1,collar_length+handle_length+battery_length-wall_thickness,0])
            cube([drill_length*2,wall_thickness,drill_length]);
        }
    }
}

module clampOutside()
{
    scale([thickness,1,thickness])
    difference()
    {
        // Increase the size to make to make the clamp larger than the drill
        union()
        {
            collarClamp();

            translate([0,collar_length,0])
            handleClamp();

            translate([0,collar_length+handle_length,0])
            batteryClamp();

            // Back wall
            translate([0,collar_length+handle_length+battery_length,0])
            clamp(handle_radius2,handle_radius2,wall_thickness);
        }

        // Trim off a little to make sure that the drill strick through
        union()
        {
            // Front
            translate([drill_length*-1,remove_from_edge*-1,drill_length*-1])
            cube([drill_length*2,remove_from_edge*2,drill_length*2]);
        }
    }
}

module collarClamp()
{
    clamp(collar_radius1,collar_radius2,collar_length);
}

module drill()
{
    rotate([0,270,270])
    difference()
    {
        union()
        {
            // Chuck
            cylinder(r=chuck_radius,h=chuck_length);

            // Ring
            translate([0,0,ring_start])
            cylinder(r1=ring_radius1,r2=ring_radius2,h=ring_length);

            // Collar
            translate([0,0,collar_start])
            cylinder(r1=collar_radius1,r2=collar_radius2,h=collar_length);

            // Handle
            translate([0,0,handle_start])
            resize([handle_radius1*2,handle_radius2*2,handle_length])
            cylinder(r=handle_radius1,h=handle_length);

            // Battery
            translate([0,0,battery_start])
            resize([handle_radius1*2,handle_radius2*2,battery_length])
            cylinder(r=handle_radius1,h=battery_length);
        }

    union()
        {
            // Buttons
            /*translate([0,0,handle_start+button_center_down+button_radius2])
            resize([button_radius2*2,handle_radius2*3,button_radius1*2])
            rotate([90,90,0])
            cylinder(r=button_radius1, h=handle_radius2*3, center=true);*/

            // Cut out battery area
            translate([0,handle_radius2*-1,battery_start])
            cube([handle_radius1, handle_radius2*2, battery_length*2]);
        }
    }
}

module drillImpressions()
{
    translate([0,collar_start+remove_from_edge,0])
    difference()
    {
        /*%translate([0,drill_length/2-(collar_start+remove_from_edge),0])
        cube([handle_radius2*2,drill_length,handle_radius2*2],center=true);*/
        /*%translate([0,(collar_start+remove_from_edge)*-1,0])
        drill();*/

        hull()
        {
            /*rotate([0,0,0])*/
            translate([0,(collar_start+remove_from_edge)*-1,0])
            drill();

            rotate([350,0,0])
            translate([0,(collar_start+remove_from_edge)*-1,0])
            drill();
        }

        translate([drill_length/2*-1,battery_start-collar_start-remove_from_edge,0])
        cube(drill_length);

        /*for (x = [350:2.5:360])
        {*/
            /*union()
            {*/
                /*rotate([x,0,0])
                translate([0,(collar_start+remove_from_edge)*-1,0])
                drill();*/
            /*}*/

            /*union()
            {

            }*/
        /*}*/
    }

}

/*!drillImpressions();*/

module handleClamp()
{
    clamp(handle_radius1,handle_radius2,handle_length);
}

module mount()
{
    difference()
    {
        translate([0,0,wall_thickness/2])
        union()
        {
            // Flat bar
            cube([handle_radius2*2*mount_width_factor,mount_width,wall_thickness],center=true);

            // Right screw
            translate([handle_radius2*mount_width_factor,0,0])
            cylinder(d=mount_width,h=wall_thickness,center=true);

            // Left screw
            translate([handle_radius2*mount_width_factor*-1,0,0])
            cylinder(d=mount_width,h=wall_thickness,center=true);

            // Vertical bar
            translate([0,0,mount_width/2])
            cube([handle_radius2*2,wall_thickness,mount_width],center=true);

            // Right prism
            translate([handle_radius2+mount_width,wall_thickness/2*-1,0])
            rotate([0,0,90])
            prism(wall_thickness,mount_width,mount_width);

            // Right prism
            translate([(handle_radius2+mount_width)*-1,wall_thickness/2,0])
            rotate([0,0,270])
            prism(wall_thickness,mount_width,mount_width);
        }

        translate([0,0,wall_thickness])
        union()
        {
            translate([handle_radius2*mount_width_factor,0,0])
            screwHole();

            translate([handle_radius2*mount_width_factor*-1,0,0])
            screwHole();
        }
    }
}

module screwHole()
{
    buffer_length=25;

    translate([0,0,(buffer_length+screw_head)*-1])
    difference()
    {
        union()
        {
            cylinder(r=screw_radius,h=buffer_length);

            translate([0,0,buffer_length])
            cylinder(r1=screw_radius,r2=recess_radius,h=screw_head);

            translate([0,0,buffer_length+screw_head])
            cylinder(r=recess_radius,h=buffer_length);
        }

        union()
        {

        }
    }
}

module prism(x,y,z)
{
    points=[
        [0,0,0], // 0 -- bottom
        [x,0,0], // 1 -- bottom
        [x,y,0], // 2 -- bottom
        [0,y,0], // 3 -- bottom
        [0,y,z], // 4 -- top
        [x,y,z], // 5 -- top
    ];

    faces=[
        [0,1,2,3], // bottom
        [5,4,3,2], // back
        [0,4,5,1], // front
        [0,3,4],   // left side
        [5,2,1],   // right side
    ];

    polyhedron(points=points,faces=faces);
}

module trapezoidal_prism(x1,x2,y,z)
{
    // Build half of the prism that we are going to mirror
    module half(x,y,z,prism_y)
    {
        // Make cube the center of the prism
        cube([x,y,z]);

        // Bookend the cube with front prism
        translate([prism_y*-1,y,0])
        rotate([0,0,270])
        prism(y,prism_y,z);
    }

    long_x=(x1>x2)?x1:x2;
    short_x=(x1<x2)?x1:x2;
    half_x=short_x/2;

    prism_y=(long_x-short_x)/2;

    translate([prism_y,0,0])
    union()
    {
        // front half
        half(half_x,y,z,prism_y);

        // back half
        translate([short_x,0,0])
        mirror([1,0,0])
        half(half_x,y,z,prism_y);
    }
}

module wireHole()
{
    difference()
    {
        // Put the bottom at 0 on the z-axis, but let the extra hang past
        translate([0,0,wire_radius])
        rotate([0,90,0])
        union()
        {
            // Wire one
            translate([0,wire_radius*-1,0])
            cylinder(r=wire_radius,h=10,center=true);

            // Wire two
            translate([0,wire_radius,0])
            cylinder(r=wire_radius,h=10,center=true);

            // Connect the bottom & allow it to stick out past the bottom
            translate([wire_radius,0,0])
            cube([wire_radius*2,wire_radius*4,10],center=true);
        }

        union()
        {

        }
    }
}

bracket();
