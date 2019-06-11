# parent values fall through scopes 

$a = "original value"
function e { 
    "hello from e"
}

# we can still use e and $a even though 
# they are defined in a different scope
function f {
    e
    $a 
}

f 

break 

# we can still use e and $a even though 
# they are defined in a different scope
& { 
    e
    $a 
}