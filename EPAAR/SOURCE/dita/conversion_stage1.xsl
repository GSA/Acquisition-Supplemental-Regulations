<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	xmlns:tce="http://www.thecontentera.com/" 	xmlns:xs="http://www.w3.org/2001/XMLSchema" 	xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" 	exclude-result-prefixes="tce xs ditaarch">
	<xsl:output method="xml" indent="yes" />
	<xsl:param name="p-limit">9999</xsl:param>

	<xsl:function name="tce:isItalicNumeric" as="xs:boolean">
		<xsl:param name="item"/>
		
		<xsl:variable name="item-text"><xsl:value-of select="$item/text()"/></xsl:variable>
		<xsl:variable name="item-text-full"><xsl:value-of select="$item//text()"/></xsl:variable>
		<xsl:variable name="true">
			<xsl:choose>
				<xsl:when test="matches(replace(normalize-space($item-text-full), '^[\- ]+', ''), '^\([0-9]+\)') and starts-with(replace(normalize-space($item-text), '^[\- ]+', ''), '()')">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:sequence select="$true"/>
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

		<xsl:choose>
			<xsl:when test="exists($item/@start)">
				<xsl:sequence select="$item/@start"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
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
		<!--<xsl:variable name="item-text-tmp"><xsl:value-of select="$item/text()"/></xsl:variable>-->
		<!--<xsl:variable name="item-text" select="replace(normalize-space($item-text-tmp), '^[- ]+', '')"/>-->
		<xsl:variable name="item-text" select="tce:getParaText($item)"/>
		<xsl:variable name="start-list" select="tce:isStartList($item)"/>
		<xsl:variable name="prev" select="$item/preceding-sibling::P[1]"/>
		<!--<xsl:variable name="tmp-text"><xsl:value-of select="$prev/text()"/></xsl:variable><xsl:variable name="prev-text"><xsl:value-of select="replace(normalize-space($tmp-text), '^[- ]+', '')"/></xsl:variable>-->
		<xsl:variable name="prev-text" select="tce:getParaText($prev)"/>
		<!-- 
		1 - (a)
		2 - (i)
		3 - (1)
		4 - (A)
		-->
		<xsl:variable name="para-type">
			<xsl:choose>
				<xsl:when test="matches($item-text, '^\([ivx]+\)')">
					<xsl:value-of select="2"/>
				</xsl:when>
				<!--				<xsl:when test="matches($item-text, '^\([a-z]\)')">
					<xsl:value-of select="1"/>
				</xsl:when>
-->				<xsl:when test="matches($item-text, '^\([A-Z]+\)')">
					<xsl:value-of select="4"/>
				</xsl:when>
				<xsl:when test="matches($item-text, '^\([0-9]+\)')">
					<xsl:value-of select="3"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="-1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="$para-type = 2 and $start-list and tce:isRunin($prev)">
					<xsl:value-of select="tce:getListLevel($prev) + 2"/>
				</xsl:when>
				<!-- exception for unordered p in 49.603-4 -->
				<xsl:when test="$para-type = 2 and $start-list and tce:getListLevel($prev) = 0 and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\(4\)') ">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]) + 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 2 and $start-list">
					<xsl:value-of select="tce:getListLevel($prev) + 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 2 and matches($prev-text, '^\([ivx]+\)')">
					<xsl:value-of select="tce:getListLevel($prev)"/>
				</xsl:when>
				<xsl:when test="$para-type = 2 and tce:isRunin($prev) and matches($prev-text, '^\(([a-zA-Z]|[0-9]+|[ivx]+)\) ?\(([a-zA-Z]|[0-9]+|[ivx]+)\) ?\(i\)')">
					<xsl:value-of select="tce:getListLevel($prev) + 2"/>
				</xsl:when>
				<xsl:when test="$para-type = 2 and tce:isRunin($prev)">
					<xsl:value-of select="tce:getListLevel($prev) + 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 2 and matches($prev-text, '^\([A-Z]+\)')">
					<xsl:value-of select="tce:getListLevel($prev) - 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 2 and matches($prev-text, '^\([0-9]+\)') and tce:getListLevel($prev) = 5">
					<xsl:value-of select="tce:getListLevel($prev) - 2"/>
				</xsl:when>
				<xsl:when test="$para-type = 2 and matches($prev-text, '^\([0-9]+\)')">
					<xsl:value-of select="tce:getListLevel($prev) - 1"/>
				</xsl:when>
				<xsl:when test="matches($item-text, '^\([a-z]\)')">
					<xsl:value-of select="1"/>
				</xsl:when>
				<!-- exception for broken list number in 19.508 -->
				<xsl:when test="matches($item-text, '^\(a\)\-?\(b\)')">
					<xsl:value-of select="1"/>
				</xsl:when>
				<xsl:when test="$para-type = 4 and tce:isRunin($prev) and matches(tce:getParaText($prev), '^\([a-z0-9]+\) ?\([a-z0-9]+\) ?\([a-z0-9]+\)')">
					<xsl:value-of select="tce:getListLevel($prev) + 3"/>
				</xsl:when>
				<xsl:when test="$para-type = 4 and tce:isRunin($prev) and not(matches(tce:getParaText($prev), '^\([a-zA-Z0-9]+\) ?\([A-Z]\)'))">
					<xsl:value-of select="tce:getListLevel($prev) + 2"/>
				</xsl:when>
				<xsl:when test="$para-type = 4 and $start-list">
					<xsl:value-of select="tce:getListLevel($prev) + 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 4 and matches($prev-text, '^\([A-Z]+\)')">
					<xsl:value-of select="tce:getListLevel($prev)"/>
				</xsl:when>
				<xsl:when test="$para-type = 4 and tce:isRunin($prev)">
					<xsl:value-of select="tce:getListLevel($prev) + 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 4 and matches($prev-text, '^\([0-9]+\)')">
					<xsl:value-of select="tce:getListLevel($prev) - 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 4 and matches($prev-text, '^\([ivx]+\)')">
					<xsl:value-of select="tce:getListLevel($prev) - 2"/>
				</xsl:when>
				<xsl:when test="$para-type = 3 and matches($prev-text, '^\([0-9]+\)') and tce:isItalicNumeric($prev) and not(tce:isItalicNumeric($item))">
					<xsl:value-of select="tce:getListLevel($prev) - 2"/>
				</xsl:when>
				<xsl:when test="$para-type = 3 and matches($prev-text, '^\([0-9]+\)')">
					<xsl:value-of select="tce:getListLevel($prev)"/>
				</xsl:when>
				<!-- exception for broken list number in 19.1307 -->
				<xsl:when test="matches($item-text, '^2\)') and matches($prev-text, '^\([0-9]+\)')">
					<xsl:value-of select="tce:getListLevel($prev)"/>
				</xsl:when>
				<!-- exception for unordered p in 16.601 -->
				<xsl:when test="$item/parent::DIV8[@N='16.601'] and matches($item-text, '^\(1\)') and $item/preceding-sibling::P and tce:getListLevel($prev) = 0 and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\([a-z]+\)')">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]) + 1"/>
				</xsl:when>
				<xsl:when test="$item/parent::DIV8[@N='16.601' or @N='31.205-47'] and matches($item-text, '^\(1\)') and $item/preceding-sibling::P and tce:getListLevel($prev) = 0 and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\([2-9]?\)')">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1])"/>
				</xsl:when>
				<!-- exception for unordered p in 31.205-47, 52.203-12, 52.203-16 -->
				<xsl:when test="$item/ancestor::DIV8[@N = ('31.205-47','52.203-12','52.203-16','52.204-7','52.204-10', '52.204-13', '52.204-16','52.204-17','52.204-18','52.204-20','52.204-23','52.204-25','52.209-7','52.209-10','52.211-5','52.212-3','52.219-1','52.219-8','52.222-11','52.222-18','52.222-26','52.222-27','52.222-48','52.222-50','52.222-52','52.222-54','52.222-55','52.222-62','52.223-11','52.223-13','52.223-16','52.225-3','52.225-5','52.225-11','52.225-18','52.225-20','52.225-21','52.225-23','52.225-25','52.225-26','52.226-6','52.227-11','52.227-13','52.227-14','52.227-20','52.230-6','52.245-1','52.246-3','52.246-6','52.246-8','52.247-68','52.250-3','52.250-4','52.250-5')] and matches($item-text, '^\(1\)') and $item/preceding-sibling::P and tce:getListLevel($prev) = 0 and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\(a\)')">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]) + 1"/>
				</xsl:when>
				<!-- exception for unordered p in 52.203-12 -->
				<xsl:when test="$item/ancestor::DIV8[@N = ('52.203-12','52.203-16','52.204-13','52.204-23','52.204-25','52.219-1','52.219-8','52.222-54','52.223-16','52.225-3','52.225-11','52.225-20','52.225-21','52.225-23','52.225-25','52.226-6','52.230-6','52.245-1')] and matches($item-text, '^\(1\)') and $item/preceding-sibling::P and tce:getListLevel($prev) = 0 and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\([2-9]\)')">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1])"/>
				</xsl:when>
				
				<!-- exception for unordered p in 49.112-1 -->
				<xsl:when test="matches($item-text, '^\(2\)') and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\([a-zA-Z0-9]+\) ?\(1\)') ">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]) + 1"/>
				</xsl:when>
				<!-- exception for unordered p in 49.603-4 -->
				<xsl:when test="matches($item-text, '^\(4\)') and tce:getListLevel($prev) = 0 and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\(3\)') ">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1])"/>
				</xsl:when>
				<!-- exception for unordered p in 31.205-46 -->
				<xsl:when test="matches($item-text, '^\(7\)') and tce:getListLevel($prev) = 0 and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\([ivx]+\)') ">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]) - 1"/>
				</xsl:when>
				<!-- exception for unordered p in 32.410 -->
				<xsl:when test="$item/ancestor::DIV8[@N='32.410'] and matches($item-text, '^\([0-9]+\)') and tce:getListLevel($prev) = 0 and matches(tce:getParaText($item/preceding-sibling::P[tce:getListLevel(.) > 0][1]), '^\([0-9]+\)') ">
					<xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[tce:getListLevel(.) > 0][1])"/>
				</xsl:when>
				
				<!--				<xsl:when test="matches($item-text, '^\([0-9]+\)') and tce:isRunin($prev) and not(matches(tce:getParaText($prev), '^\([a-zA-Z0-9]+\) ?\([0-9]\)'))">
					<xsl:value-of select="tce:getListLevel($prev) + 2"/>
				</xsl:when>
-->
				<xsl:when test="$para-type = 3 and $start-list and tce:isRunin($prev) and not(matches(tce:getParaText($prev), '^\([a-zA-Z0-9]+\) ?\([0-9]\)'))">
					<xsl:value-of select="tce:getListLevel($prev) + 2"/>
				</xsl:when>
				
				<xsl:when test="$para-type = 3 and $start-list">
					<xsl:value-of select="tce:getListLevel($prev) + 1"/>
				</xsl:when>
				<xsl:when test="starts-with($item-text, '(2)') and tce:isRunin($prev) and matches($prev-text,  '^\([a-zA-Z0-9]+\) ?\(1\)') ">
					<xsl:value-of select="tce:getListLevel($prev) + 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 3 and tce:isRunin($prev) and matches($prev-text,  '^\([a-z]\)') ">
					<xsl:value-of select="tce:getListLevel($prev) + 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 3 and matches($prev-text,  '^\([A-Z]\)') and $start-list">
					<xsl:value-of select="tce:getListLevel($prev) + 1"/>
				</xsl:when>
				<xsl:when test="$para-type = 3 and matches($prev-text,  '^\([A-Z]\)')">
					<xsl:value-of select="tce:getListLevel($prev) - 2"/>
				</xsl:when>
				<xsl:when test="$para-type = 3 and matches($prev-text, '^\([ivx]+\)')">
					<xsl:value-of select="tce:getListLevel($prev) - 1"/>
				</xsl:when>
				<!--				<xsl:when test="matches($item-text, '^\([0-9]+\)') and matches($prev-text, '^\([a-z]+\)')"><xsl:value-of select="2"/></xsl:when>-->
				<!--<xsl:when test="matches($item-text, '^\([0-9]+\)')"><xsl:value-of select="1"/></xsl:when>-->
				<xsl:otherwise>
					<xsl:value-of select="0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--<xsl:variable name="level"><xsl:choose><xsl:when test="$start-list and $item/preceding-sibling::P[1]"><xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[1]) + 1"/></xsl:when><xsl:when test="$item/preceding-sibling::P[1]"><xsl:value-of select="tce:getListLevel($item/preceding-sibling::P[1])"/></xsl:when><xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise></xsl:choose></xsl:variable>-->
		<xsl:sequence select="$level"/>
	</xsl:function>
	<xsl:template match="P">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*"/>
			<xsl:if test="count(preceding-sibling::P[not(@level)]) &lt; $p-limit">
				<xsl:attribute name="level" select="tce:getListLevel(.)"/>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="dita  | @* | node() | comment() | processing-instruction()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@* | node() | comment() | processing-instruction()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>