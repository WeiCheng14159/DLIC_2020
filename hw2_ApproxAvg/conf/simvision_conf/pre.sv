# SimVision Command Script (一  九  13 十六時卅分52秒 CST 2021)
#
# Version 15.20.s084
#
# You can restore this configuration with:
#
#     simvision -input /home/wei/git/DLIC_2021/hw2_ApproxAvg/conf/simvision_conf/pre.sv
#


#
# Preferences
#
preferences set plugin-enable-svdatabrowser-new 1
preferences set plugin-enable-groupscope 0
preferences set plugin-enable-interleaveandcompare 0
preferences set plugin-enable-waveformfrequencyplot 0
preferences set whats-new-dont-show-at-startup 1

#
# Databases
#
database require CS -search {
	./CS.shm/CS.trn
	/home/wei/git/DLIC_2021/hw2_ApproxAvg/build/CS.shm/CS.trn
}

#
# Mnemonic Maps
#
mmap new -reuse -name {Boolean as Logic} -radix %b -contents {{%c=FALSE -edgepriority 1 -shape low}
{%c=TRUE -edgepriority 1 -shape high}}
mmap new -reuse -name {Example Map} -radix %x -contents {{%b=11???? -bgcolor orange -label REG:%x -linecolor yellow -shape bus}
{%x=1F -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=2C -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=* -label %x -linecolor gray -shape bus}}

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 1848x1016+71+26}] != ""} {
    window geometry "Waveform 1" 1848x1016+71+26
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar select designbrowser
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units ns \
    -valuewidth 75
waveform baseline set -time 0

set id [waveform add -signals  {
	CS::testfixture.top.reset
	} ]
set id [waveform add -signals  {
	CS::testfixture.top.clk
	} ]
set id [waveform add -signals  {
	{CS::testfixture.top.X[7:0]}
	} ]
set id [waveform add -signals  {
	{CS::testfixture.top.Y[9:0]}
	} ]
set id [waveform add -signals  {
	{CS::testfixture.top.cnt[3:0]}
	} ]

waveform xview limits 0 4000ns

#
# Waveform Window Links
#

