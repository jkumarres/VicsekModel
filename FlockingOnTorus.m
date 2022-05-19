clear
close all

%-----------------------------------------
%        Vicsek model on a torus
%-----------------------------------------

%-------- Control parameters -------------

NumberParticles   = 1000;
InteractionRadius = 1.5;
NoiseStrength     = 1;
SwimmerSpeed      = 3;

DomainWidth       = 10;    
DomainHeight      = 10;   

NumberIterations  = 10000;
dt = 0.01;

%--------- Initial conditions ------------

SwimmerX = DomainWidth * rand(NumberParticles,1);
SwimmerY = DomainHeight * rand(NumberParticles,1);

%----------------------------------------

SwimmerTheta = 2*pi * rand(NumberParticles,1);
TT = zeros(NumberParticles,1);

%----------------------------------------

SwimmerVx = SwimmerSpeed * cos(SwimmerTheta);
SwimmerVy = SwimmerSpeed * sin(SwimmerTheta);

%---------- Visualization ------------

%----- Particle distribution

figure;
subplot(1,2,1);
Q1 = quiver(SwimmerX,SwimmerY,SwimmerVx,SwimmerVy,'b');
hold on;
Q2 = plot(SwimmerX,SwimmerY,'.');

plot([DomainWidth,DomainWidth]',[0,DomainHeight]','-');

axis equal;
axis tight;
xlabel('X');
ylabel('Y');

xlim([0,DomainWidth]);
ylim([0,DomainHeight]);

%------ Histogram of orientation

subplot(1,2,2);
P3 = histogram(SwimmerTheta,20);
title('Histogram of \theta');
xlabel('\theta');

sgtitle('FLOCKING ON A TORUS');

%------------- Main loop --------------------

for it=1:NumberIterations
    
    SwimmerVx = SwimmerSpeed * cos(SwimmerTheta);
    SwimmerVy = SwimmerSpeed * sin(SwimmerTheta);
    
    SwimmerX = SwimmerX + SwimmerVx * dt;
    SwimmerY = SwimmerY + SwimmerVy * dt;
    
    SwimmerX = mod( SwimmerX , DomainWidth );
    SwimmerY = mod( SwimmerY , DomainHeight );
        
    %------ Averaging theta -------
    
    for i=1:NumberParticles
       xx = abs(SwimmerX(:)-SwimmerX(i));
       yy = abs(SwimmerY(:)-SwimmerY(i));
       
       rr = sqrt((min(xx,DomainWidth-xx)).^2+(min(yy,DomainHeight-yy)).^2);
       I = find(rr<InteractionRadius);
       
       dT = mod( SwimmerTheta(I)-SwimmerTheta(i) , 2*pi );
       II = find(dT>pi);
       dT(II) = dT(II) - 2*pi;
       
       TT(i) = sum(dT)/length(I) + NoiseStrength * (0.5-rand(1))*pi/10;
    end
    
    SwimmerTheta = SwimmerTheta + TT(1:NumberParticles);
    
    set(Q1,'XData',SwimmerX,'YData',SwimmerY,'UData',SwimmerVx,'VData',SwimmerVy);
    set(Q2,'XData',SwimmerX,'YData',SwimmerY);
        
    set(P3,'Data',SwimmerTheta);
    
    drawnow;
end