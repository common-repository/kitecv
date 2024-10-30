/* This was taken from DotClear file admin/js/multi-part-page.js */

function multiPartPage(index) {
	if (index == undefined) { index = 0; }
	
	this.getDivisions();
	this.createList();
	this.showDivision(index);
}

multiPartPage.prototype= {
	className: 'multi-part',
	listClassName: 'kite-tabs',
	divs: new Array(),
	items: new Array(),
	
	getDivisions: function() {
		this.divs = getElementsByNameAndClass('div',this.className);
	},
	
	createList: function() {
		if (this.divs.length <= 0) {
			return;
		}
		
		this.list = document.createElement('ul');
		this.list.className = this.listClassName;
		var li, a;
		
		for (var i=0; i<this.divs.length; i++) {
			li = document.createElement('li');
			a = document.createElement('a');
			a.appendChild(document.createTextNode(this.divs[i].title));
			this.divs[i].title = '';
			this.divs[i].shown = false;
			a.href = '#';
			a.fn = this.showDivision;
			a.index = this.divs[i].id || i;
			a.obj = this;
			a.onclick = function() { this.fn.call(this.obj,this.index); return false; };
			li.appendChild(a);
			this.list.appendChild(li);
			this.items[i] = li;
		}
		
		// Get links with the same class and put them at the end of tabs list
		var links = getElementsByNameAndClass('a',this.className);
		
		for (i=0; i<links.length; i++) {
			li = document.createElement('li');
			li.className = this.listClassName+'-link';
			li.appendChild(links[i]);
			this.list.appendChild(li);
		}
		
		this.divs[0].parentNode.insertBefore(this.list,this.divs[0]);
		
		return;
	},
	
	showDivision: function(index) {
		for (var i=0; i<this.divs.length; i++) {
			if (this.divs[i].id != '' && this.divs[i].id == index) {
				this.divs[i].style.display = 'block';
				this.items[i].className = this.listClassName+'-active';
				this.updateDivision(index,this.divs[i]);
				this.divs[i].shown = true;
			} else if (i == index) {
				this.divs[i].style.display = 'block';
				this.items[i].className = this.listClassName+'-active';
				this.updateDivision(index,this.divs[i]);
				this.divs[i].shown = true;
			} else {
				this.divs[i].style.display = 'none';
				this.items[i].className = '';
			}
		}
	},
	
	updateDivision: function(index) {}
}
