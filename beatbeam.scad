/*
 *  OpenSCAD BeatBeam Library (www.openscad.org)
 *  Copyright (C) 2009 Timothy Schmidt
 *                     Michael Williams
 *
 *  License: LGPL 2.1 or later
*/

// zBeam(segments) - create a vertical beatbeam strut 'segments' long
// xBeam(segments) - create a horizontal beatbeam strut along the X axis
// yBeam(segments) - create a horizontal beatbeam strut along the Y axis
// topShelf(width, depth, corners) - create a shelf suitable for use in beatbeam structures width and depth in 'segments', corners == 1 notches corners
// bottomShelf(width, depth, corners) - like topShelf, but aligns shelf to underside of beams
// backBoard(width, height, corners) - create a backing board suitable for use in beatbeam structures width and height in 'segments', corners == 1 notches corners
// frontBoard(width, height, corners) - like backBoard, but aligns board to front side of beams
// translateBeam([x, y, z]) - translate beatbeam struts or shelves in X, Y, or Z axes in units 'segments'

include <units.scad>
include <nuts_and_bolts.scad>

$beam_width = mm * 10;
$beam_hole_radius = mm * 2.4;
$beam_is_hollow = 0;
$beam_wall_thickness = mm * 2;
$beam_shelf_thickness = mm * 4;
$hex_size = 4;

module zBeam(segments) {
	difference() {
		cube([$beam_width, $beam_width, $beam_width * segments]);
		for(i = [0 : segments - 1]) {
			translate([$beam_width / 2, $beam_width + 1, $beam_width * i + $beam_width / 2])
			rotate([90,0,0])
			cylinder(r=$beam_hole_radius, h=$beam_width + 2, $fn=50);

			translate([$beam_width / 2, $beam_width + 1, $beam_width * i + $beam_width / 2])
			rotate([90,0,0])
			nutHole(size=$hex_size);

			translate([-1, $beam_width / 2, $beam_width * i + $beam_width / 2])
			rotate([0,90,0])
			cylinder(r=$beam_hole_radius, h=$beam_width + 2, $fn=50);

			translate([-1, $beam_width / 2, $beam_width * i + $beam_width / 2])
			rotate([0,90,0])
			nutHole(size=$hex_size);

		}
	if ($beam_is_hollow == 1) {
		translate([$beam_wall_thickness, $beam_wall_thickness, -1])
		cube([$beam_width - $beam_wall_thickness * 2, $beam_width - $beam_wall_thickness * 2, $beam_width * segments + 2]);
	}
	}
}

module xBeam(segments) {
	translate([0,0,$beam_width])
	rotate([0,90,0])
	zBeam(segments);
}

module yBeam(segments) {
	translate([0,0,$beam_width])
	rotate([-90,0,0])
	zBeam(segments);
}

module translateBeam(v) {
	for (i = [0 : $children - 1]) {
		translate(v * $beam_width) child(i);
	}
}

module topShelf(width, depth, corners) {
	difference() {
        cube([width * $beam_width, depth * $beam_width, $beam_shelf_thickness]);

		if (corners == 1) {
		translate([-1,  -1,  -1])
		cube([$beam_width + 2, $beam_width + 2, $beam_shelf_thickness + 2]);
		translate([-1, (depth - 1) * $beam_width, -1])
		cube([$beam_width + 2, $beam_width + 2, $beam_shelf_thickness + 2]);
		translate([(width - 1) * $beam_width, -1, -1])
		cube([$beam_width + 2, $beam_width + 2, $beam_shelf_thickness + 2]);
		translate([(width - 1) * $beam_width, (depth - 1) * $beam_width, -1])
		cube([$beam_width + 2, $beam_width + 2, $beam_shelf_thickness + 2]);
		}
	}
}

module bottomShelf(width, depth, corners) {
	translate([0,0,-$beam_shelf_thickness])
	topShelf(width, depth, corners);
}

module backBoard(width, height, corners) {
	translate([$beam_width, 0, 0])
	difference() {
		cube([$beam_shelf_thickness, width * $beam_width, height * $beam_width]);

		if (corners == 1) {
		translate([-1,  -1,  -1])
		cube([$beam_shelf_thickness + 2, $beam_width + 2, $beam_width + 2]);
		translate([-1, -1, (height - 1) * $beam_width])
		cube([$beam_shelf_thickness + 2, $beam_width + 2, $beam_width + 2]);
		translate([-1, (width - 1) * $beam_width, -1])
		cube([$beam_shelf_thickness + 2, $beam_width + 2, $beam_width + 2]);
		translate([-1, (width - 1) * $beam_width, (height - 1) * $beam_width])
		cube([$beam_shelf_thickness + 2, $beam_width + 2, $beam_width + 2]);
		}
	}
}

module frontBoard(width, height, corners) {
	translate([-$beam_width - $beam_shelf_thickness, 0, 0])
	backBoard(width, height, corners);
}
