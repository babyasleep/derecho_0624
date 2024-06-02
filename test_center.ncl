 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"


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
;path =case_name+"/wrfout_d01_0001-01-*"
path =case_name+"/wrfout_d01_0001-01-01_0[0-9]:00:00"
files = systemfunc("ls "+path)  
a = addfiles(files,"r")
it   = -1
msl_in  = wrf_user_getvar(a,"slp",it)   ; sea level pressure
uvmet10_in = wrf_user_getvar(a,"uvmet10",it)
umet10_in = uvmet10_in(0,:,:,:)
vmet10_in = uvmet10_in(1,:,:,:)
times = wrf_user_list_times(a)
dim = dimsizes(times)


;printVarSummary(lat)
dim= dimsizes(times)
lat_location = new(dim,float)
lon_location = new(dim,float)
plot = new(dim,"graphic")
plot1 = new(dim,"graphic")
plot2 = new(dim,"graphic")
plot3 = new(dim,"graphic")
dum1 = new(dim,"graphic")
dum2 = new(dim,"graphic")

do i_time=0,1,1
    msl = msl_in(i_time,:,:)

    ;printVarSummary(msl)
    ;printMinMax(msl,0)
    
    ;TC_area = msl
    TC_area = msl
    dims = dimsizes(TC_area(:,:)) 
    ij= ind_resolve(minind(ndtooned(TC_area(:,:))),dims(0:1))
    print(ij)
    exit
end do
end
  
