%% Example 1 (Simple Pendulum with Damping)

clear variables
clc

%{
EOM of the System:
    thetaDotDot = -(g/L)*sin(theta) - c*thetaDot
%}

%Constants
    g = 9.81; %Gravity Constant
    c = 0.2; %Damping Ratio
    L = 0.5; %Length of the Pendulum Rod
    tspan = linspace(0,20,500); %Time Span of Integration
    IC = [-30 10]; %Initial Angle (Relative to 270 degrees) and Velocity
    options = odeset('RelTol',1e-6,'AbsTol',1e-6); %Integration Tolerances
    filename = 'Examples\Ex1.gif';
    
%Equation of Motion using State Space
    ex1EOM = @(t,x) [x(2);                       % xDotDot = d/dt(xDot)
                    (-g/L)*sind(x(1)) - c*x(2)]; % xDotDot = EOM
    
%Integrating
    [t,angle] = ode45(ex1EOM, tspan, IC, options);
    
%Plotting using DynamicsGraphingToolbox    
    for i = 1:2:length(t)
        plotSetup(1,'Example 1: Pendulum')
        plotGround(0.9,'down')
        endPoint = plotLine([0.5 0.9],L,angle(i,1)-90);
        plotCircle(endPoint,0.03)
        hold off
        
        %Capturing Image for Gif
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);

        %Writing Gif to File
            if i == 1 %Creates Gif
                imwrite(imind,cm,filename,'gif','Loopcount',inf,...
                        'DelayTime',0.001,'BackgroundColor',0);
            else %Adds new frames onto Gif
                imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.04);
            end
    end
    
%% Example 2 (Simple Pendulum with Damping [Phase Space])

clear variables
clc

%{
EOM of the System:
    thetaDotDot = -(g/L)*sin(theta) - c*thetaDot
%}

%Constants
    g = 9.81; %Gravity Constant
    L = 0.5; %Length of the Pendulum Rod
    c = [0:0.01:1 , 1:-0.01:0];
    tspan = [0 50]; %Time Span of Integration
    IC = [-30 10]; %Initial Angle (Relative to 270 degrees) and Velocity
    options = odeset('RelTol',1e-6,'AbsTol',1e-6); %Integration Tolerances
    filename = 'Examples\Ex2.gif';

    
%Plotting using DynamicsGraphingToolbox    
    for i = 1:length(c)
        %Equation of Motion using State Space
            ex1EOM = @(t,x) [x(2);                       % xDotDot = d/dt(xDot)
                            (-g/L)*sind(x(1)) - c(i)*x(2)]; % xDotDot = EOM
        
        %Integrating
            [t,angle] = ode45(ex1EOM, tspan, IC, options);

        %Plotting
            plot(angle(:,1),angle(:,2),'LineWidth',1.5)
            axis equal
            title('Phase Space of Example 1 as Damping Ratio Changes')
            xlabel('Angular Position (Degrees)')
            xl = xlim;
            xticks(round(xl(1)/5)*5:5:xl(2));
            ylabel('Angular Velocity (Degrees per Second)')
            yl = ylim;
            yticks(round(yl(1)/5)*5:5:yl(2));
            legChar = 'Damping Ratio = '+string(c(i));
            legend(legChar)
            grid on
        
        %Capturing Image for Gif
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);

        %Writing Gif to File
            if i == 1 %Creates Gif
                imwrite(imind,cm,filename,'gif','Loopcount',inf,...
                        'DelayTime',0.001,'BackgroundColor',0);
            else %Adds new frames onto Gif
                imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.001);
            end
    end