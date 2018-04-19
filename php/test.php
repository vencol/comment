<?php
function isPost() {
	return $_SERVER['REQUEST_METHOD'] == 'POST' ? true : false;
}
if(isPost())
{
	echo "post";
	echo "a="+$_POST[a];
}
else
	echo "get";
?>
