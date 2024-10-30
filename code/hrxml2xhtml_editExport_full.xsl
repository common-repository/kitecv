<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:hr="http://ns.hr-xml.org/2006-02-28" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://www.iso.org/" xmlns:exslt="http://exslt.org/common" version="1.0" exclude-result-prefixes="xsl hr xi xsd #default iso exslt">
<!--
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
-->
 <xsl:variable name="formats">
  <formats xmlns="http://www.w3.org/1999/xhtml">
  <c code="xhtml" mime-type="text/html" name="Web">
   <p>
    __(XHTML document files can be viewed through any modern standards-compliant web browser.)
    __(You can download Firefox from)
    <a href="http://www.mozilla.com/firefox/">http://www.mozilla.com/firefox/</a>.
   </p>
  </c>
  <c code="odt" mime-type="application/vnd.oasis.opendocument.text" name="OpenDocument">
   <p>
    __(OpenDocument Text files can be opened with any modern standards-compliant office suite.)
    __(You can download OpenOffice.org from)
   <a href="http://www.openoffice.org/">http://www.openoffice.org/</a>.
   </p>
  </c>
  <c code="cedefoppdf" mime-type="application/pdf" name="PDF">
   <p>
    __(PDF documents can be viewed and printed.)
    __(This generation procedure uses the European Union official web services to transform XML to PDF.)
   </p>
  </c>
  <c code="cedefop" mime-type="text/xml" name="Europass CV (XML)">
   <p>
    __(You can generate documents in various formats from bare XML using the European Union's official online tools at)
    <a href="http://europass.cedefop.europa.eu/europass/home/vernav/Europasss+Documents/Europass+CV/navigate.action">http://europass.cedefop.europa.eu/europass/home/vernav/Europasss+Documents/Europass+CV/navigate.action</a>.
   </p>
  </c>
  <c code="foaf" mime-type="text/xml" name="RDF">
   <p>
    Friend Of A Friend
   </p>
  </c>
  <c code="hrxml" mime-type="text/xml" name="HR-XML">
   <p>
    __(HR-XML is the native format of KiteCV, and a standard exchange format within human resource management tools.)
    __(More information at) <a href="http://www.hr-xml.org/">http://www.hr-xml.org/</a>.
   </p>
  </c>
</formats>
 </xsl:variable>
 <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>
 <xsl:param name="languageCode"/>
 <xsl:param name="position"/>
 <xsl:param name="format"/>
 <xsl:template match="/">
  <xsl:for-each select="/hr:Candidate/hr:CandidateProfile">
   <xsl:if test="position() = $position">
    <xsl:variable name="candidateProfilePath">/hr:Candidate/hr:CandidateProfile(<xsl:number/>)</xsl:variable>
    <xsl:for-each select="hr:UserArea/hr:Export">
     <xsl:if test="@format = $format">
      <xsl:variable name="exportPath"><xsl:value-of select="$candidateProfilePath"/>/hr:UserArea/hr:Export(<xsl:number/>)</xsl:variable>
      <xsl:variable name="viewName"><xsl:value-of select="../../hr:ProfileName"/></xsl:variable>
      <xsl:variable name="node"><xsl:copy-of select="."/></xsl:variable>
      <xsl:for-each select="exslt:node-set($formats)/*/*[@code=$format]">
       <xsl:variable name="url">_exportURL_?position=<xsl:value-of select="$position"/>&amp;format=<xsl:value-of select="$format"/></xsl:variable>
       <h3><xsl:value-of select="@name"/> __(export of view) <em><xsl:value-of select="$viewName"/></em></h3>
       <xsl:copy-of select="html:p"/>
       <ul>
        <li>__(Access code:)
         <input type="text" onChange="javascript:this.form.submit()">
          <xsl:attribute name="name"><xsl:value-of select="$exportPath"/>/@accessCode</xsl:attribute>
          <xsl:attribute name="value"><xsl:value-of select="exslt:node-set($node)/hr:Export/@accessCode"/></xsl:attribute>
         </input>
         __((optional))
        </li>
        <li>__(Public URL:)
         <a target="KiteCVObject">
          <xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute>
          <xsl:value-of select="$url"/>
         </a>
         <object name="KiteCVObject" style="display:block; width:98%; height: 30em;">
          <xsl:attribute name="type"><xsl:value-of select="@mime-type"/></xsl:attribute>
          <xsl:attribute name="data"><xsl:value-of select="$url"/></xsl:attribute>
		  <param name="src">
		   <xsl:attribute name="value"><xsl:value-of select="$url"/></xsl:attribute>
		  </param>
          __((Not supported in your browser))
         </object>
        </li>
       </ul>
      </xsl:for-each>
     </xsl:if>
    </xsl:for-each>
   </xsl:if>
  </xsl:for-each>
 </xsl:template>
</xsl:stylesheet>
