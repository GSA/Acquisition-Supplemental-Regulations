<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	xmlns:tce="http://www.thecontentera.com/" 	xmlns:xs="http://www.w3.org/2001/XMLSchema" 	xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" 	exclude-result-prefixes="tce xs ditaarch">
	<xsl:output method="xml" indent="yes" doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="ditabase.dtd" />
	<xsl:template match="DIV1">
		<xsl:variable name="href" select="concat(@NODE, '.ditamap')"/>
		<mapref navtitle="{HEAD//text()}" href="{$href}">
			<xsl:result-document method="xml" href="{$href}" doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="ditabase.dtd">
				<map>
					<title>
						<xsl:value-of select="HEAD//text()"/>
					</title>
					<xsl:apply-templates select="DIV3"/>
				</map>
			</xsl:result-document>
		</mapref>
	</xsl:template>
	<xsl:template match="DIV3">
		<xsl:variable name="href" select="concat(@NODE, '.dita')"/>
		<topicref navtitle="{HEAD//text()}" href="{$href}" props="{tce:getPropsText(HEAD[1])}" outputclass="Chapter">
			<xsl:result-document method="xml" href="{$href}" doctype-public="-//OASIS//DTD DITA Composite//EN" doctype-system="ditabase.dtd">
				<dita>
					<topic id="{generate-id()}" outputclass="Chapter">
						<xsl:apply-templates select="HEAD"/>
					</topic>
				</dita>
			</xsl:result-document>
			<xsl:apply-templates select="DIV4"/>
		</topicref>
	</xsl:template>
	<xsl:template match="DIV4">
		<xsl:variable name="href" select="concat(@NODE, '.dita')"/>
		<topicref navtitle="{HEAD//text()}" href="{$href}" props="{tce:getPropsText(HEAD[1])}" outputclass="SubChapter">
			<xsl:result-document method="xml" href="{$href}" doctype-public="-//OASIS//DTD DITA Composite//EN" doctype-system="ditabase.dtd">
				<dita>
					<topic id="{generate-id()}" outputclass="SubChapter">
						<xsl:apply-templates select="HEAD"/>
					</topic>
				</dita>
			</xsl:result-document>
			<xsl:apply-templates select="DIV5 | DIV9"/>
		</topicref>
	</xsl:template>
	<xsl:template match="DIV5">
		<xsl:variable name="href" select="concat(@NODE, '.dita')"/>
		<topicref navtitle="{HEAD//text()}" href="{$href}" props="{tce:getPropsText(HEAD[1])}" outputclass="Part">
			<xsl:result-document method="xml" href="{$href}" doctype-public="-//OASIS//DTD DITA Composite//EN" doctype-system="ditabase.dtd">
				<dita>
					<topic id="{generate-id()}" outputclass="Part">
						<xsl:apply-templates select="HEAD"/>
						<xsl:if test="AUTH | SOURCE">
							<body>
								<xsl:apply-templates select="AUTH | SOURCE"/>
							</body>
						</xsl:if>
					</topic>
				</dita>
			</xsl:result-document>
			<xsl:apply-templates select="DIV6 | DIV8"/>
		</topicref>
	</xsl:template>
	<xsl:template match="DIV6">
		<xsl:variable name="href" select="concat(@NODE, '.dita')"/>
		<topicref navtitle="{HEAD//text()}" href="{$href}" props="{tce:getPropsText(HEAD[1])}" outputclass="SubPart">
			<xsl:result-document method="xml" href="{$href}" doctype-public="-//OASIS//DTD DITA Composite//EN" doctype-system="ditabase.dtd">
				<dita>
					<topic id="{generate-id()}" outputclass="SubPart">
						<xsl:apply-templates select="HEAD"/>
						<xsl:if test="AUTH | SOURCE">
							<body>
								<xsl:apply-templates select="AUTH | SOURCE"/>
							</body>
						</xsl:if>
					</topic>
				</dita>
			</xsl:result-document>
			<xsl:apply-templates select="DIV8"/>
		</topicref>
	</xsl:template>
	<xsl:template match="DIV8">
		<xsl:variable name="href" select="concat(@NODE, '.dita')"/>
		<topicref navtitle="{HEAD//text()}" href="{$href}" props="{tce:getPropsText(HEAD[1])}" outputclass="Section">
			<xsl:result-document method="xml" href="{$href}" doctype-public="-//OASIS//DTD DITA Composite//EN" doctype-system="ditabase.dtd">
				<dita>
					<concept id="{generate-id()}" outputclass="Section">
						<xsl:apply-templates select="HEAD"/>
						<xsl:if test="*[not(self::HEAD)]">
							<conbody>
								<xsl:apply-templates select="*[not(self::HEAD) and not(self::EXTRACT) and not(self::TABLE) and not(self::img) and not(self::MATH) and not(self::DIV) and not(self::FP) and not(self::HD3) and not(self::FP-DASH)] "/>
							</conbody>
						</xsl:if>
					</concept>
				</dita>
			</xsl:result-document>
		</topicref>
	</xsl:template>
	<xsl:template match="DIV9">
		<xsl:variable name="href" select="concat(@NODE, '.dita')"/>
		<topicref navtitle="{HEAD//text()}" href="{$href}" props="{tce:getPropsText(HEAD[1])}" outputclass="Appendix">
			<xsl:result-document method="xml" href="{$href}" doctype-public="-//OASIS//DTD DITA Composite//EN" doctype-system="ditabase.dtd">
				<dita>
					<topic id="{generate-id()}" outputclass="Appendix">
						<xsl:apply-templates select="HEAD"/>
						<body>
							<xsl:apply-templates select="*[not(self::HEAD)]"/>
						</body>
					</topic>
				</dita>
			</xsl:result-document>
			<!--<xsl:apply-templates select="DIV6"/>-->
		</topicref>
	</xsl:template>
	<!--<xsl:template match="HEAD[parent::DIV1]"/>-->
	<xsl:template match="HEAD">
		<title class="- topic/title ">
			<xsl:variable name="text-raw">
				<xsl:value-of select="text()"/>
			</xsl:variable>
			<xsl:variable name="text" select="normalize-space($text-raw)"/>
			<xsl:choose>
				<xsl:when test="matches($text, '^\d+.\d+(\-\d+)?')">
					<ph props="autonumber">
						<xsl:value-of select="replace($text, '^(\d+.\d+(\-\d+)?).*', '$1')"/>
					</ph>
					<xsl:value-of select="replace($text, '^\d+.\d+(\-\d+)?', '')"/>
				</xsl:when>
				<xsl:when test="matches(lower-case($text), '^part\s\d+\s', 'i')">
					<ph props="autonumber">
						<xsl:value-of select="replace($text, '^(^part\s\d+).*', '$1', 'i')"/>
					</ph>
					<xsl:value-of select="replace($text, '^part\s\d+', '', 'i')"/>
				</xsl:when>
				<xsl:when test="matches(lower-case($text), '^subpart\s\d+\.\d+\s', 'i')">
					<ph props="autonumber">
						<xsl:value-of select="replace($text, '^(^subpart\s\d+\.\d+).*', '$1', 'i')"/>
					</ph>
					<xsl:value-of select="replace($text, '^subpart\s\d+\.\d+', '', 'i')"/>
				</xsl:when>
				<xsl:when test="matches(lower-case($text), '^subchapter\s[a-z]+\s', 'i')">
					<ph props="autonumber">
						<xsl:value-of select="replace($text, '^(^subchapter\s[a-z]+).*', '$1', 'i')"/>
					</ph>
					<xsl:value-of select="replace($text, '^subchapter\s[a-z]+', '', 'i')"/>
				</xsl:when>
				<xsl:when test="matches(lower-case($text), '^chapter\s\d+\s', 'i')">
					<ph props="autonumber">
						<xsl:value-of select="replace($text, '^(^chapter\s\d+).*', '$1', 'i')"/>
					</ph>
					<xsl:value-of select="replace($text, '^chapter\s\d+', '', 'i')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</title>
	</xsl:template>
	<xsl:template match="AUTH | SOURCE">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="AUTH/HED | SOURCE/HED">
		<ph class="- topic/ph ">
			<xsl:value-of select="text()"/>
			<xsl:text> </xsl:text>
		</ph>
	</xsl:template>
	<xsl:template match="AUTH/PSPACE | SOURCE/PSPACE">
		<xsl:value-of select="text()"/>
	</xsl:template>
	<xsl:template match="DIV">
		<xsl:apply-templates/>
		<xsl:if test="following-sibling::*[1][self::img or self::MATH or (self::DIV and DIV/TABLE)]">
			<xsl:apply-templates select="following-sibling::*[1]"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:function name="tce:getPropsText" as="xs:string">
		<xsl:param name="item"/>
		
		<xsl:variable name="item-text">
			<xsl:value-of select="$item//text()"/>
		</xsl:variable>
		
		<xsl:variable name="text" select="normalize-space($item-text)"/>
		<xsl:variable name="props-text">
			<xsl:choose>
				<xsl:when test="matches($text, '^\d+.\d+(\-\d+)?')">
					<xsl:value-of select="replace($text, '^(\d+.\d+(\-\d+)?).*', '$1')"/>
				</xsl:when>
				<xsl:when test="matches(lower-case($text), '^part\s\d+\s', 'i')">
					<xsl:value-of select="replace($text, '^(^part\s\d+).*', '$1', 'i')"/>
				</xsl:when>
				<xsl:when test="matches(lower-case($text), '^subpart\s\d+\.\d+\s', 'i')">
					<xsl:value-of select="replace($text, '^(^subpart\s\d+\.\d+).*', '$1', 'i')"/>
				</xsl:when>
				<xsl:when test="matches(lower-case($text), '^subchapter\s[a-z]+\s', 'i')">
					<xsl:value-of select="replace($text, '^(^subchapter\s[a-z]+).*', '$1', 'i')"/>
				</xsl:when>
				<xsl:when test="matches(lower-case($text), '^chapter\s\d+\s', 'i')">
					<xsl:value-of select="replace($text, '^(^chapter\s\d+).*', '$1', 'i')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$text"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:sequence select="$props-text"/>
	</xsl:function>

	<xsl:function name="tce:getParaText" as="xs:string">
		<xsl:param name="item"/>
		
		<xsl:choose>
			<xsl:when test="exists($item/@text)">
				<xsl:sequence select="$item/@text"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="tce:isStartList" as="xs:boolean">
		<xsl:param name="item"/>
		
		<xsl:sequence select="$item/@start"/>
	</xsl:function>
	
	<xsl:function name="tce:isRunin" as="xs:boolean">
		<xsl:param name="item"/>
		
		<xsl:choose>
			<xsl:when test="exists($item/@runin)">
				<xsl:sequence select="$item/@runin"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	<xsl:function name="tce:getListLevel" as="xs:integer">
		<xsl:param name="item"/>
		
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="$item">
					<xsl:value-of select="$item/@level"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:sequence select="$level"/>
	</xsl:function>
	<!--	dropping-->
	<xsl:template match="EDNOTE | CFRTOC | SUBJECT | SECTNO | PTHD | PG | XREF | PUBPLACE | PUBLISHER | KEYWORDS | TEXTCLASS | PTHD | PROFILEDESC | FILEDESC"/>

<!--Beginning of Tom's Additions-->

	<!--Pass through text-->
	<xsl:template match="E">
		<xsl:value-of select="text()"/>
	</xsl:template>
	<!--	Mapping range and elements-->
	<xsl:template match="BR">
		<lines/>
	</xsl:template>
	<xsl:template match="B">
		<b>
			<xsl:value-of select="text()"/>
		</b>
	</xsl:template>
	<xsl:template match="I">
		<i>
			<xsl:value-of select="text()"/>
		</i>
	</xsl:template>
	<xsl:template match="sup">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>
	<xsl:template match="SU">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>
	<xsl:template match="STARS">
		<p outputclass="STARS">* * * * *</p>
	</xsl:template>
	<xsl:template match="P-DASH">
		<p outputclass="P-DASH">
			<xsl:value-of select="text()"/> _______________________</p>
	</xsl:template>
	
<!--	<xsl:template match="FRP">
		<p outputclass="FRP">
			<xsl:value-of select="text()"/> -\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-</p>
	</xsl:template>
-->	
	<xsl:template match="NOTE">
		<xsl:choose>
			<xsl:when test="parent::EXTRACT">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<note>
					<xsl:apply-templates/>
				</note>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EFFDNOT">
		<note>
			<xsl:apply-templates/>
		</note>
	</xsl:template>
	
	<xsl:template match="EFFDNOT/HED">
		<p>
			<b>
				<xsl:value-of select="text()"/>
			</b>
		</p>
	</xsl:template>
	
	<xsl:template match="EFFDNOT/PSPACE">
	<p>
		<xsl:value-of select="text()"/>
	</p>
	</xsl:template>
	
	<xsl:template match="NOTE/HED">
		<p>
			<b>
				<xsl:value-of select="text()"/>
			</b>
		</p>
	</xsl:template>
	
	<xsl:template match="FP1-2">
		<p outputclass="FP1-2">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	<xsl:template match="FP-2">
		<p outputclass="FP-2">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="FP-DASH">
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::*[1]/self::FP-DASH) and not(parent::EXTRACT)">
				<note>
					<p outputclass="FP-DASH">
						<xsl:apply-templates/>
					</p>
					<xsl:if test="following-sibling::*[1][self::FP-DASH or self::FP or self::FRP or self::FP-1]">
						<xsl:apply-templates select="following-sibling::*[1]"/>	
					</xsl:if>
				</note>
			</xsl:when>
			<xsl:otherwise>
				<p outputclass="FP-DASH">
					<xsl:apply-templates/>
				</p>
				<xsl:if test="following-sibling::*[1][self::FP-DASH or self::FP or self::FRP or self::FP-1]">
					<xsl:apply-templates select="following-sibling::*[1]"/>	
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="following-sibling::*[1][self::HD3]">
			<xsl:apply-templates select="following-sibling::*[1]"/>	
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="FP[parent::EXTRACT]">
		<xsl:if test="not(preceding-sibling::*) or preceding-sibling::*[1][not(self::FP) and not(self::FP-DASH)]">
		<p outputclass="FP">
			<xsl:apply-templates/>			
		</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="FP[not(parent::EXTRACT)]">
		<note>
		<p outputclass="FP">
			<xsl:apply-templates/>
		</p>
		</note>
	</xsl:template>
	
	<xsl:template match="DIV[@class='table_foot']">
		<fn>
			<xsl:apply-templates/>
		</fn>
	</xsl:template>
	
	<xsl:template match="HD1">
		<xsl:if test="not(preceding-sibling::*) or preceding-sibling::*[1][not(self::P)]">
		<p outputclass="HD1">
			<xsl:apply-templates/>
		</p>
		</xsl:if>
	</xsl:template>
	<xsl:template match="HD2">
		<p outputclass="HD2">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="HD3[parent::EXTRACT]">
		<!--<xsl:if test="not(preceding-sibling::*[1][self::P])">-->
		<p outputclass="HD3">
			<xsl:apply-templates/>
		</p>
		<xsl:if test="following-sibling::*[1][self::DIV and DIV/TABLE]">
			<xsl:apply-templates select="following-sibling::*[1]"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="HD3[not(parent::EXTRACT)]">
		<note>
		<p outputclass="HD3">
			<xsl:apply-templates/>
		</p>
		</note>
	</xsl:template>
	<xsl:template match="SECHD">
		<p outputclass="SECHD">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="FRP">
		<p outputclass="FRP">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="LI">
		<p outputclass="LI">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="FTNT">
		<fn>
			<xsl:apply-templates/>
			<!--<xsl:value-of select="text()"/>-->
		</fn>
	</xsl:template>
	
<!--End of Tom's additions-->
	
	<xsl:template match="FP-1">
		<xsl:if test="not(preceding-sibling::*) or preceding-sibling::*[1][not(self::FP-1)]">
			<xsl:text disable-output-escaping="yes">
				<![CDATA[<ul>]]>
			</xsl:text>
		</xsl:if>
		<li>
			<xsl:apply-templates/>
		</li>
		<xsl:if test="not(following-sibling::*) or following-sibling::*[1][not(self::FP-1)]">
			<xsl:text disable-output-escaping="yes">
				<![CDATA[</ul>]]>
			</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="EXTRACT">
		<note>
			<xsl:if test="child::node()[1][self::FP-DASH or self::FP or self::HD3 or (self::DIV and DIV/TABLE) or self::FP-1 or self::FTNT or self::HD1]">
				<xsl:apply-templates select="child::node()[1]"/>	
			</xsl:if>
			<xsl:apply-templates select="*[not(self::FP-DASH) and not(self::FP) and not(self::HD3) and not(self::DIV and DIV/TABLE) and not(self::FP-1) and not(self::FTNT) and not(self::HD1)]"/>
		</note>
	</xsl:template>
	<xsl:template name="process-para-text">
		<xsl:param name="item"/>
		<xsl:param name="text"/>
		<xsl:variable name="text-full">
			<xsl:value-of select="$item//text()"/>
		</xsl:variable>
		<xsl:variable name="autonumber" select="replace($text-full, '^\s*(\(([a-zA-Z]|[0-9]+|[ivx])+\)).*', '$1', 's')"/>
		<xsl:variable name="para-text" select="replace($text-full, '^\s*(\(([a-zA-Z]|[0-9]+|[ivx])+\))\s*', '')"/>
		<ph props="autonumber">
			<xsl:value-of select="concat($autonumber, ' ')"/>
		</ph>
		<xsl:value-of select="$para-text"/>
	</xsl:template>
	<xsl:template match="P">
		<xsl:param name="level"/>
		<xsl:variable name="text" select="tce:getParaText(.)"/>
		<xsl:variable name="curr-level" select="tce:getListLevel(.)"/>
		<!--<xsl:variable name="next"><xsl:value-of select="following-sibling::P[1]"/></xsl:variable>-->
		<xsl:variable name="next-level">
			<xsl:value-of select="tce:getListLevel(following-sibling::P[1])"/>
		</xsl:variable>
		<!--<xsl:variable name="runin" select="matches(normalize-space($text), '^\([a-z0-9]+\) ?\([a-z0-9]+\)')"/>-->
		<!--<xsl:variable name="prev"><xsl:value-of select="preceding-sibling::P[1]"/></xsl:variable>-->
		<xsl:variable name="prev-level">
			<xsl:value-of select="tce:getListLevel(preceding-sibling::P[1])"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor-or-self::*/preceding-sibling::HD3[starts-with(text()[1],'(End of clause)')] or
				ancestor-or-self::*/preceding-sibling::HD3[starts-with(text()[1],'(End of provision)')] or
				ancestor-or-self::*/preceding-sibling::P/child::node()[1][self::I and starts-with(text()[1],'Alternate I')]">
				<p>
					<xsl:apply-templates/>
				</p>
				<xsl:if test="following-sibling::*[1][self::EXTRACT or self::img or self::MATH or (self::DIV and DIV/TABLE) or self::FP or self::HD3 or self::FP-DASH or self::FTNT]">
					<xsl:apply-templates select="following-sibling::*[1]"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="tce:isStartList(.)">
				<xsl:if test="exists(preceding-sibling::P[1][tce:getListLevel(.) > 0]) and $prev-level = 0">
						<xsl:text disable-output-escaping="yes">
							<![CDATA[</li>]]>
						</xsl:text>
					</xsl:if>
					<xsl:if test="$prev-level = $curr-level">
						<xsl:text disable-output-escaping="yes">
							<![CDATA[</ol>]]>
						</xsl:text>
					</xsl:if>
					<xsl:if test="tce:isRunin(preceding-sibling::P[1])">
						<xsl:text disable-output-escaping="yes">
							<![CDATA[<li>]]>
						</xsl:text>
					</xsl:if>
					<xsl:text disable-output-escaping="yes">
						<![CDATA[<ol>]]>
					</xsl:text>
					<xsl:choose>
						<xsl:when test="tce:isRunin(.)">
							<xsl:text disable-output-escaping="yes">
								<![CDATA[<li props="Runin">]]>
							</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text disable-output-escaping="yes">
								<![CDATA[<li>]]>
							</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<p>
						<!--<xsl:comment>curr: <xsl:value-of select="$curr-level"/>, next: <xsl:value-of select="$next-level"/></xsl:comment>-->
						<!--<xsl:comment>prev-text: <xsl:value-of select="tce:getParaText(preceding-sibling::P[1])"/></xsl:comment>-->
						<!--<xsl:comment>text: <xsl:value-of select="$text"/></xsl:comment>-->
						<!--<xsl:attribute name="start" select="tce:isStartList(.)"/>-->
						<xsl:call-template name="process-para-text">
							<xsl:with-param name="item" select="."/>
						</xsl:call-template>
					</p>
					<xsl:if test="following-sibling::*[1][self::EXTRACT or self::img or self::MATH or (self::DIV and DIV/TABLE) or self::FP or self::HD1 or self::HD3 or self::FP-DASH or self::FTNT]">
						<xsl:apply-templates select="following-sibling::*[1]"/>
					</xsl:if>
				
				
				<xsl:variable name="include-following-p" select="$next-level = 0 and 
					following-sibling::P[tce:getListLevel(.) > 0][1] and 
					not(tce:isStartList(following-sibling::P[tce:getListLevel(.) > 0][1]))"/>
				<xsl:if test="$include-following-p">
					<!--<xsl:comment>COPY P</xsl:comment>-->
					<!--<xsl:variable name="temp" select="following-sibling::P[tce:getListLevel(.) > 0][1]"/>
							<xsl:apply-templates select="following-sibling::P[tce:getListLevel(.) = 0 and . &lt;&lt; $temp]"/>-->
				</xsl:if>
				<xsl:if test="tce:isRunin(.) and matches($text, '^\(([a-zA-Z]|[0-9]+|[ivx]+)\) ?\(([a-zA-Z]|[0-9]+|[ivx]+)\) ?\(([a-zA-Z]|[0-9]+|[ivx]+)\)')">
					<xsl:text disable-output-escaping="yes">
								<![CDATA[<ol><li>]]> <!--RUNM2-->
							</xsl:text>
				</xsl:if>
				
					<xsl:if test="tce:isRunin(.) and $next-level > $curr-level">
						<xsl:text disable-output-escaping="yes">
							<![CDATA[<ol>]]>
						</xsl:text>
					</xsl:if>
					<xsl:if test="$curr-level = $next-level">
						<xsl:text disable-output-escaping="yes">
							<![CDATA[</li>]]>
						</xsl:text>
					</xsl:if>
				<xsl:choose>
					<xsl:when test="$curr-level = 1 and not(following-sibling::P)">
						<xsl:text disable-output-escaping="yes">
							<![CDATA[</li></ol>]]>
						</xsl:text>
					</xsl:when>
					<!-- exception for broken list in 25.504-4 -->
					<xsl:when test="parent::DIV8[@N='25.504-4'] and $curr-level = 1 and not(following-sibling::P[tce:getListLevel(.) > 0])">
						<xsl:text disable-output-escaping="yes">
							<![CDATA[</li></ol>]]>
						</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<!-- matches($text, '^2\).*') and tce:getListLevel(.) > 0 - exception for broken list number in 19.1307
				matches($text, '^(a)-(b).*') and tce:getListLevel(.) > 0 - exception for 19.508
			-->
				<xsl:when test="matches($text, '^\([a-zA-Z0-9]+\).*')
					or (matches($text, '^2\).*') and tce:getListLevel(.) > 0) 
					or (matches($text, '^(a)\-?(b).*') and tce:getListLevel(.) > 0)"> 

					
					<xsl:if test="exists(preceding-sibling::P[tce:getListLevel(.) > 0]) and $prev-level = 0">
						<xsl:text disable-output-escaping="yes">
								<![CDATA[</li>]]><!--ddd-->
						</xsl:text>
						<xsl:variable name="prev-actual" select="preceding-sibling::P[tce:getListLevel(.) > 0][1]"/>
						<xsl:choose>
							<xsl:when test="tce:getListLevel($prev-actual) - 1 = $curr-level and $curr-level = 2">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</ol></li>]]>
								</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
						<!--<xsl:if test="tce:isRunin(.) and exists(preceding-sibling::P[tce:getListLevel(.) = $curr-level][1]) and $curr-level = 1"><xsl:text disable-output-escaping="yes"><![CDATA[www]]></xsl:text></xsl:if>-->
						<!--				<xsl:variable name="parent-runin" select="preceding-sibling::P[tce:getListLevel(.) = $curr-level and tce:isStartList(.)][1]"/><xsl:if test="tce:isRunin(.) and tce:isRunin($parent-runin)"><xsl:text disable-output-escaping="yes"><![CDATA[</ol></li>WWW]]></xsl:text></xsl:if>-->
					<!--<xsl:if test="not(exists(preceding-sibling::P[tce:getListLevel(.) = $curr-level or (tce:isRunin(.) and tce:getListLevel(.) = $curr-level - 1)]))">
						<xsl:text disable-output-escaping="yes">
							<![CDATA[<ol><!-\- OL2 -\->]]>
						</xsl:text>
					</xsl:if>-->
					<xsl:choose>
						<xsl:when test="$curr-level = 1 and not(tce:isStartList(.)) and not(preceding-sibling::P[tce:getListLevel(.) = 1]) and 
							parent::*[self::EXTRACT] and ../preceding-sibling::EXTRACT[P[tce:getListLevel(.) = 1]]">
							<xsl:text disable-output-escaping="yes">
							<![CDATA[<ol>]]>
							</xsl:text>
						</xsl:when>
						<!-- exception for incomplete list in 13.500 only -->
						<xsl:when test="starts-with($text, '(b)') and not(preceding-sibling::P)">
							<xsl:text disable-output-escaping="yes">
							<![CDATA[<ol>]]>
							</xsl:text>
						</xsl:when>
						<!-- exception for incomplete list in 25.504-4 only -->
						<xsl:when test="starts-with($text, '(b)') and not(preceding-sibling::P[starts-with(tce:getParaText(.), '(a)')])">
							<xsl:text disable-output-escaping="yes">
							<![CDATA[<ol>]]>
							</xsl:text>
						</xsl:when>
					</xsl:choose>
					
						<xsl:choose>
							<xsl:when test="tce:isRunin(.)">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[<li props="Runin">]]>
								</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text disable-output-escaping="yes">
									<![CDATA[<li>]]>
								</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<p>
							<!--<xsl:comment>curr: <xsl:value-of select="$curr-level"/>, next: <xsl:value-of select="$next-level"/></xsl:comment>-->
							<!--<xsl:comment>prev-text: <xsl:value-of select="tce:getParaText(preceding-sibling::P[1])"/></xsl:comment>-->
							<!--<xsl:comment>text: <xsl:value-of select="$text"/></xsl:comment>-->
							<!--<xsl:attribute name="start" select="tce:isStartList(.)"/>-->
							<xsl:call-template name="process-para-text">
								<xsl:with-param name="item" select="."/>
							</xsl:call-template>
						</p>
						<xsl:if test="following-sibling::*[1][self::EXTRACT or self::img or self::MATH or (self::DIV and DIV/TABLE ) or self::FP or self::HD1 or self::HD3 or self::FP-DASH or self::FTNT]">
							<xsl:apply-templates select="following-sibling::*[1]"/>
						</xsl:if>
					
						<xsl:variable name="next-actual" select="following-sibling::P[tce:getListLevel(.) > 0][1]"/>
						<xsl:variable name="include-following-p" select="$next-level = 0 and 
									$next-actual and 
									not(tce:isStartList($next-actual))"/>
						<xsl:if test="$include-following-p">
							<!--<xsl:comment>COPY P</xsl:comment>-->
							<!--<xsl:variable name="temp" select="following-sibling::P[tce:getListLevel(.) > 0][1]"/>
							<xsl:apply-templates select="following-sibling::P[tce:getListLevel(.) = 0 and . &lt;&lt; $temp]"/>-->
						</xsl:if>
					
						<xsl:if test="tce:isRunin(.) and matches($text, '^\(([a-zA-Z]|[0-9]+|[ivx]+)\) ?\(([a-zA-Z]|[0-9]+|[ivx]+)\) ?\(([a-zA-Z]|[0-9]+|[ivx]+)\)')">
							<xsl:text disable-output-escaping="yes">
								<![CDATA[<ol><li>]]><!--RUNM-->
							</xsl:text>
						</xsl:if>
						<xsl:if test="tce:isRunin(.) and $next-level > $curr-level">
							<xsl:text disable-output-escaping="yes">
								<![CDATA[<ol>]]>
							</xsl:text>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="$curr-level = $next-level">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 1 and $next-level > 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 1 and $next-level = 0 and $include-following-p">
								<!-- skip -->
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 1 and $next-level = 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 2 and $next-level = 0 and $include-following-p and tce:getListLevel($next-actual) = $curr-level">
								<!-- skip -->
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 2 and $next-level = 0 and tce:getListLevel(preceding-sibling::P[tce:getListLevel(.) &lt; $curr-level][1]) = 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol>]]>
								</xsl:text>
								<!--<xsl:comment>fff</xsl:comment>-->
							</xsl:when>
							
							<xsl:when test="$curr-level = $next-level + 2 and $next-level = 0 and $include-following-p">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 2 and $next-level = 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li></ol>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 2 and $next-level > 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li></ol></li>]]>
								</xsl:text>
							</xsl:when>
							
							<xsl:when test="$curr-level = $next-level + 3 and $next-level > 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li></ol></li></ol></li>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 3 and $next-level = 0 and tce:getListLevel(preceding-sibling::P[tce:getListLevel(.) &lt; $curr-level][1]) = 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li></ol>]]>
								</xsl:text>
							</xsl:when>

							<!--<xsl:when test="$curr-level = $next-level + 3 and $next-level = 0 and $include-following-p and tce:getListLevel($next-actual) + 1 = $curr-level">
								<!-\- skip -\->
							</xsl:when>-->
							
							<xsl:when test="$curr-level = $next-level + 3 and $next-level = 0 and $include-following-p">
								<!-- skip -->
							</xsl:when>
							
							<xsl:when test="$curr-level = $next-level + 3 and $next-level = 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li></ol></li></ol>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 4 and $next-level = 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li></ol></li></ol></li></ol>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 4 and $next-level > 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li></ol></li></ol></li></ol></li>]]>
								</xsl:text>
							</xsl:when>
							<xsl:when test="$curr-level = $next-level + 6 and $next-level = 0">
								<xsl:text disable-output-escaping="yes">
									<![CDATA[</li></ol></li></ol></li></ol></li></ol></li></ol></li></ol>]]>
								</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!--				<xsl:if test="preceding-sibling::P[tce:getListLevel(.) > 0]"><xsl:text disable-output-escaping="yes"><![CDATA[<li>aaa]]></xsl:text></xsl:if>-->
						<p>
							<xsl:apply-templates/>
						</p>
						<xsl:if test="following-sibling::*[1][self::EXTRACT or self::img or self::MATH or (self::DIV and DIV/TABLE) or self::FP or self::HD3 or self::FP-DASH]">
							<xsl:apply-templates select="following-sibling::*[1]"/>
						</xsl:if>
						<!--<xsl:if test="preceding-sibling::P[tce:getListLevel(.) > 0] and tce:getListLevel(following-sibling::P[1]) > 0"><xsl:text disable-output-escaping="yes"><![CDATA[</li>rrr]]></xsl:text></xsl:if>-->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:template>
			<xsl:template match="CITA">
				<msgblock outputclass="CITA" xml:space="preserve" class="+ topic/pre sw-d/msgblock ">
					<xsl:value-of select="text()"/>
				</msgblock>
			</xsl:template>
			<xsl:template match="SECAUTH">
				<msgblock outputclass="SECAUTH" xml:space="preserve" class="+ topic/pre sw-d/msgblock ">
					<xsl:value-of select="text()"/>
				</msgblock>
			</xsl:template>
			<xsl:template match="TH | TD">
				<xsl:variable name="name" select="name()"/>
				<entry colname="{count(preceding-sibling::*[name() = $name]) + 1}">
					<xsl:if test="@align">
						<xsl:attribute name="align">
							<xsl:value-of select="@align" />
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</entry>
			</xsl:template>
			<xsl:template match="TR">
				<row>
					<xsl:apply-templates/>
				</row>
			</xsl:template>
			<xsl:template match="MATH">
				<xsl:apply-templates/>
				<xsl:if test="following-sibling::*[1][self::img or self::MATH or (self::DIV and DIV/TABLE)]">
					<xsl:apply-templates select="following-sibling::*[1]"/>
				</xsl:if>
			</xsl:template>
			<xsl:template match="img">
				<fig frame="all">
					<image href="{replace(@src, '^.*/','')}" placement="inline"/>
				</fig>
				<xsl:if test="following-sibling::*[1][self::img or self::MATH or (self::DIV and DIV/TABLE)]">
					<xsl:apply-templates select="following-sibling::*[1]"/>
				</xsl:if>
			</xsl:template>
			<xsl:template match="DIV[@class='table_head']"/>
			<xsl:template match="TABLE">
				<table>
					<xsl:if test="../preceding-sibling::DIV[@class='table_head']">
						<title>
							<xsl:value-of select="../preceding-sibling::DIV[@class='table_head']//text()"/>
						</title>
					</xsl:if>
					<xsl:variable name="cols" select="count(TR[1]/*)"/>
					<tgroup cols="{$cols}" outputclass="FormatA">
						<xsl:for-each select="1 to $cols">
							<colspec colnum="{current()}" colname="{current()}" colsep="0"/>
						</xsl:for-each>
						<xsl:if test="TR[1][TH]">
							<thead>
								<xsl:apply-templates select="TR[1]"/>
							</thead>
						</xsl:if>
						<tbody>
							<xsl:apply-templates select="TR[TD]"/>
						</tbody>
					</tgroup>
				</table>
				<xsl:apply-templates select="*[not(self::DIV | self::TR | self::TD  | self::TH)]"/>
			</xsl:template>
			<xsl:template match="ECFRBRWS">
				<xsl:apply-templates select="DIV1"/>
			</xsl:template>
			<xsl:template match="HEADER/FILEDESC/TITLESTMT/TITLE">
				<title>
					<xsl:value-of select="text()"/>
				</title>
			</xsl:template>
			<xsl:template match="DLPSTEXTCLASS">
				<map>
					<xsl:apply-templates select="HEADER/FILEDESC/TITLESTMT/TITLE"/>
					<xsl:apply-templates select="TEXT/BODY/ECFRBRWS"/>
				</map>
			</xsl:template>
		</xsl:stylesheet>