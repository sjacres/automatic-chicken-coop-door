include <../common.scad>
include <dimensions.scad>

// globals

module bearing(flush = 0)
{
    flush = ("top" == flush) ?
        bearing_depth * -.5 :
            ("bottom" == flush) ?
                bearing_depth * .5 :
                flush;

    translate([0, 0, flush])
    color("silver")
    difference()
    {
        union()
        {
            cylinder(r=bearing_od_radius, h=bearing_depth, center=true);
        }

        union()
        {
            cylinder(r=bearing_id_radius, h=bearing_depth, center=true);
        }
    }
}

module bearing_assembly()
{
    rotate([90, 0, 0])
    difference()
    {
        union()
        {
            // back bearing
            translate([0, 0, tab_depth * -.5])
            bearing("bottom");

            // front bearing
            translate([0, 0, tab_depth * .5])
            bearing("top");

            cylinder(r=bearing_id_radius, h=tab_depth, center=true);
        }

        union()
        {

        }
    }
}

module panel()
{
    translate([0, panel_depth * -.5, 0])
    difference()
    {
        union()
        {
            cube(size=[door_width, panel_depth, door_height], center=true);
        }

        union()
        {

        }
    }
}

module plexi()
{
    translate([0, plexi_depth * -.5, 0])
    difference()
    {
        union()
        {
            cube(size=[door_width, plexi_depth, door_height], center=true);
        }

        union()
        {

        }
    }
}
