
begin
fcor = 5.0e-5
plot = new(8,"graphic")
base = new(8,"graphic")
ij_location = new((/2,2/),integer)
level_string=ispan(1010,100,5)
RMW_line0 = new(dimsizes(level_string),"graphic")
RMW_line1 = new(dimsizes(level_string),"graphic")
RMW_line2 = new(dimsizes(level_string),"graphic")
RMW_line3 = new(dimsizes(level_string),"graphic")
RMW_line4 = new(dimsizes(level_string),"graphic")
RMW_line5 = new(dimsizes(level_string),"graphic")
RMW_line6 = new(dimsizes(level_string),"graphic")
RMW_line7 = new(dimsizes(level_string),"graphic")
RMW_line8 = new(dimsizes(level_string),"graphic")

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
wks = gsn_open_wks("pdf",case_name+"/draw/figure/"+domain_name+"_AAM_vertical_profile_"+i_time)

;==========================start outputing data====================================================================
output_file = case_name+"/draw/test_data/"+domain_name+"_vertical_profile_AAM_"+i_time_list(i_time_iterator)+".nc"
f2 = addfile(output_file, "r")
w_plot = f2->w_plot
w_plot_scale = f2->w_plot_scale
wind_rad_plot = f2->wind_rad_plot
wind_tan_plot = f2->wind_tan_plot
windspeed_plot = f2->windspeed_plot
AAM_plot= f2->AAM_plot
MV=f2->MV 
MH=f2->MH
;=f2->  

profile_range = 100
average_range = 1
dx_dy = 2


res                 = True  
res@gsnLeftString	  = i_time+":00"
res@tmXBOn		  = True
res@tmXBMode		  = "Explicit"
res@tmXBValues		  = ispan(0,profile_range,25)
res@tmXBLabels		  = res@tmXBValues*dx_dy
res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
res@pmLabelBarOrthogonalPosF = -0.05
res@cnFillPalette        = "temp_19lev"
res@trYLog		  = False
res@tmYRTickSpacingF = 2.0 
res@tmYLTickSpacingF = 100. 

refmag = 4.0
res@vcRefAnnoOn = True
res@vcRefMagnitudeF = refmag                ; define vector ref mag
res@vcRefAnnoString1 = refmag+" m/s"
res@vcRefLengthF    = 0.015              ; define length of vec ref
res@vcMinDistanceF  = 0.03               ; thin out vectors
res@vcMapDirection  = False
res@gsnPresHgtHeightLabelOn = False
res@vcLineArrowColor = "grey58" ;violetred4
res@cnLevelSelectionMode  = "ExplicitLevels" ; set manual contour levels

res@gsnDraw         = False
res@gsnFrame        = False
res@vcGlyphStyle    = "LineArrow"      ; turn on curly vectors
res@vcLineArrowHeadMaxSizeF = 0.01
;res@vcLineArrowHeadMinSizeF = 0.005

;res@vcGlyphStyle    = "FillArrow"
;res@vcLineArrowThicknessF   = 1.5               ; change vector thickness
;res@vcVectorDrawOrder       = "Draw";"PostDraw"        ; draw vectors last
;res@vcMinDistanceF          = 0.025 ;0.01 ;0.03
;res@vcMinMagnitudeF         = 0.1
;res@vcFillArrowHeadInteriorXF = 0.25
;res@vcFillArrowHeadXF         = 0.6
;res@vcFillArrowHeadYF         = 0.2
;res@vcFillArrowWidthF         = 0.1


res@cnFillOn      = False                  
res@cnLinesOn     = True  
res@cnLineLabelsOn = True
res@cnLineLabelFontHeightF = 0.010
res@cnLineLabelInterval    = 1
res@cnConstFLabelConstantSpacingF = 0.0
res@cnInfoLabelOn	   = False
res@cnLineLabelPerimOn 		= False
res@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
res@cnLineLabelAngleF = 0.0
res@cnLineLabelBackgroundColor = "white"
res@cnMonoLevelFlag = False
res@cnLevelFlags= "LineAndLabel"
res@cnLineLabelPlacementMode = "Constant"
;res@cnLineLabelPlacementMode  = "Computed"
;res@cnLineLabelDensityF	      = 0.5

res@vcRefAnnoString2On = False
res@gsnPresHgtHeightLabelOn   = False
res@tmYLMode = "Explicit"
res@tmYLValues = ispan(1000,100,100)
res@tmYLLabelsOn = True
res@tmYLLabels = ispan(1000,100,100)
;res@cnFillColors	  = ispan(3,19,1)

;;;add filling missing values
res1                 = True  
res1@gsnDraw         = False
res1@gsnFrame        = False
res1@cnFillOn      = True                  
res1@cnLinesOn     = False 
res1@cnLevelSelectionMode  = "ExplicitLevels" ; set manual contour levels
res1@cnLevels              = (/-8.0,-4.0/)
res1@cnFillColors          = (/-1,-1,-1/)
res1@cnFillMode		  = "AreaFill"
res1@cnMissingValFillColor = "gray76"
res1@gsnRightString        = ""
res1@gsnLeftString        = ""
res1@lbLabelBarOn	  = False
res1@cnInfoLabelOn	   = False
res1@gsnPresHgtHeightLabelOn   = False

plres = True
plres@gsLineColor = "red4"   ; Set the line color.
plres@gsLineThicknessF = 2.0
plres@gsLineDashPattern = 0
;plres@gsLineThickness = 4.0

res@cnLevels              := (/-8.0,-4.0,-2.0,2.0,4.0,8.0/)
res@cnFillColors          := (/7,8,9,-1,12,13,14/)
;res@cnMinLevelValF        = -6.0        ; set min contour level
;res@cnLevelSpacingF       =  1.0          ; set contour interval
;res@cnMaxLevelValF        =  6.0         ; set max contour level                

res@gsnRightString        = "radial wind (m/s)"


plot(6)  = gsn_csm_pres_hgt_vector(wks, wind_rad_plot,wind_rad_plot,w_plot_scale, res) 
base(6) = gsn_csm_pres_hgt(wks,wind_rad_plot,res1)
overlay(plot(6),base(6))

;==========================add maximum windspeed line==================================================================================================================================
level_string=ispan(1010,100,5)
do i_level=0,dimsizes(level_string)-3,1
	RMW_line0(i_level) = gsn_add_polyline(wks,plot(6),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),plres)
end do
;==========================add maximum windspeed line==================================================================================================================================


res@cnLevels              := (/-1.2,-1.0,-0.6,-0.2,0.2,0.6,1.0,1.2/)
res@cnFillColors          := (/6,7,8,9,-1,12,13,14,15/)
;res@cnMinLevelValF        = -1.2        ; set min contour level
;res@cnLevelSpacingF       =  0.2          ; set contour interval
;res@cnMaxLevelValF        =  1.2         ; set max contour level                

res@gsnRightString        = "w (m/s)"
plot(7)  = gsn_csm_pres_hgt_vector(wks, w_plot ,wind_rad_plot,w_plot_scale, res) 
base(7) = gsn_csm_pres_hgt(wks,wind_rad_plot,res1)
overlay(plot(7),base(7))
;==========================add maximum windspeed line==================================================================================================================================
level_string=ispan(1010,100,5)
do i_level=0,dimsizes(level_string)-3,1
	RMW_line1(i_level) = gsn_add_polyline(wks,plot(7),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),plres)
end do
;==========================add maximum windspeed line==================================================================================================================================



res@cnLevels              := (/10,20,30,40,50,60/)
res@cnFillColors          := (/-1,12,13,14,15,16,17/)
;res@cnMinLevelValF        = 5.        ; set min contour level
;res@cnLevelSpacingF       = 5.          ; set contour interval
;res@cnMaxLevelValF        = 60.         ; set max contour level                

res@gsnRightString        = "tangential wind (m/s)"

plot(5)  = gsn_csm_pres_hgt_vector(wks, wind_tan_plot,wind_rad_plot,w_plot_scale, res) 
base(5) = gsn_csm_pres_hgt(wks,wind_rad_plot,res1)
overlay(plot(5),base(5))

;==========================add maximum windspeed line==================================================================================================================================
level_string=ispan(1010,100,5)
do i_level=0,dimsizes(level_string)-3,1
	RMW_line2(i_level) = gsn_add_polyline(wks,plot(5),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),plres)
end do
;==========================add maximum windspeed line==================================================================================================================================


res@cnLevels              := (/10,15,20,25,30,35,40/)
res@cnFillColors          := (/-1,12,13,14,15,16,17,18/)
;res@cnMinLevelValF        = 2.        ; set min contour level
;res@cnLevelSpacingF       = 2.          ; set contour interval
;res@cnMaxLevelValF        = 40.         ; set max contour level                
res@gsnRightString        = "AAM (/10^5 m^2 s^(-1))"

plot(0)  = gsn_csm_pres_hgt_vector(wks,AAM_plot,wind_rad_plot,w_plot_scale,res)
base(0) = gsn_csm_pres_hgt(wks,wind_rad_plot,res1)
overlay(plot(0),base(0))
;==========================add maximum windspeed line==================================================================================================================================
level_string=ispan(1010,100,5)
do i_level=0,dimsizes(level_string)-3,1
	RMW_line3(i_level) = gsn_add_polyline(wks,plot(0),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),plres)
end do
;==========================add maximum windspeed line==================================================================================================================================


;;===========================count the MH of AAM========================================================
printMinMax(MH,0)
res@cnLevels              := (/-40,-30,-20,-10,-5.0,-2.5,2.5,5.0,10,20,30,40/)
res@cnFillColors          := (/4,5,6,7,8,9,-1,12,13,14,15,16,17/)
res@gsnRightString        = "MH (10^5 m^2 s^(-1) h^(-1))"

plot(2)  = gsn_csm_pres_hgt_vector(wks,MH,wind_rad_plot,w_plot_scale,res)
base(2) = gsn_csm_pres_hgt(wks,wind_rad_plot,res1)
overlay(plot(2),base(2))
;==========================add maximum windspeed line==================================================================================================================================
level_string=ispan(1010,100,5)
do i_level=0,dimsizes(level_string)-3,1
	RMW_line4(i_level) = gsn_add_polyline(wks,plot(2),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),plres)
end do
;==========================add maximum windspeed line==================================================================================================================================

printMinMax(MV,0)
;res@cnLevels              := (/-2.0,-1.8,-1.6,-1.4,-1.2,-1.0,1.0,1.2,1.4,1.6,1.8,2.0/)
;res@cnFillColors          := (/4,5,6,7,8,9,-1,12,13,14,15,16,17/)
res@gsnRightString        = "MV (10^5 m^2 s^(-1) h^(-1))" 

plot(3)  = gsn_csm_pres_hgt_vector(wks,MV,wind_rad_plot,w_plot_scale,res)
base(3) = gsn_csm_pres_hgt(wks,wind_rad_plot,res1)
overlay(plot(3),base(3))
;==========================add maximum windspeed line==================================================================================================================================
level_string=ispan(1010,100,5)
do i_level=0,dimsizes(level_string)-3,1
	RMW_line5(i_level) = gsn_add_polyline(wks,plot(3),(/maxind(windspeed_plot(i_level,:)),maxind(windspeed_plot(i_level+1,:))/),(/level_string(i_level),level_string(i_level+1)/),plres)
end do
;==========================add maximum windspeed line==================================================================================================================================






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
gsn_panel(wks,(/plot(7),plot(6),plot(5),plot(0),plot(3),plot(2)/), (/3,2/), resP)
frame(wks)

;gsn_panel(wks,(/plot(4),plot(2),plot(3),plot(1)/), (/2,2/), resP)
;frame(wks)


print_clock("sucessfully draw the figure")
;delete(plot(7))
end do


end 
