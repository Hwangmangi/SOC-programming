proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  set_param xicom.use_bs_reader 1
  debug::add_scope template.lib 1
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part xilinx.com:zc702:part0:1.1 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir D:/work_edu/ch13_pl_cis/ch13_pl_cis.cache/wt [current_project]
  set_property parent.project_path D:/work_edu/ch13_pl_cis/ch13_pl_cis.xpr [current_project]
  set_property ip_repo_paths d:/work_edu/ch13_pl_cis/ch13_pl_cis.cache/ip [current_project]
  set_property ip_output_repo d:/work_edu/ch13_pl_cis/ch13_pl_cis.cache/ip [current_project]
  add_files -quiet D:/work_edu/ch13_pl_cis/ch13_pl_cis.runs/synth_1/top.dcp
  add_files -quiet D:/work_edu/ch13_pl_cis/ch13_pl_cis.runs/RAM_camera_synth_1/RAM_camera.dcp
  set_property netlist_only true [get_files D:/work_edu/ch13_pl_cis/ch13_pl_cis.runs/RAM_camera_synth_1/RAM_camera.dcp]
  read_xdc -mode out_of_context -ref RAM_camera -cells U0 d:/work_edu/ch13_pl_cis/ch13_pl_cis.srcs/sources_1/ip/RAM_camera/RAM_camera_ooc.xdc
  set_property processing_order EARLY [get_files d:/work_edu/ch13_pl_cis/ch13_pl_cis.srcs/sources_1/ip/RAM_camera/RAM_camera_ooc.xdc]
  read_xdc D:/work_edu/ch13_pl_cis/ch13_pl_cis.srcs/constrs_1/new/top.xdc
  link_design -top top -part xc7z020clg484-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force top_opt.dcp
  catch {report_drc -file top_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  write_checkpoint -force top_placed.dcp
  catch { report_io -file top_io_placed.rpt }
  catch { report_clock_utilization -file top_clock_utilization_placed.rpt }
  catch { report_utilization -file top_utilization_placed.rpt -pb top_utilization_placed.pb }
  catch { report_control_sets -verbose -file top_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force top_routed.dcp
  catch { report_drc -file top_drc_routed.rpt -pb top_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file top_timing_summary_routed.rpt -rpx top_timing_summary_routed.rpx }
  catch { report_power -file top_power_routed.rpt -pb top_power_summary_routed.pb }
  catch { report_route_status -file top_route_status.rpt -pb top_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force top.bit 
  if { [file exists D:/work_edu/ch13_pl_cis/ch13_pl_cis.runs/synth_1/top.hwdef] } {
    catch { write_sysdef -hwdef D:/work_edu/ch13_pl_cis/ch13_pl_cis.runs/synth_1/top.hwdef -bitfile top.bit -meminfo top.mmi -file top.sysdef }
  }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

