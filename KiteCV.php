<?php
/*
Plugin Name: KiteCV
Plugin URI: http://www.kite-eu.org/
Description: Compose your Europass CV and export views of it as HR-XML
Version: 1.0
Author: Kite European Projet
Author URI: http://www.kite-eu.org/

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

// This file integrates KiteCVPlugin in Wordpress
// Wordpress MU support by Raymond Elferink <raymond@raycom.com>

include_once 'code/KiteCVPlugin.php';

class KiteCV {
	var $dir;
	var $plugin;
	var $wp_plugin_dir;
	function KiteCV() {
		#$old_level = error_reporting(E_ALL);
		if( defined( 'MUPLUGINDIR' ) == false ) {
			$this->wp_plugin_dir = PLUGINDIR;
		}else{
			$this->wp_plugin_dir = MUPLUGINDIR;
		}
		add_action('admin_head', array(&$this, 'start')); // load class when userdata is available in WP
		add_action('admin_head', array(&$this, 'add_head'));
		add_action('admin_menu', array(&$this, 'add_menu'));
		add_action('admin_notices', array(&$this, 'admin_notices'));
		add_filter('the_content', 'KiteCV_filter_content');
		load_plugin_textdomain('default', $this->wp_plugin_dir.'/KiteCV/locales');
		#error_reporting($old_level);
	}
	function start(){ // function to load KiteCV later, when WP userdata is available
		#$old_level = error_reporting(E_ALL);
		$this->dir = new KiteCVDir(
			dirname(__FILE__).'/data'
		);
		$this->plugin = new KiteCVPlugin(
			$this->dir,
			'../'.$this->wp_plugin_dir.'/KiteCV/requisites',							// HTML requisites URL
			'../'.$this->wp_plugin_dir.'/KiteCV/export.php?uid=%1$s&languageCode=%2$s&format=%3$s&position=%4$s',	// exportURL
			'wordpress'
		);
		$objUser = wp_get_current_user();
		$userId = $objUser->ID;
		$this->plugin->setUserId($userId);
		if (array_key_exists('KiteCV_languageCode', $_POST)) {
			$KiteCV_languageCode = $_POST['KiteCV_languageCode'];
			$this->dir->setSelectedLanguage($userId, $KiteCV_languageCode);
		} else {
			$KiteCV_languageCode = $this->dir->getSelectedLanguage($userId);
		}
		if ($KiteCV_languageCode !== FALSE) {
			$this->plugin->setLanguageCode($KiteCV_languageCode);
			$this->plugin->openFile();
			if (array_key_exists('KiteCV_download', $_POST)) {
				$this->plugin->replyWithRawFile();
				exit;
			}
		}
		#error_reporting($old_level);
	}
	function add_head() {
		echo $this->plugin->getHeaderHTML();
	}
	function add_menu() {
		add_management_page(__('CV'), __('CV'), 8, 'KiteCV', array(&$this, 'management_page'));
	}
	function admin_notices() {
		#$old_level = error_reporting(E_ALL);
		$this->plugin->doActions();
		if (FALSE !== ($errorMessage = $this->plugin->getErrorMessage())) {
 			echo '<div id="message" class="error fade"><p>'.$errorMessage.'</p></div>';
		} elseif (FALSE !== ($noticeMessage = $this->plugin->getNoticeMessage())) {
 			echo '<div id="message" class="updated fade"><p>'.$noticeMessage.'</p></div>';
		}
		#error_reporting($old_level);
	}
	function management_page() {
		echo $this->plugin->getManagementDiv();
	}
	function getXHTMLView($languageCode, $position) {
		$this->plugin->setLanguageCode($languageCode);
		$this->plugin->openFile();
		return $this->plugin->getXHTMLView($position);
	}
}

$KiteCV = new KiteCV();

function KiteCV_filter_content($content) {
	echo preg_replace_callback(
		'/KiteCVView_(..)_([0-9]+)/',
		create_function(
			'$matches',
			'global $KiteCV;return $KiteCV->getXHTMLView($matches[1], $matches[2]);'
		),
		$content
	);
}
?>
