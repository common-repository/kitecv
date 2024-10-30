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
 <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>
 <xsl:param name="languageCode"/>
 <xsl:param name="position"/><!-- 'NEW', but not used here -->
 <xsl:template match="/">
  <h3>__(Add a new view)</h3>
  <p>
   __(One may create a view of your CV to target a specific employer or a specific category of job.)
  </p>
  __(New view name:) <input type="text">
   <xsl:attribute name="name">/hr:Candidate/hr:CandidateProfile(<xsl:value-of select="count(/hr:Candidate/hr:CandidateProfile) + 1"/>)/hr:ProfileName</xsl:attribute>
  </input>
  <button type="submit">
   <xsl:attribute name="onClick">javascript:submitFormSettingNextPage('hrxml2xhtml_editTargetedCV.xsl position=<xsl:value-of select="count(/hr:Candidate/hr:CandidateProfile) + 1"/>', this);</xsl:attribute>
   __(OK)
  </button>
 </xsl:template>
</xsl:stylesheet>
