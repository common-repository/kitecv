<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hr="http://ns.hr-xml.org/2006-02-28" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:iso="http://www.iso.org/" xmlns:exslt="http://exslt.org/common" xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:europass="http://europass.cedefop.europa.eu/Europass/V1.0" xmlns:php="http://php.net/xsl" version="1.0" exclude-result-prefixes="xsl hr xi xsd iso exslt str php xlink dc math xforms dom">
<!--
This file is part of KiteCV.
Copyright ©2006 Les Developpements Durables <contact@ldd.fr>,
Sébastien Ducoulombier <seb@ldd.fr> and
Antoine Ducoulombier <antoine@ldd.fr> and
Vincent Finkelstein <vincent@ldd.fr>.

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
  <xsl:variable name="locales">
   <locales>
    <locale lang="bg">bg_BG</locale>
    <locale lang="cs">cs_CZ</locale>
    <locale lang="da">da_DK</locale>
    <locale lang="de">de_DE</locale>
    <locale lang="et">et_EE</locale>
    <locale lang="el">el_GR</locale>
    <locale lang="en">en_GB</locale>
    <locale lang="es">es_ES</locale>
    <locale lang="fr">fr_FR</locale>
    <locale lang="it">it_IT</locale>
    <locale lang="lv">lv_LV</locale>
    <locale lang="lt">lt_LT</locale>
    <locale lang="hu">hu_HU</locale>
    <locale lang="mt">mt_MT</locale>
    <locale lang="nl">nl_NL</locale>
    <locale lang="no">no_NO</locale>
    <locale lang="pl">pl_PL</locale>
    <locale lang="pt">pt_PT</locale>
    <locale lang="sk">sk_SK</locale>
    <locale lang="sl">sl_SI</locale>
    <locale lang="fi">fi_FI</locale>
    <locale lang="sv">sv_SE</locale>
    <locale lang="tr">tr_TR</locale>
   </locales>
  </xsl:variable>
  <xsl:template match="/">
    <europass:learnerinfo xmlns:europass="http://europass.cedefop.europa.eu/Europass/V1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://europass.cedefop.europa.eu/Europass/V1.0 http://europass.cedefop.europa.eu/xml/EuropassSchema_V1.0.xsd">
      <xsl:attribute name="locale">
       <xsl:variable name="lang">
        <xsl:value-of select="/hr:Candidate/@xml:lang"/>
       </xsl:variable>
       <xsl:value-of select="exslt:node-set($locales)/*/*[@lang=$lang]"/>
      </xsl:attribute>
      <docinfo>
        <issuedate>2006-06-22T15:26:02+03:00</issuedate>
        <xsdversion>V1.0</xsdversion>
        <comment>Automatically generated Europass CV</comment>
      </docinfo>
      <xsl:for-each select="/hr:Candidate/hr:CandidateProfile">
          <xsl:if test="position() = $position">
            
            <identification>
              <firstname/>
              <lastname>
                <xsl:value-of select="hr:PersonalData/hr:PersonName/hr:FormattedName"/>
              </lastname>
              
              <contactinfo>
                <xsl:for-each select="hr:ContactInfo/hr:ContactMethod/hr:PostalAddress">
                  <address>
        <xsl:call-template name="postalAddress">
                      <xsl:with-param name="node">
                        <xsl:copy-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
      </address>
                </xsl:for-each>
                
                <xsl:if test="hr:PersonalData/hr:ContactMethod[hr:Telephone]">
                  <telephone>
                    <xsl:value-of select="hr:PersonalData/hr:ContactMethod/hr:Telephone/hr:FormattedNumber"/>
                  </telephone>
                </xsl:if>
                
                <xsl:if test="hr:PersonalData/hr:ContactMethod[hr:Fax]">
                  <fax>
                    <xsl:value-of select="hr:PersonalData/hr:ContactMethod/hr:Fax/hr:FormattedNumber"/>
                  </fax>
                </xsl:if>

  <mobile/>
                
                <xsl:if test="hr:PersonalData/hr:ContactMethod[hr:InternetEmailAddress]">
                  <email>
                    <xsl:value-of select="hr:PersonalData/hr:ContactMethod/hr:InternetEmailAddress"/>
                  </email>
                </xsl:if>
              </contactinfo>
              
              <demographics>
                <xsl:if test="hr:PersonalData/hr:PersonDescriptors/hr:BiologicalDescriptors/hr:DateOfBirth">
                  <birthdate>
                    <xsl:value-of select="hr:PersonalData/hr:PersonDescriptors/hr:BiologicalDescriptors/hr:DateOfBirth"/>
                  </birthdate>
                </xsl:if>
                
                <xsl:if test="hr:PersonalData/hr:PersonDescriptors/hr:BiologicalDescriptors/hr:GenderCode != 3">
                  <xsl:variable name="genderCode">
                    <xsl:value-of select="hr:PersonalData/hr:PersonDescriptors/hr:BiologicalDescriptors/hr:GenderCode"/>
                  </xsl:variable>
                  <xsl:variable name="genderCodes">
                    <c code="1" label="M"/>
                    <c code="2" label="F"/>
                    <c code="3" label="NA"/>
                  </xsl:variable>
                  <xsl:for-each select="exslt:node-set($genderCodes)/*">
                    <xsl:if test="@code=$genderCode">
                      <gender>
                        <xsl:value-of select="@label"/>
                      </gender>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>
                
                <xsl:if test="hr:PersonalData/hr:PersonDescriptors/hr:DemographicDescriptors/hr:Nationality">
                  <nationality>
                    <xsl:value-of select="hr:PersonalData/hr:PersonDescriptors/hr:DemographicDescriptors/hr:Nationality"/>
                  </nationality>
                </xsl:if>
              </demographics>
            </identification>
              
            <xsl:if test="hr:PreferredPosition/hr:PositionTitle">
              <application>
                <xsl:value-of select="hr:PreferredPosition/hr:PositionTitle"/>
              </application>
            </xsl:if>
            
            <xsl:if test="hr:EmploymentHistory/hr:EmployerOrg">
              <workexperiencelist>
                <xsl:for-each select="hr:EmploymentHistory/hr:EmployerOrg">
                  <xsl:call-template name="workExperience">
                    <xsl:with-param name="node">
                      <xsl:copy-of select="."/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
              </workexperiencelist>
            </xsl:if>
            
            <xsl:if test="hr:EducationHistory/hr:SchoolOrInstitution">
              <educationlist>
                <xsl:for-each select="hr:EducationHistory/hr:SchoolOrInstitution">
                  <xsl:call-template name="degree">
                    <xsl:with-param name="node">
                      <xsl:copy-of select="."/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
              </educationlist>
            </xsl:if>
            
            <languagelist>
              <xsl:for-each select="hr:UserArea/hr:MotherLanguages/hr:MotherLanguage">
                <language type="mother">
                  <name>
                    <xsl:call-template name="languageName">
                      <xsl:with-param name="code">
                        <xsl:value-of select="."/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </name>
                </language>
              </xsl:for-each>
            
              <xsl:if test="hr:UserArea/hr:OtherLanguages/hr:OtherLanguage">
                <xsl:for-each select="hr:UserArea/hr:OtherLanguages/hr:OtherLanguage">
                  <xsl:call-template name="otherLanguage">
                    <xsl:with-param name="node">
                      <xsl:copy-of select="."/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:if>
            </languagelist>
            
            <skilllist>
              <xsl:call-template name="competencySection">
                <xsl:with-param name="name">social</xsl:with-param>
                <xsl:with-param name="title">__(Social skills and competences)</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="competencySection">
                <xsl:with-param name="name">organisational</xsl:with-param>
                <xsl:with-param name="title">__(Organisational skills and competences)</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="competencySection">
                <xsl:with-param name="name">technical</xsl:with-param>
                <xsl:with-param name="title">__(Technical skills and competences)</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="competencySection">
                <xsl:with-param name="name">computer</xsl:with-param>
                <xsl:with-param name="title">__(Computer skills and competences)</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="competencySection">
                <xsl:with-param name="name">artistic</xsl:with-param>
                <xsl:with-param name="title">__(Artistic skills and competences)</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="competencySection">
                <xsl:with-param name="name">other</xsl:with-param>
                <xsl:with-param name="title">__(Other skills and competences)</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="competencySection">
                <xsl:with-param name="name">driving</xsl:with-param>
                <xsl:with-param name="title">__(Driving licence(s))</xsl:with-param>
              </xsl:call-template>
            </skilllist>
              
            <misclist>
              <xsl:if test="hr:UserArea/hr:AdditionalInformations/hr:AdditionalInformation">
                <xsl:for-each select="hr:UserArea/hr:AdditionalInformations/hr:AdditionalInformation">
                  <misc type="additional">
                    <xsl:value-of select="hr:Description"/>
                  </misc>
                </xsl:for-each>
              </xsl:if>
              
              <xsl:if test="hr:SupportingMaterials">
                <xsl:for-each select="hr:SupportingMaterials">
                  <xsl:call-template name="supportingMaterials">
                    <xsl:with-param name="node">
                      <xsl:copy-of select="."/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:if>
            </misclist>
          
          </xsl:if>
      </xsl:for-each>
    </europass:learnerinfo>
  </xsl:template>
  <xsl:template name="supportingMaterials">
    <xsl:param name="node"/>
    <xsl:for-each select="exslt:node-set($node)/*">
      <misc type="annexes">
        <xsl:value-of select="hr:Description"/>
        <xsl:value-of select="hr:Link"/>
      </misc>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="workExperience">
    <xsl:param name="node"/>
    <workexperience>
      <period>
        <from>
          <xsl:value-of select="php:function('KiteCVFile::hrxmlDate2cedefopDate', string(exslt:node-set($node)/hr:EmployerOrg/hr:PositionHistory[1]/hr:StartDate/hr:AnyDate))" disable-output-escaping="yes"/>
        </from>
        <to>
    <xsl:value-of select="php:function('KiteCVFile::hrxmlDate2cedefopDate', string(exslt:node-set($node)/hr:EmployerOrg/hr:PositionHistory[1]/hr:EndDate/hr:AnyDate))" disable-output-escaping="yes"/>
        </to>
      </period>
      
      <position>
        <xsl:value-of select="exslt:node-set($node)/hr:EmployerOrg/hr:PositionHistory/hr:Title"/>
      </position>
      
      <activities>
        <xsl:value-of select="exslt:node-set($node)/hr:EmployerOrg/hr:PositionHistory/hr:Description"/>
      </activities>
      
      <employer>
        <xsl:value-of select="exslt:node-set($node)/hr:EmployerOrg/hr:EmployerOrgName"/><xsl:text> - </xsl:text>
  <xsl:call-template name="postalAddress">
          <xsl:with-param name="node">
            <xsl:copy-of select="exslt:node-set($node)/hr:EmployerOrg/hr:EmployerContactInfo/hr:ContactMethod/hr:PostalAddress"/>
          </xsl:with-param>
        </xsl:call-template>
      </employer>
      
      <sector>
        <xsl:value-of select="exslt:node-set($node)/hr:EmployerOrg/hr:PositionHistory[1]/hr:OrgIndustry[1]/hr:IndustryDescription"/>
      </sector>
    </workexperience>
  </xsl:template>
  <xsl:template name="degree">
    <xsl:param name="node"/>
    <education>
      <period>
        <from>
          <xsl:value-of select="php:function('KiteCVFile::hrxmlDate2cedefopDate', string(exslt:node-set($node)/hr:SchoolOrInstitution/hr:Degree/hr:DatesOfAttendance[1]/hr:StartDate/hr:AnyDate))" disable-output-escaping="yes"/>
        </from>
        <to>
          <xsl:value-of select="php:function('KiteCVFile::hrxmlDate2cedefopDate', string(exslt:node-set($node)/hr:SchoolOrInstitution/hr:Degree/hr:DatesOfAttendance[1]/hr:EndDate/hr:AnyDate))" disable-output-escaping="yes"/>
        </to>
      </period>
      
      <title>
        <xsl:value-of select="exslt:node-set($node)/hr:SchoolOrInstitution/hr:Degree/hr:DegreeName"/>
      </title>
      
      <skills>
        <xsl:value-of select="exslt:node-set($node)/hr:SchoolOrInstitution/hr:Degree/hr:Comments"/>
      </skills>
      
      <organisation>
        <xsl:value-of select="exslt:node-set($node)/hr:SchoolOrInstitution/hr:School/hr:SchoolName"/>
      </organisation>
      
      <level>
        <xsl:value-of select="exslt:node-set($node)/hr:SchoolOrInstitution/hr:Degree/hr:UserArea/hr:ReferenceLevel"/>
        (<xsl:value-of select="exslt:node-set($node)/hr:SchoolOrInstitution/hr:Degree/hr:UserArea/hr:ReferenceLevel/@referenceType"/>)
      </level>
    </education>
  </xsl:template>
  <xsl:template name="otherLanguage">
    <xsl:param name="node"/>
    <xsl:for-each select="exslt:node-set($node)/*">
      <language type="foreign">
        <name>
          <xsl:call-template name="languageName">
            <xsl:with-param name="code">
              <xsl:value-of select="hr:CompetencyId/@id"/>
            </xsl:with-param>
          </xsl:call-template>
        </name>

        <level>
          <listening>
            <xsl:call-template name="ELPSelectOptions">
              <xsl:with-param name="value">
                <xsl:value-of select="hr:CompetencyEvidence[@id='listen']/hr:StringValue"/>
              </xsl:with-param>
            </xsl:call-template>
          </listening>
          
          <reading>
            <xsl:call-template name="ELPSelectOptions">
              <xsl:with-param name="value">
                <xsl:value-of select="hr:CompetencyEvidence[@id='read']/hr:StringValue"/>
              </xsl:with-param>
            </xsl:call-template>
          </reading>
          
          <spokeninteraction>
            <xsl:call-template name="ELPSelectOptions">
              <xsl:with-param name="value">
                <xsl:value-of select="hr:CompetencyEvidence[@id='talk']/hr:StringValue"/>
              </xsl:with-param>
            </xsl:call-template>
          </spokeninteraction>
          
          <spokenproduction>
            <xsl:call-template name="ELPSelectOptions">
              <xsl:with-param name="value">
                <xsl:value-of select="hr:CompetencyEvidence[@id='speech']/hr:StringValue"/>
              </xsl:with-param>
            </xsl:call-template>
          </spokenproduction>
          
          <writing>
            <xsl:call-template name="ELPSelectOptions">
              <xsl:with-param name="value">
                <xsl:value-of select="hr:CompetencyEvidence[@id='write']/hr:StringValue"/>
              </xsl:with-param>
            </xsl:call-template>
          </writing>
        </level>
      </language>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="languageName">
    <xsl:param name="code"/>
    <xsl:variable name="value">
      <xsl:value-of select="translate($code, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    </xsl:variable>
    <xsl:value-of select="exslt:node-set($isocodes)/iso:iso_639_entries/iso:iso_639_entry[@iso_639_1_code = $value]/@name"/>
  </xsl:template>
  <xsl:template name="countryName">
    <xsl:param name="code"/>
    <xsl:variable name="value">
      <xsl:value-of select="translate($code, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    </xsl:variable>
    <xsl:value-of select="exslt:node-set($isocodes)/iso:iso_3166_entries/iso:iso_3166_entry[@alpha_2_code = $value]/@name"/>
  </xsl:template>
  <xsl:template name="postalAddress">
    <xsl:param name="node"/>
    <xsl:for-each select="exslt:node-set($node)/hr:PostalAddress/hr:DeliveryAddress/hr:AddressLine">
      <xsl:value-of select="."/><xsl:text>, </xsl:text>
    </xsl:for-each>
    <xsl:value-of select="exslt:node-set($node)/hr:PostalAddress/hr:Municipality"/><xsl:text> </xsl:text>
    <xsl:value-of select="exslt:node-set($node)/hr:PostalAddress/hr:PostalCode"/><xsl:text>, </xsl:text>
    <xsl:call-template name="countryName">
      <xsl:with-param name="code">
        <xsl:value-of select="exslt:node-set($node)/hr:PostalAddress/hr:CountryCode"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="ELPSelectOptions">
    <xsl:param name="value"/>
    <xsl:variable name="codes">
      <c v="A1">A1</c>
      <c v="A2">A2</c>
      <c v="B1">B1</c>
      <c v="B2">B2</c>
      <c v="C1">C1</c>
      <c v="C2">C2</c>
    </xsl:variable>
    <xsl:for-each select="exslt:node-set($codes)/*[@v=$value]">
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="competencySection">
    <xsl:param name="name"/>
    <xsl:param name="title"/>
    <xsl:if test="hr:PreferredPosition/hr:Competency[@name=$name]">
      <skill>
       <xsl:attribute name="type">
        <xsl:value-of select="$name"/>
       </xsl:attribute>
       <xsl:for-each select="hr:PreferredPosition/hr:Competency[@name=$name]">
         <xsl:value-of select="@description"/>
         <xsl:text>&#13;&#13;</xsl:text>
       </xsl:for-each>
      </skill>
    </xsl:if>
  </xsl:template>
  <xsl:variable name="isocodes">
    <!-- iso-639.tab							--><!--									--><!-- Copyright (C) 2004 Alastair McKinstry   <mckinstry@computer.org>   --><!-- Released under the GNU License; see file COPYING for details	--><!--									--><!-- Last update: 2004-10-27						--><!--									--><!-- This file gives a list of all languages in the ISO-639		--><!-- standard, and is used to provide translations (via gettext)	--><!--									--><!-- Status: ISO 639-2:1998 + additions and changes until 2004-03-05	--><!-- Source: http://lcweb.loc.gov/standards/iso639-2/englangn.html	--><iso_639_entries xmlns="http://www.iso.org/" xml:base="iso-codes/iso_639.xml">
	<iso_639_entry iso_639_2B_code="aar" iso_639_2T_code="aar" iso_639_1_code="aa" name="Afar"/>
	<iso_639_entry iso_639_2B_code="abk" iso_639_2T_code="abk" iso_639_1_code="ab" name="Abkhazian"/>
	<iso_639_entry iso_639_2B_code="ace" iso_639_2T_code="ace" name="Achinese"/>
	<iso_639_entry iso_639_2B_code="ach" iso_639_2T_code="ach" name="Acoli"/>
	<iso_639_entry iso_639_2B_code="ada" iso_639_2T_code="ada" name="Adangme"/>
	<iso_639_entry iso_639_2B_code="ady" iso_639_2T_code="ady" name="Adyghe; Adygei"/>
	<iso_639_entry iso_639_2B_code="afa" iso_639_2T_code="afa" name="Afro-Asiatic (Other)"/>
	<iso_639_entry iso_639_2B_code="afh" iso_639_2T_code="afh" name="Afrihili"/>
	<iso_639_entry iso_639_2B_code="afr" iso_639_2T_code="afr" iso_639_1_code="af" name="Afrikaans"/>
	<iso_639_entry iso_639_2B_code="aka" iso_639_2T_code="aka" iso_639_1_code="ak" name="Akan"/>
	<iso_639_entry iso_639_2B_code="akk" iso_639_2T_code="akk" name="Akkadian"/>
	<iso_639_entry iso_639_2B_code="alb" iso_639_2T_code="sqi" iso_639_1_code="sq" name="Albanian"/>
	<iso_639_entr iso_639_2B_code="alg" iso_639_2T_code="alg" name="Algonquian languages"/>
	<iso_639_entry iso_639_2B_code="amh" iso_639_2T_code="amh" iso_639_1_code="am" name="Amharic"/>
	<iso_639_entry iso_639_2B_code="ang" iso_639_2T_code="ang" name="English, Old (ca.450-1100)"/>
	<iso_639_entry iso_639_2B_code="apa" iso_639_2T_code="apa" name="Apache languages"/>
	<iso_639_entry iso_639_2B_code="ara" iso_639_2T_code="ara" iso_639_1_code="ar" name="Arabic"/>
	<iso_639_entry iso_639_2B_code="arc" iso_639_2T_code="arc" name="Aramaic"/>
	<iso_639_entry iso_639_2B_code="arg" iso_639_2T_code="arg" iso_639_1_code="an" name="Aragonese"/>
	<iso_639_entry iso_639_2B_code="arm" iso_639_2T_code="hye" iso_639_1_code="hy" name="Armenian"/>
	<iso_639_entry iso_639_2B_code="arn" iso_639_2T_code="arn" name="Araucanian"/>
	<iso_639_entry iso_639_2B_code="arp" iso_639_2T_code="arp" name="Arapaho"/>
	<iso_639_entry iso_639_2B_code="art" iso_639_2T_code="art" name="Artificial (Other)"/>
	<iso_639_entry iso_639_2B_code="arw" iso_639_2T_code="arw" name="Arawak"/>
	<iso_639_entry iso_639_2B_code="asm" iso_639_2T_code="asm" iso_639_1_code="as" name="Assamese"/>
	<iso_639_entry iso_639_2B_code="ast" iso_639_2T_code="ast" name="Asturian; Bable"/>
	<iso_639_entry iso_639_2B_code="ath" iso_639_2T_code="ath" name="Athapascan language"/>
	<iso_639_entry iso_639_2B_code="aus" iso_639_2T_code="aus" name="Australian languages"/>
	<iso_639_entry iso_639_2B_code="ava" iso_639_2T_code="ava" iso_639_1_code="av" name="Avaric"/>
	<iso_639_entry iso_639_2B_code="ave" iso_639_2T_code="ave" iso_639_1_code="ae" name="Avestan"/>
	<iso_639_entry iso_639_2B_code="awa" iso_639_2T_code="awa" name="Awadhi"/>
	<iso_639_entry iso_639_2B_code="aym" iso_639_2T_code="aym" iso_639_1_code="ay" name="Aymara"/>
	<iso_639_entry iso_639_2B_code="aze" iso_639_2T_code="aze" iso_639_1_code="az" name="Azerbaijani"/>
	<iso_639_entry iso_639_2B_code="bad" iso_639_2T_code="bad" name="Banda"/>
	<iso_639_entry iso_639_2B_code="bai" iso_639_2T_code="bai" name="Bamileke languages"/>
	<iso_639_entry iso_639_2B_code="bak" iso_639_2T_code="bak" iso_639_1_code="ba" name="Bashkir"/>
	<iso_639_entry iso_639_2B_code="bal" iso_639_2T_code="bal" name="Baluchi"/>
	<iso_639_entry iso_639_2B_code="bam" iso_639_2T_code="bam" iso_639_1_code="bm" name="Bambara"/>
	<iso_639_entry iso_639_2B_code="ban" iso_639_2T_code="ban" name="Balinese"/>
	<iso_639_entry iso_639_2B_code="baq" iso_639_2T_code="eus" iso_639_1_code="eu" name="Basque"/>
	<iso_639_entry iso_639_2B_code="bas" iso_639_2T_code="bas" name="Basa"/>
	<iso_639_entry iso_639_2B_code="bat" iso_639_2T_code="bat" name="Baltic (Other)"/>
	<iso_639_entry iso_639_2B_code="bej" iso_639_2T_code="bej" name="Beja"/>
	<iso_639_entry iso_639_2B_code="bel" iso_639_2T_code="bel" iso_639_1_code="be" name="Belarusian"/>
	<iso_639_entry iso_639_2B_code="bem" iso_639_2T_code="bem" name="Bemba"/>
	<iso_639_entry iso_639_2B_code="ben" iso_639_2T_code="ben" iso_639_1_code="bn" name="Bengali"/>
	<iso_639_entry iso_639_2B_code="ber" iso_639_2T_code="ber" name="Berber (Other)"/>
	<iso_639_entry iso_639_2B_code="bho" iso_639_2T_code="bho" name="Bhojpuri"/>
	<iso_639_entry iso_639_2B_code="bih" iso_639_2T_code="bih" iso_639_1_code="bh" name="Bihari"/>
	<iso_639_entry iso_639_2B_code="bik" iso_639_2T_code="bik" name="Bikol"/>
	<iso_639_entry iso_639_2B_code="bin" iso_639_2T_code="bin" name="Bini"/>
	<iso_639_entry iso_639_2B_code="bis" iso_639_2T_code="bis" iso_639_1_code="bi" name="Bislama"/>
	<iso_639_entry iso_639_2B_code="bla" iso_639_2T_code="bla" name="Siksika"/>
	<iso_639_entry iso_639_2B_code="bnt" iso_639_2T_code="bnt" name="Bantu (Other)"/>
	<iso_639_entry iso_639_2B_code="bos" iso_639_2T_code="bos" iso_639_1_code="bs" name="Bosnian"/>
	<iso_639_entry iso_639_2B_code="bra" iso_639_2T_code="bra" name="Braj"/>
	<iso_639_entry iso_639_2B_code="bre" iso_639_2T_code="bre" iso_639_1_code="br" name="Breton"/>
	<iso_639_entry iso_639_2B_code="btk" iso_639_2T_code="btk" name="Batak (Indonesia)"/>
	<iso_639_entry iso_639_2B_code="bua" iso_639_2T_code="bua" name="Buriat"/>
	<iso_639_entry iso_639_2B_code="bug" iso_639_2T_code="bug" name="Buginese"/>
	<iso_639_entry iso_639_2B_code="bul" iso_639_2T_code="bul" iso_639_1_code="bg" name="Bulgarian"/>
	<iso_639_entry iso_639_2B_code="bur" iso_639_2T_code="mya" iso_639_1_code="my" name="Burmese"/>
	<iso_639_entry iso_639_2B_code="byn" iso_639_2T_code="byn" name="Blin; Bilin"/>
	<iso_639_entry iso_639_2B_code="cad" iso_639_2T_code="cad" name="Caddo"/>
	<iso_639_entry iso_639_2B_code="cai" iso_639_2T_code="cai" name="Central American Indian (Other)"/>
	<iso_639_entry iso_639_2B_code="car" iso_639_2T_code="car" name="Carib"/>
	<iso_639_entry iso_639_2B_code="cat" iso_639_2T_code="cat" iso_639_1_code="ca" name="Catalan"/>
	<iso_639_entry iso_639_2B_code="cau" iso_639_2T_code="cau" name="Caucasian (Other)"/>
	<iso_639_entry iso_639_2B_code="ceb" iso_639_2T_code="ceb" name="Cebuano"/>
	<iso_639_entry iso_639_2B_code="cel" iso_639_2T_code="cel" name="Celtic (Other)"/>
	<iso_639_entry iso_639_2B_code="cha" iso_639_2T_code="cha" iso_639_1_code="ch" name="Chamorro"/>
	<iso_639_entry iso_639_2B_code="chb" iso_639_2T_code="chb" name="Chibcha"/>
	<iso_639_entry iso_639_2B_code="che" iso_639_2T_code="che" iso_639_1_code="ce" name="Chechen"/>
	<iso_639_entry iso_639_2B_code="chg" iso_639_2T_code="chg" name="Chagatai"/>
	<iso_639_entry iso_639_2B_code="chi" iso_639_2T_code="zho" iso_639_1_code="zh" name="Chinese"/>
	<iso_639_entry iso_639_2B_code="chk" iso_639_2T_code="chk" name="Chukese"/>
	<iso_639_entry iso_639_2B_code="chm" iso_639_2T_code="chm" name="Mari"/>
	<iso_639_entry iso_639_2B_code="chn" iso_639_2T_code="chn" name="Chinook jargon"/>
	<iso_639_entry iso_639_2B_code="cho" iso_639_2T_code="cho" name="Choctaw"/>
	<iso_639_entry iso_639_2B_code="chp" iso_639_2T_code="chp" name="Chipewyan"/>
	<iso_639_entry iso_639_2B_code="chr" iso_639_2T_code="chr" name="Cherokee"/>
	<iso_639_entry iso_639_2B_code="chu" iso_639_2T_code="chu" name="Church Slavic"/>
	<iso_639_entry iso_639_2B_code="chv" iso_639_2T_code="chv" iso_639_1_code="cv" name="Chuvash"/>
	<iso_639_entry iso_639_2B_code="chy" iso_639_2T_code="chy" name="Cheyenne"/>
	<iso_639_entry iso_639_2B_code="cmc" iso_639_2T_code="cmc" name="Chamic languages"/>
	<iso_639_entry iso_639_2B_code="cop" iso_639_2T_code="cop" name="Coptic"/>
	<iso_639_entry iso_639_2B_code="cor" iso_639_2T_code="cor" iso_639_1_code="kw" name="Cornish"/>
	<iso_639_entry iso_639_2B_code="cos" iso_639_2T_code="cos" iso_639_1_code="co" name="Corsican"/>
	<iso_639_entry iso_639_2B_code="cpe" iso_639_2T_code="cpe" name="English-based (Other)"/>
	<iso_639_entry iso_639_2B_code="cpf" iso_639_2T_code="cpf" name="French-based (Other)"/>
	<iso_639_entry iso_639_2B_code="cpp" iso_639_2T_code="cpp" name="Portuguese-based (Other)"/>
	<iso_639_entry iso_639_2B_code="cre" iso_639_2T_code="cre" iso_639_1_code="cr" name="Cree"/>
	<iso_639_entry iso_639_2B_code="crh" iso_639_2T_code="crh" name="Crimean Turkish; Crimean Tatar"/>
	<iso_639_entry iso_639_2B_code="crp" iso_639_2T_code="crp" name="Creoles and pidgins (Other)"/>
	<iso_639_entry iso_639_2B_code="csb" iso_639_2T_code="csb" name="Kashubian"/>
	<iso_639_entry iso_639_2B_code="cus" iso_639_2T_code="cus" name="Cushitic (Other)"/>
	<iso_639_entry iso_639_2B_code="cze" iso_639_2T_code="ces" iso_639_1_code="cs" name="Czech"/>
	<iso_639_entry iso_639_2B_code="dak" iso_639_2T_code="dak" name="Dakota"/>
	<iso_639_entry iso_639_2B_code="dan" iso_639_2T_code="dan" iso_639_1_code="da" name="Danish"/>
	<iso_639_entry iso_639_2B_code="dar" iso_639_2T_code="dar" name="Dargwa"/>
	<iso_639_entry iso_639_2B_code="del" iso_639_2T_code="del" name="Delaware"/>
	<iso_639_entry iso_639_2B_code="den" iso_639_2T_code="den" name="Slave (Athapascan)"/>
	<iso_639_entry iso_639_2B_code="dgr" iso_639_2T_code="dgr" name="Dogrib"/>
	<iso_639_entry iso_639_2B_code="din" iso_639_2T_code="din" name="Dinka"/>
	<iso_639_entry iso_639_2B_code="div" iso_639_2T_code="div" iso_639_1_code="dv" name="Divehi"/>
	<iso_639_entry iso_639_2B_code="doi" iso_639_2T_code="doi" name="Dogri"/>
	<iso_639_entry iso_639_2B_code="dra" iso_639_2T_code="dra" name="Dravidian (Other)"/>
	<iso_639_entry iso_639_2B_code="dsb" iso_639_2T_code="dsb" name="Lower Sorbian"/>
	<iso_639_entry iso_639_2B_code="dua" iso_639_2T_code="dua" name="Duala"/>
	<iso_639_entry iso_639_2B_code="dum" iso_639_2T_code="dum" name="Dutch, Middle (ca. 1050-1350)"/>
	<iso_639_entry iso_639_2B_code="dut" iso_639_2T_code="nld" iso_639_1_code="nl" name="Dutch"/>
	<iso_639_entry iso_639_2B_code="dyu" iso_639_2T_code="dyu" name="Dyula"/>
	<iso_639_entry iso_639_2B_code="dzo" iso_639_2T_code="dzo" iso_639_1_code="dz" name="Dzongkha"/>
	<iso_639_entry iso_639_2B_code="efi" iso_639_2T_code="efi" name="Efik"/>
	<iso_639_entry iso_639_2B_code="egy" iso_639_2T_code="egy" name="Egyptian (Ancient)"/>
	<iso_639_entry iso_639_2B_code="eka" iso_639_2T_code="eka" name="Ekajuk"/>
	<iso_639_entry iso_639_2B_code="elx" iso_639_2T_code="elx" name="Elamite"/>
	<iso_639_entry iso_639_2B_code="eng" iso_639_2T_code="eng" iso_639_1_code="en" name="English"/>
	<iso_639_entry iso_639_2B_code="enm" iso_639_2T_code="enm" name="English, Middle (1100-1500)"/>
	<iso_639_entry iso_639_2B_code="epo" iso_639_2T_code="epo" iso_639_1_code="eo" name="Esperanto"/>
	<iso_639_entry iso_639_2B_code="est" iso_639_2T_code="est" iso_639_1_code="et" name="Estonian"/>
	<iso_639_entry iso_639_2B_code="ewe" iso_639_2T_code="ewe" iso_639_1_code="ee" name="Ewe"/>
	<iso_639_entry iso_639_2B_code="ewo" iso_639_2T_code="ewo" name="Ewondo"/>
	<iso_639_entry iso_639_2B_code="fan" iso_639_2T_code="fan" name="Fang"/>
	<iso_639_entry iso_639_2B_code="fao" iso_639_2T_code="fao" iso_639_1_code="fo" name="Faroese"/>
	<iso_639_entry iso_639_2B_code="fat" iso_639_2T_code="fat" name="Fanti"/>
	<iso_639_entry iso_639_2B_code="fij" iso_639_2T_code="fij" iso_639_1_code="fj" name="Fijian"/>
	<iso_639_entry iso_639_2B_code="fil" iso_639_2T_code="fil" name="Filipino; Pilipino"/>
	<iso_639_entry iso_639_2B_code="fin" iso_639_2T_code="fin" iso_639_1_code="fi" name="Finnish"/>
	<iso_639_entry iso_639_2B_code="fiu" iso_639_2T_code="fiu" name="Finno-Ugrian (Other)"/>
	<iso_639_entry iso_639_2B_code="fon" iso_639_2T_code="fon" name="Fon"/>
	<iso_639_entry iso_639_2B_code="fre" iso_639_2T_code="fra" iso_639_1_code="fr" name="French"/>
	<iso_639_entry iso_639_2B_code="frm" iso_639_2T_code="frm" name="French, Middle (ca.1400-1600)"/>
	<iso_639_entry iso_639_2B_code="fro" iso_639_2T_code="fro" name="French, Old (842-ca.1400)"/>
	<iso_639_entry iso_639_2B_code="fry" iso_639_2T_code="fry" iso_639_1_code="fy" name="Frisian"/>
	<iso_639_entry iso_639_2B_code="ful" iso_639_2T_code="ful" iso_639_1_code="ff" name="Fulah"/>
	<iso_639_entry iso_639_2B_code="fur" iso_639_2T_code="fur" name="Friulian"/>
	<iso_639_entry iso_639_2B_code="gaa" iso_639_2T_code="gaa" name="Ga"/>
	<iso_639_entry iso_639_2B_code="gay" iso_639_2T_code="gay" name="Gayo"/>
	<iso_639_entry iso_639_2B_code="gba" iso_639_2T_code="gba" name="Gbaya"/>
	<iso_639_entry iso_639_2B_code="gem" iso_639_2T_code="gem" name="Germanic (Other)"/>
	<iso_639_entry iso_639_2B_code="geo" iso_639_2T_code="kat" iso_639_1_code="ka" name="Georgian"/>
	<iso_639_entry iso_639_2B_code="ger" iso_639_2T_code="deu" iso_639_1_code="de" name="German"/>
	<iso_639_entry iso_639_2B_code="gez" iso_639_2T_code="gez" name="Geez"/>
	<iso_639_entry iso_639_2B_code="gil" iso_639_2T_code="gil" name="Gilbertese"/>
	<iso_639_entry iso_639_2B_code="gla" iso_639_2T_code="gla" iso_639_1_code="gd" name="Gaelic; Scottish"/>
	<iso_639_entry iso_639_2B_code="gle" iso_639_2T_code="gle" iso_639_1_code="ga" name="Irish"/>
	<iso_639_entry iso_639_2B_code="glg" iso_639_2T_code="glg" iso_639_1_code="gl" name="Gallegan"/>
	<iso_639_entry iso_639_2B_code="glv" iso_639_2T_code="glv" iso_639_1_code="gv" name="Manx"/>
	<iso_639_entry iso_639_2B_code="gmh" iso_639_2T_code="gmh" name="German, Middle High (ca.1050-1500)"/>
	<iso_639_entry iso_639_2B_code="goh" iso_639_2T_code="goh" name="German, Old High (ca.750-1050)"/>
	<iso_639_entry iso_639_2B_code="gon" iso_639_2T_code="gon" name="Gondi"/>
	<iso_639_entry iso_639_2B_code="gor" iso_639_2T_code="gor" name="Gorontalo"/>
	<iso_639_entry iso_639_2B_code="got" iso_639_2T_code="got" name="Gothic"/>
	<iso_639_entry iso_639_2B_code="grb" iso_639_2T_code="grb" name="Grebo"/>
	<iso_639_entry iso_639_2B_code="grc" iso_639_2T_code="grc" name="Greek, Ancient (to 1453)"/>
	<iso_639_entry iso_639_2B_code="gre" iso_639_2T_code="ell" iso_639_1_code="el" name="Greek, Modern (1453-)"/>
	<iso_639_entry iso_639_2B_code="grn" iso_639_2T_code="grn" iso_639_1_code="gn" name="Guarani"/>
	<iso_639_entry iso_639_2B_code="guj" iso_639_2T_code="guj" iso_639_1_code="gu" name="Gujarati"/>
	<iso_639_entry iso_639_2B_code="gwi" iso_639_2T_code="gwi" name="Gwichin"/>
	<iso_639_entry iso_639_2B_code="hai" iso_639_2T_code="hai" name="Haida"/>
	<iso_639_entry iso_639_2B_code="hat" iso_639_2T_code="hat" iso_639_1_code="ht" name="Haitian; Haitian Creole"/>
	<iso_639_entry iso_639_2B_code="hau" iso_639_2T_code="hau" iso_639_1_code="ha" name="Hausa"/>
	<iso_639_entry iso_639_2B_code="haw" iso_639_2T_code="haw" name="Hawaiian"/>
	<iso_639_entry iso_639_2B_code="heb" iso_639_2T_code="heb" iso_639_1_code="he" name="Hebrew"/>
	<iso_639_entry iso_639_2B_code="her" iso_639_2T_code="her" iso_639_1_code="hz" name="Herero"/>
	<iso_639_entry iso_639_2B_code="hil" iso_639_2T_code="hil" name="Hiligaynon"/>
	<iso_639_entry iso_639_2B_code="him" iso_639_2T_code="him" name="Himachali"/>
	<iso_639_entry iso_639_2B_code="hin" iso_639_2T_code="hin" iso_639_1_code="hi" name="Hindi"/>
	<iso_639_entry iso_639_2B_code="hit" iso_639_2T_code="hit" name="Hittite"/>
	<iso_639_entry iso_639_2B_code="hmn" iso_639_2T_code="hmn" name="Hmong"/>
	<iso_639_entry iso_639_2B_code="hmo" iso_639_2T_code="hmo" iso_639_1_code="ho" name="Hiri"/>
	<iso_639_entry iso_639_2B_code="hsb" iso_639_2T_code="hsb" name="Upper Sorbian"/>
	<iso_639_entry iso_639_2B_code="hun" iso_639_2T_code="hun" iso_639_1_code="hu" name="Hungarian"/>
	<iso_639_entry iso_639_2B_code="hup" iso_639_2T_code="hup" name="Hupa"/>
	<iso_639_entry iso_639_2B_code="iba" iso_639_2T_code="iba" name="Iban"/>
	<iso_639_entry iso_639_2B_code="ibo" iso_639_2T_code="ibo" iso_639_1_code="ig" name="Igbo"/>
	<iso_639_entry iso_639_2B_code="ice" iso_639_2T_code="isl" iso_639_1_code="is" name="Icelandic"/>
	<iso_639_entry iso_639_2B_code="ido" iso_639_2T_code="ido" iso_639_1_code="io" name="Ido"/>
	<iso_639_entry iso_639_2B_code="iii" iso_639_2T_code="iii" iso_639_1_code="ii" name="Sichuan Yi"/>
	<iso_639_entry iso_639_2B_code="ijo" iso_639_2T_code="ijo" name="Ijo"/>
	<iso_639_entry iso_639_2B_code="iku" iso_639_2T_code="iku" iso_639_1_code="iu" name="Inuktitut"/>
	<iso_639_entry iso_639_2B_code="ile" iso_639_2T_code="ile" iso_639_1_code="ie" name="Interlingue"/>
	<iso_639_entry iso_639_2B_code="ilo" iso_639_2T_code="ilo" name="Iloko"/>
	<iso_639_entry iso_639_2B_code="ina" iso_639_2T_code="ina" iso_639_1_code="ia" name="Interlingua"/>
	<iso_639_entry iso_639_2B_code="inc" iso_639_2T_code="inc" name="Indic (Other)"/>
	<iso_639_entry iso_639_2B_code="ind" iso_639_2T_code="ind" iso_639_1_code="id" name="Indonesian"/>
	<iso_639_entry iso_639_2B_code="ine" iso_639_2T_code="ine" name="Indo-European (Other)"/>
	<iso_639_entry iso_639_2B_code="inh" iso_639_2T_code="inh" name="Ingush"/>
	<iso_639_entry iso_639_2B_code="ipk" iso_639_2T_code="ipk" iso_639_1_code="ik" name="Inupiaq"/>
	<iso_639_entry iso_639_2B_code="ira" iso_639_2T_code="ira" name="Iranian (Other)"/>
	<iso_639_entry iso_639_2B_code="iro" iso_639_2T_code="iro" name="Iroquoian languages"/>
	<iso_639_entry iso_639_2B_code="ita" iso_639_2T_code="ita" iso_639_1_code="it" name="Italian"/>
	<iso_639_entry iso_639_2B_code="jav" iso_639_2T_code="jav" iso_639_1_code="jv" name="Javanese"/>
	<iso_639_entry iso_639_2B_code="jbo" iso_639_2T_code="jbo" name="Lojban"/>
	<iso_639_entry iso_639_2B_code="jpn" iso_639_2T_code="jpn" iso_639_1_code="ja" name="Japanese"/>
	<iso_639_entry iso_639_2B_code="jpr" iso_639_2T_code="jpr" name="Judeo-Persian"/>
	<iso_639_entry iso_639_2B_code="jrb" iso_639_2T_code="jrb" name="Judeo-Arabic"/>
	<iso_639_entry iso_639_2B_code="kaa" iso_639_2T_code="kaa" name="Kara-Kalpak"/>
	<iso_639_entry iso_639_2B_code="kab" iso_639_2T_code="kab" name="Kabyle"/>
	<iso_639_entry iso_639_2B_code="kac" iso_639_2T_code="kac" name="Kachin"/>
	<iso_639_entry iso_639_2B_code="kal" iso_639_2T_code="kal" iso_639_1_code="kl" name="Greenlandic (Kalaallisut)"/>
	<iso_639_entry iso_639_2B_code="kam" iso_639_2T_code="kam" name="Kamba"/>
	<iso_639_entry iso_639_2B_code="kan" iso_639_2T_code="kan" iso_639_1_code="kn" name="Kannada"/>
	<iso_639_entry iso_639_2B_code="kar" iso_639_2T_code="kar" name="Karen"/>
	<iso_639_entry iso_639_2B_code="kas" iso_639_2T_code="kas" iso_639_1_code="ks" name="Kashmiri"/>
	<iso_639_entry iso_639_2B_code="kau" iso_639_2T_code="kau" iso_639_1_code="kr" name="Kanuri"/>
	<iso_639_entry iso_639_2B_code="kaw" iso_639_2T_code="kaw" name="Kawi"/>
	<iso_639_entry iso_639_2B_code="kaz" iso_639_2T_code="kaz" iso_639_1_code="kk" name="Kazakh"/>
	<iso_639_entry iso_639_2B_code="kbd" iso_639_2T_code="kbd" name="Kabardian"/>
	<iso_639_entry iso_639_2B_code="kha" iso_639_2T_code="kha" name="Khazi"/>
	<iso_639_entry iso_639_2B_code="khi" iso_639_2T_code="khi" name="Khoisan (Other)"/>
	<iso_639_entry iso_639_2B_code="khm" iso_639_2T_code="khm" iso_639_1_code="km" name="Khmer"/>
	<iso_639_entry iso_639_2B_code="kho" iso_639_2T_code="kho" name="Khotanese"/>
	<iso_639_entry iso_639_2B_code="kik" iso_639_2T_code="kik" iso_639_1_code="ki" name="Kikuyu"/>
	<iso_639_entry iso_639_2B_code="kin" iso_639_2T_code="kin" iso_639_1_code="rw" name="Kinyarwanda"/>
	<iso_639_entry iso_639_2B_code="kir" iso_639_2T_code="kir" iso_639_1_code="ky" name="Kirghiz"/>
	<iso_639_entry iso_639_2B_code="kmb" iso_639_2T_code="kmb" name="Kimbundu"/>
	<iso_639_entry iso_639_2B_code="kok" iso_639_2T_code="kok" name="Konkani"/>
	<iso_639_entry iso_639_2B_code="kom" iso_639_2T_code="kom" iso_639_1_code="kv" name="Komi"/>
	<iso_639_entry iso_639_2B_code="kon" iso_639_2T_code="kon" iso_639_1_code="kg" name="Kongo"/>
	<iso_639_entry iso_639_2B_code="kor" iso_639_2T_code="kor" iso_639_1_code="ko" name="Korean"/>
	<iso_639_entry iso_639_2B_code="kos" iso_639_2T_code="kos" name="Kosraean"/>
	<iso_639_entry iso_639_2B_code="kpe" iso_639_2T_code="kpe" name="Kpelle"/>
	<iso_639_entry iso_639_2B_code="krc" iso_639_2T_code="krc" name="Karachay-Balkar"/>
	<iso_639_entry iso_639_2B_code="kro" iso_639_2T_code="kro" name="Kru"/>
	<iso_639_entry iso_639_2B_code="kru" iso_639_2T_code="kru" name="Kurukh"/>
	<iso_639_entry iso_639_2B_code="kua" iso_639_2T_code="kua" iso_639_1_code="kj" name="Kuanyama"/>
	<iso_639_entry iso_639_2B_code="kum" iso_639_2T_code="kum" name="Kumyk"/>
	<iso_639_entry iso_639_2B_code="kur" iso_639_2T_code="kur" iso_639_1_code="ku" name="Kurdish"/>
	<iso_639_entry iso_639_2B_code="kut" iso_639_2T_code="kut" name="Kutenai"/>
	<iso_639_entry iso_639_2B_code="lad" iso_639_2T_code="lad" name="Ladino"/>
	<iso_639_entry iso_639_2B_code="lah" iso_639_2T_code="lah" name="Lahnda"/>
	<iso_639_entry iso_639_2B_code="lam" iso_639_2T_code="lam" name="Lamba"/>
	<iso_639_entry iso_639_2B_code="lao" iso_639_2T_code="lao" iso_639_1_code="lo" name="Lao"/>
	<iso_639_entry iso_639_2B_code="lat" iso_639_2T_code="lat" iso_639_1_code="la" name="Latin"/>
	<iso_639_entry iso_639_2B_code="lav" iso_639_2T_code="lav" iso_639_1_code="lv" name="Latvian"/>
	<iso_639_entry iso_639_2B_code="lez" iso_639_2T_code="lez" name="Lezghian"/>
	<iso_639_entry iso_639_2B_code="lim" iso_639_2T_code="lim" iso_639_1_code="li" name="Limburgian"/>
	<iso_639_entry iso_639_2B_code="lin" iso_639_2T_code="lin" iso_639_1_code="ln" name="Lingala"/>
	<iso_639_entry iso_639_2B_code="lit" iso_639_2T_code="lit" iso_639_1_code="lt" name="Lithuanian"/>
	<iso_639_entry iso_639_2B_code="lol" iso_639_2T_code="lol" name="Mongo"/>
	<iso_639_entry iso_639_2B_code="loz" iso_639_2T_code="loz" name="Lozi"/>
	<iso_639_entry iso_639_2B_code="ltz" iso_639_2T_code="ltz" iso_639_1_code="lb" name="Luxembourgish"/>
	<iso_639_entry iso_639_2B_code="lua" iso_639_2T_code="lua" name="Luba-Lulua"/>
	<iso_639_entry iso_639_2B_code="lub" iso_639_2T_code="lub" iso_639_1_code="lu" name="Luba-Katanga"/>
	<iso_639_entry iso_639_2B_code="lug" iso_639_2T_code="lug" iso_639_1_code="lg" name="Ganda"/>
	<iso_639_entry iso_639_2B_code="lui" iso_639_2T_code="lui" name="Luiseno"/>
	<iso_639_entry iso_639_2B_code="lun" iso_639_2T_code="lun" name="Lunda"/>
	<iso_639_entry iso_639_2B_code="luo" iso_639_2T_code="luo" name="Luo (Kenya and Tanzania)"/>
	<iso_639_entry iso_639_2B_code="lus" iso_639_2T_code="lus" name="Lushai"/>
	<iso_639_entry iso_639_2B_code="mac" iso_639_2T_code="mkd" iso_639_1_code="mk" name="Macedonian"/>
	<iso_639_entry iso_639_2B_code="mad" iso_639_2T_code="mad" name="Madurese"/>
	<iso_639_entry iso_639_2B_code="mag" iso_639_2T_code="mag" name="Magahi"/>
	<iso_639_entry iso_639_2B_code="mah" iso_639_2T_code="mah" iso_639_1_code="mh" name="Marshallese"/>
	<iso_639_entry iso_639_2B_code="mai" iso_639_2T_code="mai" name="Maithili"/>
	<iso_639_entry iso_639_2B_code="mak" iso_639_2T_code="mak" name="Makasar"/>
	<iso_639_entry iso_639_2B_code="mal" iso_639_2T_code="mal" iso_639_1_code="ml" name="Malayalam"/>
	<iso_639_entry iso_639_2B_code="man" iso_639_2T_code="man" name="Mandingo"/>
	<iso_639_entry iso_639_2B_code="mao" iso_639_2T_code="mri" iso_639_1_code="mi" name="Maori"/>
	<iso_639_entry iso_639_2B_code="map" iso_639_2T_code="map" name="Austronesian (Other)"/>
	<iso_639_entry iso_639_2B_code="mar" iso_639_2T_code="mar" iso_639_1_code="mr" name="Marathi"/>
	<iso_639_entry iso_639_2B_code="mas" iso_639_2T_code="mas" name="Masai"/>
	<iso_639_entry iso_639_2B_code="may" iso_639_2T_code="msa" iso_639_1_code="ms" name="Malay"/>
	<iso_639_entry iso_639_2B_code="mdf" iso_639_2T_code="mdf" name="Moksha"/>
	<iso_639_entry iso_639_2B_code="mdr" iso_639_2T_code="mdr" name="Mandar"/>
	<iso_639_entry iso_639_2B_code="men" iso_639_2T_code="men" name="Mende"/>
	<iso_639_entry iso_639_2B_code="mga" iso_639_2T_code="mga" name="Irish, Middle (900-1200)"/>
	<iso_639_entry iso_639_2B_code="mic" iso_639_2T_code="mic" name="Mi'kmaq; Micmac"/>
	<iso_639_entry iso_639_2B_code="min" iso_639_2T_code="min" name="Minangkabau"/>
	<iso_639_entry iso_639_2B_code="mis" iso_639_2T_code="mis" name="Miscellaneous languages"/>
	<iso_639_entry iso_639_2B_code="mkh" iso_639_2T_code="mkh" name="Mon-Khmer (Other)"/>
	<iso_639_entry iso_639_2B_code="mlg" iso_639_2T_code="mlg" iso_639_1_code="mg" name="Malagasy"/>
	<iso_639_entry iso_639_2B_code="mlt" iso_639_2T_code="mlt" iso_639_1_code="mt" name="Maltese"/>
	<iso_639_entry iso_639_2B_code="mnc" iso_639_2T_code="mnc" name="Manchu"/>
	<iso_639_entry iso_639_2B_code="mno" iso_639_2T_code="mno" name="Manobo languages"/>
	<iso_639_entry iso_639_2B_code="moh" iso_639_2T_code="moh" name="Mohawk"/>
	<iso_639_entry iso_639_2B_code="mol" iso_639_2T_code="mol" iso_639_1_code="mo" name="Moldavian"/>
	<iso_639_entry iso_639_2B_code="mon" iso_639_2T_code="mon" iso_639_1_code="mn" name="Mongolian"/>
	<iso_639_entry iso_639_2B_code="mos" iso_639_2T_code="mos" name="Mossi"/>
	<iso_639_entry iso_639_2B_code="mul" iso_639_2T_code="mul" name="Multiple languages"/>
	<iso_639_entry iso_639_2B_code="mun" iso_639_2T_code="mun" name="Munda languages"/>
	<iso_639_entry iso_639_2B_code="mus" iso_639_2T_code="mus" name="Creek"/>
	<iso_639_entry iso_639_2B_code="mwl" iso_639_2T_code="mwl" name="Mirandese"/>
	<iso_639_entry iso_639_2B_code="mwr" iso_639_2T_code="mwr" name="Marwari"/>
	<iso_639_entry iso_639_2B_code="myn" iso_639_2T_code="myn" name="Mayan languages"/>
	<iso_639_entry iso_639_2B_code="myv" iso_639_2T_code="myv" name="Erzya"/>
	<iso_639_entry iso_639_2B_code="nah" iso_639_2T_code="nah" name="Nahuatl"/>
	<iso_639_entry iso_639_2B_code="nai" iso_639_2T_code="nai" name="North American Indian (Other)"/>
	<iso_639_entry iso_639_2B_code="nap" iso_639_2T_code="nap" name="Neapolitan"/>
	<iso_639_entry iso_639_2B_code="nau" iso_639_2T_code="nau" iso_639_1_code="na" name="Nauru"/>
	<iso_639_entry iso_639_2B_code="nav" iso_639_2T_code="nav" iso_639_1_code="nv" name="Navaho"/>
	<iso_639_entry iso_639_2B_code="nbl" iso_639_2T_code="nbl" iso_639_1_code="nr" name="Ndebele, South"/>
	<iso_639_entry iso_639_2B_code="nde" iso_639_2T_code="nde" iso_639_1_code="nd" name="Ndebele, North"/>
	<iso_639_entry iso_639_2B_code="ndo" iso_639_2T_code="ndo" iso_639_1_code="ng" name="Ndonga"/>
	<iso_639_entry iso_639_2B_code="nds" iso_639_2T_code="nds" name="German, Low"/>
	<iso_639_entry iso_639_2B_code="nep" iso_639_2T_code="nep" iso_639_1_code="ne" name="Nepali"/>
	<iso_639_entry iso_639_2B_code="new" iso_639_2T_code="new" name="Newari"/>
	<iso_639_entry iso_639_2B_code="nia" iso_639_2T_code="nia" name="Nias"/>
	<iso_639_entry iso_639_2B_code="nic" iso_639_2T_code="nic" name="Niger-Kordofanian (Other)"/>
	<iso_639_entry iso_639_2B_code="niu" iso_639_2T_code="niu" name="Niuean"/>
	<iso_639_entry iso_639_2B_code="nno" iso_639_2T_code="nno" iso_639_1_code="nn" name="Norwegian Nynorsk"/>
	<iso_639_entry iso_639_2B_code="nob" iso_639_2T_code="nob" iso_639_1_code="nb" name="Bokmål, Norwegian"/>
	<iso_639_entry iso_639_2B_code="nog" iso_639_2T_code="nog" name="Nogai"/>
	<iso_639_entry iso_639_2B_code="non" iso_639_2T_code="non" name="Norse, Old"/>
	<iso_639_entry iso_639_2B_code="nor" iso_639_2T_code="nor" iso_639_1_code="no" name="Norwegian"/>
	<iso_639_entry iso_639_2B_code="nso" iso_639_2T_code="nso" name="Northern Sotho; Pedi; Sepedi"/>
	<iso_639_entry iso_639_2B_code="nub" iso_639_2T_code="nub" name="Nubian languages"/>
	<iso_639_entry iso_639_2B_code="nym" iso_639_2T_code="nym" name="Nyamwezi"/>
	<iso_639_entry iso_639_2B_code="nwc" iso_639_2T_code="nwc" name="Classical Newari; Old Newari"/>
	<iso_639_entry iso_639_2B_code="nya" iso_639_2T_code="nya" iso_639_1_code="ny" name="Chewa; Chichewa; Nyanja"/>
	<iso_639_entry iso_639_2B_code="nyn" iso_639_2T_code="nyn" name="Nyankole"/>
	<iso_639_entry iso_639_2B_code="nyo" iso_639_2T_code="nyo" name="Nyoro"/>
	<iso_639_entry iso_639_2B_code="nzi" iso_639_2T_code="nzi" name="Nzima"/>
	<iso_639_entry iso_639_2B_code="oci" iso_639_2T_code="oci" iso_639_1_code="oc" name="Occitan (post 1500)"/>
	<iso_639_entry iso_639_2B_code="oji" iso_639_2T_code="oji" iso_639_1_code="oj" name="Ojibwa"/>
	<iso_639_entry iso_639_2B_code="ori" iso_639_2T_code="ori" iso_639_1_code="or" name="Oriya"/>
	<iso_639_entry iso_639_2B_code="orm" iso_639_2T_code="orm" iso_639_1_code="om" name="Oromo"/>
	<iso_639_entry iso_639_2B_code="osa" iso_639_2T_code="osa" name="Osage"/>
	<iso_639_entry iso_639_2B_code="oss" iso_639_2T_code="oss" iso_639_1_code="os" name="Ossetian"/>
	<iso_639_entry iso_639_2B_code="ota" iso_639_2T_code="ota" name="Turkish, Ottoman (1500-1928)"/>
	<iso_639_entry iso_639_2B_code="oto" iso_639_2T_code="oto" name="Otomian languages"/>
	<iso_639_entry iso_639_2B_code="paa" iso_639_2T_code="paa" name="Papuan (Other)"/>
	<iso_639_entry iso_639_2B_code="pag" iso_639_2T_code="pag" name="Pangasinan"/>
	<iso_639_entry iso_639_2B_code="pal" iso_639_2T_code="pal" name="Pahlavi"/>
	<iso_639_entry iso_639_2B_code="pam" iso_639_2T_code="pam" name="Pampanga"/>
	<iso_639_entry iso_639_2B_code="pan" iso_639_2T_code="pan" iso_639_1_code="pa" name="Punjabi"/>
	<iso_639_entry iso_639_2B_code="pap" iso_639_2T_code="pap" name="Papiamento"/>
	<iso_639_entry iso_639_2B_code="pau" iso_639_2T_code="pau" name="Palauan"/>
	<iso_639_entry iso_639_2B_code="peo" iso_639_2T_code="peo" name="Persian, Old (ca.600-400 B.C.)"/>
	<iso_639_entry iso_639_2B_code="per" iso_639_2T_code="fas" iso_639_1_code="fa" name="Persian"/>
	<iso_639_entry iso_639_2B_code="phi" iso_639_2T_code="phi" name="Philippine (Other)"/>
	<iso_639_entry iso_639_2B_code="phn" iso_639_2T_code="phn" name="Phoenician"/>
	<iso_639_entry iso_639_2B_code="pli" iso_639_2T_code="pli" iso_639_1_code="pi" name="Pali"/>
	<iso_639_entry iso_639_2B_code="pol" iso_639_2T_code="pol" iso_639_1_code="pl" name="Polish"/>
	<iso_639_entry iso_639_2B_code="por" iso_639_2T_code="por" iso_639_1_code="pt" name="Portuguese"/>
	<iso_639_entry iso_639_2B_code="pon" iso_639_2T_code="pon" name="Pohnpeian"/>
	<iso_639_entry iso_639_2B_code="pra" iso_639_2T_code="pra" name="Prakrit languages"/>
	<iso_639_entry iso_639_2B_code="pro" iso_639_2T_code="pro" name="Provençal, Old (to 1500)"/>
	<iso_639_entry iso_639_2B_code="pus" iso_639_2T_code="pus" iso_639_1_code="ps" name="Pushto"/>
	<iso_639_entry iso_639_2B_code="que" iso_639_2T_code="que" iso_639_1_code="qu" name="Quechua"/>
	<iso_639_entry iso_639_2B_code="raj" iso_639_2T_code="raj" name="Rajasthani"/>
	<iso_639_entry iso_639_2B_code="rap" iso_639_2T_code="rap" name="Rapanui"/>
	<iso_639_entry iso_639_2B_code="rar" iso_639_2T_code="rar" name="Rarotongan"/>
	<iso_639_entry iso_639_2B_code="roa" iso_639_2T_code="roa" name="Romance (Other)"/>
	<iso_639_entry iso_639_2B_code="roh" iso_639_2T_code="roh" iso_639_1_code="rm" name="Raeto-Romance"/>
	<iso_639_entry iso_639_2B_code="rom" iso_639_2T_code="rom" name="Romany"/>
	<iso_639_entry iso_639_2B_code="rum" iso_639_2T_code="ron" iso_639_1_code="ro" name="Romanian"/>
	<iso_639_entry iso_639_2B_code="run" iso_639_2T_code="run" iso_639_1_code="rn" name="Rundi"/>
	<iso_639_entry iso_639_2B_code="rus" iso_639_2T_code="rus" iso_639_1_code="ru" name="Russian"/>
	<iso_639_entry iso_639_2B_code="sad" iso_639_2T_code="sad" name="Sandawe"/>
	<iso_639_entry iso_639_2B_code="sag" iso_639_2T_code="sag" iso_639_1_code="sg" name="Sango"/>
	<iso_639_entry iso_639_2B_code="sah" iso_639_2T_code="sah" name="Yakut"/>
	<iso_639_entry iso_639_2B_code="sai" iso_639_2T_code="sai" name="South American Indian (Other)"/>
	<iso_639_entry iso_639_2B_code="sal" iso_639_2T_code="sal" name="Salishan languages"/>
	<iso_639_entry iso_639_2B_code="sam" iso_639_2T_code="sam" name="Samaritan Aramaic"/>
	<iso_639_entry iso_639_2B_code="san" iso_639_2T_code="san" iso_639_1_code="sa" name="Sanskrit"/>
	<iso_639_entry iso_639_2B_code="sas" iso_639_2T_code="sas" name="Sasak"/>
	<iso_639_entry iso_639_2B_code="sat" iso_639_2T_code="sat" name="Santali"/>
	<iso_639_entry iso_639_2B_code="scc" iso_639_2T_code="srp" iso_639_1_code="sr" name="Serbian"/>
	<iso_639_entry iso_639_2B_code="scn" iso_639_2T_code="scn" name="Sicilian"/>
	<iso_639_entry iso_639_2B_code="sco" iso_639_2T_code="sco" name="Scots"/>
	<iso_639_entry iso_639_2B_code="scr" iso_639_2T_code="hrv" iso_639_1_code="hr" name="Croatian"/>
	<iso_639_entry iso_639_2B_code="sel" iso_639_2T_code="sel" name="Selkup"/>
	<iso_639_entry iso_639_2B_code="sem" iso_639_2T_code="sem" name="Semitic (Other)"/>
	<iso_639_entry iso_639_2B_code="sga" iso_639_2T_code="sga" name="Irish, Old (to 900)"/>
	<iso_639_entry iso_639_2B_code="sgn" iso_639_2T_code="sgn" name="Sign languages"/>
	<iso_639_entry iso_639_2B_code="shn" iso_639_2T_code="shn" name="Shan"/>
	<iso_639_entry iso_639_2B_code="sid" iso_639_2T_code="sid" name="Sidamo"/>
	<iso_639_entry iso_639_2B_code="sin" iso_639_2T_code="sin" iso_639_1_code="si" name="Sinhala; Sinhalese"/>
	<iso_639_entry iso_639_2B_code="sio" iso_639_2T_code="sio" name="Siouan languages"/>
	<iso_639_entry iso_639_2B_code="sit" iso_639_2T_code="sit" name="Sino-Tibetan (Other)"/>
	<iso_639_entry iso_639_2B_code="sla" iso_639_2T_code="sla" name="Slavic (Other)"/>
	<iso_639_entry iso_639_2B_code="slo" iso_639_2T_code="slk" iso_639_1_code="sk" name="Slovak"/>
	<iso_639_entry iso_639_2B_code="slv" iso_639_2T_code="slv" iso_639_1_code="sl" name="Slovenian"/>
	<iso_639_entry iso_639_2B_code="sma" iso_639_2T_code="sma" name="Southern Sami"/>
	<iso_639_entry iso_639_2B_code="sme" iso_639_2T_code="sme" iso_639_1_code="se" name="Northern Sami"/>
	<iso_639_entry iso_639_2B_code="smi" iso_639_2T_code="smi" name="Sami languages (Other)"/>
	<iso_639_entry iso_639_2B_code="smj" iso_639_2T_code="smj" name="Lule Sami"/>
	<iso_639_entry iso_639_2B_code="smn" iso_639_2T_code="smn" name="Inari Sami"/>
	<iso_639_entry iso_639_2B_code="smo" iso_639_2T_code="smo" iso_639_1_code="sm" name="Samoan"/>
	<iso_639_entry iso_639_2B_code="sms" iso_639_2T_code="sms" name="Skolt Sami"/>
	<iso_639_entry iso_639_2B_code="sna" iso_639_2T_code="sna" iso_639_1_code="sn" name="Shona"/>
	<iso_639_entry iso_639_2B_code="snd" iso_639_2T_code="snd" iso_639_1_code="sd" name="Sindhi"/>
	<iso_639_entry iso_639_2B_code="snk" iso_639_2T_code="snk" name="Soninke"/>
	<iso_639_entry iso_639_2B_code="sog" iso_639_2T_code="sog" name="Sogdian"/>
	<iso_639_entry iso_639_2B_code="som" iso_639_2T_code="som" iso_639_1_code="so" name="Somali"/>
	<iso_639_entry iso_639_2B_code="son" iso_639_2T_code="son" name="Songhai"/>
	<iso_639_entry iso_639_2B_code="sot" iso_639_2T_code="sot" iso_639_1_code="st" name="Sotho, Southern"/>
	<iso_639_entry iso_639_2B_code="spa" iso_639_2T_code="spa" iso_639_1_code="es" name="Spanish"/>
	<iso_639_entry iso_639_2B_code="srd" iso_639_2T_code="srd" iso_639_1_code="sc" name="Sardinian"/>
	<iso_639_entry iso_639_2B_code="srr" iso_639_2T_code="srr" name="Serer"/>
	<iso_639_entry iso_639_2B_code="ssa" iso_639_2T_code="ssa" name="Nilo-Saharan (Other)"/>
	<iso_639_entry iso_639_2B_code="ssw" iso_639_2T_code="ssw" iso_639_1_code="ss" name="Swati"/>
	<iso_639_entry iso_639_2B_code="suk" iso_639_2T_code="suk" name="Sukuma"/>
	<iso_639_entry iso_639_2B_code="sun" iso_639_2T_code="sun" iso_639_1_code="su" name="Sundanese"/>
	<iso_639_entry iso_639_2B_code="sus" iso_639_2T_code="sus" name="Susu"/>
	<iso_639_entry iso_639_2B_code="sux" iso_639_2T_code="sux" name="Sumerian"/>
	<iso_639_entry iso_639_2B_code="swa" iso_639_2T_code="swa" iso_639_1_code="sw" name="Swahili"/>
	<iso_639_entry iso_639_2B_code="swe" iso_639_2T_code="swe" iso_639_1_code="sv" name="Swedish"/>
	<iso_639_entry iso_639_2B_code="syr" iso_639_2T_code="syr" name="Syriac"/>
	<iso_639_entry iso_639_2B_code="tah" iso_639_2T_code="tah" iso_639_1_code="ty" name="Tahitian"/>
	<iso_639_entry iso_639_2B_code="tai" iso_639_2T_code="tai" name="Tai (Other)"/>
	<iso_639_entry iso_639_2B_code="tam" iso_639_2T_code="tam" iso_639_1_code="ta" name="Tamil"/>
	<iso_639_entry iso_639_2B_code="tso" iso_639_2T_code="tso" iso_639_1_code="ts" name="Tsonga"/>
	<iso_639_entry iso_639_2B_code="tat" iso_639_2T_code="tat" iso_639_1_code="tt" name="Tatar"/>
	<iso_639_entry iso_639_2B_code="tel" iso_639_2T_code="tel" iso_639_1_code="te" name="Telugu"/>
	<iso_639_entry iso_639_2B_code="tem" iso_639_2T_code="tem" name="Timne"/>
	<iso_639_entry iso_639_2B_code="ter" iso_639_2T_code="ter" name="Tereno"/>
	<iso_639_entry iso_639_2B_code="tet" iso_639_2T_code="tet" name="Tetum"/>
	<iso_639_entry iso_639_2B_code="tgk" iso_639_2T_code="tgk" iso_639_1_code="tg" name="Tajik"/>
	<iso_639_entry iso_639_2B_code="tgl" iso_639_2T_code="tgl" iso_639_1_code="tl" name="Tagalog"/>
	<iso_639_entry iso_639_2B_code="tha" iso_639_2T_code="tha" iso_639_1_code="th" name="Thai"/>
	<iso_639_entry iso_639_2B_code="tib" iso_639_2T_code="bod" iso_639_1_code="bo" name="Tibetan"/>
	<iso_639_entry iso_639_2B_code="tig" iso_639_2T_code="tig" name="Tigre"/>
	<iso_639_entry iso_639_2B_code="tir" iso_639_2T_code="tir" iso_639_1_code="ti" name="Tigrinya"/>
	<iso_639_entry iso_639_2B_code="tiv" iso_639_2T_code="tiv" name="Tiv"/>
	<iso_639_entry iso_639_2B_code="tlh" iso_639_2T_code="tlh" name="Klingon; tlhIngan-Hol"/>
	<iso_639_entry iso_639_2B_code="tkl" iso_639_2T_code="tkl" name="Tokelau"/>
	<iso_639_entry iso_639_2B_code="tli" iso_639_2T_code="tli" name="Tlinglit"/>
	<iso_639_entry iso_639_2B_code="tmh" iso_639_2T_code="tmh" name="Tamashek"/>
	<iso_639_entry iso_639_2B_code="tog" iso_639_2T_code="tog" name="Tonga (Nyasa)"/>
	<iso_639_entry iso_639_2B_code="ton" iso_639_2T_code="ton" iso_639_1_code="to" name="Tonga (Tonga Islands)"/>
	<iso_639_entry iso_639_2B_code="tpi" iso_639_2T_code="tpi" name="Tok Pisin"/>
	<iso_639_entry iso_639_2B_code="tsi" iso_639_2T_code="tsi" name="Tsimshian"/>
	<iso_639_entry iso_639_2B_code="tsn" iso_639_2T_code="tsn" iso_639_1_code="tn" name="Tswana"/>
	<iso_639_entry iso_639_2B_code="tuk" iso_639_2T_code="tuk" iso_639_1_code="tk" name="Turkmen"/>
	<iso_639_entry iso_639_2B_code="tum" iso_639_2T_code="tum" name="Tumbuka"/>
	<iso_639_entry iso_639_2B_code="tup" iso_639_2T_code="tup" name="Tupi languages"/>
	<iso_639_entry iso_639_2B_code="tur" iso_639_2T_code="tur" iso_639_1_code="tr" name="Turkish"/>
	<iso_639_entry iso_639_2B_code="tut" iso_639_2T_code="tut" name="Altaic (Other)"/>
	<iso_639_entry iso_639_2B_code="tvl" iso_639_2T_code="tvl" name="Tuvalu"/>
	<iso_639_entry iso_639_2B_code="twi" iso_639_2T_code="twi" iso_639_1_code="tw" name="Twi"/>
	<iso_639_entry iso_639_2B_code="tyv" iso_639_2T_code="tyv" name="Tuvinian"/>
	<iso_639_entry iso_639_2B_code="udm" iso_639_2T_code="udm" name="Udmurt"/>
	<iso_639_entry iso_639_2B_code="uga" iso_639_2T_code="uga" name="Ugaritic"/>
	<iso_639_entry iso_639_2B_code="uig" iso_639_2T_code="uig" iso_639_1_code="ug" name="Uighur"/>
	<iso_639_entry iso_639_2B_code="ukr" iso_639_2T_code="ukr" iso_639_1_code="uk" name="Ukrainian"/>
	<iso_639_entry iso_639_2B_code="umb" iso_639_2T_code="umb" name="Umbundu"/>
	<iso_639_entry iso_639_2B_code="und" iso_639_2T_code="und" name="Undetermined"/>
	<iso_639_entry iso_639_2B_code="urd" iso_639_2T_code="urd" ido_639_1_code="ur" name="Urdu"/>
	<iso_639_entry iso_639_2B_code="uzb" iso_639_2T_code="uzb" iso_639_1_code="uz" name="Uzbek"/>
	<iso_639_entry iso_639_2B_code="vai" iso_639_2T_code="vai" name="Vai"/>
	<iso_639_entry iso_639_2B_code="ven" iso_639_2T_code="ven" iso_639_1_code="ve" name="Venda"/>
	<iso_639_entry iso_639_2B_code="vie" iso_639_2T_code="vie" iso_639_1_code="vi" name="Vietnamese"/>
	<iso_639_entry iso_639_2B_code="vol" iso_639_2T_code="vol" iso_639_1_code="vo" name="Volapuk"/>
	<iso_639_entry iso_639_2B_code="vot" iso_639_2T_code="vot" name="Votic"/>
	<iso_639_entry iso_639_2B_code="wak" iso_639_2T_code="wak" name="Wakashan languages"/>
	<iso_639_entry iso_639_2B_code="wal" iso_639_2T_code="wal" name="Walamo"/>
	<iso_639_entry iso_639_2B_code="war" iso_639_2T_code="war" name="Waray"/>
	<iso_639_entry iso_639_2B_code="was" iso_639_2T_code="was" name="Washo"/>
	<iso_639_entry iso_639_2B_code="wel" iso_639_2T_code="cym" iso_639_1_code="cy" name="Welsh"/>
	<iso_639_entry iso_639_2B_code="wen" iso_639_2T_code="wen" name="Sorbian languages"/>
	<iso_639_entry iso_639_2B_code="wln" iso_639_2T_code="wln" iso_639_1_code="wa" name="Walloon"/>
	<iso_639_entry iso_639_2B_code="wol" iso_639_2T_code="wol" iso_639_1_code="wo" name="Wolof"/>
	<iso_639_entry iso_639_2B_code="xal" iso_639_2T_code="xal" name="Kalmyk"/>
	<iso_639_entry iso_639_2B_code="xho" iso_639_2T_code="xho" iso_639_1_code="xh" name="Xhosa"/>
	<iso_639_entry iso_639_2B_code="yao" iso_639_2T_code="yao" name="Yao"/>
	<iso_639_entry iso_639_2B_code="yap" iso_639_2T_code="yap" name="Yapese"/>
	<iso_639_entry iso_639_2B_code="yid" iso_639_2T_code="yid" iso_639_1_code="yi" name="Yiddish"/>
	<iso_639_entry iso_639_2B_code="yor" iso_639_2T_code="yor" iso_639_1_code="yo" name="Yoruba"/>
	<iso_639_entry iso_639_2B_code="ypk" iso_639_2T_code="ypk" name="Yupik languages"/>
	<iso_639_entry iso_639_2B_code="zap" iso_639_2T_code="zap" name="Zapotec"/>
	<iso_639_entry iso_639_2B_code="zen" iso_639_2T_code="zen" name="Zenaga"/>
	<iso_639_entry iso_639_2B_code="zha" iso_639_2T_code="zha" iso_639_1_code="za" name="Chuang; Zhuang"/>
	<iso_639_entry iso_639_2B_code="znd" iso_639_2T_code="znd" name="Zande"/>
	<iso_639_entry iso_639_2B_code="zul" iso_639_2T_code="zul" iso_639_1_code="zu" name="Zulu"/>
	<iso_639_entry iso_639_2B_code="zun" iso_639_2T_code="zun" name="Zuni"/>
</iso_639_entries>
    <!-- iso-3166.tab 								--><!--										--><!-- Copyright (C) 2002,2004 Alastair McKinstry <mckinstry@debian.org>		--><!--   Additional material: Andreas Jochens <aj@andaco.de>			--><!--    Last updated: 2004-04-29						--><!-- Released under the LGPL							--><iso_3166_entries xmlns="http://www.iso.org/" xml:base="iso-codes/iso_3166.xml">
	<iso_3166_entry alpha_2_code="AF" alpha_3_code="AFG" numeric_code="004" name="Afghanistan" official_name="The Transitional Islamic State of Afghanistan"/>
	<iso_3166_entry alpha_2_code="AX" alpha_3_code="ALA" numeric_code="248" name="Åland Islands"/>
	<iso_3166_entry alpha_2_code="AL" alpha_3_code="ALB" numeric_code="008" name="Albania" official_name="Republic of Albania"/>
	<iso_3166_entry alpha_2_code="DZ" alpha_3_code="DZA" numeric_code="012" name="Algeria" official_name="People's Democratic Republic of Algeria"/>
	<iso_3166_entry alpha_2_code="AS" alpha_3_code="ASM" numeric_code="016" name="American Samoa"/>
	<iso_3166_entry alpha_2_code="AD" alpha_3_code="AND" numeric_code="020" name="Andorra" official_name="Principality of Andorra"/>
	<iso_3166_entry alpha_2_code="AO" alpha_3_code="AGO" numeric_code="024" name="Angola" official_name="Republic of Angola"/>
	<iso_3166_entry alpha_2_code="AI" alpha_3_code="AIA" numeric_code="660" name="Anguilla"/>
	<iso_3166_entry alpha_2_code="AQ" alpha_3_code="ATA" numeric_code="010" name="Antarctica"/>
	<iso_3166_entry alpha_2_code="AG" alpha_3_code="ATG" numeric_code="028" name="Antigua and Barbuda"/>
	<iso_3166_entry alpha_2_code="AR" alpha_3_code="ARG" numeric_code="032" name="Argentina" official_name="Argentine Republic"/>
	<iso_3166_entry alpha_2_code="AM" alpha_3_code="ARM" numeric_code="051" name="Armenia" official_name="Republic of Armenia"/>
	<iso_3166_entry alpha_2_code="AW" alpha_3_code="ABW" numeric_code="533" name="Aruba"/>
	<iso_3166_entry alpha_2_code="AU" alpha_3_code="AUS" numeric_code="036" name="Australia"/>
	<iso_3166_entry alpha_2_code="AT" alpha_3_code="AUT" numeric_code="040" name="Austria" official_name="Republic of Austria"/>
	<iso_3166_entry alpha_2_code="AZ" alpha_3_code="AZE" numeric_code="031" name="Azerbaijan" official_name="Republic of Azerbaijan"/>
	<iso_3166_entry alpha_2_code="BS" alpha_3_code="BHS" numeric_code="044" name="Bahamas" official_name="Commonwealth of the Bahamas"/>
	<iso_3166_entry alpha_2_code="BH" alpha_3_code="BHR" numeric_code="048" name="Bahrain" official_name="State of Bahrain"/>
	<iso_3166_entry alpha_2_code="BD" alpha_3_code="BGD" numeric_code="050" name="Bangladesh" official_name="People's Republic of Bangladesh"/>
	<iso_3166_entry alpha_2_code="BB" alpha_3_code="BRB" numeric_code="052" name="Barbados"/>
	<iso_3166_entry alpha_2_code="BY" alpha_3_code="BLR" numeric_code="112" name="Belarus" official_name="Republic of Belarus"/>
	<iso_3166_entry alpha_2_code="BE" alpha_3_code="BEL" numeric_code="056" name="Belgium" official_name="Kingdom of Belgium"/>
	<iso_3166_entry alpha_2_code="BZ" alpha_3_code="BLZ" numeric_code="084" name="Belize"/>
	<iso_3166_entry alpha_2_code="BJ" alpha_3_code="BEN" numeric_code="204" name="Benin" official_name="Republic of Benin"/>
	<iso_3166_entry alpha_2_code="BM" alpha_3_code="BMU" numeric_code="060" name="Bermuda"/>
	<iso_3166_entry alpha_2_code="BT" alpha_3_code="BTN" numeric_code="064" name="Bhutan" official_name="Kingdom of Bhutan"/>
	<iso_3166_entry alpha_2_code="BO" alpha_3_code="BOL" numeric_code="068" name="Bolivia" official_name="Republic of Bolivia"/>
	<iso_3166_entry alpha_2_code="BA" alpha_3_code="BIH" numeric_code="070" name="Bosnia and Herzegovina" official_name="Republic of Bosnia and Herzegovina"/>
	<iso_3166_entry alpha_2_code="BW" alpha_3_code="BWA" numeric_code="072" name="Botswana" official_name="Republic of Botswana"/>
	<iso_3166_entry alpha_2_code="BV" alpha_3_code="BVT" numeric_code="074" name="Bouvet Island"/>
	<iso_3166_entry alpha_2_code="BR" alpha_3_code="BRA" numeric_code="076" name="Brazil" official_name="Federative Republic of Brazil"/>
	<iso_3166_entry alpha_2_code="IO" alpha_3_code="IOT" numeric_code="086" name="British Indian Ocean Territory"/>
	<iso_3166_entry alpha_2_code="BN" alpha_3_code="BRN" numeric_code="096" name="Brunei Darussalam"/>
	<iso_3166_entry alpha_2_code="BG" alpha_3_code="BGR" numeric_code="100" name="Bulgaria" official_name="Republic of Bulgaria"/>
	<iso_3166_entry alpha_2_code="BF" alpha_3_code="BFA" numeric_code="854" name="Burkina Faso"/>
	<iso_3166_entry alpha_2_code="BI" alpha_3_code="BDI" numeric_code="108" name="Burundi" official_name="Republic of Burundi"/>
	<iso_3166_entry alpha_2_code="KH" alpha_3_code="KHM" numeric_code="116" name="Cambodia" official_name="Kingdom of Cambodia"/>
	<iso_3166_entry alpha_2_code="CM" alpha_3_code="CMR" numeric_code="120" name="Cameroon" official_name="Republic of Cameroon"/>
	<iso_3166_entry alpha_2_code="CA" alpha_3_code="CAN" numeric_code="124" name="Canada"/>
	<iso_3166_entry alpha_2_code="CV" alpha_3_code="CPV" numeric_code="132" name="Cape Verde" official_name="Republic of Cape Verde"/>
	<iso_3166_entry alpha_2_code="KY" alpha_3_code="CYM" numeric_code="136" name="Cayman Islands"/>
	<iso_3166_entry alpha_2_code="CF" alpha_3_code="CAF" numeric_code="140" name="Central African Republic"/>
	<iso_3166_entry alpha_2_code="TD" alpha_3_code="TCD" numeric_code="148" name="Chad" official_name="Republic of Chad"/>
	<iso_3166_entry alpha_2_code="CL" alpha_3_code="CHL" numeric_code="152" name="Chile" official_name="Republic of Chile"/>
	<iso_3166_entry alpha_2_code="CN" alpha_3_code="CHN" numeric_code="156" name="China" official_name="People's Republic of China"/>
	<iso_3166_entry alpha_2_code="CX" alpha_3_code="CXR" numeric_code="162" name="Christmas Island"/>
	<iso_3166_entry alpha_2_code="CC" alpha_3_code="CCK" numeric_code="166" name="Cocos (Keeling) Islands"/>
	<iso_3166_entry alpha_2_code="CO" alpha_3_code="COL" numeric_code="170" name="Colombia" official_name="Republic of Colombia"/>
	<iso_3166_entry alpha_2_code="KM" alpha_3_code="COM" numeric_code="174" name="Comoros" official_name="Union of the Comoros"/>
	<iso_3166_entry alpha_2_code="CG" alpha_3_code="COG" numeric_code="178" name="Congo" official_name="Republic of the Congo"/>
	<iso_3166_entry alpha_2_code="CD" alpha_3_code="ZAR" numeric_code="180" name="Congo, The Democratic Republic of the"/>
	<iso_3166_entry alpha_2_code="CK" alpha_3_code="COK" numeric_code="184" name="Cook Islands"/>
	<iso_3166_entry alpha_2_code="CR" alpha_3_code="CRI" numeric_code="188" name="Costa Rica" official_name="Republic of Costa Rica"/>
	<iso_3166_entry alpha_2_code="CI" alpha_3_code="CIV" numeric_code="384" name="Côte d'Ivoire" official_name="Republic of Cote d'Ivoire"/>
	<iso_3166_entry alpha_2_code="HR" alpha_3_code="HRV" numeric_code="191" name="Croatia" official_name="Republic of Croatia"/>
	<iso_3166_entry alpha_2_code="CU" alpha_3_code="CUB" numeric_code="192" name="Cuba" official_name="Republic of Cuba"/>
	<iso_3166_entry alpha_2_code="CY" alpha_3_code="CYP" numeric_code="196" name="Cyprus" official_name="Republic of Cyprus"/>
	<iso_3166_entry alpha_2_code="CZ" alpha_3_code="CZE" numeric_code="203" name="Czech Republic"/>
	<iso_3166_entry alpha_2_code="DK" alpha_3_code="DNK" numeric_code="208" name="Denmark" official_name="Kingdom of Denmark"/>
	<iso_3166_entry alpha_2_code="DJ" alpha_3_code="DJI" numeric_code="262" name="Djibouti" official_name="Republic of Djibouti"/>
	<iso_3166_entry alpha_2_code="DM" alpha_3_code="DMA" numeric_code="212" name="Dominica" official_name="Commonwealth of Dominica"/>
	<iso_3166_entry alpha_2_code="DO" alpha_3_code="DOM" numeric_code="214" name="Dominican Republic"/>
	<iso_3166_entry alpha_2_code="TL" alpha_3_code="TLS" numeric_code="626" name="Timor-Leste" official_name="Democratic Republic of Timor-Leste"/>
	<iso_3166_entry alpha_2_code="EC" alpha_3_code="ECU" numeric_code="218" name="Ecuador" official_name="Republic of Ecuador"/>
	<iso_3166_entry alpha_2_code="EG" alpha_3_code="EGY" numeric_code="818" name="Egypt" official_name="Arab Republic of Egypt"/>
	<iso_3166_entry alpha_2_code="SV" alpha_3_code="SLV" numeric_code="222" name="El Salvador" official_name="Republic of El Salvador"/>
	<iso_3166_entry alpha_2_code="GQ" alpha_3_code="GNQ" numeric_code="226" name="Equatorial Guinea" official_name="Republic of Equatorial Guinea"/>
	<iso_3166_entry alpha_2_code="ER" alpha_3_code="ERI" numeric_code="232" name="Eritrea"/>
	<iso_3166_entry alpha_2_code="EE" alpha_3_code="EST" numeric_code="233" name="Estonia" official_name="Republic of Estonia"/>
	<iso_3166_entry alpha_2_code="ET" alpha_3_code="ETH" numeric_code="231" name="Ethiopia" official_name="Federal Democratic Republic of Ethiopia"/>
	<iso_3166_entry alpha_2_code="FK" alpha_3_code="FLK" numeric_code="238" name="Falkland Islands (Malvinas)"/>
	<iso_3166_entry alpha_2_code="FO" alpha_3_code="FRO" numeric_code="234" name="Faroe Islands"/>
	<iso_3166_entry alpha_2_code="FJ" alpha_3_code="FJI" numeric_code="242" name="Fiji" official_name="Republic of the Fiji Islands"/>
	<iso_3166_entry alpha_2_code="FI" alpha_3_code="FIN" numeric_code="246" name="Finland" official_name="Republic of Finland"/>
	<iso_3166_entry alpha_2_code="FR" alpha_3_code="FRA" numeric_code="250" name="France" official_name="French Republic"/>
	<iso_3166_entry alpha_2_code="GF" alpha_3_code="GUF" numeric_code="254" name="French Guiana"/>
	<iso_3166_entry alpha_2_code="PF" alpha_3_code="PYF" numeric_code="258" name="French Polynesia"/>
	<iso_3166_entry alpha_2_code="TF" alpha_3_code="ATF" numeric_code="260" name="French Southern Territories"/>
	<iso_3166_entry alpha_2_code="GA" alpha_3_code="GAB" numeric_code="266" name="Gabon" official_name="Gabonese Republic"/>
	<iso_3166_entry alpha_2_code="GM" alpha_3_code="GMB" numeric_code="270" name="Gambia" official_name="Republic of the Gambia"/>
	<iso_3166_entry alpha_2_code="GE" alpha_3_code="GEO" numeric_code="268" name="Georgia"/>
	<iso_3166_entry alpha_2_code="DE" alpha_3_code="DEU" numeric_code="276" name="Germany" official_name="Federal Republic of Germany"/>
	<iso_3166_entry alpha_2_code="GH" alpha_3_code="GHA" numeric_code="288" name="Ghana" official_name="Republic of Ghana"/>
	<iso_3166_entry alpha_2_code="GI" alpha_3_code="GIB" numeric_code="292" name="Gibraltar"/>
	<iso_3166_entry alpha_2_code="GR" alpha_3_code="GRC" numeric_code="300" name="Greece" official_name="Hellenic Republic"/>
	<iso_3166_entry alpha_2_code="GL" alpha_3_code="GRL" numeric_code="304" name="Greenland"/>
	<iso_3166_entry alpha_2_code="GD" alpha_3_code="GRD" numeric_code="308" name="Grenada"/>
	<iso_3166_entry alpha_2_code="GP" alpha_3_code="GLP" numeric_code="312" name="Guadeloupe"/>
	<iso_3166_entry alpha_2_code="GU" alpha_3_code="GUM" numeric_code="316" name="Guam"/>
	<iso_3166_entry alpha_2_code="GT" alpha_3_code="GTM" numeric_code="320" name="Guatemala" official_name="Republic of Guatemala"/>
	<iso_3166_entry alpha_2_code="GN" alpha_3_code="GIN" numeric_code="324" name="Guinea" official_name="Republic of Guinea"/>
	<iso_3166_entry alpha_2_code="GW" alpha_3_code="GNB" numeric_code="624" name="Guinea-Bissau" official_name="Republic of Guinea-Bissau"/>
	<iso_3166_entry alpha_2_code="GY" alpha_3_code="GUY" numeric_code="328" name="Guyana" official_name="Republic of Guyana"/>
	<iso_3166_entry alpha_2_code="HT" alpha_3_code="HTI" numeric_code="332" name="Haiti" official_name="Republic of Haiti"/>
	<iso_3166_entry alpha_2_code="HM" alpha_3_code="HMD" numeric_code="334" name="Heard Island and McDonald Islands"/>
	<iso_3166_entry alpha_2_code="VA" alpha_3_code="VAT" numeric_code="336" name="Holy See (Vatican City State)"/>
	<iso_3166_entry alpha_2_code="HN" alpha_3_code="HND" numeric_code="340" name="Honduras" official_name="Republic of Honduras"/>
	<iso_3166_entry alpha_2_code="HK" alpha_3_code="HKG" numeric_code="344" name="Hong Kong" official_name="Hong Kong Special Administrative Region of China"/>
	<iso_3166_entry alpha_2_code="HU" alpha_3_code="HUN" numeric_code="348" name="Hungary" official_name="Republic of Hungary"/>
	<iso_3166_entry alpha_2_code="IS" alpha_3_code="ISL" numeric_code="352" name="Iceland" official_name="Republic of Iceland"/>
	<iso_3166_entry alpha_2_code="IN" alpha_3_code="IND" numeric_code="356" name="India" official_name="Republic of India"/>
	<iso_3166_entry alpha_2_code="ID" alpha_3_code="IDN" numeric_code="360" name="Indonesia" official_name="Republic of Indonesia"/>
	<iso_3166_entry alpha_2_code="IR" alpha_3_code="IRN" numeric_code="364" name="Iran, Islamic Republic of" official_name="Islamic Republic of Iran"/>
	<iso_3166_entry alpha_2_code="IQ" alpha_3_code="IRQ" numeric_code="368" name="Iraq" official_name="Republic of Iraq"/>
	<iso_3166_entry alpha_2_code="IE" alpha_3_code="IRL" numeric_code="372" name="Ireland"/>
		<iso_3166_entry alpha_2_code="IL" alpha_3_code="ISR" numeric_code="376" name="Israel" official_name="State of Israel"/>
	<iso_3166_entry alpha_2_code="IT" alpha_3_code="ITA" numeric_code="380" name="Italy" official_name="Italian Republic"/>
	<iso_3166_entry alpha_2_code="JM" alpha_3_code="JAM" numeric_code="388" name="Jamaica"/>
	<iso_3166_entry alpha_2_code="JP" alpha_3_code="JPN" numeric_code="392" name="Japan"/>
	<iso_3166_entry alpha_2_code="JO" alpha_3_code="JOR" numeric_code="400" name="Jordan" official_name="Hashemite Kingdom of Jordan"/>
	<iso_3166_entry alpha_2_code="KZ" alpha_3_code="KAZ" numeric_code="398" name="Kazakhstan" official_name="Republic of Kazakhstan"/>
	<iso_3166_entry alpha_2_code="KE" alpha_3_code="KEN" numeric_code="404" name="Kenya" official_name="Republic of Kenya"/>
	<iso_3166_entry alpha_2_code="KI" alpha_3_code="KIR" numeric_code="296" name="Kiribati" official_name="Republic of Kiribati"/>
	<iso_3166_entry alpha_2_code="KP" alpha_3_code="PRK" numeric_code="408" name="Korea, Democratic People's Republic of" official_name="Democratic People's Republic of Korea"/>
	<iso_3166_entry alpha_2_code="KR" alpha_3_code="KOR" numeric_code="410" name="Korea, Republic of"/>
	<iso_3166_entry alpha_2_code="KW" alpha_3_code="KWT" numeric_code="414" name="Kuwait" official_name="State of Kuwait"/>
	<iso_3166_entry alpha_2_code="KG" alpha_3_code="KGZ" numeric_code="417" name="Kyrgyzstan" official_name="Kyrgyz Republic"/>
	<iso_3166_entry alpha_2_code="LA" alpha_3_code="LAO" numeric_code="418" name="Lao People's Democratic Republic"/>
	<iso_3166_entry alpha_2_code="LV" alpha_3_code="LVA" numeric_code="428" name="Latvia" official_name="Republic of Latvia"/>
	<iso_3166_entry alpha_2_code="LB" alpha_3_code="LBN" numeric_code="422" name="Lebanon" official_name="Lebanese Republic"/>
	<iso_3166_entry alpha_2_code="LS" alpha_3_code="LSO" numeric_code="426" name="Lesotho" official_name="Kingdom of Lesotho"/>
	<iso_3166_entry alpha_2_code="LR" alpha_3_code="LBR" numeric_code="430" name="Liberia" official_name="Republic of Liberia"/>
	<iso_3166_entry alpha_2_code="LY" alpha_3_code="LBY" numeric_code="434" name="Libyan Arab Jamahiriya" official_name="Socialist People's Libyan Arab Jamahiriya"/>
	<iso_3166_entry alpha_2_code="LI" alpha_3_code="LIE" numeric_code="438" name="Liechtenstein" official_name="Principality of Liechtenstein"/>
	<iso_3166_entry alpha_2_code="LT" alpha_3_code="LTU" numeric_code="440" name="Lithuania" official_name="Republic of Lithuania"/>
	<iso_3166_entry alpha_2_code="LU" alpha_3_code="LUX" numeric_code="442" name="Luxembourg" official_name="Grand Duchy of Luxembourg"/>
	<iso_3166_entry alpha_2_code="MO" alpha_3_code="MAC" numeric_code="446" name="Macao" official_name="Macao Special Administrative Region of China"/>
	<iso_3166_entry alpha_2_code="MK" alpha_3_code="MKD" numeric_code="807" name="Macedonia, Republic of" official_name="The Former Yugoslav Republic of Macedonia"/>
	<iso_3166_entry alpha_2_code="MG" alpha_3_code="MDG" numeric_code="450" name="Madagascar" official_name="Republic of Madagascar"/>
	<iso_3166_entry alpha_2_code="MW" alpha_3_code="MWI" numeric_code="454" name="Malawi" official_name="Republic of Malawi"/>
	<iso_3166_entry alpha_2_code="MY" alpha_3_code="MYS" numeric_code="458" name="Malaysia"/>
	<iso_3166_entry alpha_2_code="MV" alpha_3_code="MDV" numeric_code="462" name="Maldives" official_name="Republic of Maldives"/>
	<iso_3166_entry alpha_2_code="ML" alpha_3_code="MLI" numeric_code="466" name="Mali" official_name="Republic of Mali"/>
	<iso_3166_entry alpha_2_code="MT" alpha_3_code="MLT" numeric_code="470" name="Malta" official_name="Republic of Malta"/>
	<iso_3166_entry alpha_2_code="MH" alpha_3_code="MHL" numeric_code="584" name="Marshall Islands" official_name="Republic of the Marshall Islands"/>
	<iso_3166_entry alpha_2_code="MQ" alpha_3_code="MTQ" numeric_code="474" name="Martinique"/>
	<iso_3166_entry alpha_2_code="MR" alpha_3_code="MRT" numeric_code="478" name="Mauritania" official_name="Islamic Republic of Mauritania"/>
	<iso_3166_entry alpha_2_code="MU" alpha_3_code="MUS" numeric_code="480" name="Mauritius" official_name="Republic of Mauritius"/>
	<iso_3166_entry alpha_2_code="YT" alpha_3_code="MYT" numeric_code="175" name="Mayotte"/>
	<iso_3166_entry alpha_2_code="MX" alpha_3_code="MEX" numeric_code="484" name="Mexico" official_name="United Mexican States"/>
	<iso_3166_entry alpha_2_code="FM" alpha_3_code="FSM" numeric_code="583" name="Micronesia, Federated States of" official_name="Federated States of Micronesia"/>
	<iso_3166_entry alpha_2_code="MD" alpha_3_code="MDA" numeric_code="498" name="Moldova, Republic of" official_name="Republic of Moldova"/>
	<iso_3166_entry alpha_2_code="MC" alpha_3_code="MCO" numeric_code="492" name="Monaco" official_name="Principality of Monaco"/>
	<iso_3166_entry alpha_2_code="MN" alpha_3_code="MNG" numeric_code="496" name="Mongolia"/>
	<iso_3166_entry alpha_2_code="MS" alpha_3_code="MSR" numeric_code="500" name="Montserrat"/>
	<iso_3166_entry alpha_2_code="MA" alpha_3_code="MAR" numeric_code="504" name="Morocco" official_name="Kingdom of Morocco"/>
	<iso_3166_entry alpha_2_code="MZ" alpha_3_code="MOZ" numeric_code="508" name="Mozambique" official_name="Republic of Mozambique"/>
	<iso_3166_entry alpha_2_code="MM" alpha_3_code="MMR" numeric_code="104" name="Myanmar" official_name="Union of Myanmar"/>
	<iso_3166_entry alpha_2_code="NA" alpha_3_code="NAM" numeric_code="516" name="Namibia" official_name="Republic of Namibia"/>
	<iso_3166_entry alpha_2_code="NR" alpha_3_code="NRU" numeric_code="520" name="Nauru" official_name="Republic of Nauru"/>
	<iso_3166_entry alpha_2_code="NP" alpha_3_code="NPL" numeric_code="524" name="Nepal" official_name="Kingdom of Nepal"/>
	<iso_3166_entry alpha_2_code="NL" alpha_3_code="NLD" numeric_code="528" name="Netherlands" official_name="Kingdom of the Netherlands"/>
	<iso_3166_entry alpha_2_code="AN" alpha_3_code="ANT" numeric_code="530" name="Netherlands Antilles"/>
	<iso_3166_entry alpha_2_code="NC" alpha_3_code="NCL" numeric_code="540" name="New Caledonia"/>
	<iso_3166_entry alpha_2_code="NZ" alpha_3_code="NZL" numeric_code="554" name="New Zealand"/>
	<iso_3166_entry alpha_2_code="NI" alpha_3_code="NIC" numeric_code="558" name="Nicaragua" official_name="Republic of Nicaragua"/>
	<iso_3166_entry alpha_2_code="NE" alpha_3_code="NER" numeric_code="562" name="Niger" official_name="Republic of the Niger"/>
	<iso_3166_entry alpha_2_code="NG" alpha_3_code="NGA" numeric_code="566" name="Nigeria" official_name="Federal Republic of Nigeria"/>
	<iso_3166_entry alpha_2_code="NU" alpha_3_code="NIU" numeric_code="570" name="Niue" official_name="Republic of Niue"/>
	<iso_3166_entry alpha_2_code="NF" alpha_3_code="NFK" numeric_code="574" name="Norfolk Island"/>
	<iso_3166_entry alpha_2_code="MP" alpha_3_code="MNP" numeric_code="580" name="Northern Mariana Islands" official_name="Commonwealth of the Northern Mariana Islands"/>
	<iso_3166_entry alpha_2_code="NO" alpha_3_code="NOR" numeric_code="578" name="Norway" official_name="Kingdom of Norway"/>
	<iso_3166_entry alpha_2_code="OM" alpha_3_code="OMN" numeric_code="512" name="Oman" official_name="Sultanate of Oman"/>
	<iso_3166_entry alpha_2_code="PK" alpha_3_code="PAK" numeric_code="586" name="Pakistan" official_name="Islamic Republic of Pakistan"/>
	<iso_3166_entry alpha_2_code="PW" alpha_3_code="PLW" numeric_code="585" name="Palau" official_name="Republic of Palau"/>
	<iso_3166_entry alpha_2_code="PS" alpha_3_code="PSE" numeric_code="275" name="Palestinian Territory, Occupied" official_name="Occupied Palestinian Territory"/>
	<iso_3166_entry alpha_2_code="PA" alpha_3_code="PAN" numeric_code="591" name="Panama" official_name="Republic of Panama"/>
	<iso_3166_entry alpha_2_code="PG" alpha_3_code="PNG" numeric_code="598" name="Papua New Guinea"/>
	<iso_3166_entry alpha_2_code="PY" alpha_3_code="PRY" numeric_code="600" name="Paraguay" official_name="Republic of Paraguay"/>
	<iso_3166_entry alpha_2_code="PE" alpha_3_code="PER" numeric_code="604" name="Peru" official_name="Republic of Peru"/>
	<iso_3166_entry alpha_2_code="PH" alpha_3_code="PHL" numeric_code="608" name="Philippines" official_name="Republic of the Philippines"/>
	<iso_3166_entry alpha_2_code="PN" alpha_3_code="PCN" numeric_code="612" name="Pitcairn"/>
	<iso_3166_entry alpha_2_code="PL" alpha_3_code="POL" numeric_code="616" name="Poland" official_name="Republic of Poland"/>
	<iso_3166_entry alpha_2_code="PT" alpha_3_code="PRT" numeric_code="620" name="Portugal" official_name="Portuguese Republic"/>
	<iso_3166_entry alpha_2_code="PR" alpha_3_code="PRI" numeric_code="630" name="Puerto Rico"/>
	<iso_3166_entry alpha_2_code="QA" alpha_3_code="QAT" numeric_code="634" name="Qatar" official_name="State of Qatar"/>
	<iso_3166_entry alpha_2_code="RE" alpha_3_code="REU" numeric_code="638" name="Reunion"/>
	<iso_3166_entry alpha_2_code="RO" alpha_3_code="ROU" numeric_code="642" name="Romania"/>
	<iso_3166_entry alpha_2_code="RU" alpha_3_code="RUS" numeric_code="643" name="Russian Federation"/>
	<iso_3166_entry alpha_2_code="RW" alpha_3_code="RWA" numeric_code="646" name="Rwanda" official_name="Rwandese Republic"/>
	<iso_3166_entry alpha_2_code="SH" alpha_3_code="SHN" numeric_code="654" name="Saint Helena"/>
	<iso_3166_entry alpha_2_code="KN" alpha_3_code="KNA" numeric_code="659" name="Saint Kitts and Nevis"/>
	<iso_3166_entry alpha_2_code="LC" alpha_3_code="LCA" numeric_code="662" name="Saint Lucia"/>
	<iso_3166_entry alpha_2_code="PM" alpha_3_code="SPM" numeric_code="666" name="Saint Pierre and Miquelon"/>
	<iso_3166_entry alpha_2_code="VC" alpha_3_code="VCT" numeric_code="670" name="Saint Vincent and the Grenadines"/>
	<iso_3166_entry alpha_2_code="WS" alpha_3_code="WSM" numeric_code="882" name="Samoa" official_name="Independent State of Samoa"/>
	<iso_3166_entry alpha_2_code="SM" alpha_3_code="SMR" numeric_code="674" name="San Marino" official_name="Republic of San Marino"/>
	<iso_3166_entry alpha_2_code="ST" alpha_3_code="STP" numeric_code="678" name="Sao Tome and Principe" official_name="Democratic Republic of Sao Tome and Principe"/>
	<iso_3166_entry alpha_2_code="SA" alpha_3_code="SAU" numeric_code="682" name="Saudi Arabia" official_name="Kingdom of Saudi Arabia"/>
	<iso_3166_entry alpha_2_code="SN" alpha_3_code="SEN" numeric_code="686" name="Senegal" official_name="Republic of Senegal"/>
	<iso_3166_entry alpha_2_code="SC" alpha_3_code="SYC" numeric_code="690" name="Seychelles" official_name="Republic of Seychelles"/>
	<iso_3166_entry alpha_2_code="SL" alpha_3_code="SLE" numeric_code="694" name="Sierra Leone" official_name="Republic of Sierra Leone"/>
	<iso_3166_entry alpha_2_code="SG" alpha_3_code="SGP" numeric_code="702" name="Singapore" official_name="Republic of Singapore"/>
	<iso_3166_entry alpha_2_code="SK" alpha_3_code="SVK" numeric_code="703" name="Slovakia" official_name="Slovak Republic"/>
	<iso_3166_entry alpha_2_code="SI" alpha_3_code="SVN" numeric_code="705" name="Slovenia" official_name="Republic of Slovenia"/>
	<iso_3166_entry alpha_2_code="SB" alpha_3_code="SLB" numeric_code="090" name="Solomon Islands"/>
	<iso_3166_entry alpha_2_code="SO" alpha_3_code="SOM" numeric_code="706" name="Somalia" official_name="Somali Republic"/>
	<iso_3166_entry alpha_2_code="ZA" alpha_3_code="ZAF" numeric_code="710" name="South Africa" official_name="Republic of South Africa"/>
	<iso_3166_entry alpha_2_code="GS" alpha_3_code="SGS" numeric_code="239" name="South Georgia and the South Sandwich Islands"/>
	<iso_3166_entry alpha_2_code="ES" alpha_3_code="ESP" numeric_code="724" name="Spain" official_name="Kingdom of Spain"/>
	<iso_3166_entry alpha_2_code="LK" alpha_3_code="LKA" numeric_code="144" name="Sri Lanka" official_name="Democratic Socialist Republic of Sri Lanka"/>
	<iso_3166_entry alpha_2_code="SD" alpha_3_code="SDN" numeric_code="736" name="Sudan" official_name="Republic of the Sudan"/>
	<iso_3166_entry alpha_2_code="SR" alpha_3_code="SUR" numeric_code="740" name="Suriname" official_name="Republic of Suriname"/>
	<iso_3166_entry alpha_2_code="SJ" alpha_3_code="SJM" numeric_code="744" name="Svalbard and Jan Mayen"/>
	<iso_3166_entry alpha_2_code="SZ" alpha_3_code="SWZ" numeric_code="748" name="Swaziland" official_name="Kingdom of Swaziland"/>
	<iso_3166_entry alpha_2_code="SE" alpha_3_code="SWE" numeric_code="752" name="Sweden" official_name="Kingdom of Sweden"/>
	<iso_3166_entry alpha_2_code="CH" alpha_3_code="CHE" numeric_code="756" name="Switzerland" official_name="Swiss Confederation"/>
	<iso_3166_entry alpha_2_code="SY" alpha_3_code="SYR" numeric_code="760" name="Syrian Arab Republic"/>
	<iso_3166_entry alpha_2_code="TW" alpha_3_code="TWN" numeric_code="158" common_name="Taiwan" name="Taiwan, Province of China" official_name="Taiwan, Province of China"/>
	<iso_3166_entry alpha_2_code="TJ" alpha_3_code="TJK" numeric_code="762" name="Tajikistan" official_name="Republic of Tajikistan"/>
	<iso_3166_entry alpha_2_code="TZ" alpha_3_code="TZA" numeric_code="834" name="Tanzania, United Republic of" official_name="United Republic of Tanzania"/>
	<iso_3166_entry alpha_2_code="TH" alpha_3_code="THA" numeric_code="764" name="Thailand" official_name="Kingdom of Thailand"/>
	<iso_3166_entry alpha_2_code="TG" alpha_3_code="TGO" numeric_code="768" name="Togo" official_name="Togolese Republic"/>
	<iso_3166_entry alpha_2_code="TK" alpha_3_code="TKL" numeric_code="772" name="Tokelau"/>
	<iso_3166_entry alpha_2_code="TO" alpha_3_code="TON" numeric_code="776" name="Tonga" official_name="Kingdom of Tonga"/>
	<iso_3166_entry alpha_2_code="TT" alpha_3_code="TTO" numeric_code="780" name="Trinidad and Tobago" official_name="Republic of Trinidad and Tobago"/>
	<iso_3166_entry alpha_2_code="TN" alpha_3_code="TUN" numeric_code="788" name="Tunisia" official_name="Republic of Tunisia"/>
	<iso_3166_entry alpha_2_code="TR" alpha_3_code="TUR" numeric_code="792" name="Turkey" official_name="Republic of Turkey"/>
	<iso_3166_entry alpha_2_code="TM" alpha_3_code="TKM" numeric_code="795" name="Turkmenistan"/>
	<iso_3166_entry alpha_2_code="TC" alpha_3_code="TCA" numeric_code="796" name="Turks and Caicos Islands"/>
	<iso_3166_entry alpha_2_code="TV" alpha_3_code="TUV" numeric_code="798" name="Tuvalu"/>
	<iso_3166_entry alpha_2_code="UG" alpha_3_code="UGA" numeric_code="800" name="Uganda" official_name="Republic of Uganda"/>
	<iso_3166_entry alpha_2_code="UA" alpha_3_code="UKR" numeric_code="804" name="Ukraine"/>
	<iso_3166_entry alpha_2_code="AE" alpha_3_code="ARE" numeric_code="784" name="United Arab Emirates"/>
	<iso_3166_entry alpha_2_code="GB" alpha_3_code="GBR" numeric_code="826" name="United Kingdom" official_name="United Kingdom of Great Britain and Northern Ireland"/>
	<iso_3166_entry alpha_2_code="US" alpha_3_code="USA" numeric_code="840" name="United States" official_name="United States of America"/>
	<iso_3166_entry alpha_2_code="UM" alpha_3_code="UMI" numeric_code="581" name="United States Minor Outlying Islands"/>
	<iso_3166_entry alpha_2_code="UY" alpha_3_code="URY" numeric_code="858" name="Uruguay" official_name="Eastern Republic of Uruguay"/>
	<iso_3166_entry alpha_2_code="UZ" alpha_3_code="UZB" numeric_code="860" name="Uzbekistan" official_name="Republic of Uzbekistan"/>
	<iso_3166_entry alpha_2_code="VU" alpha_3_code="VUT" numeric_code="548" name="Vanuatu" official_name="Republic of Vanuatu"/>
	<iso_3166_entry alpha_2_code="VE" alpha_3_code="VEN" numeric_code="862" name="Venezuela" official_name="Bolivarian Republic of Venezuela"/>
	<iso_3166_entry alpha_2_code="VN" alpha_3_code="VNM" numeric_code="704" name="Viet Nam" official_name="Socialist Republic of Viet Nam"/>
	<!-- FIXME CHECK OFFICIAL NAME -->
	<iso_3166_entry alpha_2_code="VG" alpha_3_code="VGB" numeric_code="092" name="Virgin Islands, British" official_name="British Virgin Islands"/>
	<iso_3166_entry alpha_2_code="VI" alpha_3_code="VIR" numeric_code="850" name="Virgin Islands, U.S." official_name="Virgin Islands of the United States"/>
	<iso_3166_entry alpha_2_code="WF" alpha_3_code="WLF" numeric_code="876" name="Wallis and Futuna"/>
	<iso_3166_entry alpha_2_code="EH" alpha_3_code="ESH" numeric_code="732" name="Western Sahara"/>
	<iso_3166_entry alpha_2_code="YE" alpha_3_code="YEM" numeric_code="887" name="Yemen" official_name="Republic of Yemen"/>
	<iso_3166_entry alpha_2_code="ZM" alpha_3_code="ZMB" numeric_code="894" name="Zambia" official_name="Republic of Zambia"/>
	<iso_3166_entry alpha_2_code="ZW" alpha_3_code="ZWE" numeric_code="716" name="Zimbabwe" official_name="Republic of Zimbabwe"/>
	<iso_3166_entry alpha_2_code="CS" alpha_3_code="SCG" numeric_code="891" name="Serbia and Montenegro"/>
	<iso_3166_3_entry alpha_4_code="BQAQ" alpha_3_code="ATB" numeric_code="1979" names="British Antarctic Territory"/>
	<iso_3166_3_entry alpha_4_code="BUMM" alpha_3_code="BUR" numeric_code="104" date_withdrawn="1989-12-05" names="Burma, Socialist Republic of the Union of"/>
	<iso_3166_3_entry alpha_4_code="BYAA" alpha_3_code="BYS" numeric_code="112" date_withdrawn="1992-06-15" names="Byelorussian SSR Soviet Socialist Republic"/>
	<iso_3166_3_entry alpha_4_code="CTKI" alpha_3_code="CTE" numeric_code="128" date_withdrawn="1984" names="Canton &amp; Enderbury Islands"/>
	<iso_3166_3_entry alpha_4_code="CSHH" alpha_3_code="CSK" numeric_code="200" date_withdrawn="1993-06-15" names="Czechoslovakia, Czechoslovak Socialist Republic"/>
	<iso_3166_3_entry alpha_4_code="DYBJ" alpha_3_code="DHY" numeric_code="204" date_withdrawn="1977" names="Dahomey"/>
	<iso_3166_3_entry alpha_4_code="NQAQ" alpha_3_code="ATN" numeric_code="216" date_withdrawn="1983" names="Dronning Maud Land"/>
	<iso_3166_3_entry alpha_4_code="TPTL" alpha_3_code="TMP" numeric_code="626" date_withdrawn="2002-05-20" names="East Timor" comment="was Portuguese Timor"/>
	<iso_3166_3_entry alpha_4_code="ET" alpha_3_code="ETH" numeric_code="230" date_withdrawn="1993-07-16" names="Ethiopia"/>
	<iso_3166_3_entry alpha_4_code="FXFR" alpha_3_code="FXX" numeric_code="249" date_withdrawn="1997-07-14" names="France, Metropolitan"/>
	<iso_3166_3_entry alpha_4_code="AIDJ" alpha_3_code="AFI" numeric_code="262" date_withdrawn="1977" names="French Afars and Issas"/>
	<iso_3166_3_entry alpha_4_code="FQHH" alpha_3_code="ATF" date_withdrawn="1979" names="French Southern and Antarctic Territories" comment="now split between AQ and TF"/>
	<iso_3166_3_entry alpha_4_code="DDDE" alpha_3_code="DDR" numeric_code="278" date_withdrawn="1990-10-30" names="German Democratic Republic"/>
	<iso_3166_3_entry alpha_4_code="DE" alpha_3_code="DEU" numeric_code="280" date_withdrawn="1990-10-30" names="Germany, Federal Republic of"/>
	<iso_3166_3_entry alpha_4_code="GEHH" alpha_3_code="GEL" numeric_code="296" date_withdrawn="1979" names="Gilbert &amp; Ellice Islands" comment="now split into Kiribati and Tuvalu"/>
	<iso_3166_3_entry alpha_4_code="JTUM" alpha_3_code="JTN" numeric_code="396" date_withdrawn="1986" names="Johnston Island"/>
	<iso_3166_3_entry alpha_4_code="MIUM" alpha_3_code="MID" numeric_code="488" date_withdrawn="1986" names="Midway Islands"/>
	<iso_3166_3_entry alpha_4_code="AN" alpha_3_code="ANT" numeric_code="532" date_withdrawn="1993-07-12" names="Netherlands Antilles"/>
	<iso_3166_3_entry alpha_4_code="NTHH" alpha_3_code="NTZ" numeric_code="536" date_withdrawn="1993-07-12" names="Neutral Zone" comment="formerly between Saudi Arabia &amp; Iraq"/>
	<iso_3166_3_entry alpha_4_code="NHVU" alpha_3_code="NHB" numeric_code="548" date_withdrawn="1980" names="New Hebrides"/>
	<iso_3166_3_entry alpha_4_code="PCHH" alpha_3_code="PCI" numeric_code="582" date_withdrawn="1986" names="Pacific Islands (trust territory)" comment="divided into FM, MH, MP, and PW"/>
	<iso_3166_3_entry alpha_4_code="PA" alpha_3_code="PAN" numeric_code="590" date_withdrawn="1993-07-22" names="Panama, Republic of"/>
	<iso_3166_3_entry alpha_4_code="PZPA" alpha_3_code="PCZ" date_withdrawn="1980" names="Panama Canal Zone"/>
	<iso_3166_3_entry alpha_4_code="RO" alpha_3_code="ROM" numeric_code="642" date_withdrawn="2002-02-01" names="Romania, Socialist Republic of"/>
	<iso_3166_3_entry alpha_4_code="KN" alpha_3_code="KNA" numeric_code="658" date_withdrawn="1988" names="St. Kitts-Nevis-Anguilla" comment="now St. Kitts and Nevis and Anguilla"/>
	<iso_3166_3_entry alpha_4_code="SKIN" alpha_3_code="SKM" date_withdrawn="1975" names="Sikkim"/>
	<iso_3166_3_entry alpha_4_code="RHZW" alpha_3_code="RHO" numeric_code="716" date_withdrawn="1980" names="Southern Rhodesia"/>
	<iso_3166_3_entry alpha_4_code="EH" alpha_3_code="ESH" numeric_code="732" date_withdrawn="1988" names="Spanish Sahara" comment="now Western Sahara"/>
	<iso_3166_3_entry alpha_4_code="PUUM" alpha_3_code="PUS" numeric_code="849" date_withdrawn="1986" names="US Miscellaneous Pacific Islands"/>
	<iso_3166_3_entry alpha_4_code="SUHH" alpha_3_code="SUN" numeric_code="810" date_withdrawn="1992-08-30" names="USSR, Union of Soviet Socialist Republics"/>
	<iso_3166_3_entry alpha_4_code="HVBF" alpha_3_code="HVO" numeric_code="854" date_withdrawn="1984" names="Upper Volta, Republic of"/>
	<iso_3166_3_entry alpha_4_code="VA" alpha_3_code="VAT" numeric_code="336" date_withdrawn="1996-04-03" names="Vatican City State (Holy See)"/>
	<iso_3166_3_entry alpha_4_code="VDVN" alpha_3_code="VDR" date_withdrawn="1977" names="Viet-Nam, Democratic Republic of"/>
	<iso_3166_3_entry alpha_4_code="WKUM" alpha_3_code="WAK" numeric_code="872" date_withdrawn="1986" names="Wake Island"/>
	<iso_3166_3_entry alpha_4_code="YDYE" alpha_3_code="YMD" numeric_code="720" date_withdrawn="1990-08-14" names="Yemen, Democratic, People's Democratic Republic of"/>
	<iso_3166_3_entry alpha_4_code="YE" alpha_3_code="YEM" numeric_code="891" date_withdrawn="1990-08-14" names="Yemen, Yemen Arab Republic"/>
	<iso_3166_3_entry alpha_4_code="YUCS" alpha_3_code="YUG" numeric_code="891" date_withdrawn="1993-07-28" names="Yugoslavia, Socialist Federal Republic of"/>
	<iso_3166_3_entry alpha_4_code="ZRCD" alpha_3_code="ZAR" numeric_code="180" date_withdrawn="1997-07-14" names="Zaire, Republic of"/>
</iso_3166_entries>
  </xsl:variable>
</xsl:stylesheet>
