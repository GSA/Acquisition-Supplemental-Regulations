<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="xml" doctype-system="C:\GSA-Acquisition-Tools\TOOLS\StructureGSA_FAR\xml\EFC\ECFR.dtd" indent="yes"/>
   
	<xsl:template match="@NODE">
		<xsl:attribute name="NODE">
			<xsl:value-of select="translate(.,':','_')"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@* | node() | comment() | processing-instruction()">
		<xsl:param name="topic-number"></xsl:param>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@* | node() | comment() | processing-instruction()">
				<xsl:with-param name="topic-number" select="$topic-number"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="BODY">
		<xsl:copy>
			<xsl:apply-templates select="ECFRBRWS[position() &lt;= 7]"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="TITLE">
		<xsl:copy>
			<xsl:value-of select="translate(.,':','_')"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="img">
		<xsl:copy>
			<xsl:attribute name="src">
				<xsl:call-template name="getImgSrc">
					<xsl:with-param name="src" select="@src"/>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="getImgSrc">
	  <xsl:param name="src"/>
	  <xsl:choose>
		<xsl:when test="contains($src, '/')">
			<xsl:call-template name="getImgSrc">
				<xsl:with-param name="src">
					<xsl:value-of select="substring-after($src, '/')"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat('./',$src)"/>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
	
		<xsl:template match="TABLE">
		<table>
			<!--<xsl:if test="../preceding-sibling::DIV[@class = 'table_head']">
				<title>
					<xsl:value-of select="../preceding-sibling::DIV[@class = 'table_head']//text()"
					/>
				</title>
			</xsl:if>-->
			<xsl:variable name="cols" select="count(TR[1]/*)"/>
			<tgroup cols="{$cols}" outputclass="FormatA">
				<xsl:for-each select="1 to $cols">
					<colspec colnum="{current()}" colname="{current()}" colsep="0"/>
				</xsl:for-each>
				<xsl:if test="TR[1][TH]">
					<thead>
						<xsl:apply-templates select="TR[1]" mode="make-table"/>
					</thead>
				</xsl:if>
				<tbody>
					<xsl:apply-templates select="TR[TD]" mode="make-table"/>
				</tbody>
			</tgroup>
		</table>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="TH | TD | TR"/>

	<xsl:template match="TH | TD" mode="make-table">
		<xsl:variable name="name" select="name()"/>
		<entry colname="{count(preceding-sibling::*[name() = $name]) + 1}">
			<xsl:if test="@align">
				<xsl:attribute name="align">
					<xsl:value-of select="@align" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="#current"/>
		</entry>
	</xsl:template>
	<xsl:template match="TR" mode="make-table">
		<row>
			<xsl:apply-templates mode="#current"/>
		</row>
	</xsl:template>
	
	
</xsl:stylesheet>