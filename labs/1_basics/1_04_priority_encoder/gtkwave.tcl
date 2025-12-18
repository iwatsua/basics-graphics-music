# gtkwave::loadFile "dump.vcd"

set all_signals [list]

lappend all_signals tb.i_lab_top.in
lappend all_signals tb.i_lab_top.enc0
lappend all_signals tb.i_lab_top.enc1
lappend all_signals tb.i_lab_top.enc2
lappend all_signals tb.i_lab_top.enc3


set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
