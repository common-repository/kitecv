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

define('hr_ns_prefix', 'hr');
define('hr_ns_url', 'http://ns.hr-xml.org/2006-02-28');
class KiteCVFile {
	// This class represents a CV file.
	var $path;
	var $errorMessage;
	function KiteCVFile($path) {
		$this->path = $path;
		$this->errorMessage = FALSE;
	}
	function getErrorMessage() {
		return $this->errorMessage;
	}
	function exists() {
		return file_exists($this->path);
	}
	function create($languageCode) {
		$ok = TRUE;
		if (!$this->exists()) {
			if (version_compare(phpversion(), '5') == -1) { // PHP4
				$dom = domxml_new_doc('1.0');
				$rootElement = $dom->create_element('Candidate');
				$rootElement->set_attribute('xmlns', hr_ns_url);
				$rootElement->set_attribute('xml:lang', $languageCode);
				$rootElement->set_attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
				$rootElement->set_attribute('xsi:schemaLocation', "http://ns.hr-xml.org/2006-02-28\nCandidate.xsd");
				$dom->append_child($rootElement);
				$ok = $dom->dump_file($this->path);
			} else { // PHP5
				$dom = new DOMDocument();
				$rootElement = $dom->createElementNS(hr_ns_url, 'Candidate');
				$rootElement->setAttribute('xml:lang', $languageCode);
				$rootElement->setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
				$rootElement->setAttribute('xsi:schemaLocation', "http://ns.hr-xml.org/2006-02-28\nCandidate.xsd");
				$dom->appendChild($rootElement);
				$ok = $dom->save($this->path);
			}
			if (!$ok) {
				$this->errorMessage = 'A new CV could not be initialized.';
			}
		}
		return $ok;
	}
	function delete() {
		$ok = unlink($this->path);
		if (!$ok) {
			$this->errorMessage = 'The CV could not be deleted.';
		}
		return $ok;
	}
	function modify() {
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$dom = domxml_open_file($this->path);
		} else { // PHP5
			$dom = new DOMDocument();
			$dom->load($this->path);
		}
		if (!$dom) {
			$this->errorMessage = 'Could not parse the CV document.';
			return FALSE;
		}
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$xpathContext = xpath_new_context($dom);
			xpath_register_ns($xpathContext, hr_ns_prefix, hr_ns_url);
		} else { // PHP5
			$xpathContext = new DOMXPath($dom);
			$xpathContext->registerNamespace(hr_ns_prefix, hr_ns_url);
		}
		$prefixToRemove = '/hr:Candidate/';
		include(dirname(__FILE__).'/CandidateSequences.php');
		$ignoredKeys = array('KiteCVAction', 'KiteCVXsltName', 'KiteCVObject', 'photoFile', 'MAX_FILE_SIZE', 'x', 'y', 'xd_check');
		foreach ($_POST as $key => $value) {
			$key = stripslashes($key);
			$value = stripslashes($value);
			$prefixPositionInKey = strpos($key, $prefixToRemove);
			$prefixPositionInValue = strpos($value, $prefixToRemove);
			if ($prefixPositionInKey !== FALSE && $prefixPositionInKey == 0) {
				$path = substr($key, strlen($prefixToRemove));
				$path = strtr($path, "()", "[]");
				if (version_compare(phpversion(), '5') == -1) { // PHP4
					$this->createNode($xpathContext, $dom->document_element(), $path, $value, $tree['Candidate']);
				} else { // PHP5
					$this->createNode($xpathContext, $dom->firstChild, $path, $value, $tree['Candidate']);
				}
			} elseif (array_search($key, $ignoredKeys) !== FALSE) {
				// ignore.
			} elseif ($key == 'delete' && $prefixPositionInValue !== FALSE && $prefixPositionInValue == 0) {
				$path = substr($value, strlen($prefixToRemove));
				$path = strtr($path, "()", "[]");
				$pathToDelete = $path;
			} elseif ($key == 'delete' && $value == '') {
				// ignore.
			} else {
				$this->errorMessage = "Unexpected POST variable : ".$key.'='.$value;
				return FALSE;
			}
		}
		if (isset($pathToDelete)) {
			// echo "Deleting node $pathToDelete.<br/>\n";
			if (version_compare(phpversion(), '5') == -1) { // PHP4
				$this->deleteNode($xpathContext, $dom->document_element(), $pathToDelete);
			} else { // PHP5
				$this->deleteNode($xpathContext, $dom->documentElement, $pathToDelete);
			}
		}
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$this->tidyUp($xpathContext, $dom->document_element());
			$dom->dump_file($this->path);
		} else { // PHP5
			$this->tidyUp($xpathContext, $dom->documentElement);
			$dom->save($this->path);
		}
		return TRUE;
	}
	function generateViewFromFormatAndPosition($format, $position) {
		if ($format == 'pdf')
			return $this->generatePDFView($position);
		return $this->generateView('hrxml2'.$format.'_export.xsl position='.$position);
	}
	function generatePDFView($position) {
		include_once dirname(__FILE__).'/fpdf/fpdf.php';
		$pdf=new FPDF();
		$pdf->AddPage();
		$pdf->SetFont('Arial','B',16);
		$pdf->Cell(40,10,'Hello World !');
		return $pdf->Output(null, 'S');
	}
	function generateView($spec, $postprocessXHTML = false) {
		// Processes the XML document through an XSLT.
		// $spec contains either
		// - the XSLT file name alone, or
		// - the XSLT file name followed by arguments.
		// Usage example :
		// $cvFile->generateView('mysheet.xsl arg1=23 arg2=name')
		if (strpos($spec, ' ') === FALSE) {
			$xsltName = $spec;
			$xsltParam = null;
		} else {
			list($xsltName, $paramString) = explode(' ', $spec, 2);
			$xsltParam = array();
			foreach (explode(' ', $paramString) as $paramLine) {
				list($name, $value) = explode('=', $paramLine, 2);
				$xsltParam[$name] = $value;
			}
		}
		$xsltPath = dirname(__FILE__).'/'.$xsltName;
		$fullXsltPath = preg_replace('/^(.+).xsl$/', '$1'.'_full.xsl', $xsltPath);
		if (file_exists($fullXsltPath)) {
			$xsltPath = $fullXsltPath;
		}
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$xp = xslt_create();
			$xsl = preg_replace(
				'/exslt:node-set\(([^)]+)\)/e',
				"'$1'",
				file_get_contents($xsltPath)
			);
			$arguments = array('/_xsl' => $xsl);
			$html = xslt_process($xp, $this->path, 'arg:/_xsl', NULL, $arguments, $xsltParam);
			xslt_free($xp);
		} else { // PHP5
			$doc = new DOMDocument();
			$xsl = new XSLTProcessor();
			$doc->load($xsltPath);
			$xsl->importStyleSheet($doc);
			$doc->load($this->path);
			if ($xsltParam != NULL) {
				foreach($xsltParam as $key => $value) {
					$xsl->setParameter('', $key, $value);
				}
			}
			$xsl->registerPHPFunctions(
				array(
					'KiteCVFile::frameLines',
					'KiteCVFile::nl2brAndLink',
					'KiteCVFile::hrxmlDate2cedefopDate'
				)
			);
			if ($postprocessXHTML) {
				$doc = $xsl->transformToDoc($doc);
				$doc2 = new DOMDocument();
				$doc2->load(dirname(__FILE__).'/xhtml2xhtml_postprocess.xsl');
				$xsl = new XSLTProcessor();
				$xsl->importStyleSheet($doc2);
			}
			$html = $xsl->transformToXML($doc);
		}
		$html = preg_replace('/__\(([^_\n<]+)\)/e', 'KiteCVTranslate("$1")', $html);
		return $html;
	}
			static function frameLines($text, $before, $after) {
				$lines = explode("\n", $text);
				return $before.implode($after.$before, $lines).$after;
			}
			static function nl2brAndLink($text) {
				$lines = explode("\n", $text);
				$r = implode('<br/>', $lines);
				$r = ereg_replace(
					"([^a-zA-Z0-9]|^)([[:alpha:]]+://[^<>[:space:]]+[[:alnum:]/])([,. ]|$)",
					"\\1<a href=\"\\2\">\\2</a>\\3",
					$r
				);
				return $r;
			}
			static function hrxmlDate2cedefopDate($text) {
				if ($text == '') {
					# TODO: log an error
					return '';
				}
				$a = explode("-", $text);
				if (count($a) != 3) {
					# TODO: log an error
					return '';
				}
				$r =
					'<year>'.$a[0].'</year>'.
					'<month>--'.$a[1].'</month>'.
					'<day>---'.$a[2].'</day>';
				return $r;
			}
	function createNode(&$xpathContext, &$domElement, $path, $content, $nameTree = array()) {
		// This recursive method creates and returns the node at $path with $domElement as origin (root).
		// $nameTree is a tree of all element names defined in the XML Schema.
		// It is used as a guide on where to insert a node.

		// The method returns the new node,
		// unless it does not already exist AND its content is an empty string (FALSE is returned in this case)
		// The code is not universal at all, and only answers KiteCV needs.

		# 0. If the path is an empty string, set $domElement's content and return it.
		if ($path == '') {
			if (version_compare(phpversion(), '5') == -1) { // PHP4
				//echo "0 replacing content of ".$domElement->node_name()." from ".$domElement->get_content()." to $content.<br/>\n";
			} else {
				//echo "0 replacing content of ".$domElement->nodeName." from ".$domElement->textContent." to $content.<br/>\n";
			}
			$this->replace_content($domElement, $content);
			return $domElement;
		}

		# 1. If the node already exists, set its content and return it.
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$xpathResult = $xpathContext->xpath_eval($path, $domElement);
			$nodeset = $xpathResult->nodeset;
			if (count($nodeset) > 0) {
				$node = $nodeset[0];
				if ($node->get_content() != $content) {
					//echo "1 replacing content of existing $path, ".$node->get_content().", by $content.<br/>\n";
					$this->replace_content($node, $content);
				}
				return $node;
			}
		} else { // PHP5
			$nodeset = $xpathContext->query($path, $domElement);
			if ($nodeset->length > 0) {
				$node =  $nodeset->item(0);
				if ($node->nodeValue != $content) {
					//echo "1 replacing content of existing $path, ".$node->textContent.", by $content.<br/>\n";
					$this->replace_content($node, $content);
				}
				return $node;
			}
		}

		# 2. Since the node does not exist, if $content is an empty string, we stop here, returning FALSE.
		if (trim($content) == '') {
			return FALSE;
		}

		# 3. create and return a new attribute if path is "@something"
		if ($path[0] == '@') {
			//echo "3 adding new attribute $path = $content.<br/>\n";
			if (version_compare(phpversion(), '5') == -1) { // PHP4
				return $domElement->set_attribute(substr($path, 1), $content);
			} else { // PHP5
				return $domElement->setAttribute(substr($path, 1), $content);
			}
		}

		# 4. if the first ancestor of the element we have to create exists, recurse with it and the remaining path
		if (strpos($path, '/') !== FALSE) {
			list($ancestorPath, $remainingPath) = explode('/', $path, 2);
		} else {
			$ancestorPath = $path;
			$remainingPath = '';
		}
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$xpathResult = xpath_eval($xpathContext, $ancestorPath, $domElement);
			$nodeset = $xpathResult->nodeset;
			if (count($nodeset) > 0) {
				//echo "4 ancestor $ancestorPath exists, recursing with remaining path $remainingPath<br/>\n";
				$node = $nodeset[0];
				$newTree = array_key_exists($node->node_name(), $nameTree)
				? $nameTree[$node->node_name()]
				: array();
				return $this->createNode($xpathContext, $nodeset[0], $remainingPath, $content, $newTree);
			}
		} else { // PHP5
			$nodeset = $xpathContext->query($ancestorPath, $domElement);
			if ($nodeset->length > 0) {
				//echo "4 ancestor $ancestorPath exists, recursing with remaining path $remainingPath<br/>\n";
				$node = $nodeset->item(0);
				$newTree = array_key_exists($node->nodeName, $nameTree)
				? $nameTree[$node->nodeName]
				: array();
				return $this->createNode($xpathContext, $node, $remainingPath, $content, $newTree);
			}
		}

		# 5. strip namespace prefix from the ancestor path
		$localPath = preg_replace('/^'.hr_ns_prefix.':/', '', $ancestorPath);

		# 6. separate the element name and potential bracket contents.
		$bracketContents = array();
		while (preg_match('/^(.+)\[([^\]]+)\]$/', $localPath, $matches) > 0) {
			$localPath = $matches[1];
			array_unshift($bracketContents, $matches[2]);
		}
		$elementName = $localPath;

		# 7. create the ancestor element
		//echo "7 creating ancestor element $elementName<br/>\n";
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$document = $domElement->owner_document();
			$ancestorElement = $document->create_element_ns(hr_ns_url, $elementName, hr_ns_prefix);
		} else { // PHP5
			$document = $domElement->ownerDocument;
			$ancestorElement = $document->createElementNS(hr_ns_url, $elementName);
		}

		# 8. handle bracket content that are conditions and ignore those that are positions : we assume the new element's position is n+1 in all cases
		$aPositionIsSpecified = false;
		foreach ($bracketContents as $bracketContent) {
			if (ctype_digit($bracketContent)) {
				$aPositionIsSpecified = true;
			} else {
				$condition = $bracketContent;
				# 8.1 handle "@attributeName = 'staticValue'"
				if (preg_match('/^@(\S+)\s*=\s*\'(.+)\'$/', $condition, $matches)) {
					$attributeName = $matches[1];
					$attributeValue = $matches[2];
					//echo "8 adding new condition attribute $attributeName=$attributeValue<br/>\n";
					if (version_compare(phpversion(), '5') == -1) { // PHP4
						$ancestorElement->set_attribute($attributeName, $attributeValue);
					} else { // PHP5
						$ancestorElement->setAttribute($attributeName, $attributeValue);
					}
				} else {
					echo "Warning: unhandled condition '$condition' (elementName = $elementName, remaining path = $remainingPath, path was $path).<br/>\n";
				}
			}
		}

		# 9. Find a reference node in the tree, so to insert the new element just after
		# and append the new ancestor element to its parent element
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$childElement = $domElement->first_child();
			while($childElement and $this->secondAfterFirst(array_keys($nameTree), $childElement->node_name(), $elementName)) {
				$childElement = $childElement->next_sibling();
			}
			# if $aPositionIsSpecified, make sure we are inserting the node after the other sibling with the same name
			if ($aPositionIsSpecified) {
				while ($childElement and $childElement->node_name() == $elementName) {
					$childElement = $childElement->next_sibling();
				}
			}
			if ($childElement) {
				$ancestorElement = $domElement->insert_before($ancestorElement, $childElement);
				//echo "Inserted $elementName just before ".$childElement->node_name()."<br/>\n";
			} else {
				$ancestorElement = $domElement->append_child($ancestorElement);
				//echo "Appended $elementName to the child list.<br/>\n";
			}
		} else { // PHP5
			$childElement = $domElement->firstChild;
			while($childElement and $this->secondAfterFirst(array_keys($nameTree), $childElement->nodeName, $elementName)) {
				$childElement = $childElement->nextSibling;
			}
			# if $aPositionIsSpecified, make sure we are inserting the node after the other sibling with the same name
			if ($aPositionIsSpecified) {
				while ($childElement and $childElement->nodeName == $elementName) {
					$childElement = $childElement->nextSibling;
				}
			}
			if ($childElement) {
				$ancestorElement = $domElement->insertBefore($ancestorElement, $childElement);
				//echo "Inserted $elementName just before ".$childElement->nodeName."<br/>\n";
			} else {
				$ancestorElement = $domElement->appendChild($ancestorElement);
				//echo "Appended $elementName to the child list.<br/>\n";
			}
		}

		# 10. recurse on the remaining path with the new ancestor element
		$newTree = array_key_exists($elementName, $nameTree)
		? $nameTree[$elementName]
		: array();
		return $this->createNode($xpathContext, $ancestorElement, $remainingPath, $content, $newTree);
	}
	function secondAfterFirst($list, $first, $second) {
		foreach($list as $value) {
			if ($first == $value) {
				return true;
			} elseif ($second == $value) {
				return false;
			}
		}
		//echo "Warning : Neither '$first' nor '$second' found in list=".join(',', $list)."<br/>\n";
		return false;
	}
	function deleteNode(&$xpathContext, &$domElement, $path) {
		// deletes the node at $path with $domElement as origin (root)
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$xpathResult = $xpathContext->xpath_eval($path, $domElement);
			$nodeset = $xpathResult->nodeset;
			if (count($nodeset) > 0) {
				$node = $nodeset[0];
				$parent_node = $node->parent_node();
				$parent_node->remove_child($node);
			} else {
				echo "<p>Could not remove element at path=$path</p>\n";
			}
		} else { // PHP5
			$nodeset = $xpathContext->query($path, $domElement);
			if ($nodeset->length > 0) {
				$node = $nodeset->item(0);
				$node->parentNode->removeChild($node);
			} else {
				echo "<p>Could not remove element at path=$path</p>\n";
			}
		}
	}
	function replace_content(&$node, $new_content) {
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$kids = &$node->child_nodes();
			foreach ($kids as $kid)
				if ($kid->node_type() == XML_TEXT_NODE)
					$node->remove_child($kid);
			$node->set_content($new_content);
		} else { // PHP5
			$kids = &$node->childNodes;
			foreach ($kids as $kid)
				if ($kid->nodeType == XML_TEXT_NODE)
					$node->removeChild($kid);
			$node->nodeValue = $new_content;
		}
	}
	function tidyUp(&$xpathContext, &$domElement) {
		// cleans up known potential empty branches in the document
		$done = false;
		while (!$done) {
			if (version_compare(phpversion(), '5') == -1) { // PHP4
				$xpathResult = $xpathContext->xpath_eval('//*[not(*|text()|@*)]', $domElement);
				$nodeset = $xpathResult->nodeset;
				$done = (count($nodeset) == 0);
				foreach ($nodeset as $node) {
					// echo "removing ".$node->node_name()."<br/>";
					$parent_node = $node->parent_node();
					$parent_node->remove_child($node);
				}
			} else { // PHP5
				$nodeset = $xpathContext->query('//*[not(*|text()|@*)]', $domElement);
				$done = ($nodeset->length == 0);
				foreach ($nodeset as $node) {
					// echo "removing ".$node->node_name()."<br/>";
					$parent_node = $node->parentNode;
					$parent_node->removeChild($node);
				}
			}
		}
		$requiredAttributes = array(
			'/hr:Candidate/hr:Resume/hr:StructuredXMLResume/hr:EmploymentHistory/hr:EmployerOrg/hr:PositionHistory/hr:OrgIndustry' => array(
				'primaryIndicator' => 'true'
			),
			'/hr:Candidate/hr:CandidateProfile/hr:EmploymentHistory/hr:EmployerOrg/hr:PositionHistory/hr:OrgIndustry' => array(
				'primaryIndicator' => 'true'
			),
			'/hr:Candidate/hr:Resume/hr:StructuredXMLResume/hr:EducationHistory/hr:SchoolOrInstitution' => array(
				'schoolType' => 'university'
			),
			'/hr:Candidate/hr:CandidateProfile/hr:EducationHistory/hr:SchoolOrInstitution' => array(
				'schoolType' => 'university'
			),
		);
		foreach ($requiredAttributes as $path => $attributes) {
			$attributeCondition = 'not(';
			$first = true;
			foreach (array_keys($attributes) as $attributeName) {
				if ($first) {
					$first = false;
				} else {
					$attributeCondition .= ' or ';
				}
				$attributeCondition .= "@$attributeName";
			}
			$attributeCondition .= ')';
			if (version_compare(phpversion(), '5') == -1) { // PHP4
				$xpathResult = $xpathContext->xpath_eval($path."[$attributeCondition and *]", $domElement);
				$nodeset = $xpathResult->nodeset;
				foreach($nodeset as $node) {
					foreach($attributes as $key => $value) {
						// echo "adding attribute $key=$value to $path<br/>";
						$node->set_attribute($key, $value);
					}
				}
			} else { // PHP5
				$nodeset = $xpathContext->query($path."[$attributeCondition and *]", $domElement);
				foreach($nodeset as $node) {
					foreach($attributes as $key => $value) {
						// echo "adding attribute $key=$value to $path<br/>";
						$node->setAttribute($key, $value);
					}
				}
			}
		}
	}
	function checkAccessCode($format, $position, $accessCode) {
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$dom = domxml_open_file($this->path);
		} else { // PHP5
			$dom = new DOMDocument();
			$dom->load($this->path);
		}
		if (!$dom) {
			$this->errorMessage = 'Could not parse the CV document.';
			return FALSE;
		}
		$checkEnabled = "/hr:Candidate/hr:CandidateProfile[$position]/hr:UserArea/hr:Export[@format='$format']";
		$checkAccessCode = "/hr:Candidate/hr:CandidateProfile[$position]/hr:UserArea/hr:Export[@format='$format' and (@accessCode='$accessCode' or not(@accessCode))]";
		$r = FALSE;
		if (version_compare(phpversion(), '5') == -1) { // PHP4
			$xpathContext = xpath_new_context($dom);
			xpath_register_ns($xpathContext, hr_ns_prefix, hr_ns_url);
			$xpathResult = $xpathContext->xpath_eval($checkEnabled);
			$nodeset = $xpathResult->nodeset;
			if (count($nodeset) > 0) {
				$xpathResult = $xpathContext->xpath_eval($checkAccessCode);
				$nodeset = $xpathResult->nodeset;
				$r = (count($nodeset) > 0);
			} else {
				//header("HTTP/1.0 404 Not Found");
				$this->errorMessage = 'No such export.';
			}
		} else { // PHP5
			$xpathContext = new DOMXPath($dom);
			$xpathContext->registerNamespace(hr_ns_prefix, hr_ns_url);
			$nodeset = $xpathContext->query($checkEnabled);
			if ($nodeset->length > 0) {
				$nodeset = $xpathContext->query($checkAccessCode);
				$r = ($nodeset->length > 0);
			} else {
				//header("HTTP/1.0 404 Not Found");
				$this->errorMessage = 'No such export.';
			}
		}
		return $r;
	}
}
