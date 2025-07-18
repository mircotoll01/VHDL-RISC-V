# Check file required for this script exists
proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/src/instr_fetch.vhd"]"\
 "[file normalize "$origin_dir/src/instr_decode.vhd"]"\
 "[file normalize "$origin_dir/src/instr_exec.vhd"]"\
 "[file normalize "$origin_dir/src/decoder.vhd"]"\
 "[file normalize "$origin_dir/src/ALU.vhd"]"\
 "[file normalize "$origin_dir/src/write_back.vhd"]"\
 "[file normalize "$origin_dir/src/instr_mem_init.coe"]"\
 "[file normalize "$origin_dir/src/comparator.vhd"]"\
 "[file normalize "$origin_dir/ip/register_file/register_file.xci"]"\
 "[file normalize "$origin_dir/ip/data_memory/data_mem.xci"]"\
 "[file normalize "$origin_dir/ip/instruction_memory/instruction_memory.xci"]"\
 "[file normalize "$origin_dir/sim/IF_testbench.vhd"]"\
 "[file normalize "$origin_dir/sim/ID_testbench.vhd"]"\
 "[file normalize "$origin_dir/sim/IE_testbench.vhd"]"\
 "[file normalize "$origin_dir/sim/WB_testbench.vhd"]"\
 "[file normalize "$origin_dir/src/datapath.vhd"]"\
 "[file normalize "$origin_dir/sim/ID_testbench.vhd"]"\
 "[file normalize "$origin_dir/sim/ID_testbench_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/ALU.vhd"]"\
 "[file normalize "$origin_dir/src/comparator.vhd"]"\
 "[file normalize "$origin_dir/src/decoder.vhd"]"\
 "[file normalize "$origin_dir/src/instr_decode.vhd"]"\
 "[file normalize "$origin_dir/src/instr_exec.vhd"]"\
 "[file normalize "$origin_dir/src/instr_fetch.vhd"]"\
 "[file normalize "$origin_dir/sim/IE_testbench.vhd"]"\
 "[file normalize "$origin_dir/sim/IE_testbench_behav.wcfg"]"\
 "[file normalize "$origin_dir/src/ALU.vhd"]"\
 "[file normalize "$origin_dir/src/comparator.vhd"]"\
 "[file normalize "$origin_dir/src/data_memory.vhd"]"\
 "[file normalize "$origin_dir/src/decoder.vhd"]"\
 "[file normalize "$origin_dir/src/instr_decode.vhd"]"\
 "[file normalize "$origin_dir/src/instr_exec.vhd"]"\
 "[file normalize "$origin_dir/src/instr_fetch.vhd"]"\
 "[file normalize "$origin_dir/src/write_back.vhd"]"\
 "[file normalize "$origin_dir/sim/WB_testbench.vhd"]"\
 "[file normalize "$origin_dir/src/datapath.vhd"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find remote file $ifile "
      set status false
    }
  }

  return $status
}
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir [file dirname [info script]]

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "VHDL-RISC-V"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "VHDL-RISC-V.tcl"

# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/VHDL-RISC-V"]"

# Check for paths and files needed for project creation
set validate_required 0
if { $validate_required } {
  if { [checkRequiredFiles $origin_dir] } {
    puts "Tcl file $script_file is valid. All files required for project creation is accesable. "
  } else {
    puts "Tcl file $script_file is not valid. Not all files required for project creation is accesable. "
    return
  }
}

# Create project
create_project ${_xil_proj_name_} $origin_dir/${_xil_proj_name_}

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
set_msg_config  -id {Synth 8-7080}  -suppress  -ruleid {10}  -source 16

# Set project properties
set obj [current_project]
set_property -name "board_part_repo_paths" -value "[file normalize "$origin_dir/../../../../../.Xilinx/Vivado/2024.1/xhub/board_store/xilinx_board_store"]" -objects $obj
set_property -name "board_part" -value "digilentinc.com:basys3:part0:1.2" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_resource_estimation" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "platform.board_id" -value "basys3" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "sim_compile_state" -value "1" -objects $obj
set_property -name "target_language" -value "VHDL" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "29" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "29" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "29" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "29" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "29" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "29" -objects $obj
set_property -name "webtalk.xsim_launch_sim" -value "151" -objects $obj
set_property -name "xpm_libraries" -value "XPM_MEMORY" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/src/instr_fetch.vhd"] \
 [file normalize "${origin_dir}/src/instr_decode.vhd"] \
 [file normalize "${origin_dir}/src/instr_exec.vhd"] \
 [file normalize "${origin_dir}/src/decoder.vhd"] \
 [file normalize "${origin_dir}/src/ALU.vhd"] \
 [file normalize "${origin_dir}/src/write_back.vhd"] \
 [file normalize "${origin_dir}/src/instr_mem_init.coe"] \
 [file normalize "${origin_dir}/src/comparator.vhd"] \
 [file normalize "${origin_dir}/ip/register_file/register_file.xci"] \
 [file normalize "${origin_dir}/ip/data_memory/data_mem.xci"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/src/instr_fetch.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/instr_decode.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/instr_exec.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/decoder.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/ALU.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/write_back.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/comparator.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/ip/register_file/register_file.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property -name "generate_synth_checkpoint" -value "0" -objects $file_obj
}
set_property -name "registered_with_manager" -value "1" -objects $file_obj

set file "$origin_dir/ip/data_memory/data_mem.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property -name "synth_checkpoint_mode" -value "Singular" -objects $file_obj
}


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "dataflow_viewer_settings" -value "min_width=16" -objects $obj
set_property -name "top" -value "instr_fetch" -objects $obj

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/ip/instruction_memory/instruction_memory.xci"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/ip/instruction_memory/instruction_memory.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property -name "synth_checkpoint_mode" -value "Singular" -objects $file_obj
}


# Set 'sources_1' fileset file properties for local files
# None

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Empty (no sources present)

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
set files [list \
 [file normalize "${origin_dir}/sim/IF_testbench.vhd"] \
 [file normalize "${origin_dir}/sim/ID_testbench.vhd"] \
 [file normalize "${origin_dir}/sim/IE_testbench.vhd"] \
 [file normalize "${origin_dir}/sim/WB_testbench.vhd"] \
 [file normalize "${origin_dir}/src/datapath.vhd"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sim_1' fileset file properties for remote files
set file "$origin_dir/sim/IF_testbench.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/sim/ID_testbench.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/sim/IE_testbench.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/sim/WB_testbench.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/datapath.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj


# Set 'sim_1' fileset file properties for local files
# None

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "IF_testbench" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'sim_2' fileset (if not found)
if {[string equal [get_filesets -quiet sim_2] ""]} {
  create_fileset -simset sim_2
}

# Set 'sim_2' fileset object
set obj [get_filesets sim_2]
set files [list \
 [file normalize "${origin_dir}/sim/ID_testbench.vhd"] \
 [file normalize "${origin_dir}/sim/ID_testbench_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sim_2' fileset file properties for remote files
set file "$origin_dir/sim/ID_testbench.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_2] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj


# Set 'sim_2' fileset file properties for local files
# None

# Set 'sim_2' fileset properties
set obj [get_filesets sim_2]
set_property -name "top" -value "ID_testbench" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'sim_3' fileset (if not found)
if {[string equal [get_filesets -quiet sim_3] ""]} {
  create_fileset -simset sim_3
}

# Set 'sim_3' fileset object
set obj [get_filesets sim_3]
set files [list \
 [file normalize "${origin_dir}/src/ALU.vhd"] \
 [file normalize "${origin_dir}/src/comparator.vhd"] \
 [file normalize "${origin_dir}/src/decoder.vhd"] \
 [file normalize "${origin_dir}/src/instr_decode.vhd"] \
 [file normalize "${origin_dir}/src/instr_exec.vhd"] \
 [file normalize "${origin_dir}/src/instr_fetch.vhd"] \
 [file normalize "${origin_dir}/sim/IE_testbench.vhd"] \
 [file normalize "${origin_dir}/sim/IE_testbench_behav.wcfg"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sim_3' fileset file properties for remote files
set file "$origin_dir/src/ALU.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_3] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/comparator.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_3] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/decoder.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_3] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/instr_decode.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_3] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/instr_exec.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_3] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/instr_fetch.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_3] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/sim/IE_testbench.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_3] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj


# Set 'sim_3' fileset file properties for local files
# None

# Set 'sim_3' fileset properties
set obj [get_filesets sim_3]
set_property -name "top" -value "IE_testbench" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'sim_4' fileset (if not found)
if {[string equal [get_filesets -quiet sim_4] ""]} {
  create_fileset -simset sim_4
}

# Set 'sim_4' fileset object
set obj [get_filesets sim_4]
set files [list \
 [file normalize "${origin_dir}/src/ALU.vhd"] \
 [file normalize "${origin_dir}/src/comparator.vhd"] \
 [file normalize "${origin_dir}/src/data_memory.vhd"] \
 [file normalize "${origin_dir}/src/decoder.vhd"] \
 [file normalize "${origin_dir}/src/instr_decode.vhd"] \
 [file normalize "${origin_dir}/src/instr_exec.vhd"] \
 [file normalize "${origin_dir}/src/instr_fetch.vhd"] \
 [file normalize "${origin_dir}/src/write_back.vhd"] \
 [file normalize "${origin_dir}/sim/WB_testbench.vhd"] \
 [file normalize "${origin_dir}/src/datapath.vhd"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sim_4' fileset file properties for remote files
set file "$origin_dir/src/ALU.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/comparator.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/data_memory.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/decoder.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/instr_decode.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/instr_exec.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/instr_fetch.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/write_back.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/sim/WB_testbench.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj

set file "$origin_dir/src/datapath.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_4] [list "*$file"]]
set_property -name "file_type" -value "VHDL 2019" -objects $file_obj


# Set 'sim_4' fileset file properties for local files
# None

# Set 'sim_4' fileset properties
set obj [get_filesets sim_4]
set_property -name "top" -value "WB_testbench" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Set 'utils_1' fileset object
set obj [get_filesets utils_1]
# Empty (no sources present)

# Set 'utils_1' fileset properties
set obj [get_filesets utils_1]

set idrFlowPropertiesConstraints ""
catch {
 set idrFlowPropertiesConstraints [get_param runs.disableIDRFlowPropertyConstraints]
 set_param runs.disableIDRFlowPropertyConstraints 1
}

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7a35tcpg236-1 -flow {Vivado Synthesis 2024} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2024" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_1_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_1_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_1
}
set obj [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0]
if { $obj != "" } {

}
set obj [get_runs synth_1]
set_property -name "auto_incremental_checkpoint" -value "1" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7a35tcpg236-1 -flow {Vivado Implementation 2024} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2024" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'impl_1_init_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_init_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps init_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_opt_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_drc_0 -report_type report_drc:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_place_report_io_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0] "" ] } {
  create_report_config -report_name impl_1_place_report_io_0 -report_type report_io:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0] "" ] } {
  create_report_config -report_name impl_1_place_report_utilization_0 -report_type report_utilization:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_control_sets_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0] "" ] } {
  create_report_config -report_name impl_1_place_report_control_sets_0 -report_type report_control_sets:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0]
if { $obj != "" } {
set_property -name "options.verbose" -value "1" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_1' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_1 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_place_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_post_place_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_place_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_place_power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_route_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_route_report_drc_0 -report_type report_drc:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_methodology_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0] "" ] } {
  create_report_config -report_name impl_1_route_report_methodology_0 -report_type report_methodology:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_power_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0] "" ] } {
  create_report_config -report_name impl_1_route_report_power_0 -report_type report_power:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_route_status_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0] "" ] } {
  create_report_config -report_name impl_1_route_report_route_status_0 -report_type report_route_status:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_route_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0]
if { $obj != "" } {
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_route_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_route_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_clock_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0] "" ] } {
  create_report_config -report_name impl_1_route_report_clock_utilization_0 -report_type report_clock_utilization:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_route_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0]
if { $obj != "" } {
set_property -name "options.warn_on_violation" -value "1" -objects $obj

}
# Create 'impl_1_post_route_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "1" -objects $obj

}
# Create 'impl_1_post_route_phys_opt_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0]
if { $obj != "" } {
set_property -name "options.warn_on_violation" -value "1" -objects $obj

}
set obj [get_runs impl_1]
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]
catch {
 if { $idrFlowPropertiesConstraints != {} } {
   set_param runs.disableIDRFlowPropertyConstraints $idrFlowPropertiesConstraints
 }
}

puts "INFO: Project created:${_xil_proj_name_}"
# Create 'drc_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "drc_1" ] ] ""]} {
create_dashboard_gadget -name {drc_1} -type drc
}
set obj [get_dashboard_gadgets [ list "drc_1" ] ]
set_property -name "reports" -value "impl_1#impl_1_route_report_drc_0" -objects $obj

# Create 'methodology_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "methodology_1" ] ] ""]} {
create_dashboard_gadget -name {methodology_1} -type methodology
}
set obj [get_dashboard_gadgets [ list "methodology_1" ] ]
set_property -name "reports" -value "impl_1#impl_1_route_report_methodology_0" -objects $obj

# Create 'power_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "power_1" ] ] ""]} {
create_dashboard_gadget -name {power_1} -type power
}
set obj [get_dashboard_gadgets [ list "power_1" ] ]
set_property -name "reports" -value "impl_1#impl_1_route_report_power_0" -objects $obj

# Create 'timing_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "timing_1" ] ] ""]} {
create_dashboard_gadget -name {timing_1} -type timing
}
set obj [get_dashboard_gadgets [ list "timing_1" ] ]
set_property -name "reports" -value "impl_1#impl_1_route_report_timing_summary_0" -objects $obj

# Create 'utilization_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "utilization_1" ] ] ""]} {
create_dashboard_gadget -name {utilization_1} -type utilization
}
set obj [get_dashboard_gadgets [ list "utilization_1" ] ]
set_property -name "reports" -value "synth_1#synth_1_synth_report_utilization_0" -objects $obj
set_property -name "run.step" -value "synth_design" -objects $obj
set_property -name "run.type" -value "synthesis" -objects $obj

# Create 'utilization_2' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "utilization_2" ] ] ""]} {
create_dashboard_gadget -name {utilization_2} -type utilization
}
set obj [get_dashboard_gadgets [ list "utilization_2" ] ]
set_property -name "reports" -value "impl_1#impl_1_place_report_utilization_0" -objects $obj

move_dashboard_gadget -name {utilization_1} -row 0 -col 0
move_dashboard_gadget -name {power_1} -row 1 -col 0
move_dashboard_gadget -name {drc_1} -row 2 -col 0
move_dashboard_gadget -name {timing_1} -row 0 -col 1
move_dashboard_gadget -name {utilization_2} -row 1 -col 1
move_dashboard_gadget -name {methodology_1} -row 2 -col 1
