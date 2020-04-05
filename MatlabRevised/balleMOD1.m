function balleMOD1(y1,speed,theta,airFlag,tau)                  %MOD
%% balleMOD1 - Program to compute the trajectory of a baseball  %MOD
%         using the Euler method.                              %MOD
% invoke as: balleMOD1(0,50,45,0,0.5)                           %MOD
% y1 = intial height (meters)                                  %MOD
% speed = intial speed (m/s)                                   %MOD
% theta = initial angle (degrees)                              %MOD
% airFlag specifies whether there is air resistance: enter 1   %MOD
% for yes, 0 for no                                            %MOD
% tau = timestep, tau(seconds)                                 %MOD
% Original by AJG; modified by Sarah Powell 20200404           %MOD
help balleMOD1; % print header                                  %MOD
% clear;  help balle;  % Clear memory and print header         %MOD

%% * Set initial position and velocity of the baseball
%y1 = input('Enter initial height (meters): ');                %MOD
r1 = [0, y1];     % Initial vector position
%speed = input('Enter initial speed (m/s): ');                 %MOD
%theta = input('Enter initial angle (degrees): ');             %MOD
v1 = [speed*cos(theta*pi/180), ...
      speed*sin(theta*pi/180)];     % Initial velocity
r = r1;  v = v1;  % Set initial position and velocity

%% * Set physical parameters (mass, Cd, etc.)
Cd = 0.35;      % Drag coefficient (dimensionless)
area = 4.3e-3;  % Cross-sectional area of projectile (m^2)
grav = 9.81;    % Gravitational acceleration (m/s^2)
mass = 0.145;   % Mass of projectile (kg)
%airFlag = input('Air resistance? (Yes:1, No:0): ');           %MOD
if( airFlag == 0 )
  rho = 0;      % No air resistance
else
  rho = 1.2;    % Density of air (kg/m^3)
end
air_const = -0.5*Cd*rho*area/mass;  % Air resistance constant

%% * Loop until ball hits ground or max steps completed
%tau = input('Enter timestep, tau (sec): ');  % (sec)          %MOD
maxstep = 1000;   % Maximum number of steps
for istep=1:maxstep

  %* Record position (computed and theoretical) for plotting
  xplot(istep) = r(1);   % Record trajectory for plot
  yplot(istep) = r(2);
  t = (istep-1)*tau;     % Current time
  xNoAir(istep) = r1(1) + v1(1)*t;
  yNoAir(istep) = r1(2) + v1(2)*t - 0.5*grav*t^2;
  
  %* Calculate the acceleration of the ball 
  accel = air_const*norm(v)*v;   % Air resistance
  accel(2) = accel(2)-grav;      % Gravity
  
  %* Calculate the new position and velocity using Euler method
  r = r + tau*v;                 % Euler step
  v = v + tau*accel;     
  
  %* If ball reaches ground (y<0), break out of the loop
  if( r(2) < 0 )  
    xplot(istep+1) = r(1);  % Record last values computed
	yplot(istep+1) = r(2);
    break;                  % Break out of the for loop
  end 
end

%% * Print maximum range and time of flight
fprintf('Maximum range is %g meters\n',r(1));
fprintf('Time of flight is %g seconds\n',istep*tau);

%% * Graph the trajectory of the baseball
figure(1); clf;    % Clear figure window #1 and bring it forward
% Mark the location of the ground by a straight line
xground = [0 max(xNoAir)];  yground = [0 0];
% Plot the computed trajectory and parabolic, no-air curve
plot(xplot,yplot,'+',xNoAir,yNoAir,'-',xground,yground,'-');
legend('Euler method','Theory (No air)  ');
xlabel('Range (m)');  ylabel('Height (m)');
title('Projectile motion');