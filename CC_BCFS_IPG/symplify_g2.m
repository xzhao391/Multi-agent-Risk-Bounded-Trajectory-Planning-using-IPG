syms xy l c s c2 s2 c4 s4 r r2 x y l2 c2s2 cs l4 l3 c2s s2c c3 s3 x2 y2

g2 =  (2*c2*l2*x)/5 + (2*c3*l2*x)/5 + c2*l2*x2 - c3*l3*x + 2*cs*l2*xy ...
    + (2*c2s*l2*y)/5 - c2s*l3*y + (2*cs*l2*y)/5 + (2*l2*s2c*x)/5 - l3*s2c*x ...
    + (2*l2*s3*y)/5 + l2*s2*y2 - l3*s3*y;
g2_x = (2*c2*l2)/5 + (2*c3*l2)/5 - c3*l3 + (2*l2*s2c)/5 - l3*s2c;
g2_y = (2*c2s*l2)/5 -c2s*l3 + (2*cs*l2)/5 + (2*l2*s3)/5 - l3*s3;
g2_xy = 2*cs*l2;
g2_x2 = c2*l2;
g2_y2 = l2*s2;