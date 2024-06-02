
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

function count_symmetric_wind_2d_profile(Radii,wspd_tan,average_range,ij_location,profile_range)
begin
    dim = dimsizes(wspd_tan)
    wspd_tan_ave = new((/dim(0),dim(1)/),float,-99999)
    copy_VarCoords(wspd_tan,wspd_tan_ave)
   
	;print_clock(i_level)
	do i_lat = ij_location(0,0),ij_location(0,0),1
	    do i_lon = ij_location(0,1),ij_location(0,1)+profile_range,1
	        wspd_tan_tmp = wspd_tan
    		wspd_tan_tmp@_FillValue = -99999
	        wspd_tan_tmp = where(Radii.ge.Radii(i_lat,i_lon)-average_range.and.Radii.le.Radii(i_lat,i_lon)+average_range, wspd_tan_tmp,wspd_tan_tmp@_FillValue)
	        ;print(num(.not.ismissing(wspd_tmp)))
	        wspd_tan_ave(i_lat,i_lon)=avg(wspd_tan_tmp)
	        delete(wspd_tan_tmp)
	    end do
	end do
    
    return wspd_tan_ave
end

begin

g_font = 0.025
l_thick = 2
    
 ;----------draw setting---------------------------------------------------------------
;---------------marker--------------------------------
polyres                   = True
polyres@gsMarkerIndex     = 2          ; polymarker style
polyres@gsMarkerSizeF     = 12.          ; polymarker size
polyres@gsMarkerThicknessF     = 6.          ; polymarker size
polyres@gsMarkerColor     = "black"          ; polymarker size

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
res@mpGeophysicalLineThicknessF = l_thick
res@mpGridLineThicknessF   = l_thick
;res@mpLandFillColor        = "white"
; res@mpGridSpacingF         = 10.     ;
;res@pmTickMarkDisplayMode = "Always"
;res@cnLevels    = (/ -0.04,-0.03,-0.02,-0.01,0,0.01,0.02,0.03,0.04/)*0.2
res@cnFillPalette        = "precip2_17lev"
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
;resP@gsnPanelXWhiteSpacePercent  = 3.5
;resP@gsnPanelMainString  = "TA SST ("+season+")"
resP@gsnPanelMainFontHeightF = 0.025
;resP@gsnPanelTop        = 0.9    ; only panel on lower half of page
;resP@gsnPanelXF         = (/0.05,0.52/)
;resP@pmLabelBarWidthF   = 0.8    ; label bar width
;;resP@gsnPanelBottom     = 0.25    ; space for label bar
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
resv@vcMinDistanceF          = 0.03 ;0.01 ;0.03
resv@vcMinMagnitudeF         = 0.3
;resv@vcFillArrowHeadInteriorXF = 0.25
;resv@vcFillArrowHeadXF         = 0.6
;resv@vcFillArrowHeadYF         = 0.2
;resv@vcFillArrowWidthF         = 0.1

;--------Set reference arrow--------
refmag = 6 
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
;; start adding file to calculate information
;;path ="/glade/work/cjiaxin/test_wrf/idealize/longer-full-ideal/test/em_tropical_cyclone/draw/test_data/wrfout_d01_0001-01-*"
;path1 =case_name+"/wrfout_d02_0001-01-*"
;files1 = systemfunc("ls "+path1)  
;a1 = addfiles(files1,"r")
;it   = -1
;msl_in  = wrf_user_getvar(a1,"slp",it)   ; sea level pressure
;
;path =case_name+"/wrfout_d03_0001-01-*"
;files = systemfunc("ls "+path)  
;a = addfiles(files,"r")
;mdbz_in = wrf_user_getvar(a,"mdbz",it)
;uvmet10_in = wrf_user_getvar(a,"uvmet10",it)
;umet10_in = uvmet10_in(0,:,:,:)
;vmet10_in = uvmet10_in(1,:,:,:)
;
;times = wrf_user_list_times(a)
;msl_in@_FillValue = 9.96921e+36
;
;;;;select data to plot
;;interval = 2
;;msl_in := msl_in(::interval,:,:)
;;mdbz_in := mdbz_in(::interval,:,:)
;;umet10_in := umet10_in(::interval,:,:)
;;vmet10_in := vmet10_in(::interval,:,:)
;
;
;dim = dimsizes(msl_in(:,0,0))
;min_slp = new(dim,float)
;max_windspeed = new(dim,float)
;max_radius = new(dim,float)
;
;;do i_time=0,1,1
;do i_time=0,dim-1,1
;    print_clock(i_time)
;    msl = msl_in(i_time,:,:)
;    mdbz = mdbz_in(i_time,:,:)
;    umet10 = umet10_in(i_time,:,:)
;    vmet10 = vmet10_in(i_time,:,:)
;    uvmet10 = wind_speed(umet10, vmet10)
;
;;------------count symmetric windspeed-----------------------------
;    ;msl_mask = where(mdbz.gt. 0.0, msl@_FillValue, msl)
;    ;ij_location_slp= ind_resolve(minind(ndtooned(msl_mask)),dimsizes(msl_mask))
;    ij_location_slp= ind_resolve(minind(ndtooned(msl)),dimsizes(msl))
;    ij_location_slp(0,0)=250
;    ij_location_slp(0,1)=250
;    ;print(ij_location_slp)
;
;    Radii = count_Radii(uvmet10, ij_location_slp,2)
;    uvmet10_ave = count_symmetric_wind_2d_profile(Radii,uvmet10,1,ij_location_slp,200)
;    max_windspeed(i_time) = max(uvmet10_ave)
;    ij_location_wind= ind_resolve(maxind(ndtooned(uvmet10_ave)),dimsizes(uvmet10_ave))
;    max_radius(i_time) =  sqrt((ij_location_slp(0,0)-ij_location_wind(0,0))^2+(ij_location_slp(0,1)-ij_location_wind(0,1))^2)*2
; 
;    ;uvmet10_mask = where(mdbz.lt. 15.0, uvmet10@_FillValue, uvmet10)
;    ;ij_location_wind= ind_resolve(maxind(ndtooned(uvmet10_mask)),dimsizes(uvmet10_mask))
;    ;print(ij_location_wind)
;    ;max_windspeed(i_time) = max(uvmet10_mask)
;    min_slp(i_time) = min(msl)
;end do
;
;output_file = case_name+"/draw/test_data/intensity_tc.nc"
;system("rm -rf "+output_file)
;f2 = addfile(output_file, "c")
;f2->min_slp = min_slp
;f2->max_windspeed = max_windspeed
;f2->max_radius = max_radius

;print(min_slp)
;print(max_windspeed)
;print(max_radius)
;;;;;end calculate information.

input_file = case_name+"/draw/test_data/smooth_intensity_tc.nc"
f2 = addfile(input_file, "r")
min_slp = f2->min_slp 
max_windspeed = f2->max_windspeed
max_radius = f2->max_radius

min_slp := min_slp(1:)
max_windspeed := max_windspeed(1:)
max_radius := max_radius(1:)


printVarSummary(min_slp) 
dim = dimsizes(min_slp)

;;;; start plotting figure 
outfile = case_name+"/draw/figure/intensity_tc"
wks = gsn_open_wks("png",outfile)
nplot = 2
plot = new(nplot, graphic)
titles = (/"(a) Pmin & Vmax",\
           "(b) Rmax"/)


;--line setting-------------------------------------------  
  rts           = True
  rts@gsnDraw   = False       ; don't draw yet
  rts@gsnFrame  = False       ; don't advance frame yet
  rts@gsnScale  = True        ; force text scaling               
  rts@tmXTLabelsOn   = False
  rts@tmXTOn = False


; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  rts@vpHeightF = 0.18        ; Changes the aspect ratio
  rts@vpWidthF  = 0.52
  ;rts@vpXF      = (/0.11,0.78/)        ; change start locations
  ;rts@vpYF      = 0.95        ; the plot

  rts@tmXBLabelFontHeightF = 0.012;0.03
  rts@tmYLLabelFontHeightF = 0.012;0.03
  rts@tmYRLabelFontHeightF = 0.012;0.03

  ;rts@tmXBTickSpacingF     = 5
;--Turn off X axis tickmarks
  rts@tmXBMajorLengthF         = 0.005;0.01
  rts@tmXBMajorOutwardLengthF  = 0.005;0.01  
  rts@tmYLMajorLengthF         = 0.005;0.01
  rts@tmYLMajorOutwardLengthF  = 0.005;0.01
  rts@tmXBMinorLengthF         = 0.0025;0.005
  rts@tmXBMinorOutwardLengthF  = 0.0025;0.005  
  rts@tmYLMinorLengthF         = 0.0025;0.005
  rts@tmYLMinorOutwardLengthF  = 0.0025;0.005 

  rts@tmXBLabelDeltaF      = -0.6
  rts@tmYLLabelDeltaF      = -0.6

  rts@trXMinF  = 0
  rts@trXMaxF  = dim+1

  rts@tiYAxisString = ""                   ; y-axis label      
  rts@xyMonoLineThickness  = True
  ;rts@gsnYRefLine           = 0.              ; reference line 
   rts@tiXAxisString = "Model Hour"
  rts@tmXBMode  ="Explicit"
  rts@tmXBValues      = ispan(0,dim,6)
  rts@tmXBLabels      = "" + rts@tmXBValues 



;----------------- bar0 chart resource -------------------------------
gsn_define_colormap(wks,"BlueWhiteOrangeRed")
sig_line_color = "226"
sig_line_pattern = 0
sig_line_thickness = "6.0"

unsig_line_color = "18"
unsig_line_pattern = 12
unsig_line_thickness ="4.0"


  rts0 = rts   
  ;rts0@xyMarkLineModes       = (/"MarkLines"/)
  rts0@xyDashPattern         = sig_line_pattern
  rts0@xyLineColor           = sig_line_color
  rts0@xyLineThicknessF      = sig_line_thickness           
  rts0@trYMinF  = 945.0                   ; min value on y-axis
  rts0@trYMaxF  = 1015.0 
  rts0@tmYLTickSpacingF = 10.0 
  rts0@tmYLMode = "Manual"
  rts0@tiYAxisString = "Pmin (hPa) [solid]"
  ;rts0@tiYAxisString = "Central Pressure (hPa) [solid]"

;----------------- bar1 chart resource -------------------------------
  ;rts1 = rts   
  ;rts1@xyMarkLineModes       = (/"MarkLines"/)
  ;rts1@xyDashPattern         = rts0@xyDashPattern       
  ;rts1@xyLineColor           = rts0@xyLineColor
  ;rts1@xyLineThicknessF      = rts0@xyLineThicknessF           
  ;rts1@xyMarker              = 16 
  ;rts1@xyMarkerColor         = "red3"  
  ;rts1@xyMarkerSizes         = 0.02 
    
;----------------- bar2 chart resource -------------------------------
  rts2 = rts   
  ;rts2@xyMarkLineModes       = (/"MarkLines"/)
  rts2@xyDashPattern         = unsig_line_pattern 
  rts2@xyLineColor           = unsig_line_color
  rts2@xyLineThicknessF      = unsig_line_thickness
  rts2@trYMinF  = 10.0                 ; min value on y-axis
  rts2@trYMaxF  = 40.0  
  rts2@tmYLTickSpacingF = 10.0 
  rts2@tiYAxisString = "Vmax (m/s) [dashed]"
  ;rts2@tiYAxisString = "Maximum surface windspeed (m/s) [dashed]"
  ;rts2@xyMarker              = 16 
  ;rts2@xyMarkerColor         = "red3"  
  ;rts2@xyMarkerSizes         = 0.02 

;--------------------------------------------------------
  time1 = ispan(1,dim,1)

  printVarSummary(time1)
  time2 = time1
  dum = new(2,graphic)
  dum_line = new(4,graphic)
  dum_text = new(4,graphic)
;--------------------------------------------------------

; create the first plot
     rts0@gsnLeftString  = titles(0)
     rts0@gsnLeftStringFontHeightF  = 0.012
     rts0@gsnLeftStringOrthogonalPosF = -0.02
     rts0@gsnRightStringFontHeightF = 0.018
     plot(0) = gsn_csm_xy2 (wks,time1,min_slp,max_windspeed,rts0,rts2)

; create the second plot
     rts0@gsnLeftString  = titles(1)
     rts0@trYMinF  = 20.0                   ; min value on y-axis
     rts0@trYMaxF  = 80.0 
     rts0@tmYLTickSpacingF = 10.0 
     rts0@gsnLeftStringFontHeightF  = 0.012
     rts0@gsnLeftStringOrthogonalPosF = -0.02
     rts0@gsnRightStringFontHeightF = 0.018
     rts0@tiYAxisString = "Rmax (km)"
     ;rts0@tiYAxisString = "Radius of maximum surface windspeed (km)"
     plot(1) = gsn_csm_xy (wks,time2,max_radius,rts0)
 

;------------panel setting-------------------------------
resP                     = True         ; modify the panel plot
resP@gsnFrame            = False
;resP@gsnMaximize         = True         ; large format

resP@gsnPanelLabelBar    = False         ; add common colorbar
resP@lbLabelFontHeightF  = 0.013
;resP@pmLabelBarParallelPosF = -0.1
;resP@pmLabelBarWidthF    = 0.7

;resP@gsnPanelYWhiteSpacePercent  = 4.5

resP@gsnPanelMainString  = ""
;resP@gsnPanelMainString  = "TA SST ("+season+")"
resP@gsnPanelMainFontHeightF = 0.025
;resP@gsnPanelTop        = 0.735    ; only panel on lower half of page
;resP@gsnPanelXF         = (/0.10,0.52/)
;resP@pmLabelBarWidthF   = 0.8    ; label bar width
;resP@gsnPanelBottom     = 0.25    ; space for label bar
;resP@gsnPanelTop        = 1.0    ; only panel on lower half of page
;resP@gsnPanelLeft        = 0.085
;resP@gsnPanelRight       = 0.92
gsn_panel(wks,plot,(/2,1/),resP)     ; now draw as one plot
frame(wks)
print("sucessfully execute the program")
end
  
