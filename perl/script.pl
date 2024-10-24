#!/usr/bin/perl

print "Hello world!\n";

$a = 100;
$b = -100;

print "Same ", "sentence", 
". ";

$x = 3;
$c = "he ";
$s = $c x $x;
$b = "bye";
print $s . "\n";
print "$s\n";
$a = $s . $b;
print $a;

# comment
$x = 10;
$s = "\nResult: $x";
print $s;


$x = 10;
$y = 10;

if($x == $y) {
    print "\n$x equals $y";
}

# Number comparison operators
# eq ==
# no !=
# gt > 
# lt < 
# ge >=
# let <=

$name = "Darius";
if ($name eq "Darius") {
    print "\nYour name is 'Darius'\n";
}

$x = 5;
$y = 10;
if($x == $y){
    print "x is equal to y";
} else {
    print "x is not equal y";
}

print "\n";
for($i = 1; $i <= 10; $i++){
    print "for loop#$i\n";
}


for $i (1, 2, 3, 4, 5) {
    print "$i\n";
}

@sequence = (1 .. 10);
$limit = 25;
for $i (@sequence, 15, 20 .. $limit) {
    print "$i\n";
}