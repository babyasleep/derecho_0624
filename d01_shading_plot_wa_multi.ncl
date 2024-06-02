 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

function count_radial_wind(TC_U,TC_V,ij_location,dx_dy)
begin
   wspd = wind_speed(TC_U,TC_V)
   dim_TC_U = dimsizes(TC_U)
 
   xx_angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,-32767)
   yy_angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,-32767)
   copy_VarCoords(wspd,xx_angle)
   copy_VarCoords(wspd,yy_angle)
   
    do i_lat = 0, dim_TC_U(0)-1
        do i_lon = 0, dim_TC_U(1)-1
            yy_angle(i_lat,i_lon)=abs(ij_location(0,0)-i_lat)*dx_dy
            xx_angle(i_lat,i_lon)=abs(ij_location(0,1)-i_lon)*dx_dy
        end do
    end do

   yy_angle(:ij_location(0,0),:) = -1.0*yy_angle(:ij_location(0,0),:)
   xx_angle(:,:ij_location(0,1)) = -1.0*xx_angle(:,:ij_location(0,1))

   Angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,"No_FillValue")
   Angle = atan2(yy_angle,xx_angle)
   ;printMinMax(Angle,1)
   Angle = where(Angle.le.0, Angle+2*get_pi("f"),Angle)
   copy_VarCoords(wspd,Angle)
   
   wspd_rad = new((/dim_TC_U(0),dim_TC_U(1)/),float,"No_FillValue")
   wspd_rad = TC_V*sin(Angle)+TC_U*cos(Angle)
   copy_VarCoords(wspd,wspd_rad)
   wspd_rad(ij_location(0,0),ij_location(0,1))=0.0
   return wspd_rad 
end

;function count_radial_wind_test(TC_U,TC_V,ij_location,dx_dy)
;begin
;   wspd = wind_speed(TC_U,TC_V)
;   dim_TC_U = dimsizes(TC_U)
; 
;   xx_angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,-32767)
;   yy_angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,-32767)
;   copy_VarCoords(wspd,xx_angle)
;   copy_VarCoords(wspd,yy_angle)
;   
;    do i_lat = 0, dim_TC_U(0)-1
;        do i_lon = 0, dim_TC_U(1)-1
;            yy_angle(i_lat,i_lon)=abs(ij_location(0,0)-i_lat)*dx_dy
;            xx_angle(i_lat,i_lon)=abs(ij_location(0,1)-i_lon)*dx_dy
;        end do
;    end do
;
;   yy_angle(:ij_location(0,0),:) = -1.0*yy_angle(:ij_location(0,0),:)
;   xx_angle(:,:ij_location(0,1)) = -1.0*xx_angle(:,:ij_location(0,1))
;
;   Angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,"No_FillValue")
;   Angle = atan2(yy_angle,xx_angle)
;   ;printMinMax(Angle,1)
;   Angle = where(Angle.le.0, Angle+2*get_pi("f"),Angle)
;   copy_VarCoords(wspd,Angle)
;   
;   wspd_rad = new((/dim_TC_U(0),dim_TC_U(1)/),float,"No_FillValue")
;   wspd_rad = TC_V*sin(Angle)+TC_U*cos(Angle)
;   copy_VarCoords(wspd,wspd_rad)
;   wspd_rad(ij_location(0,0),ij_location(0,1))=0.0
;   return wspd_rad 
;end

function count_tangential_wind(TC_U,TC_V,ij_location,dx_dy)
begin
   wspd = wind_speed(TC_U,TC_V)
   dim_TC_U = dimsizes(TC_U)
 
   xx_angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,-32767)
   yy_angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,-32767)
   copy_VarCoords(wspd,xx_angle)
   copy_VarCoords(wspd,yy_angle)
   
    do i_lat = 0, dim_TC_U(0)-1
        do i_lon = 0, dim_TC_U(1)-1
            yy_angle(i_lat,i_lon)=abs(ij_location(0,0)-i_lat)*dx_dy
            xx_angle(i_lat,i_lon)=abs(ij_location(0,1)-i_lon)*dx_dy
        end do
    end do

   yy_angle(:ij_location(0,0),:) = -1.0*yy_angle(:ij_location(0,0),:)
   xx_angle(:,:ij_location(0,1)) = -1.0*xx_angle(:,:ij_location(0,1))

   Angle = new((/dim_TC_U(0),dim_TC_U(1)/),float,"No_FillValue")
   Angle = atan2(yy_angle,xx_angle)
   ;printMinMax(Angle,1)
   Angle = where(Angle.le.0, Angle+2*get_pi("f"),Angle)
   copy_VarCoords(wspd,Angle)
   
   wspd_tan = new((/dim_TC_U(0),dim_TC_U(1)/),float,"No_FillValue")
   wspd_tan = TC_V*cos(Angle)-TC_U*sin(Angle)
   copy_VarCoords(wspd,wspd_tan)
   wspd_tan(ij_location(0,0),ij_location(0,1))=wspd(ij_location(0,0),ij_location(0,1))
   return wspd_tan 
end

begin

g_font = 0.025
l_thick = 2
    
 ;----------draw setting---------------------------------------------------------------
gres                  = True                ; polyline mods desired
gres@gsLineThicknessF = 3.0                 ; line thickness
gres@gsLineColor      = "Red"               ; line color 
;---------------marker--------------------------------
polyres                   = True
polyres@gsMarkerIndex     = 16          ; polymarker style
polyres@gsMarkerSizeF     = 0.007          ; polymarker size
polyres@gsMarkerThicknessF     = 10.          ; polymarker size
polyres@gsMarkerColor     = "violet"          ; polymarker size
polyres@gsMarkerOpacityF = 1.0

polyres1 = polyres
polyres1@gsMarkerColor     = "black"          ; polymarker size
;----------draw setting ----------------------------------------------------------------
res                 = True  
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnMaximize      = True       ; fill up the page
res@gsnRightString  = ""                 
res@gsnCenterString = ""
res@tmXTLabelsOn   = False
res@tmXTOn = False
res@tmYRLabelsOn   = False
res@tmYROn = False
; res@gsnCenterStringFontHeightF = g_font  
res@tiMainOn               = False
;res@mpFillOn               = False
;res@mpLandFillColor        = "white"
; res@mpGridSpacingF         = 10.     ;
;res@pmTickMarkDisplayMode = "Always"
;res@cnLevels    = (/ -0.04,-0.03,-0.02,-0.01,0,0.01,0.02,0.03,0.04/)*0.2
res@cnFillPalette        = "temp_diff_18lev"
res@cnFillOn      = True                  
res@cnLinesOn     = False  
res@cnLineLabelsOn = False
res@cnInfoLabelOn  = False
res@tmYLMajorLengthF=0.01
res@tmXBMajorLengthF=0.01
res@tmXBLabelFontHeightF = g_font
res@tmYLLabelFontHeightF = g_font
;res@tmYLTickSpacingF = 5
;res@tmXBTickSpacingF = 5
res@gsnAddCyclic = False  
;res@mpMaxLatF=latN
;res@mpMinLatF=latS
;res@mpMaxLonF=lonE
;res@mpMinLonF=lonW
;res@mpCenterLonF =(res@mpMaxLonF+res@mpMinLonF)/2.0
res@lbLabelBarOn    = False
res@lbLabelsOn = False

resP                     = True         ; modify the panel plot
resP@gsnFrame            = False
resP@gsnMaximize         = False         ; large format
resP@gsnPanelLabelBar    = True         ; add common colorbar
resP@lbLabelFontHeightF  = 0.013
;resP@pmLabelBarParallelPosF = -0.1
resP@pmLabelBarWidthF    = 0.7
resP@gsnPanelYWhiteSpacePercent  = 3.5
resP@gsnPanelXWhiteSpacePercent  = 3.5
;resP@gsnPanelMainString  = "TA SST ("+season+")"
resP@gsnPanelMainFontHeightF = 0.025
resP@gsnPanelTop        = 0.9    ; only panel on lower half of page
resP@gsnPanelXF         = (/0.05,0.52/)
resP@pmLabelBarWidthF   = 0.8    ; label bar width
;resP@gsnPanelBottom     = 0.25    ; space for label bar
;resP@gsnPanelTop        = 1.0    ; only panel on lower half of page
;resP@gsnPanelLeft        = 0.085

resv                 = True  
resv@gsnDraw         = False
resv@gsnFrame        = False
resv@gsnRightString  = ""                 
resv@gsnLeftString  = ""                 
resv@gsnCenterString = ""
resv@vcLineArrowColor        = "black"           ; change vector color
resv@vcLineArrowThicknessF   = 1.5               ; change vector thickness
resv@vcVectorDrawOrder       = "Draw";"PostDraw"        ; draw vectors last
resv@vcMinDistanceF          = 0.1 ;0.01 ;0.03
resv@vcMinMagnitudeF         = 0.3
;resv@vcFillArrowHeadInteriorXF = 0.25
;resv@vcFillArrowHeadXF         = 0.6
;resv@vcFillArrowHeadYF         = 0.2
;resv@vcFillArrowWidthF         = 0.1

;--------Set reference arrow--------
refmag = 5 
resv@vcRefAnnoOn = True
resv@vcRefMagnitudeF           = refmag             ; define vect
resv@vcRefLengthF              = 0.045           ; define length 
resv@vcRefAnnoSide             ="top"
resv@vcRefAnnoOrthogonalPosF   = -0.48            ; move ref vect
resv@vcRefAnnoArrowLineColor   = "black"         ; change ref vec
resv@vcRefAnnoArrowUseVecColor = False           ; don't use vec 
resv@vcRefAnnoString1On        = True
resv@vcRefAnnoString2On        = False
resv@vcRefAnnoFontHeightF      = 0.015
resv@vcRefAnnoPerimOn = False
resv@vcRefAnnoString1 = refmag+" m/s"
resv@vcRefAnnoOrthogonalPosF = -1.25
resv@vcRefAnnoParallelPosF = 1.05


case_name = "em_tropical_cyclone"
;path ="/glade/work/cjiaxin/test_wrf/idealize/longer-full-ideal/test/em_tropical_cyclone/draw/test_data/wrfout_d01_0001-01-*"
;path ="/glade/work/cjiaxin/test_wrf/idealize/longer-full-ideal/test/em_tropical_cyclone/wrfout_d01_0001-01-*"
files = systemfunc("ls "+case_name+"/wrfout_d01_0001-01-01_1[0-9]:00:00")

a = addfiles(files,"r")
it   = -1
wa_in  = wrf_user_getvar(a,"wa",it)   ; sea level pressure
ua_in  = wrf_user_getvar(a,"ua",it)   ; sea level pressure
va_in  = wrf_user_getvar(a,"va",it)   ; sea level pressure
msl_in  = wrf_user_getvar(a,"slp",it)   ; sea level pressure
p_in = wrf_user_getvar(a,"pressure",it)
times = wrf_user_list_times(a)

outfile =case_name+"/draw/figure/test_"

interval = 1
initial_center = 4
start_point  = 249-initial_center
end_point = 249+initial_center
dx_dy = 18
ij_location = new((/2,2/),integer)
ij_location(0,0) = initial_center
ij_location(0,1) = initial_center

        wa_in_plot :=wa_in(::interval,:,start_point:end_point,start_point:end_point)
        ua_in_plot :=ua_in(::interval,:,start_point:end_point,start_point:end_point)
	va_in_plot :=va_in(::interval,:,start_point:end_point,start_point:end_point)
	p_in_plot :=p_in(::interval,:,start_point:end_point,start_point:end_point)
	msl_in_plot :=msl_in(::interval,start_point:end_point,start_point:end_point)
        times_plot :=times(::interval)


;lat_in = wrf_user_getvar(a,"XLAT",it)
;lon_in = wrf_user_getvar(a,"XLONG",it)
;lat=lat_in(0,:,:)
;lon=lon_in(0,:,:)
;printVarSummary(lat)
dim= dimsizes(times_plot)
lat_location = new(dim,float)
lon_location = new(dim,float)
plot = new(dim,"graphic")
plot1 = new(dim,"graphic")
plot2 = new(dim,"graphic")
plot3 = new(dim,"graphic")
dum1 = new(dim,"graphic")
dum2 = new(dim,"graphic")

level_string=(/975,950,925,900,875,850/)
ua_plot = wrf_user_interp_level(ua_in_plot,p_in_plot,level_string,False)
va_plot = wrf_user_interp_level(va_in_plot,p_in_plot,level_string,False)
wa_plot = wrf_user_interp_level(wa_in_plot,p_in_plot,level_string,False)
printVarSummary(ua_plot)


;do i_level=0,0,1
do i_level=0,dimsizes(level_string)-1,1
wks1 = gsn_open_wks("pdf",outfile+"_tangential_wind_"+level_string(i_level)) 
wks2 = gsn_open_wks("pdf",outfile+"_radial_wind_"+level_string(i_level)) 
wks3 = gsn_open_wks("pdf",outfile+"_ua_"+level_string(i_level)) 
wks4 = gsn_open_wks("pdf",outfile+"_va_"+level_string(i_level)) 
gsn_define_colormap(wks1,"temp_diff_18lev")
gsn_define_colormap(wks2,"temp_diff_18lev")
gsn_define_colormap(wks3,"temp_diff_18lev")
gsn_define_colormap(wks4,"temp_diff_18lev")


;do i_time=1,1,1
do i_time=0,dim-1,1
    TC_area = msl_in_plot(i_time,:,:)
    ij= ind_resolve(minind(ndtooned(TC_area(:,:))),dimsizes(TC_area))
    ;print(ij)
    
    wa = wa_in_plot(i_time,i_level,:,:)
    va = va_in_plot(i_time,i_level,:,:)
    ua = ua_in_plot(i_time,i_level,:,:)

;test ua

  ; 计算格点中心坐标
  ni=2*initial_center+1
  nj=2*initial_center+1

  lat = fspan(0, ni-1, ni)
  lon = fspan(0, nj-1, nj)

  ;lat_new = 0.5 * (lat(0:ni-1) + lat(1:ni))
  ;lon_new = 0.5 * (lon(0:nj-1) + lon(1:nj))
  lat_new = 0.5 * (lat(0:ni-2) + lat(1:ni-1))
  lon_new = 0.5 * (lon(0:nj-2) + lon(1:nj-1))
  ;printVarSummary(ua)
  ;printVarSummary(lon)
  ;printVarSummary(lon_new)
  ;exit

  ;; 将lat_new和lon_new组合成目标点坐标数组
  ;newPoints = new((/dimsizes(lat_new) * dimsizes(lon_new), 2/), "float")
  ;newPoints(:,0) = lat_new(::1)
  ;newPoints(:,1) = lon_new(::1)

  ; 使用linint2_points进行插值
  ua_interpolated = linint2(lon, lat, ua(:,:), False, lon_new, lat_new, 0)
  va_interpolated = linint2(lon, lat, va(:,:), False, lon_new, lat_new, 0)
  ;ua_interpolated = area_conserve_remap_Wrap(lon,lat,ua, lon_new,lat_new, False)
  ;va_interpolated = area_conserve_remap_Wrap(lon,lat,va, lon_new,lat_new, False)
  printVarSummary(ua_interpolated)
  printVarSummary(va_interpolated)
  printVarSummary(ua_interpolated(:3,:))
  printMinMax(ua_interpolated,0)
  printMinMax(va_interpolated,0)

    ;radial_wind = count_radial_wind(ua,va,ij_location,dx_dy)
    radial_wind = count_radial_wind(ua_interpolated,va_interpolated,ij_location,dx_dy)

;print(ua_interpolated)

;;------------output txt--------------------------------
;opt_u = True
;opt_u@fout = "ua_re.txt"
;opt_v = True
;opt_v@fout = "va_re.txt"
;opt_r = True
;opt_r@fout = "ra_re.txt"
;total_num = 2*initial_center
;total_num_origin = 2*initial_center+1
;format= total_num+"f7.2"
;format_origin= total_num_origin+"f7.2"
;ot_u = True
;ot_u@fout = "origin_ua_re.txt"
;ot_v = True
;ot_v@fout = "origin_va_re.txt"
;
;write_matrix( ua(::-1,:), format_origin,ot_u)
;write_matrix( va(::-1,:), format_origin,ot_v)
;write_matrix( ua_interpolated(::-1,:), format,opt_u)
;write_matrix( va_interpolated(::-1,:), format,opt_v)
;write_matrix( radial_wind(::-1,:), format,opt_r)
;write_matrix("va.txt", va_interpolated(), format="%4d", sep=" ")
;write_matrix("radial.txt", radial_wind, format="%4d", sep=" ")


;test_lat = 50
;test_lon = 49
;
;    ;print(ua(test_lat,test_lon))
;    ;print(va(test_lat,test_lon))
;    ;print(radial_wind(test_lat,test_lon))
;             print(ua(48:50,48:50))
;             print(va(48:50,48:50))
;    print(radial_wind(48:50,48:50))
    ;exit    

    printMinMax(wa,0)
    printMinMax(radial_wind,0)

;   start ploting slp 
    tangential_wind = count_tangential_wind(ua,va,ij_location,dx_dy)
    res@cnFillColors :=(/2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18/)
    res@gsnLeftString   = times_plot(i_time)   
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnMinLevelValF        = -2.    ; set min contour level          
    res@cnLevelSpacingF       =  2.    ; set contour interval           
    res@cnMaxLevelValF        = 16.         
    plot(i_time) = gsn_csm_contour(wks1,tangential_wind,res)
    test_location = 40
   ;plot@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks1,plot(i_time),test_lon-10,test_lat+10,polyres)
;998.5  
;1.0    
;1012.5 

;   start ploting mdbz 
    res@gsnLeftString   = times_plot(i_time)   
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnMinLevelValF        = -2.8    ; set min contour level          
    res@cnLevelSpacingF       = 0.4    ; set contour interval           
    res@cnMaxLevelValF        = 2.8      ; set max contour level                
    plot1(i_time) = gsn_csm_contour(wks2,radial_wind,res)
    ;plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks2,plot1(i_time),initial_center,initial_center,polyres1)
    ;plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks2,plot1(i_time),lon_location(i_time),lat_location(i_time),polyres)
    ;dum1(i_time)=gsn_add_polyline (wks2, plot1(i_time), (/0,100/),(/50,50/), gres)
    ;dum2(i_time)=gsn_add_polyline (wks2, plot1(i_time), (/50,50/),(/0,100/), gres)

;   start ploting slp 
    res@cnFillColors :=(/2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18/)
    res@gsnLeftString   = times_plot(i_time)   
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnMinLevelValF        = -14    ; set min contour level          
    res@cnLevelSpacingF       = 2    ; set contour interval           
    res@cnMaxLevelValF        = -1.0*res@cnMinLevelValF      ; set max contour level                
    plot2(i_time) = gsn_csm_contour(wks3,ua_interpolated,res)

;   start ploting slp 
    res@cnFillColors :=(/2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18/)
    res@gsnLeftString   = times_plot(i_time)   
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnMinLevelValF        = 14    ; set min contour level          
    res@cnLevelSpacingF       = 2    ; set contour interval           
    res@cnMaxLevelValF        = -1.0*res@cnMinLevelValF      ; set max contour level                
    plot3(i_time) = gsn_csm_contour(wks4,va_interpolated,res)


end do

print("starting panel")
resP@gsnPanelMainString  = "vertical motion (m/s)*100"
grid_number = 5
x_grid = grid_number
y_grid = grid_number
gsn_panel(wks1, plot, (/x_grid,y_grid/), resP)
frame(wks1)

resP@gsnPanelMainString  = "radial windspeed (m/s)"
gsn_panel(wks2, plot1, (/x_grid,y_grid/), resP)
frame(wks2)

resP@gsnPanelMainString  = "v windspeed (m/s)"
gsn_panel(wks4, plot3, (/x_grid,y_grid/), resP)
frame(wks4)

resP@gsnPanelMainString  = "u (m/s)"
gsn_panel(wks3, plot2, (/x_grid,y_grid/), resP)
frame(wks3)


end do
print("End drawing")
end
  
