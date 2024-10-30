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

include_once 'KiteCVFile.php';

class KiteCVDir {
	// This class represents the CV repository
	var $path;
	function KiteCVDir($path) {
		$this->path = $path;
	}
	function getEnabledLanguageList($userId) {
		// Returns an array of existing (created) CV language codes
		$list = array();		
		foreach (glob($this->path.'/Candidate-'.$userId.'-??.xml') as $path) {
			$list[] = preg_replace('/^.*-([^-]*).xml$/', "$1", $path);
		}
		return $list;
	}
	function getSelectedLanguage($userId) {
		$enabledLanguageList = $this->getEnabledLanguageList($userId);
		$selectedLanguageFilePath = $this->path.'/SelectedLanguage-'.$userId.'.txt';
		if (file_exists($selectedLanguageFilePath)) {
			$selectedLanguage = file_get_contents($selectedLanguageFilePath);
			if (in_array($selectedLanguage, $enabledLanguageList)) {
				return $selectedLanguage;
			}
		}
		return FALSE;
	}
	function setSelectedLanguage($userId, $selectedLanguage) {
		$selectedLanguageFilePath = $this->path.'/SelectedLanguage-'.$userId.'.txt';
		if (!empty($selectedLanguage)) {
			file_put_contents($selectedLanguageFilePath, $selectedLanguage);
		} else {
			unlink($selectedLanguageFilePath);
		}
	}
	function getFile($languageCode, $userId) {
		return new KiteCVFile(
			$this->filePath($languageCode, $userId)
		);
	}
	function filePath($languageCode, $userId) {
		return sprintf('%s/Candidate-%s-%s.xml', $this->path, $userId, $languageCode);
	}
	function photoPath($userId) {
		return sprintf('%s/photo-%s.jpeg', $this->path, $userId);
	}
}
