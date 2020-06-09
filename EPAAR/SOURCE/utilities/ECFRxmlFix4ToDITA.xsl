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
	
</xsl:stylesheet>