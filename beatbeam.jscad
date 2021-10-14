/*
 *  OpenJsCad BeatBeam Library (http://joostn.github.com/OpenJsCad/)
 *  Copyright (C) 2009 Timothy Schmidt
 *  Copyright (C) 2013 Michael Williams
 *
 *  License: LGPL 2.1 or later
*/

// zBeam(length) - create a vertical beatbeam strut 'length' long
// xBeam(length) - create a horizontal beatbeam strug along the X axis
// yBeam(length) - create a horizontal beatbeam strut along the Y axis
// translateBeam(beam, [x, y, z]) - translate beatbeam struts in X, Y, or Z axes in units 'beam_width'

var cylresolution=16;
var beam_width=10;
var hole_radius=2.4;

// Here we define the user editable parameters: 
function getParameterDefinitions() {
  return [
    {
      name: 'quality', 
      type: 'choice',
      caption: 'Quality',
      values: [0, 1],
      captions: ["Draft","High"], 
      default: 0,
    },    
    { name: 'beam_width', caption: 'spacing between holes', type: 'float', default: 10 },
    { name: 'hole_radius', caption: 'radius of holes', type: 'float', default: 2.4 },
    { name: 'length', caption: 'beam length', type: 'int', default: 10 }
  ];
}


function main(params) {
    cylresolution=(params.quality == "1")? 64:16;
    beam_width=params.beam_width;
    hole_radius=params.hole_radius;
    return xBeam(params.length);
}

function xHole(i) {
    return CSG.cylinder( {
        start: [-1, beam_width/2, i*beam_width + beam_width/2],
        end: [beam_width+1, beam_width/2, i*beam_width + beam_width/2],
        radius: hole_radius,
        resolution: cylresolution
    } );
}

function yHole(i) {
    return CSG.cylinder( {
        start: [beam_width/2, -1, i*beam_width + beam_width/2],
        end: [beam_width/2, beam_width+1, i*beam_width + beam_width/2],
        radius: hole_radius,
        resolution: cylresolution
    } );
}

function zBeam(length) {
    var cube = CSG.cube({
        center: [beam_width/2, beam_width/2, (length*beam_width)/2],
        radius: [beam_width/2, beam_width/2, (length*beam_width)/2]
        });
    var holes = [];
    for (var i = 0; i < length; i++)
    {
        holes.push(xHole(i));
        holes.push(yHole(i)); 
    }
    var beam = cube.subtract(holes);
    return beam;
}

function yBeam(length) {
    return translateBeam(zBeam(length).rotateX(-90), [0,0,1]);
}

function xBeam(length) {
    return translateBeam(zBeam(length).rotateY(90), [0,0,1]);
}

function translateBeam(beam, t_vector) {
    return beam.translate(t_vector.map(function(n) { return beam_width*n; }));
};
