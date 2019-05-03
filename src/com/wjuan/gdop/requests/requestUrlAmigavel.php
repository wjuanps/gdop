<?php
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
	require_once '../util/urlAmigavel.php';
	$url = trim(strip_tags(filter_input(INPUT_GET, 'url', FILTER_SANITIZE_STRING)));
	if (!empty($url)) {
		die(json_encode(array('url' => urlAmigavel($url))));
	}
}