include <../common.scad>
include <dimensions.scad>

// globals

// The edge of the device
edge_radius=collar_radius/3;

module bit()
{
    difference()
    {
        union()
        {
            cylinder(r=bit_radius, h=bit_depth, $fn=6);
        }

        union()
        {

        }
    }
}

module chuckImpression()
{
    translate([0, 0, -.01])
    difference()
    {
        union()
        {
            cylinder(r=chuck_radius, h=chuck_length);
        }

        union()
        {
            // Make sure that the bit sicks out the top, so scale it up a little
            translate([0, 0, chuck_length-bit_depth+5])
            resize([0, 0, bit_depth+5])
            bit();
        }
    }
}

module logo()
{
    //import("../../docs/images/icon.png", convexity=3);
    //surface(file="../../docs/images/icon.png", center=true, convexity=5);
    surface(file="../../docs/images/icon.png", center=true, invert=true, convexity=3);
}

module roundedCorner(corner_radius)
{
    translate([corner_radius*-1, corner_radius*-1, 0])
    difference()
    {
        union()
        {
            square(corner_radius);
        }

        union()
        {
            circle(corner_radius);
        }
    }
}

module spool()
{
    difference()
    {
        union()
        {
            rotate_extrude()
            difference()
            {
                union()
                {
                    //%square([spool_radius, spool_length]);
                    hull()
                    {
                        translate([0, 0, 0])
                        square(edge_radius);

                        translate([0,spool_length-edge_radius, 0])
                        square(edge_radius);

                        translate([spool_radius-edge_radius, edge_radius,0])
                        circle(edge_radius);

                        translate([spool_radius-edge_radius, spool_length-edge_radius, 0])
                        circle(edge_radius);
                    }
                }

                translate([spool_radius, spool_lip_height, 0])
                roundedCorner(edge_radius);

                translate([spool_radius, spool_length-spool_lip_height, 0])
                rotate(270)
                roundedCorner(edge_radius);

                union()
                {
                    translate([spool_radius*.66, spool_lip_height,0])
                    hull()
                    {
                        translate([collar_radius, collar_radius,0])
                        circle(collar_radius);

                        translate([collar_radius, collar_height,0])
                        circle(collar_radius);

                        translate([collar_height, collar_radius,0])
                        circle(collar_radius);

                        translate([collar_height, collar_height,0])
                        circle(collar_radius);
                    }

                }
            }
        }

        #union()
        {
            translate([0, 0, spool_length+6])
            resize([spool_radius, spool_radius, spool_lip_height])
            surface(file="../../docs/images/icon.png", center=true, invert=true, convexity=3);
        }
    }
}

module stringHole()
{
    difference()
    {
        union()
        {
            cylinder(r=string_radius, h=spool_lip_height+collar_radius*2);
            translate([0, 0, (spool_lip_height+collar_radius)-(spool_lip_height/2)])
            union()
            {
                sphere(knot_radius);
                cylinder(r=knot_radius, h=spool_lip_height/2+collar_radius);
            }
            /*translate([0,spool_lip_height,0])
            rotate([90,0,0])
            cylinder(r=string_radius,h=spool_lip_height*2);*/
        }

        union()
        {

        }
    }
}

/*stringHole();*/

module pulley()
{
    difference()
    {
        union()
        {
            spool();
        }

        #union()
        {
            chuckImpression();
        }

        //translate([spool_radius*.66+string_radius,0, spool_length-spool_lip_height-collar_radius])
        #translate([spool_radius*.66+string_radius, 0, spool_lip_height+collar_radius])
        rotate([180, 0, 0])
        union()
        {
            stringHole();
        }
    }
}

pulley();

/*import("/Users/jimmy.puckett/Dropbox/SJ/Logo/icon.dxf", convexity=3);*/
/*linear_extrude(height = 10, center = true, convexity = 10)
import(file = "/Users/jimmy.puckett/Dropbox/SJ/Logo/icon.dxf");*/
