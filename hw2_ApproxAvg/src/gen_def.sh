#!/bin/bash

timestamp=$(date +%Y/%m/%d-%H:%M:%S)
printf "// This is generated automatically on ${timestamp}\n"
printf "// Check the # of bits for state registers !!!\n"
printf "// Check the # of bits for flag registers !!!\n\n"

STATES=("S_INIT"            \
        "S_READ"            \
        "S_ACCU"            \
        "S_PROC"            \
        "S_OUTP"            \
        "S_END"             \
)

def_pattern="%-30s \t %-3s\n"
# Generate macro
printf "\`ifndef __FLAG_DEF__\n"
printf "\`define __FLAG_DEF__\n"

# Generate FSM states
len=${#STATES[@]}
printf "\n// There're ${len} states in this design\n"
for((idx=0; idx<${len}; idx++))
do
  printf "$def_pattern" "\`define ${STATES[$idx]}" "${idx}"
done

# Generate FSM init vector
printf "$def_pattern" "\`define S_ZVEC"     "${len}'b0"
printf "$def_pattern" "\`define STATE_W"    "${len}"

# Generate other macro
printf "\n// Macro from template\n"
printf "$def_pattern" "\`define BUF_SIZE"             "9"

printf "$def_pattern" "\`define EMPTY_ADDR"           "{12{1'b0}}"
printf "$def_pattern" "\`define EMPTY_DATA"           "{20{1'b0}}"

printf "$def_pattern" "\`define LOCAL_IDX_W"          "16"
printf "$def_pattern" "\`define DATAX_W"              "8"
printf "$def_pattern" "\`define DATAY_W"              "10"

printf "\n// Self-defined macro\n"
printf "$def_pattern" "\`define CNT_W"                "4"

# Generate end macro
printf "\n\`endif\n"
