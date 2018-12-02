<?php 

$ids = array();

while($box_id = trim(fgets(STDIN))){
    $ids[] = str_split($box_id);
}

foreach($ids as $A) {
    foreach($ids as $B) {
        $diff = array_map(function($a, $b){
            if($a == $b) {
                return 0;
            }
            return 1;
        }, $A, $B);
        $total_diff = array_sum($diff);
        if($total_diff == 1) {
            $same = implode(array_intersect($A, $B));
            echo("same: $same\n");
            return;
        }
    }
}

?>
