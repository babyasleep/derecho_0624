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
fcor = 5.0e-5
plot = new(8,"graphic")
ij_location = new((/2,2/),integer)

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

level_string=ispan(1010,100,5)
p = p_in(0,:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)

;====================count windspeed=============================================
windspeed_ave =  count_symmetric_wind_profile_3d(Radii,windspeed_in(0,:,:,:),average_range,ij_location,profile_range)
windspeed_ave_profile = windspeed_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(windspeed_ave_profile)
;print(any(ismissing(windspeed_ave_profile)))
windspeed_plot = wrf_user_interp_level(windspeed_ave_profile,p,level_string,False)
windspeed_plot&level@units = "hPa"

;==========================count w and draw==================================================================================================================================
w_ave =  count_symmetric_wind_profile_3d(Radii,wa_in(0,:,:,:),average_range,ij_location,profile_range)
w_ave_profile = w_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(w_ave_profile)
;print(any(ismissing(w_ave_profile)))
w_plot = wrf_user_interp_level(w_ave_profile,p,level_string,False)
w_plot = smth9_Wrap(w_plot,0.5,0.0,False) ;q=0.0 for 5 points smooth 
w_plot&level@units = "hPa"
w_plot_scale = w_plot*10.0
printVarSummary(w_plot)


;========================== count AAM and draw==================================================================================================================================
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
AAM_plot = smth9_Wrap(AAM_plot,0.5,0.0,False) ;q=0.0 for 5 points smooth 
printVarSummary(AAM_plot)
printMinMax(AAM_plot,1)



;===========================count the MH of AAM========================================================
Radii_plot = Radii(ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
Radii_partial = conform(AAM_plot,Radii_plot,1)*1000.0
MH = wind_rad_plot*center_finite_diff_n(AAM_plot,Radii_partial,False,0,1)*(-3600) ; 3600 is used to convert the unit 10^5 m^2 s^(-2) to 10^5 m^2 s^(-1) h^(-1)
copy_VarMeta(AAM_plot,MH)
printVarSummary(MH)
printMinMax(MH,1)

;==========================count z==================================================================================================================================
z_ave =  count_symmetric_wind_profile_3d(Radii,z_in(0,:,:,:),average_range,ij_location,profile_range)
z_ave_profile = z_ave(:,ij_location(0,0):ij_location(0,0),ij_location(0,1):ij_location(0,1)+profile_range)
printVarSummary(z_ave_profile)
;print(any(ismissing(z_ave_profile)))
z_plot = wrf_user_interp_level(z_ave_profile,p,level_string,False)
z_plot&level@units = "hPa"

;===========================count the MV of AAM========================================================
MV = w_plot*center_finite_diff_n(AAM_plot,z_plot,False,0,0)*(-3600.0) ; 3600 is used to convert the unit 10^5 m^2 s^(-2) to 10^5 m^2 s^(-1) h^(-1)
;;只是测试，记得修改
;MV = center_finite_diff_n(AAM_plot,z_plot,False,0,0)
copy_VarMeta(AAM_plot,MV)
printVarSummary(MV)
printMinMax(MV,1)

;dMdt = Mt-1.0*MH-1.0*MV
;copy_VarMeta(AAM_plot,dMdt)
;printVarSummary(dMdt)
;printMinMax(dMdt,1)
;
;res@gsnDraw         = False
;res@gsnFrame        = False
;res@cnMinLevelValF        = -15.        ; set min contour level
;res@cnLevelSpacingF       =  1.5          ; set contour interval
;res@cnMaxLevelValF        =  15.         ; set max contour level                
;res@gsnRightString        = "dMdt ((10^5 m^2 s^(-1) h^(-1)))"
;res@cnFillOn      = True                  
;res@cnLinesOn     = False  
;
;plot(4)  = gsn_csm_pres_hgt_vector(wks,dMdt,wind_rad_plot,w_plot_scale,res)
;;plot(4)  = gsn_csm_pres_hgt(wks, dMdt, res) 
;;draw(plot(4))
;;frame(wks)



;==========================start outputing data====================================================================
output_file = case_name+"/draw/test_data/"+domain_name+"_vertical_profile_AAM_"+i_time_list(i_time_iterator)+".nc"
system("rm -rf "+output_file)
f2 = addfile(output_file, "c")
f2->w_plot = w_plot
f2->w_plot_scale = w_plot_scale
f2->wind_rad_plot= wind_rad_plot
f2->wind_tan_plot = wind_tan_plot 
f2->windspeed_plot = windspeed_plot
f2->AAM_plot = AAM_plot 
f2->MV = MV 
f2->MH = MH
;f2-> = 




end do


end 
