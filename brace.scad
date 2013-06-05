// brace.scad
// Brace for Garden Furniture Repair
// 
// Copyright (C) 2013 Christopher Roberts
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


// Render objects
clip  = 0;
brace = 0;
demo  = 1;

// Global Parameters
precision             = 100;
tolerance             = 0.3;

// Brace
brace_height          = 7.7;
brace_length          = 115;
brace_width           = 13.65;
brace_thickness       = 1.5;

// Posts
post_outer_diameter   = 11.95 - tolerance;
post_inner_diameter   = 8.0   + tolerance;
post_height           = 20.95;
post_recess_height    = 5;

// Clip
clip_length           = 25.0;
clip_cap_diameter     = 12.5; // 2 types 12.5 and 14.0
clip_cap_thickness    = 2;
clip_inner_diameter   = 7.9 - tolerance; // =~ post_inner_diameter
clip_inner_gap        = 3.5;
clip_gap_length       = 7.0; // 10.2
clip_gap_thickness    = 1.8;
clip_bellend_length   = 5.0;
clip_bellend_diameter = 9.9; // 2mm greater than inner_diameter

module brace() {

    difference() {

        // Things that exist
        union() {
            curved_rectangle( brace_width, brace_length, brace_height );
            translate( v = [brace_width/2, brace_width/2, 0] ) cylinder( r = post_outer_diameter/2, h = post_height, $fn = precision );
            translate( v = [brace_width/2, brace_length - brace_width/2, 0] ) cylinder( r = post_outer_diameter/2, h = post_height, $fn = precision );
        }

        // Things that don't exist
        union() {
            translate( v = [ brace_thickness, brace_thickness + brace_width, brace_thickness - 0.1 ] )
                curved_rectangle( brace_width - brace_thickness * 2, brace_length - brace_thickness *2 - brace_width*2, brace_height - brace_thickness + 0.2 );

            // Posts
            translate( v = [brace_width/2, brace_width/2, -0.1] ) cylinder( r = post_inner_diameter/2, h = post_height + 0.2, $fn = precision );
            translate( v = [brace_width/2, brace_length - brace_width/2, -0.1] ) cylinder( r = post_inner_diameter/2, h = post_height + 0.2, $fn = precision );

            // Recess
            translate( v = [brace_width/2, brace_width/2, -0.1] ) cylinder( r1 = post_outer_diameter/2, r2 = clip_bellend_diameter/2, h = post_recess_height + 0.2, $fn = precision );
            translate( v = [brace_width/2, brace_length - brace_width/2, -0.1] ) cylinder( r1 = post_outer_diameter/2, r2 = clip_bellend_diameter/2, h = post_recess_height + 0.2, $fn = precision );
        }
    
    }

}

module curved_rectangle(w,l,h) {

    translate( v = [0, w/2, 0] )
    union() {

        // Basic shape
        cube( size = [w, l-w, h]);
        translate( v = [w/2, 0, 0] ) cylinder( h = h, r = w/2, $fn = precision );
        translate( v = [w/2, l-w, 0] ) cylinder( h = h, r = w/2, $fn = precision );

    }

}

module clip() {

    difference() {

        // Things that exist
        union() {
            cylinder( r = clip_cap_diameter/2, clip_cap_thickness, $fn = precision);
            cylinder( r = clip_inner_diameter/2, clip_length - clip_bellend_length, $fn = precision);
            translate( v = [0, 0, clip_length - clip_bellend_length] )
                cylinder( r1 = clip_bellend_diameter/2, r2 = clip_inner_gap/2, clip_bellend_length, $fn = precision);
        }

        // Things to be cut out
        union() {
            // Gap between clip
            translate( v = [-clip_inner_gap/2, -clip_cap_diameter/2, clip_gap_length] ) {
                cube( size = [clip_inner_gap, clip_cap_diameter, clip_length] );
            }

            // Remove edges of bellend
            translate( v = [-clip_cap_diameter/2, clip_inner_diameter * 0.45, clip_cap_thickness] ) {
                cube( size = [clip_cap_diameter, (clip_cap_diameter - clip_inner_diameter)/2, clip_length] );
            }
            translate( v = [-clip_cap_diameter/2, -clip_inner_diameter * 0.45 - (clip_cap_diameter - clip_inner_diameter)/2, clip_cap_thickness] ) {
                cube( size = [clip_cap_diameter, (clip_cap_diameter - clip_inner_diameter)/2, clip_length] );
            }

            // Remove top edge of bellend
            translate( v = [-clip_cap_diameter/2, -clip_cap_diameter/2, clip_length - (0.2 * clip_bellend_length)] ) {
                cube( size = [clip_cap_diameter, clip_cap_diameter, 5] );
            }

        }
    }

}

if (clip == 1) {
    clip();
}
if (brace == 1) {
    brace();
}
if (demo == 1) {
    translate( v = [0, brace_length/2, 0]) {
        translate( v = [-clip_length, 0, clip_cap_diameter/2 + (brace_width - clip_cap_diameter)/2] ) rotate( a = [90, 0, 90] ) clip();
        translate( v = [brace_height + post_height, post_outer_diameter/2, brace_width] ) rotate( a = [270, 90, 90] ) brace();
    }
}
