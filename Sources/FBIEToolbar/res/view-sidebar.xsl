<?xml version="1.0" encoding="utf-16" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fn="http://www.w3.org/2004/07/xpath-functions" >

  <xsl:output method="html"/>
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

<xsl:template match="friends">

  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <title></title>
			
    <link type="text/css" rel="stylesheet" href="@toolbar-css-path" />
    <script type="text/javascript">
      <![CDATA[
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
  ]]>
  </script>

    <script type="text/javascript">
    <![CDATA[
      var imgNum = 1;

      // send "app:action" command to browser
      // which handles this command in custom way
      function NotifySidebar(msg) {
      window.navigate("app:" + msg + "@");
      }

      function writeImage(imageSrc, width, height) {

      var imageClass = "'facebook-link friend-image'";

      var imageURL =  "\"" + imageSrc + "\"";

      var onLoad = "\"window.event.srcElement.isOk=1;\"";


      var elementId = "\"img" + (imgNum++) + "\"";

      var html = "<img id=" + elementId + " src=" + imageURL + " onload=" + onLoad + " class=" + imageClass + "/>";
        document.write(html);
      }

      function handleBrokenImages(){
        for(var i = 1; i < imgNum; i++){
          var id = "img" + i;
          var el = document.getElementById(id);
          if(typeof el.isOk == "undefined")
          if(el.src.indexOf("res:") == 0)
            el.src = "http://static.ak.fbcdn.net/pics/q_silhouette.gif";
        }
      }

      function formatString(str) {
        for (var i = 0; i <= arguments.length - 2; i++) {
          str = str.replace(new RegExp("\\{p" + i + "\\}", "gi" ), arguments[i + 1]);
        }

        return str;
      }

      ]]>
      </script>

    <script type="text/javascript">
    <![CDATA[


      function DatesInSeconds() {
      this.minute  = 60;
      this.two_mins= 120;
      this.hour    = 60*this.minute;
      this.hour_and_half = 90*this.minute;
      this.day     = 24*this.hour;
      this.week    = 7*this.day;
      this.month   = 30.5*this.day;
      this.year    = 365*this.day;
      }
      var dates_in_seconds = new DatesInSeconds();

      /*
      * Render a short version of the date depending on how close it is to today's date
      * @param time - time in seconds from epoch
      */
      /*
      function getRelativeTime(time) {
      var elapsed   = Math.floor(new Date().getTime()/1000) - time;
      if (elapsed &lt;= 1)
      return 'a moment ago';
      if (elapsed &lt; dates_in_seconds.minute)
      return elapsed.toString() + ' seconds ago';
      if (elapsed &lt; 2*dates_in_seconds.two_mins)
      return 'one minute ago';
      if (elapsed &lt; dates_in_seconds.hour)
      return Math.floor(elapsed/dates_in_seconds.minute) + ' minutes ago';
      if (elapsed &lt; dates_in_seconds.hour_and_half)
      return 'about an hour ago';
      if (elapsed &lt; dates_in_seconds.day )
      return Math.round(elapsed/dates_in_seconds.hour) + ' hours ago';
      if (elapsed &lt; dates_in_seconds.week) {
      var days    = new Array( "Sunday", "Monday", "Tuesday", "Wednesday",
      "Thursday", "Friday", "Saturday" );
      var d       = new Date;
      d.setTime(time*1000);
      return 'on ' + days[d.getDay()];
      }
      if (elapsed &lt; dates_in_seconds.week*1.5)
      return 'about a week ago';
      if (elapsed &lt; dates_in_seconds.week*3.5)
      return 'about ' + Math.round(elapsed/dates_in_seconds.week) + ' weeks ago';
      if (elapsed &lt; dates_in_seconds.month*1.5)
      return 'about a month ago';
      if (elapsed &lt; dates_in_seconds.year)
      return 'about ' + Math.round(elapsed/dates_in_seconds.month) + ' months ago';
      return 'over a year ago';
      }*/

      function getRelTime(time) {
      var elapsed   = Math.floor(new Date().getTime()/1000) - time;
      if( elapsed < dates_in_seconds.week )
      return getRelTimeWithinWeek(time, false, true);
      if (elapsed < dates_in_seconds.week*1.5)
      return '[AboutWeekAgoSmall]';
      if (elapsed < dates_in_seconds.week*2.5)
      return '[AboutTwoWeekAgoSmall]';
      if (elapsed < dates_in_seconds.week*3.5)
      return formatString("[AboutWeekAgoParam]", Math.round(elapsed/dates_in_seconds.week));
      if (elapsed < dates_in_seconds.month*1.5)
      return '[AboutMonthAgoSmall]';
      return '';
      if (elapsed < dates_in_seconds.month*2.5)
      return '[AboutTwoMonthAgoParam]';
      if (elapsed < dates_in_seconds.month*10.5)
      return formatString("[AboutThreeMonthAgoParam]", Math.round(elapsed/dates_in_seconds.month));
      if (elapsed < dates_in_seconds.year)
      return formatString("[AboutMonthAgoParam]", Math.round(elapsed/dates_in_seconds.month));
      if (elapsed > dates_in_seconds.year)
      return '[OverYearAgoSmall]';
      }

      function getProfileTime(profile_time) {
      if (typeof profile_time == "undefined")
      return "";

      var relative_time = getRelTime(profile_time);
      return relative_time ? relative_time : '';
      }

      function getRelTimeWithinWeek(time, initialCap, isUpdateProfile) {
      var currentTime = new Date;

      var updateTime = new Date;
      updateTime.setTime(time*1000);

      var days    = new Array( "[Sunday]", "[Monday]", "[Tuesday]", "[Wednesday]",
      "[Thursday]", "[Friday]", "[Saturday]" );
      var day;

      var format = "[WeekDateTimeFormat]";
      if (isUpdateProfile) {
        format = "[ProfileWeekTimeFormat]";
      }
      
      // assumption that status messages are only shown if in the last 7 days
      if (updateTime.getDate() == currentTime.getDate()) {
      day = initialCap ? "[Today]" : "[TodaySmall]";
      if (isUpdateProfile) {
        format = "[ProfileTimeFormat]";
      } else {
        format = "[DateTimeFormat]";
      }
      } else if ((updateTime.getDay() + 1) % 7 == currentTime.getDay()) {
      day = initialCap ? "[Yesterday]" : "[YesterdaySmall]";
      if (isUpdateProfile) {
        format = "[ProfileTimeFormat]";
      } else {
        format = "[DateTimeFormat]";
      }
      } else {
      day = days[updateTime.getDay()];
      }

      var hour = updateTime.getHours();
      var minute = updateTime.getMinutes();
      if (minute < 10) {
      minute = '0' + minute;
      }

      var tstr = formatString(format, day, hour, minute);
      return tstr;
      }

      function getStatusTime(status_time) {
      return typeof status_time == "undefined"? "": getRelTimeWithinWeek(status_time, true, false);
      }

    ]]>
    </script>


    <script>

      var scroller;

      function init() {
      scroller = new Scroller();
      scroller.activateItem(0, true);
      scroller.disableSelection();
      scroller.registerMouseHandlers();

      handleBrokenImages();
      }

      function externalKeyUp() {
      scroller.trackScrollState({which:scroller.keys.keyUp});
      }

      function externalKeyDown() {
      scroller.trackScrollState({which:scroller.keys.keyDown});
      }

      function externalKeyPgUp() {
      scroller.trackScrollState({which:scroller.keys.pageUp});
      }

      function externalKeyPgDown() {
      scroller.trackScrollState({which:scroller.keys.pageDown});
      }

      function externalKeyHome() {
      scroller.trackScrollState({which:scroller.keys.keyHome});
      }

      function externalKeyEnd() {
      scroller.trackScrollState({which:scroller.keys.keyEnd});
      }

      function externalKeyReturn() {
      scroller.trackScrollState({which:scroller.keys.keyEnter});
      }

      function externalKeySpace() {
      scroller.trackScrollState({which:scroller.keys.keySpace});
      }

    </script>
    </head>
	
  <body onload="init()" onkeypress="scroller.stopDefaultHandling(event)" onkeyup="scroller.trackScrollState(event)">
    <div id="scrollBox"> 
      <xsl:apply-templates />
    </div>
  </body>
</html>

</xsl:template>
  <xsl:template match="friend">

  <div class="scrollItem" notifyCommand="profile.php_{@id}">
    <table border="0" cellspacing="0" cellpadding="0">
    <tr>
	<td>
  	  <div onclick="NotifySidebar('profile.php_{@id}');" oncontextmenu="NotifySidebar('profile.php_{@id}');">
	    <script type='text/javascript'>
	      writeImage(&quot;<xsl:value-of select="picSquare"/>&quot;);
	   </script>
	</div>
      </td>
      <td class="friend-margin">
	<div class="facebook-link user_name" onclick="NotifySidebar('profile.php_{@id}');" oncontextmenu="NotifySidebar('profile.php_{@id}');return false;">
	  <xsl:value-of select="name"/>
	</div>
       <div class="facebook-link ptime" style="cursor:hand;" onclick="NotifySidebar('profile.php_{@id}_hightlight=');" oncontextmenu="NotifySidebar('profile.php_{@id}_hightlight=');return false;">
         <script type='text/javascript'>
	   document.write(getProfileTime(<xsl:value-of select="profileUpdateTime"/>));
	</script>
       </div>
       <div  style="cursor:default;">
           <xsl:if test="string-length(status/message) &gt; 0">
             <xsl:if test="contains(name, ' ')">
               <xsl:value-of select="substring-before(name, ' ')"/>
             </xsl:if>
             <xsl:if test="not(contains(name, ' '))">
               <xsl:value-of select="name"/>
             </xsl:if>
             &#32;
             <xsl:value-of select="status/message"/>
           </xsl:if>
       </div>
       <div class="stime" style="cursor:default;">
           <xsl:if test="string-length(status/message) &gt; 0">
             <script type='text/javascript'>
               document.write(getStatusTime(<xsl:value-of select="status/time"/>));
             </script>
           </xsl:if>          
       </div>
       <div class="facebook-friendlinks" style="cursor:default;">
         <span class="facebook-link mini-link" onclick="NotifySidebar('message.php_{@id}');" oncontextmenu="NotifySidebar('message.php_{@id}');return false;">[@htmlMessage]</span> - 
	 <span class="facebook-link mini-link" onclick="NotifySidebar('poke.php_{@id}');" oncontextmenu="NotifySidebar('poke.php_{@id}');return false;">[@htmlPoke]</span> - 
	 <span class="facebook-link mini-link" onclick="NotifySidebar('wallpost.php_{@id}');" oncontextmenu="NotifySidebar('wallpost.php_{@id}');return false;">[@htmlWallPost]</span>
       </div>
     </td>
   </tr>
   </table>
  </div>

</xsl:template>



</xsl:stylesheet>
