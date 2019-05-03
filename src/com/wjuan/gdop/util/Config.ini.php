<?php

	$getUrl = strip_tags(trim(filter_input(INPUT_GET, 'url', FILTER_DEFAULT)));
	$setUrl = (empty($getUrl) ? 'index' : $getUrl);
	$url    = explode('/', $setUrl);

?>