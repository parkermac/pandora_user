function [] = jdf_canyon_thal(Tdir,infile,basename,tt)
%
% plots Salish simulations with a section on the thalweg
% in JdF canyon
%
% 6/26/2012  Parker MacCready

[G,S,T]=Z_get_basic_info(infile);

s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);

% define the vector for the section
%slon = [-125.5 -125.2]; slat = [48 48]; % lower canyon
%slon = [-125.3 -125.17]; slat = [48.2 48.06]; % mid canyon
% cross channel
%slon = [-125.3949 -125.3001]; slat = [48.0521 48.0028];
% along channel

A1 to A2
slon = [-(125 + 21.192/60), -(125 + 15.57/60)];
slat = [48 + 1.62/60, 48 + 5.97/60];


scvec = [29 31.5]; % surface salinity
cvec = [31.5 34]; % section salinity
vvec = [-.5 .5]; % velocity color limits

subplot(2,3,[1 4])
Z_pcolorcen(G.lon_rho,G.lat_rho,s0);
%pcolor(G.lon_rho,G.lat_rho,s0); shading flat;
caxis(scvec);
title('Surface Salinity','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
[xt,yt]=Z_lab('lr');
% add file info
Z_info(basename,tt,T,'ll');
% add coastline
Z_addcoast('combined',Tdir.coast);
Z_dar;
% add the section line
hold on
plot(slon,slat,'-w','linewidth',3)
hold on
contour(G.lon_rho,G.lat_rho,G.h,[50:50:500],'-k');
axis([-126 -124 47 49]);
Z_info(basename,tt,T,'ll')

% make some sections

nn = 50;
sect_lon = [];
sect_lat = [];
for ii = 1:length(slon)-1
    sect_lon = [sect_lon linspace(slon(ii),slon(ii+1),nn)];
    sect_lat = [sect_lat linspace(slat(ii),slat(ii+1),nn)];
end

% Salinity Section
[salt_sect] = Z_make_sect(infile,sect_lon,sect_lat,'salt');
% Velocity Section
[vel_sect] = Z_make_sect(infile,sect_lon,sect_lat,'uv');
% get the normal velocity
ca = cos(vel_sect.ang_rad); sa = sin(vel_sect.ang_rad);
us = ca.*real(vel_sect.var) + sa.*imag(vel_sect.var);
un = ca.*imag(vel_sect.var) - sa.*real(vel_sect.var);

subplot(2,3,[2 3])

pcolor(vel_sect.dist/1e3,vel_sect.z,us);
shading interp
caxis(vvec);
colorbar('eastoutside')
hold on
contour(salt_sect.dist/1e3,salt_sect.z,salt_sect.var,[1:.1:38],'-k');
plot(salt_sect.dist/1e3,salt_sect.z(1,:),'-k','linewidth',2);
title('Velocity: Positive into Canyon (m s^{-1})')
ylabel('Z (m)');

%
subplot(2,3,[5 6])

pcolor(vel_sect.dist/1e3,vel_sect.z,un);
shading interp
caxis(vvec);
colorbar('eastoutside')
hold on
contour(salt_sect.dist/1e3,salt_sect.z,salt_sect.var,[1:.1:38],'-k');
plot(salt_sect.dist/1e3,salt_sect.z(1,:),'-k','linewidth',2);
title('Velocity: Positive to NW (m s^{-1})')
ylabel('Z (m)');
xlabel('Distance from West (km)');







