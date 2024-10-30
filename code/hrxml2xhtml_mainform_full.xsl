<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:hr="http://ns.hr-xml.org/2006-02-28" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://www.iso.org/" xmlns:exslt="http://exslt.org/common" xmlns:php="http://php.net/xsl" version="1.0" exclude-result-prefixes="xsl hr xi xsd #default iso exslt">
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
 <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>
 <xsl:param name="languageCode"/>
 <xsl:param name="position"/>
 <xsl:param name="format"/>
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
 <xsl:template match="/">
  <div class="KiteCV_deletable" title="/hr:Candidate">
  <ul>
  <li>
   <button type="button" onClick="javascript:submitFormSettingNextPage('hrxml2xhtml_form_full.xsl', this);">
    <xsl:attribute name="class">
     <xsl:choose>
      <xsl:when test="$position=''">
       KiteCV_grownButton
      </xsl:when>
      <xsl:otherwise>
       KiteCV_growingButton
      </xsl:otherwise>
     </xsl:choose>
    </xsl:attribute>
    __(Master data for) <xsl:value-of select="exslt:node-set($languages)/*/*[@iso_639_1_code=$languageCode]/@name"/>
   </button>
   <xsl:if test="hr:Candidate/*">
    <ul><li>
    <button type="button">
     <xsl:attribute name="onClick">javascript:submitFormSettingNextPage('hrxml2xhtml_newView_full.xsl position=NEW', this);</xsl:attribute>
     <xsl:attribute name="class">
      <xsl:choose>
       <xsl:when test="$position='NEW'">
        KiteCV_grownButton
       </xsl:when>
       <xsl:otherwise>
        KiteCV_growingButton
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
     __(Add a new view)
    </button>
    </li></ul>
    <xsl:if test="/hr:Candidate/hr:CandidateProfile">
     <ul>
      <xsl:for-each select="/hr:Candidate/hr:CandidateProfile">
       <xsl:variable name="candidateProfilePath">/hr:Candidate/hr:CandidateProfile(<xsl:number/>)</xsl:variable>
        <xsl:variable name="candidateProfileNode"><xsl:copy-of select="."/></xsl:variable>
       <xsl:variable name="myPosition"><xsl:number/></xsl:variable>
       <li>
        <div class="KiteCV_deletable">
         <xsl:attribute name="title"><xsl:value-of select="$candidateProfilePath"/></xsl:attribute>
         <button type="button">
          <xsl:attribute name="onClick">javascript:submitFormSettingNextPage('hrxml2xhtml_editTargetedCV_full.xsl position=<xsl:number/>', this);</xsl:attribute>
          <xsl:attribute name="class">
           <xsl:choose>
            <xsl:when test="$myPosition=$position and $format=''">
             KiteCV_grownButton
            </xsl:when>
            <xsl:otherwise>
             KiteCV_growingButton
            </xsl:otherwise>
           </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="hr:ProfileName"/>
         </button>
         <xsl:if test="*[local-name() != 'ProfileName']">
          <xsl:variable name="remainingFormats">
           <xsl:for-each select="exslt:node-set($formats)/*/*">
            <xsl:variable name="code"><xsl:value-of select="@code"/></xsl:variable>
            <xsl:if test="not(exslt:node-set($candidateProfileNode)/hr:CandidateProfile/hr:UserArea/hr:Export[@format=$code])">
             <xsl:copy-of select="."/>
            </xsl:if>
           </xsl:for-each>
          </xsl:variable>
          <xsl:if test="exslt:node-set($remainingFormats)/*">
           <ul><li>
           <button type="button">
            <xsl:attribute name="onClick">javascript:submitFormSettingNextPage('hrxml2xhtml_newExport_full.xsl position=<xsl:value-of select="$myPosition"/> format=NEW', this);</xsl:attribute>
            <xsl:attribute name="class">
             <xsl:choose>
              <xsl:when test="$position=$position and $format='NEW'">
               KiteCV_grownButton
              </xsl:when>
              <xsl:otherwise>
               KiteCV_growingButton
              </xsl:otherwise>
             </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="@name"/>
            __(Enable new export)
           </button>
           </li></ul>
          </xsl:if>
          <ul>
           <xsl:for-each select="hr:UserArea/hr:Export">
            <xsl:variable name="exportPath"><xsl:value-of select="$candidateProfilePath"/>/hr:UserArea/hr:Export(<xsl:number/>)</xsl:variable>
            <xsl:variable name="myFormat"><xsl:value-of select="@format"/></xsl:variable>
            <xsl:for-each select="exslt:node-set($formats)/*/*[@code=$myFormat]">
             <!-- Embedded __(in a weblog post, type) <tt>KiteCVView_<xsl:value-of select="$languageCode"/>_<xsl:value-of select="$position"/> -->
             <li>
              <div class="KiteCV_deletable">
               <xsl:attribute name="title"><xsl:value-of select="$exportPath"/></xsl:attribute>
               <button type="button">
                <xsl:attribute name="onClick">javascript:submitFormSettingNextPage('hrxml2xhtml_editExport_full.xsl position=<xsl:value-of select="$myPosition"/> format=<xsl:value-of select="$myFormat"/>', this);</xsl:attribute>
                <xsl:attribute name="class">
                 <xsl:choose>
                  <xsl:when test="$myPosition=$position and $myFormat=$format">
                   KiteCV_grownButton
                  </xsl:when>
                  <xsl:otherwise>
                   KiteCV_growingButton
                  </xsl:otherwise>
                 </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="@name"/>
               </button>
              </div>
             </li>
            </xsl:for-each>
           </xsl:for-each>
          </ul>
         </xsl:if>
        </div>
       </li>
      </xsl:for-each>
     </ul>
    </xsl:if>
   </xsl:if>
  </li>
  </ul>
  </div>
 </xsl:template>
 <xsl:variable name="languages">
  <iso:iso_639_entries xmlns:iso="http://www.iso.org/"><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="bul" iso_639_2T_code="bul" iso_639_1_code="bg" name="Bulgarian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="cze" iso_639_2T_code="ces" iso_639_1_code="cs" name="Czech"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="dan" iso_639_2T_code="dan" iso_639_1_code="da" name="Danish"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="dut" iso_639_2T_code="nld" iso_639_1_code="nl" name="Dutch"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="eng" iso_639_2T_code="eng" iso_639_1_code="en" name="English"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="est" iso_639_2T_code="est" iso_639_1_code="et" name="Estonian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="fin" iso_639_2T_code="fin" iso_639_1_code="fi" name="Finnish"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="fre" iso_639_2T_code="fra" iso_639_1_code="fr" name="French"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="ger" iso_639_2T_code="deu" iso_639_1_code="de" name="German"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="gle" iso_639_2T_code="gle" iso_639_1_code="ga" name="Irish"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="gre" iso_639_2T_code="ell" iso_639_1_code="el" name="Greek"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="hun" iso_639_2T_code="hun" iso_639_1_code="hu" name="Hungarian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="ita" iso_639_2T_code="ita" iso_639_1_code="it" name="Italian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="lav" iso_639_2T_code="lav" iso_639_1_code="lv" name="Latvian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="lit" iso_639_2T_code="lit" iso_639_1_code="lt" name="Lithuanian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="mlt" iso_639_2T_code="mlt" iso_639_1_code="mt" name="Maltese"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="nor" iso_639_2T_code="nor" iso_639_1_code="no" name="Norwegian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="pol" iso_639_2T_code="pol" iso_639_1_code="pl" name="Polish"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="por" iso_639_2T_code="por" iso_639_1_code="pt" name="Portuguese"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="rum" iso_639_2T_code="ron" iso_639_1_code="ro" name="Romanian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="slo" iso_639_2T_code="slk" iso_639_1_code="sk" name="Slovak"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="slv" iso_639_2T_code="slv" iso_639_1_code="sl" name="Slovenian"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="spa" iso_639_2T_code="spa" iso_639_1_code="es" name="Spanish"/><iso_639_entry xmlns="http://www.iso.org/" iso_639_2B_code="swe" iso_639_2T_code="swe" iso_639_1_code="sv" name="Swedish"/></iso:iso_639_entries>
 </xsl:variable>
</xsl:stylesheet>
