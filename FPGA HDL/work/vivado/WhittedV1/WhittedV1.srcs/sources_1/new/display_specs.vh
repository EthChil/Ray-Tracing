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

`define hOffsetIndex 0
`define hFrontPorch 128 //pix
`define hSync 200 //pix
`define hBackPorch 328 //pix
`define hLength ((1920 + `hSync + `hBackPorch + `hFrontPorch) - `hOffsetIndex) //1919 since vertical starts at 0
`define hSyncEnd ((`hLength - `hBackPorch) - `hOffsetIndex)//2248
`define hSyncStart ((`hLength - (`hBackPorch + `hSync)) - `hOffsetIndex) //2048

`define vOffsetIndex 1
`define vFrontPorch 3 //lines
`define vSync 5 //lines
`define vBackPorch 32 //lines
`define vLength ((1080 + `vSync + `vBackPorch + `vFrontPorch) - `hOffsetIndex) //1119
`define vSyncEnd ((`vLength - `vBackPorch) - `hOffsetIndex) //1087
`define vSyncStart ((`vLength - (`vBackPorch + `vSync)) - `hOffsetIndex) //1082