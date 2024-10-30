<?php
/*
This file is part of KiteCV.
Copyright ©2006 Les Developpements Durables <contact@ldd.fr> and
Sébastien Ducoulombier <seb@ldd.fr>.

KiteCV is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

KiteCV is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

// This file handles export requests

include_once 'code/KiteCVPlugin.php';

$wp_plugins_dir = is_dir('../../mu-plugins') ? '../../mu-plugins' : '../../plugins';

function __($a) {
	// FIXME: this is cheating
	return $a;
}

$old_level = error_reporting(E_ALL);
$dir = new KiteCVDir(
	dirname(__FILE__).'/data'
);
$plugin = new KiteCVPlugin(
	$dir,
	$wp_plugins_dir.'/KiteCV/requisites',	// HTML requisites URL
	'export.php?uid=%1$s&languageCode=%2$s&format=%3$s&position=%4$s'	// exportURL
);
$userId = $_GET['uid'];
$plugin->setUserId($userId);
$languageCode = $_GET['languageCode'];
$plugin->setLanguageCode($languageCode);
$plugin->openFile();
$format = $_GET['format'];
$position = $_GET['position'];
$accessCode = array_key_exists('accessCode', $_POST)
	? $_POST['accessCode']
	: '';
$plugin->replyWithExport($format, $position, $accessCode);
?>
