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
`define hFrontPorch 128 //pix
`define hSync 200 //pix
`define hBackPorch 328 //pix
`define hLength 2576

`define vFrontPorch 3 //lines
`define vSync 5 //lines
`define vBackPorch 32 //lines
`define vLength 1120