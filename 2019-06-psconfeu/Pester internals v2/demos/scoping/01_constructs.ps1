# some constructs form new scopes 
# and some don't


$a = "original value"
function f {
    $a = "new value"
}

f 
"value after function 'f' is: $a"


break 

# if does not form a new scope 
# (same for foreach, while, for, etc.)

$a = "original value"

if ($true) {
    $a = "new value"
}

"value after 'if' is: $a"
