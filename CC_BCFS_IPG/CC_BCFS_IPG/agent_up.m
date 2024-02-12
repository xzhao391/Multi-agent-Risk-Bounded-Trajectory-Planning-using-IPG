classdef agent_up
    properties
      args
      solver
      x1
      N
      T
      xx
      U
      g
      X
      obj_func
      P
      mpciter
      radius
    end
    methods
        function obj = agent_up(radius,N,T,x1)
            import casadi.*
            obj.radius = radius;
            obj.xx = {}; % xx contains the history of states
            obj.N=N;
            obj.T = T;
            obj.x1 = x1;
            obj.mpciter = 0;
            
            v_max = 0.6; v_min = -v_max;
            omega_max = pi; omega_min = -omega_max;
            
            n_states = 10;
            n_controls = 4;

            obj.X = SX.sym('X',n_states,(N+1));
            obj.U = SX.sym('U',n_controls,N); % Decision variables (controls)

            obj.P = SX.sym('P',98);
            target = obj.P(11:20);
            agent1_x1 = obj.P(1:5);
            agent2_x1 = obj.P(6:10);
            agent1_x2 = obj.P(21:30);
            p_agent = obj.P(31:50);
            p_obs1 = obj.P(51:70);
            p_obs2 = obj.P(71:90);
            dir_obs1_agent2 = obj.P(91:92); mid_obs1_agent2 = obj.P(93:94);
            dir_obs2_agent2 = obj.P(95:96); mid_obs2_agent2 = obj.P(97:98);

            agent_size = 2;
            obj.obj_func = 0; % Objective function
            
            Q = diag([2 .5 .05 .05 0 2 .5 .05 .05 0]);
            R = diag([0 0 0 0]); % weighing matrices (controls)   

            obj.g = [obj.X(:,1)-obj.P(1:10)]; % initial condition constraints        
            
            for k = 1:N %cost & D
                pos = obj.X(:,k);  con = obj.U(:,k);
                obj.obj_func = obj.obj_func+(pos-target)'*Q*(pos-target) + con'*R*con; % calculate obj
                next_pos = whole_first(pos,con,obj.T);
                obj.g = [obj.g; obj.X(:,k+1)-next_pos]; % compute constraints
                obj.obj_func = obj.obj_func + .1*exp(-con(1));
                d_ij = (obj.X(1,k)-obj.X(6,k))^2 + (obj.X(2,k)-obj.X(7,k))^2;
                obj.obj_func = obj.obj_func + .1*exp(.1*(5*radius^2-d_ij));
            end

            for k = 1:N+1 %collision avoidance constraint
                [con1,con2,con3] =constraint_agent(agent1_x1,agent1_x2,p_agent);
                obj.g = [obj.g; con1;con2;con3];
                [con4,con5,con6] = constraint_obs(agent1_x1,agent1_x2,p_obs1);
                obj.g = [obj.g; con4;con5;con6];
                [con7,con8,con9] = constraint_obs(agent1_x1,agent1_x2,p_obs2);
                obj.g = [obj.g; con7;con8;con9];
                con10 = obs_constraint(agent2_x1,dir_obs1_agent2,mid_obs1_agent2);
                obj.g = [obj.g; con10];
                con11 = obs_constraint(agent2_x1,dir_obs2_agent2,mid_obs2_agent2);
                obj.g = [obj.g; con11];

                if k < N+1
                    con = obj.U(:,k);
                    [agent1_x1,agent1_x2] = high_order(agent1_x1,agent1_x2,con(1:2),T);
                    agent2_x1 = high_order0(agent2_x1,con(3:4),T);
                end
            end

            %make the decision variable one column  vector
            OPT_variables = [reshape(obj.X,10*(obj.N+1),1);reshape(obj.U,4*obj.N,1)];
            
            nlp_prob = struct('f', obj.obj_func, 'x', OPT_variables, 'g', obj.g, 'p', obj.P);
            opts = struct;
            opts.ipopt.max_iter = 2000;
            opts.ipopt.print_level =0;
            opts.print_time = 0;
            opts.ipopt.acceptable_tol =1e-8;
            opts.ipopt.acceptable_obj_change_tol = 1e-6;
            
            obj.solver = nlpsol('solver', 'ipopt', nlp_prob,opts);

            args = struct;
            args.lbg(1:5*agent_size*(N+1)) = 0;  % -1e-20  % Equality constraints
            args.ubg(1:5*agent_size*(N+1)) = 0;  % 1e-20   % Equality constraints
            
            args.lbg(5*agent_size*(N+1)+1 : 5*agent_size*(N+1)+ 11*(N+1)) = -inf; % inequality constraints
            args.ubg(5*agent_size*(N+1)+1 : 5*agent_size*(N+1)+ 11*(N+1)) = 0; % inequality constraints

            args.lbx(1:5:5*agent_size*(N+1),1) = -inf; %state x lower bound
            args.ubx(1:5:5*agent_size*(N+1),1) = inf; %state x upper bound
            args.lbx(2:5:5*agent_size*(N+1),1) = -inf; %state y lower bound
            args.ubx(2:5:5*agent_size*(N+1),1) = inf; %state y upper bound
            args.lbx(3:5:5*agent_size*(N+1),1) = -inf; %state theta lower bound
            args.ubx(3:5:5*agent_size*(N+1),1) = inf; %state theta upper bound
            args.lbx(4:5:5*agent_size*(N+1),1) = -inf;
            args.ubx(4:5:5*agent_size*(N+1),1) = inf;
            args.lbx(5:5:5*agent_size*(N+1),1) = -inf;
            args.ubx(5:5:5*agent_size*(N+1),1) = inf;
            % 
            args.lbx(5*agent_size*(N+1)+1:2:5*agent_size*(N+1)+2*agent_size*N,1) = v_min; %v lower bound
            args.ubx(5*agent_size*(N+1)+1:2:5*agent_size*(N+1)+2*agent_size*N,1) = v_max; %v upper bound
            args.lbx(5*agent_size*(N+1)+2:2:5*agent_size*(N+1)+2*agent_size*N,1) = omega_min; %omega lower bound
            args.ubx(5*agent_size*(N+1)+2:2:5*agent_size*(N+1)+2*agent_size*N,1) = omega_max; %omega upper bound
            obj.args = args;
        end

        function obj = search(obj, other, target)
            p_agent= dir_mid_x1(obj,other,obj.x1);
            p_obs1 = dir_mid_x1(obj,[0;1.5],obj.x1);
            p_obs2 = dir_mid_x1(obj,[0;-1.5],obj.x1);
            [dir_obs1_agent2, mid_obs1_agent2] = dir_mid(obj,[0;1.5],other);
            [dir_obs2_agent2, mid_obs2_agent2] = dir_mid(obj,[0;-1.5],other);
            obj.x1(6:10) = other;
            [x_1_exp,x_2_exp] = whole_expect(obj.x1);
            obj.args.p =[x_1_exp; target; x_2_exp; p_agent; p_obs1; p_obs2;
            dir_obs1_agent2; mid_obs1_agent2; dir_obs2_agent2; mid_obs2_agent2];
            sol = obj.solver('lbx', obj.args.lbx, 'ubx', obj.args.ubx,...
                'lbg', obj.args.lbg, 'ubg', obj.args.ubg,'p',obj.args.p);
            u = reshape(full(sol.x(10*(obj.N+1)+1:end))',4,obj.N); % get controls only from the solution
            obj.x1 = whole_shift(obj.x1, u, obj.T);
            predict_pos = pos_predict(obj.x1,u, obj.T, obj.N);
            obj.mpciter = obj.mpciter+1;
            obj.xx{obj.mpciter} = predict_pos;
        end

        function [dir,mid_point] = dir_mid(obj,other,own)
            relative_position = other(1:2) - own(1:2);
            l = norm(relative_position);   
            cos_t = relative_position(1)/l; sin_t = relative_position(2)/l; 
            dir = [cos_t; sin_t];
            mid_point = (l-obj.radius-1.2)*dir+own(1:2);
        end

        function p = dir_mid_x1(obj,other,own)
            relative_position = other(1:2) - own(1:2);
            l = norm(relative_position)-.02 + .04*rand;
            theta = atan2(relative_position(2),relative_position(1))-.02 + .04*rand;
            r = 1.2-.02 + .04*rand;
            [r,r2,l,l2,l3,l4,c,c2,c3,c4,s,s2,s3,s4,c2s2,c2s,s2c,cs] = sensor_expect(theta,l,r);
            p = [r;r2;l;l2;l3;l4;c;c2;c3;c4;s;s2;s3;s4;c2s2;c2s;s2c;cs;own(1);own(2)];
        end
    end
end 