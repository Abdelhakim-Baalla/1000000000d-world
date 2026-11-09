<?php
$A = explode(" ", trim(fgets(STDIN)));
$B = explode(" ", trim(fgets(STDIN)));

$i = 0;
$j = 0;
$dot_product = 0;

$countA = count($A);
$countB = count($B);

while ($i < $countA && $j < $countB) {
    $overlap = min($A[$i], $B[$j]);

    $dot_product += $overlap * $A[$i + 1] * $B[$j + 1];

    $A[$i] -= $overlap;
    $B[$j] -= $overlap;

    if ($A[$i] == 0) $i += 2;
    if ($B[$j] == 0) $j += 2;
}

echo $dot_product . "\n";
