      // send "app:action" command to browser 
  // which handles this command in custom way
    function NotifySidebar(msg) {
      window.navigate("app:" + msg + "@");
    }
	
	function Scroller() {
		this.activeItemIndex = 0;
		this.keys = {keyEnter: 13, keySpace: 32, keyUp: 38, keyDown: 40, keyEnd: 35, keyHome: 36, pageUp: 33, pageDown: 34 };
		this.scrollBoxId = 'scrollBox';

		this.getScrollbox = function() {
			if (!this.scrollbox) {
				this.scrollbox = document.getElementById(this.scrollBoxId);
				if (!this.scrollbox) {
					alert('Scroll box DOM element not found');
				}
			}
			return this.scrollbox;
		}
		
		this.stopDefaultHandling = function(e) {
		    var returnValue = true;
			var key;
			if (window.event) {
				key = e.keyCode;
			} else if (e.which) {
				key = e.which;
			};
			// prevent default handling of keys used for list navigation
			for (var i in this.keys) {
				if (this.keys[i] == key) {
					e.cancelBubble = true;
					e.returnValue = false;
					returnValue = false;
					if (e.preventDefault) {
						e.preventDefault();
					}
					if (e.stopPropagation) {
						e.stopPropagation();
					}
					
					break;
				}
			}
			return returnValue;
		}

		this.trackScrollState = function(e) {
			var returnValue;
			var key;
			if (window.event) {
				key = e.keyCode;
			} else if (e.which) {
				key = e.which;
			};

			// prevent default handling of keys used for list navigation
			for (var i in this.keys) {
				if (this.keys[i] == key) {
					e.cancelBubble = true;
					e.returnValue = false;
					returnValue = false;
					if (e.preventDefault) {
						e.preventDefault();
					}
					if (e.stopPropagation) {
						e.stopPropagation();
					}
					break;
				}
			}
			
			switch(key) {
				case this.keys.keyUp:
					this.activateItem(this.activeItemIndex-1); 
					break;
				case this.keys.keyDown:
					this.activateItem(this.activeItemIndex+1);
					break;
				case this.keys.keyEnd:
					this.activateItem(this.getScrollbox().childNodes.length - 1);
					break;
				case this.keys.keyHome:
					this.activateItem(0);
					break;
				case this.keys.pageUp:
					var topClippedIndex = this.findTopClippedItemIndex();
					var pgUpTopIndex = this.findTopIndexForPgUp(topClippedIndex);
					this.activateItem(pgUpTopIndex);
					break;
				case this.keys.pageDown:
					var bottomClippedIndex = this.findBottomClippedIndex();
					this.activateItem(bottomClippedIndex);
					break;
				case this.keys.keyEnter:
				    var childNode =  this.getScrollbox().childNodes[this.activeItemIndex];
				    if (childNode) {
				        var notifyCommand = childNode.getAttribute('notifyCommand'); 
				        if (notifyCommand) {
				            NotifySidebar(notifyCommand);
				        }
				    }
				    break;
				 case this.keys.keySpace:
				    var nextActiveIndex = this.activeItemIndex + 1;
				    if (nextActiveIndex >= this.getScrollbox().childNodes.length) {
				        nextActiveIndex = 0;
				    }
				    this.activateItem(nextActiveIndex);
				    break;
			}

			return returnValue;
		}

		this.findTopClippedItemIndex = function() {
			var items = this.getScrollbox().childNodes;
			var i;
			var index = 0;
			var scrollOffset = this.getWindowScrollOffset();
			for (i = 0; i < items.length; i++) {
				if (items[i].offsetTop < scrollOffset) {
					index = i;
				} else {
					break;
				}
			}
			return index;
		}

		this.findTopIndexForPgUp = function(indexRangeEnd) {
			var items = this.getScrollbox().childNodes;
			var winHeight = this.getWindowHeight();
			var i;
			var rangeHeight = 0;
			var indexRangeStart = indexRangeEnd;
			for (i = indexRangeEnd; i >= 0; i--) {
				if (rangeHeight + items[i].offsetHeight <= winHeight) {
					rangeHeight += items[i].offsetHeight;
					indexRangeStart = i;
				} else {
					break;
				}
			}
			return indexRangeStart;
		}

		this.findBottomClippedIndex = function() {
			var items = this.getScrollbox().childNodes;
			var i;
			var windowScrollOffset = this.getWindowScrollOffset();
			var windowHeight = this.getWindowHeight();
			var windowViewBottomLine = windowScrollOffset + windowHeight;
			for (i = 0; i < items.length; i++) {
				var item = items[i];
				if (item.offsetTop + item.offsetHeight > windowViewBottomLine) {
					return i;
				}
			}

			return items.length - 1;
		}

		this.getWindowHeight = function() {
			if (window.innerHeight) {
				return window.innerHeight;
			} else {
				// IE quirks/strict modes
				if (document.documentElement.clientHeight > 0) {
					return document.documentElement.clientHeight;
				} else {
					return document.body.clientHeight;
				}
			}
		}

		this.getWindowScrollOffset = function() {
			if (window.pageYOffset) {
				return window.pageYOffset;
			} else {
				return document.body.scrollTop;
			}
		}

		this.activateItem = function(index, scrollIntoView) {
			var scrollBox = this.getScrollbox();
			var maxIndex = scrollBox.childNodes.length - 1;
			if (index < 0) {
				index = 0;
			}
			if (index > maxIndex) {
				index = maxIndex;
			}

			var item = scrollBox.childNodes[index];
			var activeItem = scrollBox.childNodes[this.activeItemIndex];
			
			activeItem.className='scrollItem';
			item.className='scrollItem scrollItemActive';

			if (scrollIntoView === undefined || scrollIntoView) {
				if (this.isItemClipped(item)) {
					item.scrollIntoView();
				}
			}
			
			this.activeItemIndex = index;
		}

		this.isItemClipped = function(item) {
			var top = item.offsetTop;
			var viewTop = this.getWindowScrollOffset();
			var bottom = item.offsetTop + item.offsetHeight;
			var windowHeight = this.getWindowHeight();
			var viewBottom = viewTop + windowHeight;
			return (item.offsetTop < viewTop) || (bottom > viewBottom);
		}

		this.disableSelection = function() {
			this.getScrollbox().onselectstart = function() { 
				return false;
			};
		}

		this.getItemIndex = function(item) {
			var items = this.getScrollbox().childNodes;
			var i;
			for (i = 0; i < items.length; i++) {
				if (items[i] == item) {
					return i;
				}
			}
		}

		this.registerMouseHandlers = function() {
			var items = this.getScrollbox().childNodes;
			var i;
			for (i = 0; i < items.length; i++) {
				items[i].onclick = this.itemClickHandler;
				items[i].oncontextmenu = this.itemRightClickHandler;
			}
		}

		this.itemClickHandler = function() {
			scroller.activateItem(scroller.getItemIndex(this), false); 
		}
		
		this.itemRightClickHandler = function() {
			scroller.activateItem(scroller.getItemIndex(this), false); 
			return false;
		}
	}

