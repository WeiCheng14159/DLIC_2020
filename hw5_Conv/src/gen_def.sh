#!/bin/bash

timestamp=$(date +%Y/%m/%d-%H:%M:%S)
printf "// This is generated automatically on ${timestamp}\n"

STATES=("S_WAIT"             \
        "S_READ_W"           \
        "S_READ"             \
        "S_OPT"              \
        "S_WRITE"            \
        "S_END"              \
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
printf "$def_pattern" "\`define DATA_WIDTH"           "32"
printf "$def_pattern" "\`define ADDR_WIDTH"           "32"
printf "$def_pattern" "\`define EMPTY_WORD"           "32'b0"
printf "$def_pattern" "\`define EMPTY_ADDR"           "32'b0"

printf "\n// Self-defined macro\n"
printf "$def_pattern" "\`define CNT_W"                "4"
printf "$def_pattern" "\`define GLB_CNT_W"            "5"
printf "$def_pattern" "\`define IMG_SIZE"             "28"
# Generate end macro
printf "\n\`endif\n"
