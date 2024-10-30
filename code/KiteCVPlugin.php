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

include_once 'KiteCVDir.php';

class KiteCVPlugin {
 // This class implements the KiteCV plugin functionnalities and screen generation
 // The code is common to Wordpress, DotClear, Elgg ...
 var $dir;
 var $htReqsURL;
 var $exportURL;
 var $platform;
 var $languageCode;
 var $file;
 var $errorMessage;
 var $noticeMessage;
 var $userId;
 function KiteCVPlugin($dir, $htReqsURL, $exportURL = '', $platform = 'dotclear') {
  $this->dir = $dir;
  $this->htReqsURL = $htReqsURL;       // HTML requisites base dir for js and icons
  $this->exportURL = $exportURL;
  $this->platform = $platform;
  $this->languageCode = null;
  $this->userId = null;
  $this->file = null;
  $this->errorMessage = FALSE;
  $this->noticeMessage = FALSE;
 }
 function setLanguageCode($languageCode) {
  $this->languageCode = $languageCode;
  $po_file = dirname(__FILE__).'/../locales/'.$this->languageCode.'/main.po';
  $GLOBALS['_kcv_l10n'] = array();
  $tmp = getPoFile($po_file);
  $GLOBALS['_kcv_l10n'] = array_merge($GLOBALS['_kcv_l10n'],$tmp);
 }
 function setUserId($userId) {
  $this->userId = $userId;
 }
 function openFile() {
  $this->file = $this->dir->getFile($this->languageCode, $this->userId);
 }
 function getHeaderHTML() {
  return
   '<style type="text/css">'.
   '@import "'.$this->htReqsURL.'/styles/KiteCV_'.$this->platform.'.css";'.
   '</style>'."\n".
   /*'<style type="text/css">'.
   '@import "'.$this->htReqsURL.'/styles/EuropassCV.css";'.
   '</style>'."\n".
   '<style type="text/css">'.
   '@import "'.$this->htReqsURL.'/styles/EuropassCVForm.css";'.
   '</style>'."\n".
   ($this->platform == 'dotclear'
   ? ''
   : '<style type="text/css">'.
     '@import "'.$this->htReqsURL.'/styles/dcTabs.css";'.
     '</style>'."\n").*/
   '<link rel="stylesheet" type="text/css" media="all"'.
   ' href="'.$this->htReqsURL.'/js/jscalendar-1.0/calendar-win2k-cold-1.css"'.
   ' title="win2k-cold-1"/>'."\n".
   '<script type="text/javascript" src="'.$this->htReqsURL.'/js/jscalendar-1.0/calendar.js"></script>'."\n".
   '<script type="text/javascript" src="'.$this->htReqsURL.'/js/jscalendar-1.0/lang/calendar-en.js"></script>'."\n".
   '<script type="text/javascript" src="'.$this->htReqsURL.'/js/jscalendar-1.0/calendar-setup.js"></script>'."\n".
   '<script type="text/javascript" src="'.$this->htReqsURL.'/js/kitecv.js"></script>'."\n".
   '<script type="text/javascript" src="'.$this->htReqsURL.'/js/common.js"></script>'."\n".
   '<script type="text/javascript" src="'.$this->htReqsURL.'/js/multi-part-page.js"></script>'."\n";
 }
 function doActions() {
  // triggers requested or required actions.
  // Returns TRUE on success, FALSE on error
  // Sets $this->noticeMessage.
  $old_level = error_reporting(E_ALL);
  $missingModules = array();
  if (version_compare(phpversion(), '5') == -1) { // PHP4
   if (!function_exists('domxml_open_file')) {
    $missingModules[] = 'DOM XML';
   }
   if (!function_exists('xslt_create')) {
    $missingModules[] = 'XSLT';
   }
   if (!class_exists('ZipArchive')) {
    $missingModules[] = 'Zip';
   }
  } else { // PHP5
   /* if (!class_exists('ZipArchive')) {
    $missingModules[] = 'Zip';
   } */
   if (!class_exists('XSLTProcessor')) {
    $missingModules[] = 'XSL';
   }
  }
  if (!empty($missingModules)) {
   $this->noticeMessage = '
   The <strong>KiteCV</strong> plugin requires either
   <ul><li>PHP5 with modules XSL (required) and Zip (for OpenDocument export), or</li>
   <li>PHP4 with modules DOMXML, XSLT and Zip.</li></ul>
   Your PHP version is <strong>'.phpversion().'</strong>.';
   foreach ($missingModules as $module) {
    $this->noticeMessage .=
     "<br/>Missing module : <strong>$module</strong>";
   }
   return;
  }
  if (!is_writable($this->dir->path)) {
   $this->errorMessage = 'Directory <em>'.$this->dir->path.'</em> is not writable'.
    ' (that is where the KiteCV plugin stores its data).';
   return;
  }
  if (array_key_exists('KiteCVAction', $_POST)) {
   $ok = FALSE;
   switch ($_POST['KiteCVAction']) {
   case 'createCV':
    if ($this->file->create($this->languageCode))
     $this->noticeMessage = KiteCVTranslate('The CV was created.');
    else
     $this->errorMessage = $this->file->getErrorMessage();
    break;
   case 'deleteCV':
    if ($this->file->delete()) {
     $this->noticeMessage = KiteCVTranslate('The CV was deleted.');
     $enabledLanguages = $this->dir->getEnabledLanguageList($this->userId);
     if (count($enabledLanguages) > 0) {
      $this->setLanguageCode($enabledLanguages[0]);
     } else {
      $this->setLanguageCode(null);
     }
     $this->dir->setSelectedLanguage($this->userId, $this->languageCode);
     $this->file = $this->dir->getFile($this->languageCode, $this->userId);
    } else
     $this->errorMessage = $this->file->getErrorMessage();
    break;
   case 'modifyCV':
    if ($this->file->modify()) {
     // This is occuring very often, let's not notify it
     // $this->noticeMessage = 'The CV was modified.';
     if (array_key_exists('photoFile', $_FILES)) {
      if ($this->uploadPhoto())
       $this->noticeMessage = KiteCVTranslate('The photo was uploaded');
      else
       $this->errorMessage = $this->getErrorMessage();
     }
    } else
     $this->errorMessage = $this->file->getErrorMessage();
    break;
   case 'uploadCV':
    if ($this->upload())
     $this->noticeMessage = KiteCVTranslate('The CV was uploaded.');
    else
     $this->errorMessage = $this->getErrorMessage();
    break;
   default:
    $this->errorMessage = 'Unexpected action: '.$_POST['KiteCVAction'];
    break;
   }
  }
  error_reporting($old_level);
 }
 function getErrorMessage() {
  // returns an error message string if any, or FALSE.
  return $this->errorMessage;
 }
 function getNoticeMessage() {
  // returns a notice message string if any, or FALSE.
  return $this->noticeMessage;
 }
 function getManagementDiv() {
  $old_level = error_reporting(E_ALL);
  $r = '<div id="KiteCV">'."\n";
  $r .= $this->getMenu();
  if (
   isset($this->languageCode)
   and
   $this->file->exists()
  ) {
   $r .= $this->getCVEditorDiv();
  } else {
   $r .= '<div id="KiteCV_intro"'."\n";
   $r .= KiteCVTranslate('<p style="font-size:150%">Welcome to your Europass CV editor.</p>
<p>
Here you will be able to create a Master CV, per official EU language, where you can store all your personal data.
For each Master CV created, you can compose as many customised CVs as you need.
A customised CV, which is a VIEW of your Master CV, can be exported in several formats such as PDF, ODT, XHTML to be presented on the web and even HR-XML to facilitate data exchanges with online Recruitment and HR services.</p>
<p>There are only 3 simple steps to build your CV:
create your master CV, compose a view and export it!
Isn\'t it easy?</p>
<p>In order to start, just select the language of your Master CV in the CREATE drop down menu.</p>');
  $r .= '</div>'."\n";
  }
  $r .= '</div>'."\n";
  error_reporting($old_level);
  return $r;
 }
 function getMenu() {
  $r = '<div id="KiteCV_menu">';
  $r .= $this->getCVSelectorDiv();
  $r .= $this->getCVCreatorDiv();
  $r .= $this->getCVUploaderDiv();
  $r .= '<hr style="margin:0; padding:0; clear:both; height:1px; background:transparent; border:none;" />';
  $r .= '</div>';
  return $r;
 }
 function getCVEditorDiv() {
  global $core;
  // This function gets called when there is a language code and a valid file exists.
  $xsltFileName = 'hrxml2xhtml_form.xsl'; // default form is the master CV form
  $arguments = 'languageCode='.$this->languageCode; // minimal argument is the currently selected languageCode
  if (array_key_exists('KiteCVXsltName', $_POST) && !empty($_POST['KiteCVXsltName'])) {
   // A right-pane form name was specified.
   $KiteCVXsltName = $_POST['KiteCVXsltName'];
   // Split the actual XSLT file name from its arguments :
   $elements = explode(' ', $KiteCVXsltName);
   $xsltFileName = array_shift($elements);
   if (count($elements) > 0) {
    $arguments .= ' '.implode(' ', $elements);
   }
  }
  return
   '<div id="KiteCV_editorDiv">'."\n".
   '<form action="#" method="post" enctype="multipart/form-data">'."\n".
   (is_callable(array($core, 'formNonce')) ? $core->formNonce() : '').
   '<input type="hidden" name="MAX_FILE_SIZE" value="1000000"/>'.
      '<input type="hidden" name="KiteCVXsltName"'.
   ' value="'.$xsltFileName.' '.$arguments.'"/>'."\n". // by default, we are staying on the same right-pane form
      '<input type="hidden" name="KiteCVAction" value="modifyCV" />'."\n".
      '<input type="hidden" name="delete" />'."\n".
   '<div id="KiteCV_treeDiv">'."\n".
   str_replace(
    '_htReqsURL_',
    $this->htReqsURL,
    preg_replace(
     '/_exportURL_\?position=([^&]+)&amp;format=([a-z]+)/',
     sprintf($this->exportURL, $this->userId, $this->languageCode, '$2', '$1'),
     $this->file->generateView("hrxml2xhtml_mainform.xsl $arguments", true)
    )
   ).
   '</div>'."\n".
   '<div id="KiteCV_formDiv">'."\n".
   str_replace(
    '_htReqsURL_',
    $this->htReqsURL,
    preg_replace(
     '/_exportURL_\?position=([^&]+)&amp;format=([a-z]+)/',
     sprintf($this->exportURL, $this->userId, $this->languageCode, '$2', '$1'),
     $this->file->generateView("$xsltFileName $arguments", true)
    )
   )."\n".
   '</div>'."\n".
   '<button type="submit" style="visibility:hidden;"></button>'."\n".
   '</form>'."\n".
   '<script type="text/javascript">'."\n".
   'kiteCVOnLoad();'."\n".
   '</script>'."\n".
   '</div>'."\n";
 }
 function getCVSelectorDiv() {
  global $core;
  include "languages.php";
  $enabledLanguages = $this->dir->getEnabledLanguageList($this->userId);
  $r =
   '<div id="KiteCV_CVSelector">'."\n";
  if (count($enabledLanguages) > 0) {
   $r .=
       '<form action="#" method="post">'."\n".
    (is_callable(array($core, 'formNonce')) ? $core->formNonce() : '').
    '<label>'.KiteCVTranslate('Select:').'</label>'.
    '<select name="KiteCV_languageCode" onChange="javascript:this.form.submit();"'.
    ' class="KiteCV_languageSelect"'.
    ' style="background-image: url('. $this->htReqsURL.'/icons/flags/'.$this->languageCode.'.png);">';
   foreach ($enabledLanguages as $lang)
    $r .=
     '<option'.
     ' value="'.$lang.'"'.
     ' style="background-image: url('. $this->htReqsURL.'/icons/flags/'.$lang.'.png);"'.
     ($this->languageCode == $lang ? ' selected="1"' : '').
     '>'.
     KiteCVTranslate($availableLanguageList[$lang]).
     '</option>'."\n";
   $r .=
    '</select>'."\n".
    '</form>'."\n";
  }
  $r .=
   '</div>'."\n";
  return $r;
 }
 function getCVCreatorDiv() {
  global $core;
  include "languages.php";
  $enabledLanguages = $this->dir->getEnabledLanguageList($this->userId);
  $remainingLanguages = array_diff(
   array_keys($availableLanguageList),
   $enabledLanguages
  );
  $r =
   '<div id="KiteCV_CVCreator">'."\n";
  if (count($remainingLanguages) > 0) {
   $r .=
    '<form action="#" method="post">'."\n".
    (is_callable(array($core, 'formNonce')) ? $core->formNonce() : '').
    '<input type="hidden" name="KiteCVAction" value="createCV"/>'."\n".
    '<label>'.KiteCVTranslate('Create:').'</label>'."\n".
    '<select class="KiteCV_languageSelect" name="KiteCV_languageCode" onChange="javascript:this.form.submit();">'.
    '<option> </option>';
   foreach ($remainingLanguages as $lang)
    $r .=
     '<option'.
     ' value="'.$lang.'" '.
     ' style="background-image: url('. $this->htReqsURL.'/icons/flags/'.$lang.'.png);"'.
     '>'.
     KiteCVTranslate($availableLanguageList[$lang]).
     '</option>'."\n";
   $r .=
       '</select>'."\n".
    '</form>'."\n";
  }
  $r .=
   '</div>'."\n";
  return $r;
 }
 function getCVUploaderDiv() {
  global $core;
  $r =
   '<div id="KiteCV_CVUploader">'."\n".
   '<form action="#" method="post" enctype="multipart/form-data">'.
   (is_callable(array($core, 'formNonce')) ? $core->formNonce() : '').
   '<input type="hidden" name="KiteCVAction" value="uploadCV"/>'.
   '<input type="hidden" name="MAX_FILE_SIZE" value="1000000"/>'.
   '<label>'.KiteCVTranslate('Upload:').'</label>'.
   '<input type="file" name="cvFile" onChange="javascript:if(confirm(\'Please confirm:\nyour current CV file of the same language, if any, will be overwritten.\')) this.form.submit();"/>'.
   #'<button type="button" onClick="javascript:if(confirm(\'Please confirm:\nyour current CV file of the same language, if any, will be overwritten.\')) this.form.submit();">'.
   '</form>'.
   '</div>'."\n";
  return $r;
 }
 function replyWithRawFile() {
  header('Content-type: text/xml');
  readfile($this->file->path);
 }
 function replyWithPhoto() {
  header('Content-type: image/jpeg');
  readfile($this->dir->photoPath($this->userId));
 }
 function replyWithExport($format, $position, $accessCode) {
  if ($format == 'photo') {
   return $this->replyWithPhoto();
  }
  include "formats.php"; # for $availableFormatList
  if ($this->file->checkAccessCode($format, $position, $accessCode)) {
   header('Content-type: '.$availableFormatList[$format]['mime-type']);
   if ($format != 'xhtml') {
    header('Content-Disposition: attachment; filename="cv_'.$this->languageCode.'_'.$position.'.'.$format.'"');
   }
   $html = str_replace(
    '_htReqsURL_',
    $this->htReqsURL,
    preg_replace(
     '/_exportURL_\?position=([^&]+)&amp;format=([a-z]+)/',
     sprintf(str_replace('&', '&amp;', $this->exportURL), $this->userId, $this->languageCode, '$2', '$1'),
     $this->file->generateViewFromFormatAndPosition($format, $position)
    )
   );
   if ($format == 'odt') {
    $tempname = tempnam('/tmp', 'kiteCV_odt');
    if ($tempname !== FALSE) {
     if (copy(dirname(__FILE__).'/export_template.odt', $tempname)) {
      $zip = new ZipArchive();
      if ($zip->open($tempname)) {
       $zip->deleteName('content.xml');
       $zip->addFromString('content.xml', $html);
       $zip->close();
       readfile($tempname);
      }
      unlink($tempname);
     }
    }
   } elseif ($format == 'cedefoppdf') {
    //require_once('soap/nusoap.php');
    
    $document = $html;
    $filetype = 'pdf';
    $locale = ''; // autodetect

    stream_wrapper_restore('http');
    $client = new SoapClient("http://europass.cedefop.europa.eu/instrumentssrv/services/Instruments?wsdl", array('exceptions'=>false, 'trace'=>true));
    
    $response = $client->getDocumentFromCV($document, $filetype, $locale);

    //Trace to debug soap requests
    //echo "Request :\n";
    //echo htmlspecialchars($client->__getLastRequest())."\n";
    //echo "Response :\n";
    //echo htmlspecialchars($client->__getLastResponse())."\n";

    echo $response;
    
    // $request = xmlrpc_encode_request('getDocumentFromCV',array($document, $filetype, $locale));
    // FIXME: this does not work, download xmlrpc-epi-php-0.51.tar.gz from
    // http://sourceforge.net/project/showfiles.php?group_id=23199&package_id=16706
    // and have a look in the samples/ dir.

    //$function = new xmlrpcmsg('getDocumentFromCV',array(new xmlrpcval($document, "string"), new xmlrpcval($filetype, "string"), new xmlrpcval($locale, "string")));
    //$client = new xmlrpc_client('/instrumentssrv/services/Instruments','europass.cedefop.europa.eu');
    //$client->setDebug(1);
    //$response = $client->send($function);
    //if (!$reponse) { die("RPC send failed."); }
    //echo "Recuperation de la valeur de retour\n";
    //$value = $reponse->value();
    //echo "Je sais pas ce que c'est scalarval()\n";
    //$pdf = $value->scarlarval();
    //$pdf = http_post_data('http://europass.cedefop.europa.eu/instrumentssrv/services/Instruments', $request);
    
    //echo $pdf;
   } else {
    echo $html;
   }
  } else {
   header('Content-type: text/html');
   echo $this->getAccessCodeFormPage();
  }
 }
 function getAccessCodeFormPage() {
  global $core;
  $r = '<?xml version="1.0"?>'."\n".
   '<html xmlns="http://www.w3.org/1999/xhtml">'.
   '<head>'.
   '<title>Access code required</title>'.
   '</head>'.
   '<body onLoad="javascript:document.forms[0].elements.accessCode.focus();">'.
   '<form action="'.$_SERVER['REQUEST_URI'].'" method="POST">'.
   (is_callable(array($core, 'formNonce')) ? $core->formNonce() : '').
   '<label for="accessCode">Please type the access code:</label>'.
   '<input type="text" name="accessCode"/>'.
   '<button type="submit">Send</button>'.
   '</form>'.
   '</body>'.
   '</html>';
  return $r;
 }
 function getXHTMLView($position) {
  return str_replace(
    '_htReqsURL_',
    $this->htReqsURL,
    $this->file->generateView(
     'hrxml2xhtml_export.xsl position='.$position
    )
  );
 }
 function upload() {
  $tmp_name = $_FILES['cvFile']['tmp_name'];
  if (is_uploaded_file($tmp_name)) {
   if (version_compare(phpversion(), '5') == -1) { // PHP4
    $dom = domxml_open_file($tmp_name);
   } else { // PHP5
    $dom = new DOMDocument();
    $dom->load($tmp_name);
   }
   if ($dom) {
    if (version_compare(phpversion(), '5') == -1) { // PHP4
     $xpathContext = xpath_new_context($dom);
     xpath_register_ns($xpathContext, hr_ns_prefix, hr_ns_url);
     $xpathResult = $xpathContext->xpath_eval('/hr:Candidate');
     $nodeset = $xpathResult->nodeset;
     $rootIsCandidate = (count($nodeset) > 0);
    } else {
     $xpathContext = new DOMXPath($dom);
     $xpathContext->registerNamespace(hr_ns_prefix, hr_ns_url);
     $nodeset = $xpathContext->query('/hr:Candidate');
     $rootIsCandidate = ($nodeset->length > 0);
    }
    if ($rootIsCandidate) {
     if (version_compare(phpversion(), '5') == -1) { // PHP4
      $node = $nodeset[0];
      $lang = $node->get_attribute("xml:lang");
     } else {
      $node = $nodeset->item(0);
      $lang = $node->getAttribute("xml:lang");
     }
     if (!empty($lang)) {
      include "languages.php";
      if (array_key_exists($lang, $availableLanguageList)) {
       if (move_uploaded_file($tmp_name, $this->dir->filePath($lang, $this->userId)) !== FALSE) {
        $this->dir->setSelectedLanguage($this->userId, $lang);
        $this->setLanguageCode($lang);
        $this->file = $this->dir->getFile($lang, $this->userId);
        return TRUE;
       } else {
        $this->errorMessage = KiteCVTranslate('Could not save the uploaded file.');
       }
      } else {
       $this->errorMessage = KiteCVTranslate('The submitted file was refused because it does not specify a known language.');
      }
     } else {
      $this->errorMessage = KiteCVTranslate('The submitted file was refused because it does not specify a language. Please append attribute xml:lang to the root element ("Candidate").');
     }
    } else {
     $this->errorMessage = KiteCVTranslate('The submitted file was refused because it does not look like an HR-XML Candidate document.');
    }
   } else {
    $this->errorMessage = KiteCVTranslate('Error while parsing the submitted file. Are you sure this is an XML document ?');
   }
  } else {
   $this->errorMessage = KiteCVTranslate('Please specify a file.');
  }
  return FALSE;
 }
    function uploadPhoto() {
  $tmp_name = $_FILES['photoFile']['tmp_name'];
  if (is_uploaded_file($tmp_name)) {
   if (move_uploaded_file($tmp_name, $this->dir->photoPath($this->userId)) !== FALSE) {
    return TRUE;
   } else {
    $this->errorMessage = KiteCVTranslate('Could not save the uploaded file.');
   }
  } else {
   $this->errorMessage = KiteCVTranslate('Please specify a file.');
  }
  return FALSE;
 }
}

// Stolen from DotClear 2
function KiteCVTranslate($str) {
 return (!empty($GLOBALS['_kcv_l10n'][$str])) ? $GLOBALS['_kcv_l10n'][$str] : $str;
}
function getPoFile($file) {
 if (!file_exists($file)) {
  error_log("po file not found '$file'");
  return false;
 }
 $fc = implode('',file($file));
 $res = array();
 $matched = preg_match_all('/(msgid\s+("([^"]|\\\\")*?"\s*)+)\s+'.'(msgstr\s+("([^"]|\\\\")*?(?<!\\\)"\s*)+)/', $fc, $matches);
 if (!$matched) {
  error_log("strings not found in '$file'");
  return false;
 }
 for ($i=0; $i<$matched; $i++) {
  $msgid = preg_replace('/\s*msgid\s*"(.*)"\s*/s','\\1',$matches[1][$i]);
  $msgstr= preg_replace('/\s*msgstr\s*"(.*)"\s*/s','\\1',$matches[4][$i]);
  $msgstr = poString($msgstr);
  if ($msgstr) {
   $res[poString($msgid)] = $msgstr;
  }
 }
 if (!empty($res[''])) {
  $meta = $res[''];
  unset($res['']);
 }
 return $res;
}
function poString($string,$reverse=false) {
 if ($reverse) {
  $smap = array('"', "\n", "\t", "\r");
  $rmap = array('\\"', '\\n"' . "\n" . '"', '\\t', '\\r');
  return trim((string) str_replace($smap, $rmap, $string));
 } else {
  $smap = array('/"\s+"/', '/\\\\n/', '/\\\\r/', '/\\\\t/', '/\\\"/');
  $rmap = array('', "\n", "\r", "\t", '"');
  return trim((string) preg_replace($smap, $rmap, $string));
 }
}
// vim: ts=4 sts=4 sw=4

?>
