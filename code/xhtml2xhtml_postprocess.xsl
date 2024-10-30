<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:html="http://www.w3.org/1999/xhtml"
 xmlns:exslt="http://exslt.org/common"
 xmlns:str="http://exslt.org/strings"
 xmlns:php="http://php.net/xsl"
 exclude-result-prefixes="xsl #default exslt str php">
<!--
This file is part of KiteCV.
Copyright ©2006 Les Developpements Durables <contact@ldd.fr>,
Sébastien Ducoulombier <seb@ldd.fr> and
Antoine Ducoulombier <antoine@ldd.fr>.

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
-->
 <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>
 <xsl:param name="position"/>

 <!-- Under each "KiteCV_adder" div, make select or button call triggerAddition() on action -->
 <xsl:template match="//html:div[@class='KiteCV_adder']/html:button">
  <xsl:copy>
   <xsl:attribute name="onclick">javascript:KiteCVAddControl(this);</xsl:attribute>
   <xsl:apply-templates select="@*|*|text()"/>
  </xsl:copy>
 </xsl:template>
 <xsl:template match="//html:div[@class='KiteCV_adder']/html:select">
  <xsl:copy>
   <xsl:attribute name="onchange">javascript:KiteCVAddControl(this);</xsl:attribute>
   <xsl:apply-templates select="@*|*|text()"/>
  </xsl:copy>
 </xsl:template>

 <!-- Under each "KiteCV_adder" div, hide the children divs -->
 <xsl:template match="//html:div[@class='KiteCV_adder']/html:div[@class='KiteCV_adder_content']">
  <xsl:variable name="id"><xsl:value-of select="generate-id()"/></xsl:variable>
  <xsl:copy>
   <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
   <xsl:attribute name="style">display:none;</xsl:attribute>
   <xsl:apply-templates select="@*|*|text()"/>
   <div style="clear:both; height:0;"><br /></div>
  </xsl:copy>
  <script type="text/javascript">KiteCVRecursivelySetDisabled(document.getElementById('<xsl:value-of select="$id"/>'), true);</script>
 </xsl:template>

 <!-- remove those nasty adders that have nothing to add -->
 <xsl:template match="//html:div[@class='KiteCV_adder' and html:select and not(html:select/html:option[2])]">
  <div>__((none to add from the master data form))</div>
 </xsl:template>

 <!-- Move each "KiteCV_Deletable" div into a new parent div inserted at that point.
         // Then append a child button that calls buttonDelete() on action                                   // Read the path to delete in attribute "title" of the div, store it on the button, and remove it. -->
 <xsl:template match="//html:div[@class='KiteCV_deletable']">
  <xsl:variable name="path"><xsl:value-of select="@title"/></xsl:variable>
  <div class="KiteCV_deletableParent">
   <xsl:copy>
    <xsl:apply-templates select="@*|*|text()"/>
   </xsl:copy>
   <button class="KiteCV_deleteButton" type="button" onclick="javascript:KiteCVDeleteButton(this);">
    <xsl:attribute name="id">
     <xsl:text>delete_</xsl:text><xsl:value-of select="$path"/>
    </xsl:attribute>
	<span style="display:none;">Delete this item</span>
   </button>
  </div>
 </xsl:template>
 <xsl:template match="//html:div[@class='KiteCV_deletable']/@title"/>

 <!-- Help texts : hide them, and add an icon so to open them -->
 <xsl:template match="//html:div[@class='KiteCV_help']">
  <xsl:variable name="id"><xsl:value-of select="generate-id()"/></xsl:variable>
  <xsl:copy>
   <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
   <xsl:attribute name="style">display:none;</xsl:attribute>
   <xsl:apply-templates select="@*|*|text()"/>
  </xsl:copy>
  <button type="button" class="KiteCV_help_button">
   <xsl:attribute name="onclick">javascript:var b=document.getElementById('<xsl:value-of select="$id"/>');b.style.display=(b.style.display=='block'?'none':'block');</xsl:attribute>
   <span>
    <xsl:text>?</xsl:text>
   </span>
  </button>
 </xsl:template>

 <xsl:template match="*|/">
  <xsl:copy>
   <xsl:apply-templates select="@*|*|text()"/>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="text()|@*">
  <xsl:copy>
   <xsl:apply-templates/>
  </xsl:copy>
 </xsl:template>

</xsl:stylesheet>
