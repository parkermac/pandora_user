function [] = jdf_canyon_thal(Tdir,infile,basename,tt)
%
% plots Salish simulations with a section across a sill
% in JdF canyon
%
% 6/22/2012  Parker MacCready

[G,S,T]=Z_get_basic_info(infile);

s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);

% define the vector for the section
%slon = [-125.5 -125.2]; slat = [48 48]; % lower canyon
%slon = [-125.3 -125.17]; slat = [48.2 48.06]; % mid canyon
% cross channel
slon = [-125.3949 -125.3001]; slat = [48.0521 48.0028];
% along channel
%slon = [-125.3620 -125.2514]; slat = [48.0079 48.1178];

scvec = [29 31.5];

cvec = [31.5 34];

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
plot(slon,slat,'-m','linewidth',3)
plot(slon,slat,'-k','linewidth',1)
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
[sect] = Z_make_sect(infile,sect_lon,sect_lat,'salt');
subplot(2,3,[2 3])
pcolor(sect.dist/1e3,sect.z,sect.var);
shading interp
caxis(cvec);
colorbar('eastoutside')
hold on
contour(sect.dist/1e3,sect.z,sect.var,[1:.1:38],'-k');
plot(sect.dist/1e3,sect.z(1,:),'-k','linewidth',2);
title('Salinity section')
ylabel('Z (m)');

% Velocity Section
[sect] = Z_make_sect(infile,sect_lon,sect_lat,'uv');
% get the normal velocity
ca = cos(sect.ang_rad); sa = sin(sect.ang_rad);
us = ca.*real(sect.var) + sa.*imag(sect.var);
un = ca.*imag(sect.var) - sa.*real(sect.var);
%
subplot(2,3,[5 6])
pcolor(sect.dist/1e3,sect.z,un);
shading interp
vlims = [-.25 .25];
caxis(vlims);
hold on
plot(sect.dist/1e3,sect.z(1,:),'-k','linewidth',2);
title('Velocity: Positive into Canyon (m s^{-1})')
colorbar('eastoutside')
xlabel('Distance from West (km)');
ylabel('Z (m)');







