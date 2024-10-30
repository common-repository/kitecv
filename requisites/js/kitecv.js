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

//Ensure object Node is defined
if (!window['Node']) {
	window.Node = new Object();
	Node.ELEMENT_NODE = 1;
	Node.ATTRIBUTE_NODE = 2;
	Node.TEXT_NODE = 3;
	Node.CDATA_SECTION_NODE = 4;
	Node.ENTITY_REFERENCE_NODE = 5;
	Node.ENTITY_NODE = 6;
	Node.PROCESSING_INSTRUCTION_NODE = 7;
	Node.COMMENT_NODE = 8;
	Node.DOCUMENT_NODE = 9;
	Node.DOCUMENT_TYPE_NODE = 10;
	Node.DOCUMENT_FRAGMENT_NODE = 11;
	Node.NOTATION_NODE = 12;
}
//Ensure Array.indoxOf is defined
if (!Array.prototype.indexOf) {
	Array.prototype.indexOf = function(val, fromIndex) {
		if (typeof(fromIndex) != 'number') fromIndex = 0;
		for (var index = fromIndex,len = this.length; index < len; index++)
			if (this[index] == val) return index;
		return -1;
	}
}

var kiteCVTabIndex = 0;
function kiteCVSetTabIndex(tabIndex) {
	kiteCVTabIndex = tabIndex;
}
function kiteCVOnLoad() {
	// Called on page load
	// setup the tab list
	new multiPartPage(kiteCVTabIndex);
}
function KiteCVDeleteButton(button) {
	// Called from a delete button next to a deletable.
	// The path to be deleted was stored in attribute "id" of this button.
	// Submit the form setting the "delete" field to that path.
	var path = button.getAttribute('id').substr(7);
	var form = button.form;
	if (path == '/hr:Candidate') {
		if (confirm("Are you sure you want to delete the whole document in this language ?")) {
			form.elements['KiteCVAction'].value = 'deleteCV';
			form.submit();
		}
	} else {
		form.elements['delete'].value = path;
		KiteCVSaveTabIndexAndSubmitForm(button);
	}
}
function KiteCVAddControl(element) {
	// Called from a button or a select (in a "KiteCV_adder" div)
	// Hide the button or select control
	element.style.display = 'none';
	// Show a div next door
	var daddy = element.parentNode;
	var divCountDown = (element.nodeName == 'SELECT' ? element.selectedIndex : 1);
	var div = null;
	
	for (var node = daddy.firstChild; node; node = node.nextSibling) {
		if (node.nodeType == Node.ELEMENT_NODE) {
			if (divCountDown > 0 && node.nodeName == 'DIV') {
				divCountDown --;
				if (divCountDown == 0) {
					div = node;
					break;
				}
			}
		}
	}
	div.style.display = 'block';
	KiteCVRecursivelySetDisabled(div, false);
	// Move the focus to the first input, select or textarea element, whichever comes first
	for (var node = div.firstChild; node; node = node.nextSibling) {
		if (node.nodeType == Node.ELEMENT_NODE) {
			if (node.type != 'hidden' && node.nodeName == 'INPUT' || node.nodeName == 'SELECT' || node.nodeName == 'TEXTAREA') {
				node.focus();
				break;
			}
		}
	}
	
	if (element.nodeName == 'SELECT') {
		// Reset the select to its first option
		element.selectedIndex = 0;
	}
	// Create a cancel button which calls KiteCVCancelAddition()
	var cancelButton = document.createElement("button");
	element.parentNode.appendChild(cancelButton);
	if (cancelButton.textContent !== undefined) cancelButton.textContent = "cancel";
	else cancelButton.innerText = "cancel";
	cancelButton.className = "cancelButton";
	cancelButton.setAttribute('type', 'button');
	cancelButton.onclick = KiteCVCancelAddition;
	// Create a save button which submits the form
	var saveButton = document.createElement("button");
	element.parentNode.appendChild(saveButton);
	if (saveButton.textContent !== undefined) saveButton.textContent = "save";
	else saveButton.innerText = "save";
	saveButton.className = "saveButton";
	saveButton.setAttribute('type', 'button');
	saveButton.onclick = KiteCVSaveSubmitForm;
}
function KiteCVCancelAddition(e) {
	// Called from a cancel button
	var button;
	if (e == null && window.event){
		e = window.event;
		button = e.srcElement;
	}
	else button = e.currentTarget;
	var daddy = button.parentNode;
	var addControl = null;
	var childrenToRemove = new Array(0);
	for (var node = daddy.firstChild; node; node = node.nextSibling) {
		if (node.nodeType == Node.ELEMENT_NODE) {
			if (node.nodeName == 'DIV') {
				// Hide the div(s) next door
				node.style.display = 'none';
				KiteCVRecursivelySetDisabled(node, true);
			} else if (node.nodeName == 'BUTTON' || node.nodeName == 'SELECT') {
				var c = node.className;
				if (c == 'saveButton' || c == 'cancelButton') {
					// remember the cancel and save buttons to remove them later
					childrenToRemove.push(node);
				} else if (addControl == null) {
					// Show the add button or select
					addControl = node;
					node.style.display = 'block';
				}
			}
		}
	}
	// Remove the cancel and save buttons
	for (var i = 0; i < childrenToRemove.length; i++) {
		var node = childrenToRemove[i];
		daddy.removeChild(node);
	}
}
function KiteCVSaveSubmitForm(e) {
	// Called from a save button
	if (e == null && window.event){
		e = window.event;
		button = e.srcElement;
	}
	else button = e.currentTarget;
	KiteCVSaveTabIndexAndSubmitForm(button);
}
function KiteCVSaveTabIndexAndSubmitForm(element) {
	// Set the active tabIndex for next page generation
	var tabNumber = KiteCVGetTabNumber(element);
	if (tabNumber != null) {
		element.form.elements['KiteCVXsltName'].value += ' tabIndex=' + tabNumber;
	}
	element.form.submit();
}
function KiteCVGetTabNumber(element) {
	// computes the active tab number, knowing element is in that tab
	// First tab has number 0
	if (element.nodeName == "BODY") {
		return null;
	}
	if (element.className.indexOf('multi-part') == -1) {
		return KiteCVGetTabNumber(element.parentNode);
	}
	var r = 0;
	for (
		var brother = element.parentNode.firstChild;
		brother != element;
		brother = brother.nextSibling
	) {
		if (
			brother.nodeType == Node.ELEMENT_NODE
			&&
			brother.className.indexOf('multi-part') > -1
		) {
			r = r + 1;
		}
	}
	return r;
}
function submitFormDeletingPath(path, tabIndex, button) {
	button.form.elements['delete'].value = path;
	submitForm(tabIndex, button);
}
function submitFormSettingNextPage(page, button) {
	button.form.elements['KiteCVXsltName'].value = page;
	button.form.submit();
}
function setValue(name, value, button) {
	button.form.elements[name].value = value;
}
function KiteCVRecursivelySetDisabled(element, disabled) {
	if(element == null) return; //IE fix
	var child = element.firstChild;
	while(child) {
		KiteCVRecursivelySetDisabled(child, disabled);
		child = child.nextSibling;
	}
	formElements = new Array("input", "option", "select", "button", "textarea");
	if(element.tagName != null && formElements.indexOf(element.tagName.toLowerCase()) > -1) element.disabled = disabled;
}
