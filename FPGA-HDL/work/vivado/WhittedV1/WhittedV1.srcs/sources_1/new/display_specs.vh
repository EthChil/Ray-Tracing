//1920 x 1080 specs
//pixel clock 173Mhz
//horizontal
//front porch .74us 128px
//sync 1.156us 200px
//back porch 1.896us 328px
//
//vertical
//front porch 44.671us 3 lines (7728px)
//sync 74.451us 5 lines (12880px)
//back porch 476.486us 32 lines (82432px)

//VGA constants

`define s720
//`define s1080
//`define s900

//720p
`ifdef s720 //pixel clock 74.5mhz @ 60hz, 60.5mhz @ 50hz
    `define hView 1280 
    `define hOffsetIndex 1
    `define hFrontPorch 64 //pix
    `define hSync 128 //pix
    `define hBackPorch 192 //pix
    `define hLength ((`hView + `hSync + `hBackPorch + `hFrontPorch) - `hOffsetIndex) //1919 since vertical starts at 0
    `define hSyncEnd ((`hLength - `hBackPorch) - `hOffsetIndex)//2248
    `define hSyncStart ((`hLength - (`hBackPorch + `hSync)) - `hOffsetIndex) //2048
    
    `define vView 720
    `define vOffsetIndex 1
    `define vFrontPorch 3 //lines
    `define vSync 5 //lines
    `define vBackPorch 20 //lines
    `define vLength ((`vView + `vSync + `vBackPorch + `vFrontPorch) - `hOffsetIndex) //1119
    `define vSyncEnd ((`vLength - `vBackPorch) - `hOffsetIndex) //1087
    `define vSyncStart ((`vLength - (`vBackPorch + `vSync)) - `hOffsetIndex) //1082
`endif

`ifdef s1080 //pixel clock 173mhz @ 60hz, 141mhz @ 50hz
    `define hView 1920
    `define hOffsetIndex 1
    `define hFrontPorch 128 //pix
    `define hSync 200 //pix
    `define hBackPorch 328 //pix
    `define hLength ((`hView + `hSync + `hBackPorch + `hFrontPorch) - `hOffsetIndex) //1919 since vertical starts at 0
    `define hSyncEnd ((`hLength - `hBackPorch) - `hOffsetIndex)//2248
    `define hSyncStart ((`hLength - (`hBackPorch + `hSync)) - `hOffsetIndex) //2048
    
    `define vView 1080
    `define vOffsetIndex 1
    `define vFrontPorch 3 //lines
    `define vSync 5 //lines
    `define vBackPorch 32 //lines
    `define vLength ((`vView + `vSync + `vBackPorch + `vFrontPorch) - `hOffsetIndex) //1119
    `define vSyncEnd ((`vLength - `vBackPorch) - `hOffsetIndex) //1087
    `define vSyncStart ((`vLength - (`vBackPorch + `vSync)) - `hOffsetIndex) //1082
`endif

`ifdef s900 //pixel clock 96.5mhz @ 50hz
    `define hView 1600
    `define hOffsetIndex 1
    `define hFrontPorch 80 //pix
    `define hSync 160 //pix
    `define hBackPorch 240 //pix
    `define hLength ((`hView + `hSync + `hBackPorch + `hFrontPorch) - `hOffsetIndex) //1919 since vertical starts at 0
    `define hSyncEnd ((`hLength - `hBackPorch) - `hOffsetIndex)//2248
    `define hSyncStart ((`hLength - (`hBackPorch + `hSync)) - `hOffsetIndex) //2048
    
    `define vView 900
    `define vOffsetIndex 1
    `define vFrontPorch 3 //lines
    `define vSync 5 //lines
    `define vBackPorch 21 //lines
    `define vLength ((`vView + `vSync + `vBackPorch + `vFrontPorch) - `hOffsetIndex) //1119
    `define vSyncEnd ((`vLength - `vBackPorch) - `hOffsetIndex) //1087
    `define vSyncStart ((`vLength - (`vBackPorch + `vSync)) - `hOffsetIndex) //1082
`endif

