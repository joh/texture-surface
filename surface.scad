/*
 * Textured parametric surfaces in OpenSCAD
 *
 * by Johannes H. Jensen <joh@pseudoberries.com>
 * https://github.com/joh/texture-surface
 *
 * Copyright (c) 2022 by Johannes H. Jensen
 * License: MIT, see LICENSE for more details.
 */

/*
 * A parametric cylinder
 */
cylinder_shape = function(u, v, p, width=100, depth=100, height=100)
    [(width/2 + p)*cos(360*u),
     (depth/2 + p)*sin(360*u),
     v * height];

/*
 * A parametric cube
 */
cube_shape = function(u, v, p, width=100, depth=100, height=100)
    let (w = width + 2*p,
         h = depth + 2*p,
         o = u * 2 * (w + h))
    [
    (o < h/2) ? w/2 :
    (o < h/2+w) ? w/2 + h/2  - o :
    (o < (3/2)*h + w) ? -w/2 :
    (o < (3/2)*h + 2*w) ? -(3/2)*h - (3/2)*w + o :
    w/2,

    (o < h/2) ? o :
    (o < h/2+w) ? h/2 :
    (o < (3/2)*h + w) ? h + w - o :
    (o < (3/2)*h + 2*w) ? -h/2:
    o - 2*w - 2*h,

    v * height
    ];

/*
 * A parametric vase
 */
vase_shape = function(u, v, p, width=100, depth=100, height=100)
    [(width/2 + p)*(1+.25*sin(360*v))*cos(360*u),
     (depth/2 + p)*(1+.25*sin(360*v))*sin(360*u),
     v * height];

/*
 * A parametric sheet
 */
sheet_shape = function(u, v, p, width=100, depth=100)
    [width * u - width/2, depth * v - depth/2, p];

/*
 * A parametric sphere
 */
sphere_shape = function(u, v, p, diameter=100)
    let (r = diameter/2 + p)
    [ r * sin(180 * (v+1)) * cos(360 * u),
      r * sin(180 * (v+1)) * sin(360 * u),
      r * cos(180 * (v+1)) ];

/*
 * A parametric torus
 */
torus_shape = function(u, v, p, R=50, r=25)
    let (rr = r + p)
    [(R + rr * cos(-360 * u)) * cos(360 * v),
     (R + rr * cos(-360 * u)) * sin(360 * v),
     rr * sin(-360 * u)];

/*
 * Yamamoto egg
 * http://nyjp07.com/index_egg_E.html
 */
egg_shape = function(u, v, p, a=100, b=70)
    let (
    t=180*v,
    phi=360*u,
    a=(a + p),
    x = -a/2 + (a/2 - (b/4)*(1 - cos(t)))*(1+cos(t)),
    y = (a/2 - (b/4)*(1 - cos(t)))*(sin(t))
    )
    [
    y * cos(phi),
    y * sin(phi),
    -x
    ];

/*
 * Create a textured shape
 *
 * texture: 2D array with N rows and M columns
 *
 * shape: function (u, v, p) where
 *   u is the normalized texture column in the range [0, 1)
 *   v is the normalized texture row in the range [0, 1)
 *   p is the texture value at the (u, v) coordinate
 *
 * close: create a closed shape
 * cap: cap top/bottom of the object
 * torus: enable if the shape is a torus
 * u_endpoint: whether the endpoint of u is 1 (inclusive range)
 * v_endpoint: whether the endpoint of v is 1 (inclusive range)
 */
module textured_surface(texture, shape, close=true, cap=true, torus=false, u_endpoint=false, v_endpoint=true) {
    rows = len(texture);
    cols = len(texture[0]);

    points = [
        for (j=[0:rows-1], i=[0:cols-1])
        let (
            u = i / (cols - (u_endpoint ? 1 : 0)),
            v = j / (rows - (v_endpoint ? 1 : 0)),
            p = texture[rows-j-1][i]
        )
        shape(u, v, p),
    ];

    // faces using those points
    // based on https://gist.github.com/atnbueno/ef8b30d84c3594f97c75d3a793fcc066
    faces = [
        if (cap && !torus)
            // Bottom face
            [for (i=[0:cols-1]) i],

        // point triangles
        for (i = [0:cols-(close?1:2)], j = [0:rows-(torus?1:2)])

            let (i00 = i + cols*j,
                 i01 = (i+1)%cols + cols*j,
                 i10 = i + cols*((j+1)%rows),
                 i11 = (i+1)%cols + cols*((j+1)%rows))

            if (norm(points[i01]-points[i10]) < norm(points[i00]-points[i11]))
                each [[i00, i10, i01],  // lower triangle
                      [i01, i10, i11]] // upper triangle
            else
                // middle edge flipping
                each [[i00, i11, i01],  // lower triangle
                      [i00, i10, i11]], // upper triangle

        if (cap && !torus)
            // Top face
            [for (i=[0:cols-1]) ((rows-1) * cols) + (cols-i-1)],
    ];
    //faces = concat(lower_triangles, upper_triangles);
    polyhedron( points, faces, convexity=10 );
}
