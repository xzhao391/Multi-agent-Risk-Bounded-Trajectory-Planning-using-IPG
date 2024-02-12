function predict_pos = pos_predict(x1,u,T,N)
    predict_pos = zeros(2,N);
    predict_pos(1:2,1) = x1(1:2);
    for i = 2:N
        v=u(1,i);
        omega=u(2,i);
        x1(1) = x1(1)+T*v*cos(x1(3));
        x1(2) = x1(2)+T*v*sin(x1(3));
        x1(3) = x1(3)+T*omega;
        predict_pos(1:2,i) = x1(1:2);
    end
end