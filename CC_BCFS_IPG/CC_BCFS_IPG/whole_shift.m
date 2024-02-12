function out = whole_shift(x1,u,T)
    out(1:5,1) = shift(x1(1:5),u(1:2,1),T);
    out(6:10,1) = shift(x1(6:10),u(3:4,1),T);
end