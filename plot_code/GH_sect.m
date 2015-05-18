function [] = GH_sect(Tdir,infile,basename,tt)
%
% plots Salish simulations with a zonal section at 47 N
%
% 3/6/2015  Parker MacCready

[G,S,T]=Z_get_basic_info(infile);

s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);

% define the vector for the section
lon = G.lon_rho; lat = G.lat_rho;

aa = [min(lon(:)) max(lon(:)) min(lat(:)) max(lat(:))];
slon = [min(lon(:)) -124]; slat = [47 47];

cvec = [30 35];

subplot(2,3,[1 4])
%pcolorcen(G.lon_rho,G.lat_rho,s0);
pcolor(G.lon_rho,G.lat_rho,s0); shading interp;
axis(aa); 
caxis(cvec);
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

% make some sections

nn = 100;
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
aa = axis;
axis([aa(1) aa(2) -2000 5]);
shading interp
caxis(cvec);
colorbar('eastoutside')
hold on
%contour(sect.dist/1e3,sect.z,sect.var,[cvec(1):.05:cvec(2)],'-g');
contour(sect.dist/1e3,sect.z,sect.var,[cvec(1):.2:cvec(2)],'-k');
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
aa = axis;
axis([aa(1) aa(2) -2000 5]);
shading interp
vlims = [-.3 .3];
caxis(vlims);
hold on
plot(sect.dist/1e3,sect.z(1,:),'-k','linewidth',2);
title('Cross-section Velocity (m s^{-1})')
colorbar('eastoutside')
xlabel('Distance (km)');
ylabel('Z (m)');







