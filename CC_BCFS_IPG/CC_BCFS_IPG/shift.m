function out = shift(x0, u, T)
st = x0;
wv = -.01 + .02*rand;
wo = -.01 + .02*rand;
% wv = 0;
% wo = 0;
v=u(1)+wv;
omega=u(2)+wo;
out(1) = st(1)+T*v*cos(st(3));
out(2) = st(2)+T*v*sin(st(3));
out(3) = st(3)+T*omega;
out(4) = cos(st(3));
out(5) = sin(st(3));
end