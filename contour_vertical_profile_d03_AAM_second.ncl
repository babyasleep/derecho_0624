function count_Radii(TC_area,ij_location,dx_dy)
begin
    dim = dimsizes(TC_area)
    Radii = new((/dim(0),dim(1)/),float,-32767)
    copy_VarCoords(TC_area,Radii)

    do i_lat = 0, dim(0)-1
        do i_lon = 0, dim(1)-1
            Radii(i_lat,i_lon)=sqrt((ij_location(0,0)-i_lat)^2+(ij_location(0,1)-i_lon)^2)*dx_dy
        end do
    end do
    return Radii
end 

function  count_symmetric_wind_profile_3d(Radii,wspd_tan,average_range,ij_location,profile_range)
begin
    dim = dimsizes(wspd_tan)
    wspd_tan_ave = new((/dim(0),dim(1),dim(2)/),float,-99999)
    copy_VarCoords(wspd_tan,wspd_tan_ave)
   
    do i_level=0,dim(0)-1,1 
	;print_clock(i_level)
    	do i_lat = ij_location(0,0),ij_location(0,0),1
    	    do i_lon = ij_location(0,1),ij_location(0,1)+profile_range,1
    	        wspd_tan_tmp = wspd_tan(i_level,:,:)
		wspd_tan_tmp@_FillValue = -99999
    	        wspd_tan_tmp = where(Radii.ge.Radii(i_lat,i_lon)-average_range.and.Radii.le.Radii(i_lat,i_lon)+average_range, wspd_tan_tmp,wspd_tan_tmp@_FillValue)
    	        ;print(num(.not.ismissing(wspd_tmp)))
    	        wspd_tan_ave(i_level,i_lat,i_lon)=avg(wspd_tan_tmp)
    	        delete(wspd_tan_tmp)
    	    end do
    	end do
    end do
    
    return wspd_tan_ave
end

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
   return wspd_tan 
end

function count_angle(TC_U,TC_V,ij_location,dx_dy)
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
  
   return Angle 
end

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
   return wspd_rad 
end


begin
ij_location = new((/2,2/),integer)

num_figure = 16
plot = new(num_figure,"graphic")

title = (/"99hr","143hr"/)
;i_time_list = (/"05_03"/)
;i_time_plus_list = (/"05_04"/)
i_time_list = (/"05_03","06_23"/)
i_time_plus_list = (/"05_04","07_00"/)
;i_time_list = (/"01_01","04_02","01_03","01_18","01_12","01_07"/)
;i_time_list = (/"01_00", "01_01", "01_02", "01_03", "01_04", "01_05", "01_06", "01_07", "01_08", "01_09"/)

domain_name = "d03"
domain_timestep = 3600


case_name = "em_tropical_cyclone"
;do i_time_iterator= 0,0,1
do i_time_iterator= 0,dimsizes(i_time_list)-1,1
i_time = i_time_list(i_time_iterator)
wks = gsn_open_wks("pdf",case_name+"/draw/figure/paper_contour_"+domain_name+"_AAM_vertical_profile_"+title(i_time_iterator))
path = case_name+"/wrfout_"+domain_name+"_0001-01-"+i_time+":00:00"
a = addfile(path,"r")
it   = -1
slp_in  = wrf_user_getvar(a,"slp",it)   ; sea level pressure
dbz_in = wrf_user_getvar(a,"dbz",it)
ua_in = wrf_user_getvar(a,"ua",it)
va_in = wrf_user_getvar(a,"va",it)
wa_in = wrf_user_getvar(a,"wa",it)
p_in = wrf_user_getvar(a,"pressure",it)
z_in = wrf_user_getvar(a,"z",it) ;unit:m

mdbz = wrf_user_getvar(a,"mdbz",it)
uvmet10_in = wrf_user_getvar(a,"uvmet10",it)
printVarSummary(uvmet10_in)
umet10_in = uvmet10_in(0,0,:,:)
vmet10_in = uvmet10_in(1,0,:,:)
windspeed_in = wind_speed(ua_in,va_in)


;;;========需要改中心位置====================
;slp_mask = where(mdbz.gt. 0.0, slp_in@_FillValue, slp_in)
;printVarSummary(slp_mask)
;ij_location= ind_resolve(minind(ndtooned(slp_mask(0,:,:))),dimsizes(slp_mask(0,:,:)))
;
;ij_location(0,0) = 250
;ij_location(0,1) = 250
;times = wrf_user_list_times(a)
;delete(mdbz)
;
;profile_range = 50
;average_range = 10
;dx_dy = 18
initial_center = 25
start_point  = 249-initial_center
end_point = 249+initial_center
umet10_in_count :=umet10_in(start_point:end_point,start_point:end_point)
vmet10_in_count :=vmet10_in(start_point:end_point,start_point:end_point)
uvmet10_in_count = wind_speed(umet10_in_count,vmet10_in_count)
mdbz_in_count :=mdbz(0,start_point:end_point,start_point:end_point)
TC_area = where(mdbz_in_count.gt. 0.0, uvmet10_in_count@_FillValue, uvmet10_in_count)
dims = dimsizes(TC_area(:,:)) 
ij= ind_resolve(minind(ndtooned(TC_area(:,:))),dims(0:1))
;lat_location(i_time) = ij(0,0)+start_point
;lon_location(i_time) = ij(0,1)+start_point

ij_location(0,0) = ij(0,0)+start_point
ij_location(0,1) = ij(0,1)+start_point
times = wrf_user_list_times(a)

profile_range = 100
average_range = 1
dx_dy = 2
;;;========需要改上面的这些参数=============
Radii = count_Radii(p_in(0,0,:,:),ij_location,dx_dy)

;level_string=(/150,200,300,500,700,800,825,850,875,900,925,975,1000/)
level_string=ispan(1000,100,10)
p = p_in(0,:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)


res                 = True  
res@gsnLeftString	  = title(i_time_iterator)
res@gsnDraw         = False
res@gsnFrame        = False
res@tmXBOn		  = True
res@trYLog		  = True
res@tmXBMode		  = "Explicit"
res@tmXBValues		  = ispan(0,profile_range,25)
res@tmXBLabels		  = res@tmXBValues*dx_dy
res@pmLabelBarOrthogonalPosF = -0.05
res@cnFillPalette        = "temp_19lev"
res@tmYRTickSpacingF = 1.0 
res@trYLog = False
res@vcRefAnnoOn = False
res@vcRefMagnitudeF = 2.0                ; define vector ref mag
res@vcRefLengthF    = 0.025              ; define length of vec ref
res@vcGlyphStyle    = "LineArrow"      ; turn on curly vectors
res@vcMinDistanceF  = 0.03               ; thin out vectors
res@vcMapDirection  = False
res@gsnPresHgtHeightLabelOn = False
res@vcLineArrowColor = "violetred4"
res@cnLevelSelectionMode  = "ExplicitLevels" ; set manual contour levels

res@cnFillOn      = True                  
res@cnLinesOn     = True  
res@cnLineLabelsOn = True
res@cnLineLabelFontHeightF = 0.016
res@cnLineLabelInterval    = 1
res@cnConstFLabelConstantSpacingF = 0.0
res@cnInfoLabelOn	   = False
res@cnLineLabelPerimOn 		= True
res@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
res@cnLineLabelAngleF = 0.0
res@cnMonoLevelFlag = False
res@cnLevelFlags= "LineAndLabel"
res@cnLineLabelBackgroundColor = "white"
res@cnLineLabelPlacementMode = "Constant"

;res@cnFillColors	  = ispan(3,19,1)

;;===============step 1: counting the dV/dt with the local tendency and advection term===================================================================

;==========================count w and draw==================================================================================================================================
w_ave =  count_symmetric_wind_profile_3d(Radii,wa_in(0,:,:,:),average_range,ij_location,profile_range)
w_ave_profile = w_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(w_ave_profile)
;print(any(ismissing(w_ave_profile)))
w_plot = wrf_user_interp_level(w_ave_profile,p,level_string,False)
w_plot&level@units = "hPa"
w_plot = smth9_Wrap(w_plot,0.5,0.0,False) ;q=0.0 for 5 points smooth 
w_plot_scale = w_plot*10.0
printVarSummary(w_plot)

print_clock("successfully run the interp program")

;=========================== count radial wind=================================================================================================================================================
dim_ua = dimsizes(ua_in)
wind_rad = new((/dim_ua(1),dim_ua(2),dim_ua(3)/),float)

do i_level=0,dim_ua(1)-1,1
    wind_rad(i_level,:,:) = count_radial_wind(ua_in(0,i_level,:,:),va_in(0,i_level,:,:),ij_location,dx_dy)
end do


wind_rad_ave =  count_symmetric_wind_profile_3d(Radii,wind_rad,average_range,ij_location,profile_range)
wind_rad_ave_profile = wind_rad_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(wind_rad_ave_profile)
;print(any(ismissing(wind_rad_ave_profile)))
wind_rad_plot = wrf_user_interp_level(wind_rad_ave_profile,p,level_string,False)
wind_rad_plot&level@units = "hPa"
wind_rad_plot = smth9_Wrap(wind_rad_plot,0.5,0.0,False) ;q=0.0 for 5 points smooth 
printVarSummary(wind_rad_plot)

;=========================== count tangential wind=================================================================================================================================================
dim_ua = dimsizes(ua_in)
wind_tan = new((/dim_ua(1),dim_ua(2),dim_ua(3)/),float)

do i_level=0,dim_ua(1)-1,1
    wind_tan(i_level,:,:) = count_tangential_wind(ua_in(0,i_level,:,:),va_in(0,i_level,:,:),ij_location,dx_dy)
end do


wind_tan_ave =  count_symmetric_wind_profile_3d(Radii,wind_tan,average_range,ij_location,profile_range)
wind_tan_ave_profile = wind_tan_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(wind_tan_ave_profile)
;print(any(ismissing(wind_tan_ave_profile)))
wind_tan_plot = wrf_user_interp_level(wind_tan_ave_profile,p,level_string,False)
wind_tan_plot&level@units = "hPa"
wind_tan_plot = smth9_Wrap(wind_tan_plot,0.5,0.0,False) ;q=0.0 for 5 points smooth 
printVarSummary(wind_tan_plot)


;;==============count the local tendency term=================================
i_time_plus = i_time_plus_list(i_time_iterator)
path_plus = case_name+"/wrfout_"+domain_name+"_0001-01-"+i_time_plus+":00:00"
a_plus = addfile(path_plus,"r")
ua_in_plus = wrf_user_getvar(a_plus,"ua",it)
va_in_plus = wrf_user_getvar(a_plus,"va",it)
wa_in_plus = wrf_user_getvar(a_plus,"wa",it)
 p_in_plus = wrf_user_getvar(a_plus,"pressure",it)


;1.count tangential wind
wind_tan_plus = new((/dim_ua(1),dim_ua(2),dim_ua(3)/),float)

do i_level=0,dim_ua(1)-1,1
    wind_tan_plus(i_level,:,:) = count_tangential_wind(ua_in_plus(0,i_level,:,:),va_in_plus(0,i_level,:,:),ij_location,dx_dy)
end do


;2.make azimuthal average of wind_tan_plus
wind_tan_ave_plus =  count_symmetric_wind_profile_3d(Radii,wind_tan_plus(:,:,:),average_range,ij_location,profile_range)
wind_tan_ave_profile_plus = wind_tan_ave_plus(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(wind_tan_ave_profile_plus)
;print(any(ismissing(wind_tan_ave_profile)))

;3.insert to the pressure level
wind_tan_plot_plus = wrf_user_interp_level(wind_tan_ave_profile_plus,p,level_string,False)
wind_tan_plot_plus&level@units = "hPa"
printVarSummary(wind_tan_plot_plus)

Vt=((wind_tan_plot_plus-wind_tan_plot)/domain_timestep)*1e3
copy_VarMeta(wind_tan_plot,Vt)
printVarSummary(Vt)
printMinMax(Vt,1)

res@cnLevels              := (/-2,-1.5,-1.25,-1,-0.75,-0.5,0.5,0.75,1,1.25,1.5,2/)
res@cnFillColors          := (/4,5,6,7,8,9,-1,12,13,14,15,16,17/)
res@gsnRightString        = " Vt ( 10^3 m s^-2)"

plot(0)  = gsn_csm_pres_hgt_vector(wks,Vt,wind_rad_plot,w_plot_scale,res)
;plot(0)  = gsn_csm_pres_hgt(wks, Vt, res) 

;=============  count the horiztonal advection term ==============
Radii_plot = Radii(ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
Radii_partial = conform(wind_tan_plot,Radii_plot,1)*1000.0
VH = wind_rad_plot*center_finite_diff_n(wind_tan_plot,Radii_partial,False,0,1)*(-1e3)
copy_VarMeta(wind_tan_plot,VH)
printVarSummary(VH)
printMinMax(VH,1)

res@cnLevels              := (/-2,-1.5,-1.25,-1,-0.75,-0.5,0.5,0.75,1,1.25,1.5,2/)
res@cnFillColors          := (/4,5,6,7,8,9,-1,12,13,14,15,16,17/)
res@gsnRightString        = "VH (10^3 m s^-2)"

plot(1)  = gsn_csm_pres_hgt_vector(wks,VH,wind_rad_plot,w_plot_scale,res)
;plot(1)  = gsn_csm_pres_hgt(wks, VH, res) 

;==========================count z==================================================================================================================================
z_ave =  count_symmetric_wind_profile_3d(Radii,z_in(0,:,:,:),average_range,ij_location,profile_range)
z_ave_profile = z_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(z_ave_profile)
;print(any(ismissing(z_ave_profile)))
z_plot = wrf_user_interp_level(z_ave_profile,p,level_string,False)
z_plot&level@units = "hPa"

;===========================count the VV of wind_tan_plot========================================================
VV = w_plot*center_finite_diff_n(wind_tan_plot,z_plot,False,0,0)*(-1e3)
copy_VarMeta(wind_tan_plot,VV)
printVarSummary(VV)
printMinMax(VV,1)

;res@cnLevels              := (/-0.75,-0.5,0.5,0.75/)
;res@cnFillColors          := (/7,9,-1,12,14/)
res@gsnRightString        = "VV ( 10^3 m s^-2)"

plot(2)  = gsn_csm_pres_hgt_vector(wks,VV,wind_rad_plot,w_plot_scale,res)
;plot(2)  = gsn_csm_pres_hgt(wks, VV, res) 

;;====finally get dVdt======================

dVdt_plot = Vt-VH-VV 
dVdt = (Vt-VH-VV)/1e3
copy_VarMeta(wind_tan_plot,dVdt_plot)
printVarSummary(dVdt_plot)
printMinMax(dVdt_plot,1)

res@cnLevels              := (/-2,-1.5,-1.25,-1,-0.75,-0.5,0.5,0.75,1,1.25,1.5,2/)
res@cnFillColors          := (/4,5,6,7,8,9,-1,12,13,14,15,16,17/)
;res@cnLevels              := (/-0.75,-0.5,0.5,0.75/)
;res@cnFillColors          := (/7,9,-1,12,14/)
res@gsnRightString        = "dVdt_plot (10^3 m s^-2)"

plot(3)  = gsn_csm_pres_hgt_vector(wks,dVdt_plot,wind_rad_plot,w_plot_scale,res)
;plot(3)  = gsn_csm_pres_hgt(wks, dVdt, res) 


;;; =============== calculate the dVdt term related the earth rotation and vertical motion ===============================

;;; ============== count the w*sin(angle)================================================================================

angle = new((/dim_ua(1),dim_ua(2),dim_ua(3)/),float)

do i_level=0,dim_ua(1)-1,1
    angle(i_level,:,:) = count_angle(ua_in(0,i_level,:,:),va_in(0,i_level,:,:),ij_location,dx_dy)
end do

w_mod = wa_in(0,:,:,:)*angle
copy_VarMeta(wa_in(0,:,:,:),w_mod)

w_mod_ave =  count_symmetric_wind_profile_3d(Radii,w_mod,average_range,ij_location,profile_range)
w_mod_ave_profile = w_mod_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(w_mod_ave_profile)
;print(any(ismissing(w_mod_ave_profile)))
w_mod_plot = wrf_user_interp_level(w_mod_ave_profile,p,level_string,False)
w_mod_plot&level@units = "hPa"
printVarSummary(w_mod_plot)


;================== add coefficient =============================================================================
omega = 7.292e-5
fcor = 5.0e-5   ;fcor = 2*omega*sin(lat)
cos_lat = sqrt(1-(fcor/(2.0*omega))^2)
w_mod_plot = (w_mod_plot*omega*2.0*cos_lat)*1e2
printVarSummary(w_mod_plot)
printMinMax(w_mod_plot,1)

res@cnLevels              := (/-2,-1.5,-1.25,-1,-0.75,-0.5,0.5,0.75,1,1.25,1.5,2/)
res@cnFillColors          := (/4,5,6,7,8,9,-1,12,13,14,15,16,17/)
res@gsnRightString        = "2*omega*cos(lat)*w*sin(azimuth) ( 10^2 m s^-2)"

plot(4)  = gsn_csm_pres_hgt_vector(wks,w_mod_plot,wind_rad_plot,w_plot_scale,res)
;plot(4)  = gsn_csm_pres_hgt(wks, w_mod_plot, res) 

;;================= count Vr*Vt/R================================================================================
Radii_partial = where(Radii_partial.ne.0,Radii_partial,Radii_partial@_FillValue)
Vr_Vt = ((wind_tan_plot*wind_rad_plot)/Radii_partial)*1e2
copy_VarMeta(wind_rad_plot,Vr_Vt)
printVarSummary(Vr_Vt)
printMinMax(Vr_Vt,1)

;res@cnLevels		  := (/-12.0,-6.0,6.0,12.0/)
;res@cnFillColors          := (/7,9,-1,12,14/)
res@gsnRightString        = "Vr*Vt/R ( 10^2 m s^-2)"

plot(5)  = gsn_csm_pres_hgt_vector(wks,Vr_Vt,wind_rad_plot,w_plot_scale, res) 


;;================= count fcor*Vr================================================================================
fcor_Vr= (wind_rad_plot*fcor)*1e2
copy_VarMeta(wind_rad_plot,fcor_Vr)
printVarSummary(fcor_Vr)
printMinMax(fcor_Vr,1)

res@cnLevels              := (/-2,-1.5,-1.25,-1,-0.75,-0.5,0.5,0.75,1,1.25,1.5,2/)
res@cnFillColors          := (/4,5,6,7,8,9,-1,12,13,14,15,16,17/)
res@gsnRightString        = "fcor*Vr ( 10^2 m s^-2)"

plot(6)  = gsn_csm_pres_hgt_vector(wks,fcor_Vr,wind_rad_plot,w_plot_scale, res) 

;;================= count VD================================================================================
VD = dVdt*1e2-w_mod_plot+Vr_Vt+fcor_Vr
copy_VarMeta(wind_rad_plot,VD)
printVarSummary(VD)
printMinMax(VD,1)

res@cnLevels              := (/-2,-1.5,-1.25,-1,-0.75,-0.5,0.5,0.75,1,1.25,1.5,2/)
res@cnFillColors          := (/4,5,6,7,8,9,-1,12,13,14,15,16,17/)
res@gsnRightString        = "VD ( 10^2 m s^-2)"

plot(7)  = gsn_csm_pres_hgt_vector(wks,VD,wind_rad_plot,w_plot_scale, res) 

;;================= count dMdt_VD================================================================================
dMdt_VD = (VD*1e-2*Radii_partial*3600)/1e5 ;3600 is used to convert the unit
copy_VarMeta(wind_rad_plot,dMdt_VD)
printVarSummary(dMdt_VD)
printMinMax(dMdt_VD,1)

res@cnLevels              := (/-10,-8,-6,-4,-1,1,4,6,8,10/)
res@cnFillColors          := (/3,4,5,7,9,-1,12,14,16,17,18/)
;res@cnLevels		  := (/-12.0,-6.0,6.0,12.0/)
;res@cnFillColors          := (/7,9,-1,12,14/)
res@gsnRightString        = "dMdt - VD ((10^5 m^2 s^(-1) h^(-1)))"

plot(8)  = gsn_csm_pres_hgt_vector(wks,dMdt_VD,wind_rad_plot,w_plot_scale, res) 


;;=====================start to plot original figure==========================================================

;========================== count AAM and draw==================================================================================================================================
;1.count tangential wind
;dim_ua = dimsizes(ua_in)
;wind_tan = new((/dim_ua(1),dim_ua(2),dim_ua(3)/),float)
;
;do i_level=0,dim_ua(1)-1,1
;    wind_tan(i_level,:,:) = count_tangential_wind(ua_in(0,i_level,:,:),va_in(0,i_level,:,:),ij_location,dx_dy)
;end do

;2.modify the shape of Radii and count AAM in 3D
Radii_conform = conform(wind_tan,Radii,(/1,2/))
Radii_conform = Radii_conform*1000.0
AAM_in = wind_tan*Radii_conform+0.5*fcor*Radii_conform^2
;copy_VarMeta(wind_tan,AAM_in)

;3.make azimuthal average of AAM
AAM_ave =  count_symmetric_wind_profile_3d(Radii,AAM_in(:,:,:),average_range,ij_location,profile_range)
AAM_ave_profile = AAM_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(AAM_ave_profile)
;print(any(ismissing(AAM_ave_profile)))

;4.insert to the pressure level
AAM_plot = wrf_user_interp_level(AAM_ave_profile,p,level_string,False)
AAM_plot&level@units = "hPa"
AAM_plot = AAM_plot/1e5
printVarSummary(AAM_plot)
printMinMax(AAM_plot,1)

;res@cnMinLevelValF        = 5.        ; set min contour level
;res@cnLevelSpacingF       = 5.          ; set contour interval
;res@cnMaxLevelValF        = 40.         ; set max contour level                
res@gsnRightString        = "AAM (/10^5 m^2 s^(-1))"
res@cnLevels              := (/10,15,20,25,30,35,40/)
res@cnFillColors          := (/-1,12,13,14,15,16,17,18/)

plot(9)  = gsn_csm_pres_hgt_vector(wks,AAM_plot,wind_rad_plot,w_plot_scale,res)
;plot(0)  = gsn_csm_pres_hgt(wks, AAM_plot, res) 
;draw(plot(0))
;frame(wks)

;===========================count the Mt of AAM========================================================
i_time_plus = i_time_plus_list(i_time_iterator)
path_plus = case_name+"/wrfout_"+domain_name+"_0001-01-"+i_time_plus+":00:00"
a_plus = addfile(path_plus,"r")
ua_in_plus = wrf_user_getvar(a_plus,"ua",it)
va_in_plus = wrf_user_getvar(a_plus,"va",it)
wa_in_plus = wrf_user_getvar(a_plus,"wa",it)
 p_in_plus = wrf_user_getvar(a_plus,"pressure",it)


;1.count tangential wind
wind_tan_plus = new((/dim_ua(1),dim_ua(2),dim_ua(3)/),float)

do i_level=0,dim_ua(1)-1,1
    wind_tan_plus(i_level,:,:) = count_tangential_wind(ua_in_plus(0,i_level,:,:),va_in_plus(0,i_level,:,:),ij_location,dx_dy)
end do

;2.modify the shape of Radii and count AAM in 3D
AAM_in_plus = wind_tan_plus*Radii_conform+0.5*fcor*Radii_conform^2

;3.make azimuthal average of AAM
AAM_ave_plus =  count_symmetric_wind_profile_3d(Radii,AAM_in_plus(:,:,:),average_range,ij_location,profile_range)
AAM_ave_profile_plus = AAM_ave_plus(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(AAM_ave_profile_plus)
;print(any(ismissing(AAM_ave_profile)))

;4.insert to the pressure level
AAM_plot_plus = wrf_user_interp_level(AAM_ave_profile_plus,p,level_string,False)
AAM_plot_plus&level@units = "hPa"
AAM_plot_plus = AAM_plot_plus/1e5
printVarSummary(AAM_plot_plus)

Mt=((AAM_plot_plus-AAM_plot)/domain_timestep)*3600 ; 3600 is used to convert the unit 10^5 m^2 s^(-2) to 10^5 m^2 s^(-1) h^(-1)
copy_VarMeta(AAM_plot,Mt)
printVarSummary(Mt)
printMinMax(Mt,1)

;res@cnMinLevelValF        = -2.0       ; set min contour level
;res@cnLevelSpacingF       =  0.5          ; set contour interval
;res@cnMaxLevelValF        =  2.0         ; set max contour level                
;res@cnLevels              := (/-10,-8,-6,-4,-1,1,4,6,8,10/)
;res@cnFillColors          := (/3,4,5,7,9,-1,12,14,16,17,18/)
res@cnLevels              := (/-0.75,-0.5,0.5,0.75/)
res@cnFillColors          := (/7,9,-1,12,14/)
res@gsnRightString        = "Mt (10^5 m^2 s^(-1) h^(-1))"

plot(10)  = gsn_csm_pres_hgt_vector(wks,Mt,wind_rad_plot,w_plot_scale,res)
;plot(1)  = gsn_csm_pres_hgt(wks, Mt, res) 
;draw(plot(1))
;frame(wks)

;===========================count the MH of AAM========================================================
;printVarSummary(AAM_plot)
;printVarSummary(Radii)
Radii_plot = Radii(ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
Radii_partial = conform(AAM_plot,Radii_plot,1)*1000.0
MH = wind_rad_plot*center_finite_diff_n(AAM_plot,Radii_partial,False,0,1)*(-3600) ; 3600 is used to convert the unit 10^5 m^2 s^(-2) to 10^5 m^2 s^(-1) h^(-1)
copy_VarMeta(AAM_plot,MH)
printVarSummary(MH)
printMinMax(MH,1)

;res@cnMinLevelValF        = -15.        ; set min contour level
;res@cnLevelSpacingF       =  3.0          ; set contour interval
;res@cnMaxLevelValF        =  15.         ; set max contour level                
res@cnLevels              := (/-15,-10,-5,5,10,15/)
res@cnFillColors          := (/5,7,9,-1,12,14,16/)
res@gsnRightString        = "MH (10^5 m^2 s^(-1) h^(-1))"

plot(11)  = gsn_csm_pres_hgt_vector(wks,MH,wind_rad_plot,w_plot_scale,res)
;plot(2)  = gsn_csm_pres_hgt(wks, MH, res) 
;draw(plot(2))
;frame(wks)



;==========================count z==================================================================================================================================
z_ave =  count_symmetric_wind_profile_3d(Radii,z_in(0,:,:,:),average_range,ij_location,profile_range)
z_ave_profile = z_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(z_ave_profile)
;print(any(ismissing(z_ave_profile)))
z_plot = wrf_user_interp_level(z_ave_profile,p,level_string,False)
z_plot&level@units = "hPa"

;===========================count the MV of AAM========================================================
MV = w_plot*center_finite_diff_n(AAM_plot,z_plot,False,0,0)*(-3600.0) ; 3600 is used to convert the unit 10^5 m^2 s^(-2) to 10^5 m^2 s^(-1) h^(-1)
copy_VarMeta(AAM_plot,MV)
printVarSummary(MV)
printMinMax(MV,1)

;res@cnMinLevelValF        = -15.        ; set min contour level
;res@cnLevelSpacingF       =  1.5          ; set contour interval
;res@cnMaxLevelValF        =  15.         ; set max contour level                
res@gsnRightString        = "MV (10^5 m^2 s^(-1) h^(-1))"

plot(12)  = gsn_csm_pres_hgt_vector(wks,MV,wind_rad_plot,w_plot_scale,res)
;plot(3)  = gsn_csm_pres_hgt(wks, MV, res) 
;draw(plot(3))
;frame(wks)

dMdt = (Mt-1.0*MH-1.0*MV)
copy_VarMeta(AAM_plot,dMdt)
printVarSummary(dMdt)
printMinMax(dMdt,1)

;res@cnMinLevelValF        = -15.        ; set min contour level
;res@cnMaxLevelValF        =  15.         ; set max contour level                
;res@cnLevelSpacingF       =  1.5          ; set contour interval
res@cnLevels              := (/-10,-8,-6,-4,-1,1,4,6,8,10/)
res@cnFillColors          := (/3,4,5,7,9,-1,12,14,16,17,18/)
res@gsnRightString        = "dMdt ((10^5 m^2 s^(-1) h^(-1))"

plot(13)  = gsn_csm_pres_hgt_vector(wks,dMdt,wind_rad_plot,w_plot_scale,res)
;plot(4)  = gsn_csm_pres_hgt(wks, dMdt, res) 
;draw(plot(4))
;frame(wks)






resP                     = True         ; modify the panel plot
resP@gsnFrame            = False
resP@gsnMaximize         = False         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
resP@lbLabelFontHeightF  = 0.013
;resP@pmLabelBarParallelPosF = -0.1
resP@pmLabelBarWidthF    = 0.7
resP@gsnPanelYWhiteSpacePercent  = 7.5
resP@gsnPanelXWhiteSpacePercent  = 2.5
;resP@gsnPanelMainString  = "TA SST ("+season+")"
resP@gsnPanelMainFontHeightF = 0.025
resP@gsnPanelTop        = 0.95    ; only panel on lower half of page
resP@gsnPanelXF         = (/0.05,0.52/)
resP@pmLabelBarWidthF   = 0.8    ; label bar width


resP@gsnPanelMainString  = " "

gsn_panel(wks,plot(0:3), (/2,2/), resP)
frame(wks)

gsn_panel(wks,plot(4:7), (/2,2/), resP)
frame(wks)

gsn_panel(wks,(/plot(8),plot(13),plot(9),plot(10),plot(11),plot(12)/), (/3,2/), resP)
frame(wks)

print_clock("sucessfully draw the figure")
;delete(plot(7))
end do


end 
