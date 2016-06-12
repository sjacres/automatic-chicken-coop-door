include <../common.scad>
include <dimensions.scad>
include <shapes.scad>
include <community/shapes.scad>

// globals
handle_width=45;
handle_height=18;

length=46.5;
width=20;
height=length/2-handle_height;

depth=16.5;
base=7;

module spacer()
{
    difference()
    {
        union()
        {
            translate([0,0,height/2])
            cube([length,width,height],center=true);

            translate([length/2*-1+base,width/2*-1,height])
            rotate([0,0,90])
            prism(width,base,depth);

            translate([length/2-base,width/2,height])
            rotate([0,0,270])
            prism(width,base,depth);

            %translate([0,0,height+handle_height])
            rotate([90,0,0])
            oval(handle_width/2,handle_height,width,true);
        }

        union()
        {

        }
    }
}

spacer();
