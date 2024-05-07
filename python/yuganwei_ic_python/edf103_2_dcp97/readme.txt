check file gen_synplify_project "synplify_edf_path" whether correct
check file gen_synplify_project "top_module" whether correct

1. modify iccode2edf_96.sh , change filelist path

2. run edf96_2_dcp96

3. check vivado link_design log, pay attention to critical warning and error information ,
and determine whether edf and link_design are normal

