# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.runs/synth_1/.Xil/Vivado-18320-Tony-Maloney/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    rt::set_parameter datapathDensePacking false
    set rt::partid xc7a35tftg256-1
     file delete -force synth_hints.os

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common_vhdl.tcl
    set rt::defaultWorkLibName xil_defaultlib

    # Skipping read_* RTL commands because this is post-elab optimize flow
    set rt::useElabCache true
    if {$rt::useElabCache == false} {
      rt::read_verilog -sv -include {
    {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.srcs/sources_1/new}
    {c:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.srcs/sources_1/ip/clk_wiz_0}
  } {
      {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.srcs/sources_1/new/RayTracer.v}
      {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.srcs/sources_1/new/VGADriver.v}
      {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.srcs/sources_1/imports/verilog/au_top_0.v}
      {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.srcs/sources_1/new/Top.v}
      I:/Xilinx/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv
    }
      rt::read_verilog -include {
    {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.srcs/sources_1/new}
    {c:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.srcs/sources_1/ip/clk_wiz_0}
  } {
      {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.runs/synth_1/.Xil/Vivado-18320-Tony-Maloney/realtime/mig_7series_0_stub.v}
      {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.runs/synth_1/.Xil/Vivado-18320-Tony-Maloney/realtime/clk_wiz_0_stub.v}
    }
      rt::read_vhdl -lib xpm I:/Xilinx/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification true
    set rt::SDCFileList {{C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.runs/synth_1/.Xil/Vivado-18320-Tony-Maloney/realtime/Top_synth.xdc}}
    rt::sdcChecksum
    set rt::top Top
    rt::set_parameter enableIncremental true
    rt::set_parameter markDebugPreservationLevel "enable"
    set rt::reportTiming false
    rt::set_parameter elaborateOnly false
    rt::set_parameter elaborateRtl false
    rt::set_parameter eliminateRedundantBitOperator true
    rt::set_parameter elaborateRtlOnlyFlow false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter ramStyle auto
    rt::set_parameter merge_flipflops true
# MODE: 
    rt::set_parameter webTalkPath {C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.cache/wt}
    rt::set_parameter synthDebugLog false
    rt::set_parameter printModuleName false
    rt::set_parameter enableSplitFlowPath "C:/Users/ethan/Documents/GitHub/Ray-Tracing/FPGA HDL/work/vivado/WhittedV1/WhittedV1.runs/synth_1/.Xil/Vivado-18320-Tony-Maloney/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_synthesis -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    rt::HARTNDb_reportJobStats "Synthesis Optimization Runtime"
    rt::HARTNDb_stopSystemStats
    if { $rt::flowresult == 1 } { return -code error }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}
