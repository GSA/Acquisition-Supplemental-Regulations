<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tce="http://www.thecontentera.com/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
	exclude-result-prefixes="tce xs ditaarch">
	<xsl:output method="xml" indent="yes" />

	<xsl:function name="tce:getParaText" as="xs:string">
		<xsl:param name="item"/>
		<xsl:variable name="tmp-text-nochild">
			<xsl:value-of select="$item/text()"/>
		</xsl:variable>
		<xsl:variable name="tmp-text">
			<!--<xsl:value-of select="$item/text()"/>-->
			<xsl:value-of select="$item/text() | $item/*[not(self::I) or preceding-sibling::I]/text()"/>
		</xsl:variable>
		<xsl:variable name="tmp-text-full">
			<xsl:value-of select="$item//text()"/>
		</xsl:variable>
		<!--<xsl:variable name="item-text"><xsl:choose><xsl:when test="matches(replace(replace(normalize-space($tmp-text), '^[\- ]+', ''), '^(\([a-zA-Z0-9]+\))[\- ]+(\([a-zA-Z0-9]+\))', '$1$2'), '^\([a-zA-Z0-9]+\).*')"><xsl:value-of select="$tmp-text"/></xsl:when><xsl:otherwise><xsl:value-of select="$item//text()"/></xsl:otherwise></xsl:choose></xsl:variable>-->
		<xsl:variable name="item-text">
			<xsl:choose>
				<xsl:when test="matches(replace(replace(normalize-space($tmp-text-nochild), '^[\-_ ]+', ''), '^(\([a-zA-Z0-9]+\))[\- ]*(\([a-zA-Z0-9]+\))[\- ]*(\([a-zA-Z0-9]+\))', '$1$2$3'), '^\([a-zA-Z0-9]+\)\([a-zA-Z0-9]+\)\([a-zA-Z0-9]+\)')">
					<xsl:value-of select="$tmp-text-nochild"/>
				</xsl:when>
				<xsl:when test="matches(replace(replace(normalize-space($tmp-text-full), '^[\-_ ]+', ''), '^(\([a-zA-Z0-9]+\))[\- ]*(\([a-zA-Z0-9]+\))', '$1$2'), '^\([a-zA-Z0-9]+\)\([a-zA-Z0-9]+\)')">
					<xsl:value-of select="$tmp-text-full"/>
				</xsl:when>
				<!-- exception for 28.102-1 -->
				<xsl:when test="matches(replace(normalize-space($tmp-text), '^[\-_ ]+', ''), '^\(([a-zA-Z]|[0-9]+|[ivx]+)\).* - \(1\) .*')">
					<xsl:value-of select="replace(replace(normalize-space($tmp-text), '^[\-_ ]+', ''), '^(\([a-zA-Z0-9]+\)).*( - \(1\)) .*', '$1$2')"/>
				</xsl:when>
				<xsl:when test="matches(replace(replace(normalize-space($tmp-text), '^[\-_ ]+', ''), '^(\([a-zA-Z0-9]+\))[\- ]*(\([a-zA-Z0-9]+\))', '$1$2'), '^\([a-zA-Z0-9]+\).*')">
					<xsl:value-of select="$tmp-text"/>
				</xsl:when>
				<!-- exception for 52.204-4 -->
				<xsl:when test="matches(replace(normalize-space($tmp-text), '^[\-_ ]+', ''), '^[a-zA-Z]+ - \(1\) .*')">
					<xsl:value-of select="replace(replace(normalize-space($tmp-text), '^[\-_ ]+', ''), '^[a-zA-Z]+ - (\(1\)) .*', '$1')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$tmp-text-full"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:sequence select="replace(replace(normalize-space($item-text), '^[\-_ ]+', ''), '^(\([a-zA-Z0-9]+\))[\- ]+(\([a-zA-Z0-9]+\))', '$1$2')"/>
	</xsl:function>

	<xsl:function name="tce:isStartList" as="xs:boolean">
		<xsl:param name="item"/>
		<xsl:variable name="start-text" select="tce:getParaText($item)"/>
		<xsl:variable name="prev" select="$item/preceding-sibling::P[1]"/>
		<xsl:variable name="next" select="$item/following-sibling::P[1]"/>
		<xsl:variable name="start-list">
			<xsl:choose>
				<xsl:when test="starts-with($start-text, '(a)') or starts-with($start-text, '(1)') or starts-with($start-text, '(A)')">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:when test="starts-with($start-text, '(i)') and starts-with(tce:getParaText($next), '(ii)')">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:when test="starts-with($start-text, '(i)') and ends-with(normalize-space(tce:getParaText($prev)), ' -')">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:when test="starts-with($start-text, '(i)') and not($item/preceding-sibling::P[starts-with(tce:getParaText(.), '(h)')])">
					<!-- not(starts-with(tce:getParaText($prev), '(h)')) -->
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:when test="matches($start-text, '^\(i\) ?\([0-9A-Z]\)')">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:sequence select="$start-list"/>
	</xsl:function>

	<xsl:function name="tce:isRunin" as="xs:boolean">
		<xsl:param name="item"/>
		<xsl:variable name="item-text" select="tce:getParaText($item)"/>
		<xsl:variable name="runin">
			<xsl:choose>
				<!-- exception for broken list number in 19.508 -->
				<xsl:when test="starts-with($item-text, '(a)(b)')">
					<xsl:value-of select="false()"/>
				</xsl:when>
				<!-- exception for 28.102-1 -->
				<xsl:when test="matches(normalize-space($item-text), '^\(([a-zA-Z]|[0-9]+|[ivx]+)\).* - \(1\) .*')">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="matches(normalize-space($item-text), '^\(([a-zA-Z]|[0-9]+|[ivx]+)\) ?\(([a-zA-Z]|[0-9]+|[ivx]+)\)')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:sequence select="$runin"/>
	</xsl:function>
	
	<xsl:template match="P"> 
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*"/>
			
			<xsl:attribute name="start" select="tce:isStartList(.)"/>
			<xsl:attribute name="runin" select="tce:isRunin(.)"/>
			<xsl:attribute name="text" select="tce:getParaText(.)"/>

			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="dita  | @* | node() | comment() | processing-instruction()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@* | node() | comment() | processing-instruction()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>