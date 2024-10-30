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
 <xsl:template match="/">
  <h3>__(Photo)</h3>
  <p>
   __(Here you can upload a photo of yourself to be included on the top-right corner of your CV.)
  </p>
  __(Square image jpeg File:) <input type="file" name="photoFile" onChange="javascript:submitFormSettingNextPage('hrxml2xhtml_form.xsl', this);"/>
 </xsl:template>
</xsl:stylesheet>
