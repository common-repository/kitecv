<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://xmlns.com/foaf/0.1/" xmlns:hr="http://ns.hr-xml.org/2006-02-28" version="1.0" exclude-result-prefixes="xsl hr">
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
 <xsl:output method="xml" encoding="utf-8"/>
 <xsl:param name="position"/>
 <xsl:template match="*">
  <xsl:copy>
   <xsl:apply-templates/>
  </xsl:copy>
 </xsl:template>
 <xsl:template match="hr:Export"/>
 <xsl:template match="/">
  <Person>
   <xsl:for-each select="/hr:Candidate/hr:CandidateProfile">
    <xsl:if test="position() = $position">
     <name><xsl:value-of select="hr:PersonalData/hr:PersonName/hr:FormattedName"/></name>
     <xsl:for-each select="hr:PersonalData/hr:ContactMethod/hr:InternetEmailAddress">
      <mbox><xsl:value-of select="."/></mbox>
     </xsl:for-each>
     <xsl:for-each select="hr:PersonalData/hr:ContactMethod/hr:Telephone/hr:FormattedNumber">
      <phone><xsl:value-of select="."/></phone>
     </xsl:for-each>
     <plan><xsl:value-of select="hr:PreferredPosition/hr:PositionTitle"/></plan>
    </xsl:if>
   </xsl:for-each>
  </Person>
 </xsl:template>
</xsl:stylesheet>
