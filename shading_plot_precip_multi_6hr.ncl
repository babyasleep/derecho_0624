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
initial_center = 50
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
refmag = 8 
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

domain_name = "d03"
g_time = (/"01_01","01_06", "01_12", "01_18", \
	   "02_00", "02_06", "02_12", "02_18", \
	   "03_00", "03_06", "03_12", "03_18", \
	   "04_00", "04_06", "04_12", "04_18", \
	   "05_00", "05_06", "05_12", "05_18", \
	   "06_00", "06_06", "06_12", "06_18","06_23"/)

case_name = "em_tropical_cyclone"
;path ="/glade/work/cjiaxin/test_wrf/idealize/longer-full-ideal/test/em_tropical_cyclone/draw/test_data/wrfout_d01_0001-01-*"
;path ="/glade/work/cjiaxin/test_wrf/idealize/longer-full-ideal/test/em_tropical_cyclone/wrfout_d01_0001-01-*"

outfile =case_name+"/draw/figure/"+domain_name+"_surface_level_plot_6hr"
wks1 = gsn_open_wks("pdf",outfile+"_slp") 
wks2 = gsn_open_wks("pdf",outfile+"_rainnc") 
wks3 = gsn_open_wks("pdf",outfile+"_wind") 
gsn_define_colormap(wks1,"precip2_17lev")
gsn_define_colormap(wks2,"precip2_17lev")
gsn_define_colormap(wks3,"precip2_17lev")

dim= dimsizes(g_time)
lat_location = new(dim,integer)
lon_location = new(dim,integer)
plot = new(dim,"graphic")
plot1 = new(dim,"graphic")
plot2 = new(dim,"graphic")
plot3 = new(dim,"graphic")
dum1 = new(dim,"graphic")
dum2 = new(dim,"graphic")

;do i_time=10,11,1
do i_time=0,dimsizes(g_time)-1,1
path = case_name+"/wrfout_"+domain_name+"_0001-01-"+g_time(i_time)+":00:00"

files = systemfunc("ls "+path)  
a = addfiles(files,"r")
it   = 0
msl_in  = wrf_user_getvar(a,"slp",it)   ; sea level pressure
mdbz_in = wrf_user_getvar(a,"mdbz",it)
uvmet10_in = wrf_user_getvar(a,"uvmet10",it)
umet10_in = uvmet10_in(0,:,:)
vmet10_in = uvmet10_in(1,:,:)
times = wrf_user_list_times(a)
dim = dimsizes(times)


;RAINNC_in = wrf_user_getvar(a,"RAINNC",it)
;RAINC_in = wrf_user_getvar(a,"RAINC",it) ;all zero
;RAINSH_in = wrf_user_getvar(a,"RAINSH",it) ;all zero
;
;RAIN_in = RAINNC_in+RAINC_in+RAINSH_in
;;RAIN_in = RAINNC_in
;
;mdbz_in = RAIN_in
;
;  do i_dim=0,dim-2,1
;    mdbz_in(i_dim+1,:,:) = RAIN_in(i_dim+1,:,:)-RAIN_in(i_dim,:,:)
;  end do




      msl :=msl_in(:,:)
    mdbz  :=mdbz_in(:,:)
umet10 :=umet10_in(:,:)
vmet10 :=vmet10_in(:,:)
    uvmet10 = wind_speed(umet10, vmet10)

;lat_in = wrf_user_getvar(a,"XLAT",it)
;lon_in = wrf_user_getvar(a,"XLONG",it)
;lat=lat_in(0,:,:)
;lon=lon_in(0,:,:)
;printVarSummary(lat)


    ;printVarSummary(msl)
    ;printMinMax(msl,0)
    
    initialw_center = 25
    start_point  = 249-initial_center
    end_point = 249+initial_center
    umet10_in_count :=umet10_in(start_point:end_point,start_point:end_point)
    vmet10_in_count :=vmet10_in(start_point:end_point,start_point:end_point)
    uvmet10_in_count = wind_speed(umet10_in_count,vmet10_in_count)
    mdbz_in_count :=mdbz_in(start_point:end_point,start_point:end_point)
    TC_area = where(mdbz_in_count.gt. 0.0, uvmet10_in_count@_FillValue, uvmet10_in_count)
    dims = wimsizes(TC_area(:,:)) 
    ij= ind_resolve(minind(ndtooned(TC_area(:,:))),dims(0:1))
    lat_location(i_time) = ij(0,0)+start_point
    lon_location(i_time) = ij(0,1)+start_point
;print(lat_location(i_time))
;print(lon_location(i_time))
;exit


;   start ploting slp  
    res@gsnLeftString   = g_time(i_time)   
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnFillColors :=ispan(16,1,1)
    res@cnMinLevelValF        = 986.    ; set min contour level          
    res@cnLevelSpacingF       = 4.    ; set contour interval           
    res@cnMaxLevelValF        = 1010.      ; set max contour level                
    plot(i_time) = gsn_csm_contour(wks1,msl(lat_location(i_time)-initial_center:lat_location(i_time)+initial_center,lon_location(i_time)-initial_center:lon_location(i_time)+initial_center),res)
   ;plot@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks1,plot(i_time),lon_location(i_time),lat_location(i_time),polyres)
;998.5  
;1.0    
;1012.5 

;   start ploting mdbz 
    printMinMax(mdbz,0) 
    res@gsnLeftString   = g_time(i_time)   
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnFillColors :=ispan(0,16,1)
    res@cnMinLevelValF        = 10.        ; set min contour level
    res@cnLevelSpacingF       = 3.          ; set contour interval
    res@cnMaxLevelValF        = 46.         ; set max contour level                
    plot1(i_time) = gsn_csm_contour(wks2,mdbz(lat_location(i_time)-initial_center:lat_location(i_time)+initial_center,lon_location(i_time)-initial_center:lon_location(i_time)+initial_center),res)
   plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks2,plot1(i_time),initial_center,initial_center,polyres1)
    ;plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks2,plot1(i_time),lon_location(i_time),lat_location(i_time),polyres)
    ;dum1(i_time)=gsn_add_polyline (wks2, plot1(i_time), (/0,100/),(/50,50/), gres)
    ;dum2(i_time)=gsn_add_polyline (wks2, plot1(i_time), (/50,50/),(/0,100/), gres)

;   start ploting windspeed in 10m  
    res@gsnLeftString   = g_time(i_time)   
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnFillColors :=ispan(1,16,1)
    res@cnMinLevelValF        = 8.        ; set min contour level
    res@cnLevelSpacingF       = 4.          ; set contour interval
    res@cnMaxLevelValF        = 56.         ; set max contour level                
    plot2(i_time) = gsn_csm_contour(wks3,uvmet10(lat_location(i_time)-initial_center:lat_location(i_time)+initial_center,lon_location(i_time)-initial_center:lon_location(i_time)+initial_center),res)
   plot2@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks3,plot2(i_time),initial_center,initial_center,polyres1)
    ;plot2@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks3,plot2(i_time),lon_location(i_time),lat_location(i_time),polyres)

    plot3(i_time) = gsn_csm_vector(wks3,umet10(lat_location(i_time)-initial_center:lat_location(i_time)+initial_center,lon_location(i_time)-initial_center:lon_location(i_time)+initial_center),vmet10(lat_location(i_time)-initial_center:lat_location(i_time)+initial_center,lon_location(i_time)-initial_center:lon_location(i_time)+initial_center),resv)
    overlay(plot2(i_time), plot3(i_time))
    overlay(plot(i_time), plot3(i_time))


end do

print("starting panel")
resP@gsnPanelMainString  = "SLP"
grid_number = 5
x_grid = grid_number
y_grid = grid_number
gsn_panel(wks1, plot, (/x_grid,y_grid/), resP)
frame(wks1)

resP@gsnPanelMainString  = "mdbz"
gsn_panel(wks2, plot1, (/x_grid,y_grid/), resP)
frame(wks2)

resP@gsnPanelMainString  = "wind speed (10m)"
gsn_panel(wks3, plot2, (/x_grid,y_grid/), resP)
frame(wks3)

print("End drawing")
end
  
