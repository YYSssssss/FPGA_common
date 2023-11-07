import os
import sys
import csv
import io
from datetime import date
import logging
import getpass
import re
import platform

user= getpass.getuser()
project_name='logan'

#csv_scr_dir='/media/sf_f_linux_share/FromKerry/csv_expr'
csv_scr_dir = os.getcwd()
print(csv_scr_dir)
xls_file=csv_scr_dir+'/Alnilam_regmap_0_3_2.xlsx'

print(xls_file)
csvdir_path=csv_scr_dir+'/csv'
gen_rtl_path=csv_scr_dir+'/gen_rtl'
gen_if_path=csv_scr_dir+'/gen_if'
gen_c_hdr_path=csv_scr_dir+'/gen_c_hdr'
svpkgFile='regpkg.sv'
incFile='regincl.svh'
CheaderFile='regheader.h'
CheaderBaseFile='jb_logan_base_address.h'
addr_bits='11'
BasecsvFile = 'Alnilam_regmap_0_3_2.csv'
# BasecsvFile = 'LoganBaseAddressTable.csv' #LoganSub6Registers.xlsx
hdr='"jb_'+project_name+'_params.svh"'
ignore_warning_stat_RW=['dl_ant_postcfr_gain_fraction', 'dl_ant_postcfr_gain_scaler', 'dl_ant_postcfr_gain_scaler_sign', 'bypass_dpd'] 

header_param=''

hdrFile = "jb_header.svh"
hdrData = open(hdrFile, 'w')


#0:reg name, 1:offset, 2:reg_type, 3:field_name, 4: Bit width, 5: Reset Value, 6: description
blk_name_idx=0
reg_name_idx=1
addr_offset_idx=2
reg_type_idx=4
fld_name_idx=5
bit_width_idx=6
rst_value_idx=7
desc_idx=8
rtl_signal_info_idx=9

base_addr_idx=1

base_par_name_idx=0
base_par_addr_idx=1

def gen_sig_def_block(csvFile, intfName, incl_stat):
    global header_param
    check_errors(csvFile)
    #print(csvFile)
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    next(CsvData)
    sig_def_block=''
    file_name=intfName.replace('IFP','jb')
    intf_sig_def_block=("// -------------------------------------------------------------------------- // \n"+  
                "// Copyright Jabil Inc.                                                       // \n" +
                "// -------------------------------------------------------------------------- // \n" +
                "// Name         : "+user+" "*(60-len(user))+"// \n" +
                "// Date         : "+date.today().strftime("%m/%d/%y")+" "*52+"// \n" +
                "// File         : "+file_name+'.sv'+" "*(60-len(intfName))+"// \n" + 
                "// Design       :                                                             // \n" +
                "// Purpose      :                                                             // \n" +
                "// Device       :                                                             // \n" + 
                "// -------------------------------------------------------------------------- // \n\n\n" +
                "interface "+file_name+'_if'";\n")
    intf_sig_def_block_stat=("// -------------------------------------------------------------------------- // \n"+  
                "// Copyright Jabil Inc.                                                       // \n" +
                "// -------------------------------------------------------------------------- // \n" +
                "// Name         : "+user+" "*(60-len(user))+"// \n" +
                "// Date         : "+date.today().strftime("%m/%d/%y")+" "*52+"// \n" +
                "// File         : "+file_name.replace('ctrl','stat')+'.sv'+" "*(60-len(intfName))+"// \n" + 
                "// Design       :                                                             // \n" +
                "// Purpose      :                                                             // \n" +
                "// Device       :                                                             // \n" + 
                "// -------------------------------------------------------------------------- // \n\n\n" +
                "interface "+file_name.replace('ctrl','stat')+"_if;\n")
    assign_intf_sig_block=''
    assign_intf_sig_block_ro=''
    assign_intf_sig_block_param=''
    ipports=''
    opports=''
    ipports_stat=''
    opports_stat=''
    prev_sig_name=''
    signal_name='dead'

    for row in CsvData:
        #print(row)
        """
        if('stat' in row[rtl_signal_info_idx]):   
            if(row[reg_type_idx]=='RW' and row[fld_name_idx] not in opports and row[rtl_signal_info_idx]!=''):
                opports_stat+=' '+row[fld_name_idx] +','
            elif row[fld_name_idx] not in ipports and row[rtl_signal_info_idx]!='':
                ipports_stat+=' '+row[fld_name_idx] +','
        else:
            if(row[reg_type_idx]=='RW' and row[fld_name_idx] not in opports and row[rtl_signal_info_idx]!=''):
                opports+=' '+row[fld_name_idx] +','
            elif row[fld_name_idx] not in ipports and row[rtl_signal_info_idx]!='':
                ipports+=' '+row[fld_name_idx] +','
        """
        bit_width=row[bit_width_idx]
        if ':' not in bit_width:
            n_bits=1
            strt_idx=0
            end_idx=0
        else:
            bit_idx=bit_width.split(':')
            end_idx=bit_idx[0].replace('[','')
            strt_idx=bit_idx[1].replace(']','')
            n_bits=int(end_idx)-int(strt_idx)+1
        if n_bits==1:
            sig_def_block+='   logic                     '+row[reg_name_idx]+'_'+row[fld_name_idx]+';\n'
        else:
            sig_def_block+='   logic  ['+str(n_bits-1)+':0]              '+row[reg_name_idx]+'_'+row[fld_name_idx]+';\n'
        if(row[reg_type_idx]=='RW' and 'stat' in row[rtl_signal_info_idx]):
            if n_bits==1:
                sig_def_block+='   logic                     '+row[reg_name_idx]+'_'+row[fld_name_idx]+'_mod;\n'
            else:
                sig_def_block+='   logic  ['+str(n_bits-1)+':0]              '+row[reg_name_idx]+'_'+row[fld_name_idx]+'_mod;\n'
            
        sig_def_block+='  // '+row[desc_idx].replace('\n','')+'\n'		
        
        if 'param.' not in row[rtl_signal_info_idx] and row[rtl_signal_info_idx]!='':
            if 'stat.' in row[rtl_signal_info_idx]:
                 signal_name=row[rtl_signal_info_idx].replace('stat.','')
                 if '[' not in row[rtl_signal_info_idx]:  #Single bit vector
                     ipports_stat+='        '+signal_name+',\n'
                     if row[reg_type_idx]=='RW':
                        opports+='        '+signal_name+',\n'
                     if n_bits==1:  
                         intf_sig_def_block_stat+='   logic'+' '*24+signal_name+';\n'
                         if row[reg_type_idx]=='RW':
                           intf_sig_def_block+='   logic'+' '*24+signal_name+';\n'
                     else:
                         cnt=len('['+str(n_bits-1)+':0]')
                         intf_sig_def_block_stat+='   logic  ['+str(n_bits-1)+':0]'+' '*(22-cnt)+signal_name+';\n'
                         if row[reg_type_idx]=='RW':
                           intf_sig_def_block+='   logic  ['+str(n_bits-1)+':0]'+' '*(22-cnt)+signal_name+';\n'
                 else:
                     signal_name=signal_name[:signal_name.index('[')]
                     if ' '+signal_name+';' not in intf_sig_def_block_stat:
                        ipports_stat+='        '+signal_name +',\n'
                        if row[reg_type_idx]=='RW':
                            opports+='        '+signal_name+',\n'
                        multi_array=get_array_sig_info(csvFile, row)
                        prev_sig_name=signal_name
                        if n_bits==1:
                            cnt=len(multi_array)
                            intf_sig_def_block_stat+='   logic  '+multi_array+' '*(22-cnt)+signal_name+';\n' 
                            if row[reg_type_idx]=='RW':
                                intf_sig_def_block+='   logic  '+multi_array+' '*(22-cnt)+signal_name+';\n' 
                        else:
                            cnt=len(multi_array+'['+str(n_bits-1)+':0]')
                            intf_sig_def_block_stat+='   logic  '+multi_array+'['+str(n_bits-1)+':0]'+' '*(22-cnt)+signal_name+';\n'
                            if row[reg_type_idx]=='RW':
                                intf_sig_def_block+='   logic  '+multi_array+'['+str(n_bits-1)+':0]'+' '*(22-cnt)+signal_name+';\n'
                    
            else:
                signal_name=row[rtl_signal_info_idx].replace('ctrl.','')
                
                if '[' not in row[rtl_signal_info_idx]:  #Single bit vector
                    if row[reg_type_idx]=='RW':
                        #print(signal_name)
                        opports+='        '+signal_name+',\n'
                    else:
                        ipports+='        '+signal_name+',\n'
                    if n_bits==1:
                        intf_sig_def_block+='   logic'+' '*24+signal_name+';\n'
                    else:
                        cnt=len('['+str(n_bits-1)+':0]')
                        intf_sig_def_block+='   logic  ['+str(n_bits-1)+':0]'+' '*(22-cnt)+signal_name+';\n'
                else:
                    signal_name=signal_name[:signal_name.index('[')]
                    if ' '+signal_name+';' not in intf_sig_def_block:
                        if row[reg_type_idx]=='RW':
                            opports+='        '+signal_name+',\n'
                        else:
                            ipports+='        '+signal_name+',\n'
                        multi_array=get_array_sig_info(csvFile, row)
                        prev_sig_name=signal_name
                        #print(signal_name)
                        #print(multi_array,signal_name)
                        if n_bits==1:
                            cnt=len(multi_array)
                            intf_sig_def_block+='   logic  '+multi_array+' '*(22-cnt)+signal_name+';\n' 
                        else:
                            cnt=len(multi_array+'['+str(n_bits-1)+':0]')
                            intf_sig_def_block+='   logic  '+multi_array+'['+str(n_bits-1)+':0]'+' '*(22-cnt)+signal_name+';\n'
                                
        #assign logic
        if 'param.' in row[rtl_signal_info_idx]:
            param_name=row[rtl_signal_info_idx][row[rtl_signal_info_idx].index('.')+1:].upper()
            cnt=len(param_name)
            #assign_intf_sig_block+='   assign  '+row[reg_name_idx]+'_'+row[fld_name_idx]+' =  '+row[rtl_signal_info_idx][row[rtl_signal_info_idx].index('.')+1:].upper()+';\n'
            assign_intf_sig_block_param+='   assign  '+row[reg_name_idx]+'_'+row[fld_name_idx]+' =  '+param_name+';\n'
            header_param+='localparam  '+param_name+'=\'h'+row[rst_value_idx]+';\n'
            #assign_intf_sig_block_ro+='   assign  '+row[reg_name_idx]+'_'+row[fld_name_idx]+' = '+[row[rtl_signal_info_idx].index('.')+1:].upper()+';\n'
        else:
            if (row[reg_type_idx]=='RW') and 'stat.' in row[rtl_signal_info_idx]:
                if signal_name not in ignore_warning_stat_RW:
                   print(row[fld_name_idx])
                   print("arry")
                   print(ignore_warning_stat_RW)
                   logging.warning('Please Check: Incompatible Register Type (RW) and Interface Type (Stat) ',signal_name)            #error: incompatible RW & stat
                assign_intf_sig_block_ro+='   assign  '+row[reg_name_idx]+'_'+row[fld_name_idx]+'_mod = '+intfName.replace('ctrl','stat')+'.'+row[rtl_signal_info_idx].replace('stat.','')+';\n'
                assign_intf_sig_block+='   assign  '+intfName+'.'+row[rtl_signal_info_idx].replace('stat.','')+' =  '+row[reg_name_idx]+'_'+row[fld_name_idx]+';\n'
            elif row[rtl_signal_info_idx]!='':	   
                if(row[reg_type_idx]=='RW'):
                   assign_intf_sig_block+='   assign  '+intfName+'.'+row[rtl_signal_info_idx].replace('ctrl.','')+' =  '+row[reg_name_idx]+'_'+row[fld_name_idx]+';\n'
                elif incl_stat:
                   assign_intf_sig_block_ro+='   assign  '+row[reg_name_idx]+'_'+row[fld_name_idx]+' = '+intfName.replace('ctrl','stat')+'.'+row[rtl_signal_info_idx].replace('stat.','')+';\n'
                else:
                   assign_intf_sig_block_ro+='   assign  '+row[reg_name_idx]+'_'+row[fld_name_idx]+' = '+intfName+'.'+row[rtl_signal_info_idx].replace('ctrl.','')+';\n'

    opports=opports
    #print(opports)
    ipports=ipports
    #print(ipports)
    opports_stat=opports_stat[:-2]
    ipports_stat=ipports_stat[:-2]
    intf_sig_def_block+='\n\n\n'

    #modport ctrl
    intf_sig_def_block+='modport ctrl (\n'
    intf_sig_def_block+='output\n'+opports
    
    if ipports:
        intf_sig_def_block+='\n'
        intf_sig_def_block+='input\n'+ipports
        
    intf_sig_def_block=intf_sig_def_block[:-2]
    intf_sig_def_block+='\n);\n\n\n' #end modport


    #modport blk
    intf_sig_def_block+='modport  blk (\n'
    intf_sig_def_block+='input\n'+opports
    
    if ipports: 
        intf_sig_def_block+='\n'
        intf_sig_def_block+='output\n'+ipports

    
    intf_sig_def_block=intf_sig_def_block[:-2]    
    intf_sig_def_block+='\n);\n\n\n' #end modport
    
    intf_sig_def_block+='\nendinterface'

    
   ##### Stat Interface
    if incl_stat:
        intf_sig_def_block_stat+='\n\n\n'
        
        #modport ctrl
        intf_sig_def_block_stat+='modport stat (\n'
        intf_sig_def_block_stat+='input\n'+ipports_stat+'\n'
        
        intf_sig_def_block_stat+=');\n\n\n' #end modport
        
        intf_sig_def_block_stat+='modport  blk (\n'
        intf_sig_def_block_stat+='output\n'+ipports_stat+'\n'
        
        intf_sig_def_block_stat+=');\n\n\n' #end modport
        
        intf_sig_def_block_stat+='\nendinterface'
    
    
    #print(sig_def_block)
    return sig_def_block,intf_sig_def_block,intf_sig_def_block_stat,assign_intf_sig_block,assign_intf_sig_block_ro,assign_intf_sig_block_param

def gen_wr_reset_block(csvFile):
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    next(CsvData)
    wr_reset_block=''
    for row in CsvData:
        if(row[reg_type_idx]=='RW'):
          wr_reset_block+='                  '+row[reg_name_idx]+'_'+row[fld_name_idx]+' <= \'h'+row[rst_value_idx]+';'
          wr_reset_block+='  // '+row[desc_idx].replace('\n','')+'\n'
    #print(wr_reset_block)
    return wr_reset_block



def gen_wr_set_block(csvFile):
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    next(CsvData)
    wr_set_block=''
    prev_reg=''
    offset_addr=''
    for row in CsvData:
        if(row[reg_type_idx]=='RW'):
            if(row[reg_name_idx]==prev_reg):
                wr_set_block+='                  '+row[reg_name_idx]+'_'+row[fld_name_idx]+' <= IFP_axi_rw.wdata'+row[bit_width_idx]+';'
                wr_set_block+='  // '+row[desc_idx].replace('\n','')+'\n'
            else:
                if prev_reg !='':
                    wr_set_block+='             end\n'
                offset_addr=hex((int(row[addr_offset_idx],16))>>2).split('x')[-1]
                #print(offset_addr)
                wr_set_block+='      '+addr_bits+'\'h'+offset_addr+'  : begin //\'h'+row[addr_offset_idx]+'\n'
                wr_set_block+='                  '+row[reg_name_idx]+'_'+row[fld_name_idx]+' <= IFP_axi_rw.wdata'+row[bit_width_idx]+';'
                wr_set_block+='  // '+row[desc_idx].replace('\n','')+'\n'
               #### end for else
            prev_reg=row[reg_name_idx]
    wr_set_block+='               end\n'
    #print(wr_set_block)
    return wr_set_block



def gen_rd_set_block(csvFile):
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    next(CsvData)
    rd_set_block=''
    prev_reg=''
    for row in CsvData:
        if(row[reg_name_idx]==prev_reg):
            if(row[reg_type_idx]=='RW' and 'stat' in row[rtl_signal_info_idx]):
              rd_set_block+='                   IFP_axi_rw.rdata'+row[bit_width_idx]+' = '+row[reg_name_idx]+'_'+row[fld_name_idx]+'_mod;'
            else:  
              rd_set_block+='                   IFP_axi_rw.rdata'+row[bit_width_idx]+' = '+row[reg_name_idx]+'_'+row[fld_name_idx]+';'
            rd_set_block+='  // '+row[desc_idx].replace('\n','')+'\n'
        else:
            if prev_reg !='':
                rd_set_block+='             end\n'
            offset_addr=hex((int(row[addr_offset_idx],16))>>2).split('x')[-1] #take the hex->covert to dec->right shift by 2=divide by4->convert back to hex
            rd_set_block+='      '+addr_bits+'\'h'+offset_addr+'  : begin//\'h'+row[addr_offset_idx]+'\n'
            
            if(row[reg_type_idx]=='RW' and 'stat' in row[rtl_signal_info_idx]):
              rd_set_block+='                   IFP_axi_rw.rdata'+row[bit_width_idx]+' = '+row[reg_name_idx]+'_'+row[fld_name_idx]+'_mod;'
            else:
              rd_set_block+='                   IFP_axi_rw.rdata'+row[bit_width_idx]+' = '+row[reg_name_idx]+'_'+row[fld_name_idx]+';'
            rd_set_block+='  // '+row[desc_idx].replace('\n','')+'\n'
            #### end for else
        prev_reg=row[reg_name_idx]
    rd_set_block+='               end\n'
    #print(rd_set_block)
    return rd_set_block

def gen_rtl_logic(csvFile):
    #print(csvFile)
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    next(CsvData)
    first_entry=next(CsvData)
    rtlFile = "jb_"+((csvFile.lower()).replace(".csv","_regs.sv"))
    rtlFile = (rtlFile.replace("top_ctrl_",""))
    intfFile = "jb_"+((csvFile.lower()).replace(".csv","_ctrl_if.sv"))
    intfFile = (intfFile.replace("top_ctrl_",""))
    intfName = "IFP_"+((csvFile.lower()).replace(".csv",""))
    intfName = (intfName.replace("top_ctrl_",""))
    intfName = (intfName.replace("hw_beta","hw"))
    intfName = intfName+'_ctrl'
    #print(rtlFile)
    rtlData = open(gen_rtl_path+'/'+rtlFile, 'w')
    intfData = open(gen_if_path+'/'+intfFile, 'w')
    intfStatData = open(gen_if_path+'/'+intfFile.replace('ctrl','stat'), 'w')
    
    #interfaces
    incl_stat,incl_hdr= incl_if(csvFile)

    #############SIG DECLARATIONS
    rtlData.write("// -------------------------------------------------------------------------- // \n"+  
                "// Copyright Jabil Inc.                                                       // \n" +
                "// -------------------------------------------------------------------------- // \n" +
                "// Name         : "+user+" "*(60-len(user))+"// \n" +
                "// Date         : "+date.today().strftime("%m/%d/%y")+" "*52+"// \n" +
                "// File         : "+rtlFile+" "*(60-len(rtlFile))+"// \n" + 
                "// Design       :                                                             // \n" +
                "// Purpose      :                                                             // \n" +
                "// Device       :                                                             // \n" + 
                "// -------------------------------------------------------------------------- // \n" 
            ) #header
    if ( 'hw_beta' in rtlFile):
         rtlData.write("\nmodule " + (rtlFile.replace(".sv","")).replace("hw_beta","hw") + " ( \n" +
                 "    input                           clk, \n" + 
                 "    input                           srst,  \n" +
                 "    jb_axi_regs_if.slave            IFP_axi_rw, \n" + 
                 "    "+(intfFile.replace(".sv",".ctrl")).replace("hw_beta","hw")+"           "+intfName)
    else:    
         rtlData.write("\nmodule " + rtlFile.replace(".sv","")+ " ( \n" +
                 "    input                           clk, \n" + 
                 "    input                           srst,  \n" +
                 "    jb_axi_regs_if.slave            IFP_axi_rw, \n" + 
                 "    "+intfFile.replace(".sv",".ctrl")+"         "+intfName)
    
    #check if there is a static interface
    if incl_stat:
        rtlData.write(",\n    "+intfFile.replace(".sv",".stat").replace("ctrl","stat")+"         "+intfName.replace("ctrl","stat")+" \n" +
                 ");")    
    else:
        rtlData.write("\n);")

    #check if there are parameters
    if incl_hdr: 
        rtlData.write('\n\n    `include '+hdr)
 
    sig_def_block,intf_sig_def_block,intf_sig_def_block_stat,assign_intf_sig_block,assign_intf_sig_block_ro,assign_intf_sig_block_param=gen_sig_def_block(csvFile,intfName,incl_stat)
    rtlData.write("\n\n\n\n////////////////Register Field Declarations//////////////////\n\n")
    rtlData.write(sig_def_block)
    rtlData.write("\n\n\n\n")

    rtlData.write("\n\n\n\n////////////////ASSIGN PARAMETERS//////////////////\n\n")
    rtlData.write(assign_intf_sig_block_param) 
    rtlData.write("\n\n\n\n////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////\n\n")
    rtlData.write(assign_intf_sig_block)
    rtlData.write("\n\n\n\n////////////////ASSIGN STATUS RO INTF FIELDS//////////////////\n\n")
    rtlData.write(assign_intf_sig_block_ro)
    rtlData.write("\n\n\n\n")

    intfData.write(intf_sig_def_block)
    intfData.write("\n\n\n")
    intfStatData.write(intf_sig_def_block_stat)
    intfStatData.write("\n\n\n")
    #print('WARNING***:Please check '+intfFile+' for any commas at the end in modport (fix Syntax), support will be added later')
    
    #############  WRITE logic
    rtlData.write("///////////////////WRITE LOGIC ////////////////\n")
    #seq_wr_block='  assign wr_offset_addr = axi_awaddr[AXI_ADDR_WIDTH-1:ADDR_LSB];\n\n'
    seq_wr_block='  always @(posedge clk) begin\n'
    seq_wr_block+='    if (srst) begin\n'
    # add reset_block
    seq_wr_block+=gen_wr_reset_block(csvFile)
    seq_wr_block+='    end\n'
    seq_wr_block+='    else if (IFP_axi_rw.wren) begin\n'
    seq_wr_block+='      case(IFP_axi_rw.wr_offset)\n'
    seq_wr_block+=gen_wr_set_block(csvFile)
    seq_wr_block+='      endcase\n'
    seq_wr_block+='    end\n'
    seq_wr_block+='  end\n'
    rtlData.write(seq_wr_block)

    #############  READ logic
    rtlData.write("///////////////////////////////////////////////\n\n\n\n")
    rtlData.write("///////////////////READ LOGIC ////////////////\n")
    #rd_set_block='  assign rd_offset_addr = axi_araddr[AXI_ADDR_WIDTH-1:ADDR_LSB];\n\n'
    rd_set_block='  always @(*) begin\n'
    rd_set_block+='    IFP_axi_rw.rdata = 0;\n'
    rd_set_block+='    if (IFP_axi_rw.rden) begin\n'
    rd_set_block+='       case(IFP_axi_rw.rd_offset)\n'
    rd_set_block+=gen_rd_set_block(csvFile)
    rd_set_block+='       endcase\n'
    rd_set_block+='   end\n'
    rd_set_block+=' end\n'
    rtlData.write(rd_set_block)
    rtlData.write("///////////////////////////////////////////////\n\n\n\n")
    rtlData.write('endmodule')
    rtlData.close()






def gen_c_base_hdr_file(BasecsvFile):
    
    ChdrBaseData = open(gen_c_hdr_path+'/'+CheaderBaseFile, 'w')
    
    ChdrBaseData.write("\n\n//////////////////  BASE ADDRESS defines /////////////////////////////////////////////////////////////\n\n")
    
    CsvBase = csv.reader(open(csvdir_path+'/'+BasecsvFile))
    next(CsvBase)

    c_base_addr=''
    for row in CsvBase:
      c_base_addr+='#define      '
      c_base_addr+='%-50s' % (row[blk_name_idx])
      c_base_addr+='   0x%-50s' %(row[base_addr_idx])+'\n'

    c_base_addr+='\n\n\n\n'
    ChdrBaseData.write(c_base_addr)
    c_reg_addr=''
   
    ChdrBaseData.write("////////////////////////////////////////////////////////////////////////////////////////////////////\n\n")
    ChdrBaseData.close()    


def gen_c_hdr_file(csvFile):
    
   
    
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    next(CsvData)
    CHdrFile = "jb_"+((csvFile.lower()).replace(".csv",".h"))
    ChdrData = open(gen_c_hdr_path+'/'+CHdrFile, 'w')
    c_reg_addr=''
    prev_reg=''
    for row in CsvData:
        if(row[reg_name_idx]!=prev_reg):
            c_reg_addr+='#define      '
            c_reg_addr+='%-50s' % (row[reg_name_idx])
            c_reg_addr+='   '+row[blk_name_idx]+' + 0x'+row[addr_offset_idx]+'\n'
        prev_reg=row[reg_name_idx]
   
    ChdrData.write("/////////////////  REG ADDRESS defines /////////////////////////////////////////////////////////////\n\n")
    ChdrData.write(c_reg_addr)
   
    ChdrData.close()    
    

   
'''
Returns: a tuple (incl_stat, incl_hdr). incl_stat is True is there is a static interface, False otherwise.
incl_hdr is True if there are parameters and a header file must be included, False otherwise.

Parameter: csvFile is the name of a csvFile to be parsed within csvdir_path [str]
'''
def incl_if(csvFile):
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    next(CsvData)

    incl_stat= False
    incl_hdr= False

    for row in CsvData:
        if len(row)>rtl_signal_info_idx and 'stat.' in row[rtl_signal_info_idx]:
            incl_stat= True
        if len(row)>rtl_signal_info_idx and 'param.' in row[rtl_signal_info_idx]:
            incl_hdr= True
    
    return incl_stat, incl_hdr    

'''
Checks for errors duplication and bit assignment errosr in csvFile and logs the errors
in a the error log.
'''
def check_errors(csvFile):
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    zle_test=next(CsvData)
    check_field=[]
    check_bits=[]
    addr_dict={}

    for row in CsvData:
        cur_field=[row[reg_name_idx]],[row[fld_name_idx]]
        cur_bits=[row[reg_name_idx],row[fld_name_idx]],[row[bit_width_idx]]
        
        #check field
        if cur_field in check_field:
            logging.warning('Duplicate field name "'+str(row[fld_name_idx])+ '" in Register '+ str(row[reg_name_idx]))
        
        #check bits
        if cur_bits in check_bits:
            #print(check_bits)
            
            logging.warning('Overlapping bit assignment in Register '+ str(row[reg_name_idx])+ ' in ' + csvFile)
        
        #check addresses
        if addr_dict.get(row[addr_offset_idx])!=None and addr_dict.get(row[addr_offset_idx])!=row[reg_name_idx]:
            logging.warning('Duplicate address in ' + csvFile + ': '+row[addr_offset_idx])
        addr_dict[row[addr_offset_idx]]=row[reg_name_idx] 
        
        check_field+=[cur_field]
        check_bits+=[cur_bits]
    #logging.warning(check_bits)

'''
Returns the size of the array in rtl_signal_info in row of csvFile
Logs any missing indices into the error log
re.findall(r'\[([^]]*)\]',sample), extracts values in the square brackets
array_dimension_count = sum(map(lambda x : 1 if '[' in x else 0, signal_info))
'''
def get_array_sig_info(csvFile, row):
    CsvData = csv.reader(open(csvdir_path+'/'+csvFile))
    next(CsvData)

    signal_info= row[rtl_signal_info_idx]

    #if '[0]' not in signal_info:
    #    return 0
    array_sizes=re.findall(r'\[([^]]*)\]',signal_info) #extract all the values in brackets
    for i in range(0, len(array_sizes)): 
      array_sizes[i] = int(array_sizes[i])
      
    #print('get array info called')
    past_grps=[]
    common_signal= signal_info[:signal_info.index('[')]
    #print(common_signal)
    for row in CsvData:
        #print(row[rtl_signal_info_idx])
        if common_signal in row[rtl_signal_info_idx]:
            cur_signal= row[rtl_signal_info_idx]
            #print(cur_signal)
            curr_array_sizes=re.findall(r'\[([^]]*)\]',cur_signal) #extract all the values in brackets
            for i in range(0, len(curr_array_sizes)): 
                curr_array_sizes[i] = int(curr_array_sizes[i])
                if curr_array_sizes[i] > array_sizes[i]:
                    array_sizes[i] = curr_array_sizes[i]

    #print(array_sizes)
    for i in range(0, len(array_sizes)): 
      array_sizes[i] = '['+str(array_sizes[i])+':0]'
      #print(array_sizes[i])
    #check for missing indices
    #past_grps.sort()
    #grp_max= past_grps[-1]
    #if grp_max+1!=len(past_grps):
    #    logging.warning('Missing array element for ' + signal_info + ' in ' + csvFile)
    listToStr = ' '.join(map(str, array_sizes))
    listToStr = listToStr.replace(' ','')
    #print(listToStr)
    return listToStr


def main():
    #start error log
    logging.basicConfig(filename="gen_reg_error.log", filemode='w', level=logging.WARNING)

    print("Converting Alnilam_regmap_0_3_2.xlsx to csv")
    if not os.path.exists(csvdir_path):
       os.makedirs(csvdir_path)
    if (os.path.isfile(xls_file)):
       print("Found the xls File  "+xls_file+"\n")
       #os.system(csv_scr_dir+'/xls2csv.py '+xls_file)

#ok       a=os.system("python ./xls2csv_win.py")       
#ok       a=os.system("python C:/Users/2933982/Firmware-sub6/FPGA/scripts/gen_reg/xls2csv_win.py")
#ok       a=os.system("python C:/Users/2933982/Firmware-sub6/FPGA/scripts/gen_reg/xls2csv.py C:/Users/2933982/Firmware-sub6/FPGA/scripts/gen_reg/LoganSub6Registers.xlsx")
#ok       a=os.system("python xls2csv.py C:/Users/2933982/Firmware-sub6/FPGA/scripts/gen_reg/LoganSub6Registers.xlsx")
       if (platform.system()=='Windows'):
           a=os.system("python xls2csv_v2.py Alnilam_regmap_0_3_2.xlsx")
       elif (platform.system()=='Linux'):
           os.system(csv_scr_dir + '/xls2csv.py ' + xls_file)
       
    else:
      print("File not found")
      print(xls_file)
      sys.exit()
    if not os.path.exists(gen_rtl_path):
       os.makedirs(gen_rtl_path)
    if not os.path.exists(gen_c_hdr_path):
       os.makedirs(gen_c_hdr_path)
    if not os.path.exists(gen_if_path):
       os.makedirs(gen_if_path)
       
    #os.system('dir '+csv_scr_dir+'/csv/')
    #os.system('dos2unix '+csv_scr_dir+'/csv/*')
    #gen_c_base_hdr_file(BasecsvFile)
    for csvFile in os.listdir(csvdir_path): #grab all the files
        #print(csvFile)
        #if 'Base' not in csvFile and 'Release' not in csvFile and 'CORE' not in csvFile and 'RADIO_IF' not in csvFile and 'DL_DFE' in csvFile:
        if 'Base' not in csvFile and 'Release' not in csvFile and 'CORE' not in csvFile and 'RADIO_IF' not in csvFile:
            print('Generating RTL for the CSV File: '+csvFile+' in the path '+gen_rtl_path)
            gen_rtl_logic(csvFile) 
            #print('Generating C Header for the CSV File: '+csvFile+' in the path '+gen_c_hdr_path)
            #gen_c_hdr_file(csvFile)
    #pkgData = open(svpkgFile, 'w')
    #pkgData.close()           
    hdrData.write(header_param)
      
if __name__=="__main__":
    main()
