include <../common.scad>
include <dimensions.scad>
use <stubs.scad>

// globals


module arm_plate(pivot_degrees = 0)
{
    rotate([0, pivot_degrees, 0])
    translate([door_width * .25 - tab_width / 2 - pivot_center_from_edge, 0, door_height * -.5 + pivot_center_from_edge])
    difference()
    {
        union()
        {
            cube(size=[door_width / 2 + tab_width, tab_depth, door_height], center=true);
        }

        union()
        {
            translate([door_width * -.25, 0, tab_height / 2])
            cube(size=[tab_width, tab_depth, door_height - tab_height], center=true);
        }
    }
}

module layout()
{
    %cube(size=[door_width, tab_depth, door_height], center=true);
    difference()
    {
        union()
        {
            translate([door_width * -.25, 0, 0])
            left_arm();

            translate([door_width * .25, 0, 0])
            right_arm();
        }

        union()
        {

        }
    }
}

module left_arm(pivot_degrees = 0)
{
    translate([door_width * -.25 + pivot_center_from_edge, 0, door_height * .5 - pivot_center_from_edge])
    difference()
    {
        union()
        {
            arm_plate(pivot_degrees);
        }

        union()
        {
            bearing_assembly();
        }
    }
}

module right_arm(pivot_degrees = 0)
{
    difference()
    {
        union()
        {
            mirror([1, 0, 0]) {
                left_arm(pivot_degrees);
            }

        }

        union()
        {

        }
    }
}

layout();
