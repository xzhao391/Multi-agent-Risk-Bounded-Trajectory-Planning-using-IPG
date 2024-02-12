function out = whole_first(st,con,T)
    import casadi.*
    out = SX.sym('X',10);
    out(1:5) = first_order(st(1:5),con(1:2),T);
    out(6:10) = first_order0(st(6:10),con(3:4),T);
end