proc isValid {numbers value} {
    for {set i 0} {$i < [llength $numbers]} {incr i} {
        for {set j [expr {$i + 1}]} {$j < [llength $numbers]} {incr j} {
            if {$value == [expr {[lindex $numbers $i] + [lindex $numbers $j]}]} {
                return true
            }
        }
    }
    return false
}

set preambleSize 25
set infile [open "input.txt"]
set lines [list]
set numbers [list]
set part1 0
set part2 0

while { [gets $infile line] >= 0 } {
    lappend lines $line
}

for {set part1Index 0} {$part1Index < [llength $lines] && !$part1} {incr part1Index} {
    set line [lindex $lines $part1Index]
    if {[llength $numbers] < $preambleSize} {
        lappend numbers $line
        continue
    }

    if {[isValid $numbers $line]} {
        lappend numbers $line
        set numbers [lrange $numbers 1 end]
    } else {
        set part1 $line
    }
}

for {set i 0} {$i < $part1Index && !$part2} {incr i} {
    set iVal [lindex $lines $i]
    set sum $iVal
    set min $iVal
    set max $iVal
    for {set j [expr {$i + 1}]} {$j < [llength $lines]} {incr j} {
        set jVal [lindex $lines $j]
        incr sum $jVal
        if {$jVal < $min} {set min $jVal}
        if {$jVal > $max} {set max $jVal}
        if {$sum > $part1} {break}
        if {$sum == $part1} {
            set part2 [expr {$min + $max}]
            break
        }
    }
}

puts "Part 1: $part1"
puts "Part 2: $part2"
