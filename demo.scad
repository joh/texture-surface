include <texture.scad>
include <surface.scad>

/*
 * Some textures
 */

checker = texture_checkerboard(8*4, 8);
checker2 = texture_repeat(checker, 2);
checker10 = texture_repeat(checker, 10);
checker64 = texture_repeat(texture_checkerboard(32, 32), 3);

waves = texture_sine(200, 200, xperiods=15, yperiods=5);
spikes = texture_triangle(200, 200, xperiods=15, yperiods=5);

/*
 * Custom shapes
 */
myellipse = function(u, v, p)
    cylinder_shape(u, v, p, width=100, depth=50);

mycylinder = function(u, v, p)
    cylinder_shape(.5*u, v, p);

mytorus = function(u, v, p)
    torus_shape(u, .5*v, p);

myshape = function(u, v, p)
    let (x=-180+360*u, y=-180+360*v)
    (10+.1*p)*
[
    (4+(sin(4*(x+2*y))+1.25)*cos(x))*cos(y),
    (4+(sin(4*(x+2*y))+1.25)*cos(x))*sin(y),
    ((sin(4*(x+2*y))+1.25)*sin(x))
];

/*
 * Create some textured surfaces
 */
textured_surface(checker, cube_shape);
translate([200, 0, 0])
textured_surface(checker2, cube_shape);
translate([400, 0, 0])
textured_surface(checker10, cube_shape);

translate([0, 200, 0])
textured_surface(waves, cylinder_shape);
translate([200, 200, 0])
textured_surface(3*spikes, cylinder_shape);
translate([400, 200, 25])
textured_surface(checker64, torus_shape, torus=true, v_endpoint=false);

translate([0, 400, 0])
textured_surface(waves, sheet_shape, cap=false, close=false);
translate([200, 400, 0])
textured_surface(5*spikes, vase_shape);
translate([400, 400, 50])
textured_surface(2*checker64, sphere_shape);


// Non-manifold object
translate([0, 575, 0])
textured_surface(2*waves, mycylinder, cap=false, close=false, u_endpoint=true);

translate([200, 600, 0])
textured_surface(3*spikes, myellipse);

translate([400, 600, 51])
textured_surface(3*checker64, egg_shape);
