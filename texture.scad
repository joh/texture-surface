/*
 * Textured parametric surfaces in OpenSCAD
 *
 * by Johannes H. Jensen <joh@pseudoberries.com>
 * https://github.com/joh/texture-surface
 *
 * This work is licensed under a Creative Commons Attribution 4.0 International License
 * https://creativecommons.org/licenses/by/4.0/
 */

function texture_checkerboard(cols=10, rows=10) =
    [ for (j=[0:rows-1])
        [ for (i=[0:cols-1]) (i+(j%2))%2 ]
    ];

function texture_sine(cols=100, rows=100, xperiods=10, yperiods=10) =
    [ for (j=[0:rows-1])
        [ for (i=[0:cols-1])
            let (x=i/cols, y=j/rows)
            sin(xperiods*360*x) + cos(yperiods*360*y)
        ]
    ];

function triangle(x, p=1) =
    4/p * abs((((x-p/4)%p)+p)%p - p/2) - 1;

function texture_triangle(cols=100, rows=100, xperiods=10, yperiods=10) =
    let (px=1/xperiods, py=1/yperiods)
    [ for (j=[0:rows-1])
        [ for (i=[0:cols-1])
            let (x=i/cols, y=j/rows)
            triangle(x, px) * triangle(y+py/4, py)
        ]
    ];

/*
 * Repeat values in texture a number of times
 */
function texture_repeat(texture, repeat=2) =
    [ for (j=[0:repeat * len(texture) - 1])
        let (k=floor(j/repeat))
        [ for (i=[0:repeat * len(texture[k]) - 1]) texture[k][floor(i/repeat)] ]
    ];

/*
 * Pad edges of texture with a fixed value
 *
 * pad_width: what edges to pad, either:
 * - a positive integer N to pad all edges with width N
 * - a list [top, bot, left, right] specifying the width to pad for the corresponding edges
 * pad_value: the value to pad with
 */
function texture_pad(texture, pad_width, pad_value=0) =
    let (rows=len(texture), cols=len(texture[0]),
         pad_top = is_list(pad_width) ? pad_width[0] : pad_width,
         pad_bot = is_list(pad_width) ? pad_width[1] : pad_width,
         pad_left = is_list(pad_width) ? pad_width[2] : pad_width,
         pad_right = is_list(pad_width) ? pad_width[3] : pad_width
         )

    [ for (j=[-pad_top:rows-1+pad_bot])
        [ for (i=[-pad_left:cols-1+pad_right])
            (j >= 0 && j < rows && i >= 0 && i < cols) ? texture[j][i] : pad_value
        ]
    ];

