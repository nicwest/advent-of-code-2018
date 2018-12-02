<?php 


$twos = 0;
$threes = 0;

while($box_id = trim(fgets(STDIN))){
    $chars = str_split($box_id);
    $count = array();

    foreach ($chars as $char) {
        if(array_key_exists($char, $count)) {
            $count[$char] += 1;
        } else {
            $count[$char] = 1;
        }
    }

    $is_two = false;
    $is_three = false;
    foreach ($count as $char => $n) {
        switch($n) {
        case 2:
            $is_two = true;
            break;
        case 3:
            $is_three = true;
            break;
        }
    }

    if($is_two) {
        $twos += 1;
    }
    if($is_three) {
        $threes += 1;
    }
}

$checksum = $twos * $threes;
echo("checksum: $checksum\n");

?>
