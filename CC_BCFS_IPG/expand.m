syms x_pos y_pos xy l c s c2 s2 c4 s4 r r2 x y l2 c2s2 cs l4 l3 c2s s2c c3 s3 x2 y2
dir_x = l*c;
dir_y = l*s;
mid_x = x_pos+(l-r-.2)*c;
mid_y = y_pos+(l-r-.2)*s;
g = expand((x-mid_x).*dir_x+(y-mid_y).*dir_y);
g2 = expand(g^2);

old = [x^2 y^2 x*y c^4 s^4 c^2*s^2 c^2*s  c^3 s^3 s^2*c c^2 s^2 c*s l^4 l^3 l^2 r^2];
new = [x2 y2 xy c4  s4   c2s2   c2s    c3   s3  s2c   c2  s2  cs l4  l3  l2 r2];

g = subs(g, old, new);
g2 = subs(g2, old, new);



