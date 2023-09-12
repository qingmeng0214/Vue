<?php
function getApiResult($return){
    echo json_encode($return,JSON_UNESCAPED_UNICODE|JSON_PRETTY_PRINT);
}
?>