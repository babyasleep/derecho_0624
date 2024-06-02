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
   wspd_tan(ij_location(0,0),ij_location(0,1))=wspd(ij_location(0,0),ij_location(0,1))
   return wspd_tan 
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
   wspd_rad(ij_location(0,0),ij_location(0,1))=0.0
   return wspd_rad 
end


begin
plot = new(8,"graphic")
ij_location = new((/2,2/),integer)
RMW_line0 = new(12,"graphic")
RMW_line1 = new(12,"graphic")
RMW_line2 = new(12,"graphic")
RMW_line3 = new(12,"graphic")
RMW_line4 = new(12,"graphic")
RMW_line5 = new(12,"graphic")
RMW_line6 = new(12,"graphic")
RMW_line7 = new(12,"graphic")
RMW_line8 = new(12,"graphic")

i_time_list = (/"01_01","01_06", "01_12", "01_18", \
	   "02_00", "02_06", "02_12", "02_18", \
	   "03_00", "03_06", "03_12", "03_18", \
	   "04_00", "04_06", "04_12", "04_18", \
	   "05_00", "05_06", "05_12", "05_18", \
	   "06_00", "06_06", "06_12", "06_18","06_23"/)


case_name = "em_tropical_cyclone"
;do i_time_iterator= 0,0,1
do i_time_iterator= 11,dimsizes(i_time_list)-1,2
i_time = i_time_list(i_time_iterator)
wks = gsn_open_wks("pdf",case_name+"/draw/figure/d03_vertical_profile_"+i_time)
path = case_name+"/wrfout_d03_0001-01-"+i_time+":00:00"
a = addfile(path,"r")
it   = -1
rh_in  = wrf_user_getvar(a,"rh",it)   ; sea level pressure
slp_in  = wrf_user_getvar(a,"slp",it)   ; sea level pressure
dbz_in = wrf_user_getvar(a,"dbz",it)
eth_in = wrf_user_getvar(a,"eth",it)
tk_in = wrf_user_getvar(a,"tk",it)
ua_in = wrf_user_getvar(a,"ua",it)
va_in = wrf_user_getvar(a,"va",it)
wa_in = wrf_user_getvar(a,"wa",it)
p_in = wrf_user_getvar(a,"pressure",it)
mdbz = wrf_user_getvar(a,"mdbz",it)
uvmet10_in = wrf_user_getvar(a,"uvmet10",it)
printVarSummary(uvmet10_in)
umet10_in = uvmet10_in(0,0,:,:)
vmet10_in = uvmet10_in(1,0,:,:)
windspeed_in = wind_speed(ua_in,va_in)


level_string=(/1000,975,950,925,900,875,850,825,800,700,600,500/)
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
p = p_in(0,:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
Radii = count_Radii(p_in(0,0,:,:),ij_location,dx_dy)

windspeed_ave =  count_symmetric_wind_profile_3d(Radii,windspeed_in(0,:,:,:),average_range,ij_location,profile_range)
windspeed_ave_profile = windspeed_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(windspeed_ave_profile)
;print(any(ismissing(windspeed_ave_profile)))
windspeed_plot = wrf_user_interp_level(windspeed_ave_profile,p,level_string,False)
windspeed_plot&level@units = "hPa"


res                 = True  
res@gsnLeftString	  = i_time+":00"
res@tmXBOn		  = True
res@trYLog		  = True
res@tmXBMode		  = "Explicit"
res@tmXBValues		  = ispan(0,profile_range,10)
res@tmXBLabels		  = res@tmXBValues*dx_dy
res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
res@pmLabelBarOrthogonalPosF = -0.05
res@cnFillPalette        = "temp_19lev"
res@tmYRTickSpacingF = 1.0 
res@trYLog = False
;res@cnFillColors	  = ispan(3,19,1)

;==========================count temperature anomaly and draw==================================================================================================================================
tk_ave =  count_symmetric_wind_profile_3d(Radii,tk_in(0,:,:,:),average_range,ij_location,profile_range)
tk_ave_profile = tk_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(tk_ave_profile)
;print(any(ismissing(tk_ave_profile)))
tk_plot = wrf_user_interp_level(tk_ave_profile,p,level_string,False)
tk_plot&level@units = "hPa"
tk_plot = dim_rmvmean_n_Wrap(tk_plot,1)
printVarSummary(tk_plot)


res@gsnDraw         = False
res@gsnFrame        = False
res@cnMinLevelValF        = -1.0        ; set min contour level
res@cnLevelSpacingF       = 0.1          ; set contour interval
res@cnMaxLevelValF        = 1.0         ; set max contour level                
res@gsnRightString        = ""
res@cnFillOn      = True                  
res@cnLinesOn     = False  

plot(0)  = gsn_csm_pres_hgt(wks, tk_plot, res) 

;==========================add maximum windspeed line==================================================================================================================================
do i_level=0,10,1
	RMW_line0(i_level) = gsn_add_polyline(wks,plot(0),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),False)
end do

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
printVarSummary(wind_rad_plot)


;==========================count rh and draw==================================================================================================================================
rh_ave =  count_symmetric_wind_profile_3d(Radii,rh_in(0,:,:,:),average_range,ij_location,profile_range)
rh_ave_profile = rh_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(rh_ave_profile)
;print(any(ismissing(rh_ave_profile)))
rh_plot = wrf_user_interp_level(rh_ave_profile,p,level_string,False)
rh_plot&level@units = "hPa"
printVarSummary(rh_plot)


res@gsnDraw         = False
res@gsnFrame        = False
res@cnMinLevelValF        = 50.0        ; set min contour level
res@cnLevelSpacingF       = 5.0          ; set contour interval
res@cnMaxLevelValF        = 100.         ; set max contour level                

res@cnFillOn      = True                  
res@cnLinesOn     = False  
res@gsnRightString        = ""

plot(3)  = gsn_csm_pres_hgt(wks, rh_plot, res) 

;==========================add maximum windspeed line==================================================================================================================================
do i_level=0,10,1
	RMW_line3(i_level) = gsn_add_polyline(wks,plot(3),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),False)
end do

;==========================count w and draw==================================================================================================================================
w_ave =  count_symmetric_wind_profile_3d(Radii,wa_in(0,:,:,:),average_range,ij_location,profile_range)
w_ave_profile = w_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(w_ave_profile)
;print(any(ismissing(w_ave_profile)))
w_plot = wrf_user_interp_level(w_ave_profile,p,level_string,False)
w_plot&level@units = "hPa"
printVarSummary(w_plot)


;========================== draw vr and w==================================================================================================================================

dbz_ave =  count_symmetric_wind_profile_3d(Radii,dbz_in(0,:,:,:),average_range,ij_location,profile_range)
dbz_ave_profile = dbz_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(dbz_ave_profile)
;print(any(ismissing(dbz_ave_profile)))
dbz_plot = wrf_user_interp_level(dbz_ave_profile,p,level_string,False)
dbz_plot&level@units = "hPa"
printVarSummary(dbz_plot)


res1 = True
res1@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
res1@cnMinLevelValF        = 0       ; set min contour level
res1@cnLevelSpacingF       = 5          ; set contour interval
res1@cnMaxLevelValF        = 20         ; set max contour level                
res1@gsnDraw	     = False
res1@gsnFrame        = False
res1@vcRefMagnitudeF = 3.0                ; define vector ref mag
res1@vcRefLengthF    = 0.025              ; define length of vec ref
res1@vcGlyphStyle    = "LineArrow"      ; turn on curly vectors
res1@vcMinDistanceF  = 0.05               ; thin out vectors
res1@vcMapDirection  = False
res1@cnFillPalette        = "temp_19lev"
res1@cnFillOn      = False                  
res1@cnLinesOn     = True
res1@cnLineColor   = "grey60"
res1@gsnRightString        = "T'+ vertical circulation (dbz)"
res1@gsnLeftString        = i_time+":00"
res1@tmXBMode  =res@tmXBMode        
res1@tmXBValues=res@tmXBValues       
res1@tmXBLabels=res@tmXBLabels       
res1@tmYRTickSpacingF = res@tmYRTickSpacingF
res1@trYLog = res@trYLog

w_plot_scale = w_plot*10.0
printMinMax(dbz_plot,1)
plot(7)  = gsn_csm_pres_hgt_vector(wks,dbz_plot,wind_rad_plot,w_plot_scale,res1)
res1@gsnRightString        = "RH + vertical circulation (dbz)"
plot(6)  = gsn_csm_pres_hgt_vector(wks,dbz_plot,wind_rad_plot,w_plot_scale,res1)
print("sucessfully ") 
;==========================add maximum windspeed line==================================================================================================================================
do i_level=0,10,1
	RMW_line7(i_level) = gsn_add_polyline(wks,plot(7),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),False)
end do

;============================================================================================================================================================================
overlay(plot(0),plot(7))
overlay(plot(3),plot(6))

resP                     = True         ; modify the panel plot
resP@gsnFrame            = False
resP@gsnMaximize         = False         ; large format
resP@gsnPanelLabelBar    = False         ; add common colorbar
resP@lbLabelFontHeightF  = 0.013
;resP@pmLabelBarParallelPosF = -0.1
resP@pmLabelBarWidthF    = 0.7
resP@gsnPanelYWhiteSpacePercent  = 7.5
resP@gsnPanelXWhiteSpacePercent  = 3.5
;resP@gsnPanelMainString  = "TA SST ("+season+")"
resP@gsnPanelMainFontHeightF = 0.025
resP@gsnPanelTop        = 0.95    ; only panel on lower half of page
resP@gsnPanelXF         = (/0.05,0.52/)
resP@pmLabelBarWidthF   = 0.8    ; label bar width


resP@gsnPanelMainString  = " "
gsn_panel(wks,(/plot(0),plot(3),plot(7)/), (/2,2/), resP)
frame(wks)
delete(plot(7))
end do


end 
