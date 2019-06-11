# the same idea but with scriptblocks

$sb = {
    $a = "new value"
}

# & forms a new scope 
# this is like calling (an anonymous) function
$a = "original value"
& $sb 
 
"value after `&` is: $a"

break 

# . does not form a new scope 
# this is like dot-sourcing a file
$a = "original value"
. $sb

"value after `.` is: $a"

