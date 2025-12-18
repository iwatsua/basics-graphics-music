# gtkwave::loadFile "dump.vcd"

set all_signals [list]

lappend all_signals tb.i_lab_top.a
lappend all_signals tb.i_lab_top.b
lappend all_signals {tb.i_lab_top.led[0]}
lappend all_signals {tb.i_lab_top.led[1]}
lappend all_signals {tb.i_lab_top.led[2]}
lappend all_signals {tb.i_lab_top.led[3]}

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
