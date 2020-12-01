<?xml version="1.0" encoding="UTF-8"?>
<!--This stylesheet fits the data into nautils compatible data-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:ti="http://chs.harvard.edu/xmlns/cts"
    xmlns:xi="http://www.w3.org/2001/XInclude">
    <xsl:strip-space elements="*"/>

    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="yes">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="tei:TEI[not(@xml:id = 'catalogues')]">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:result-document href="output_xml/{$id}.xml">
            <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="xml:id" select="$id"/>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>


    <xsl:template match="tei:samplingDecl">
        <xsl:element name="samplingDecl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:element name="refsDecl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">CTS</xsl:attribute>
            <xsl:element name="cRefPattern" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="name">cRefPattern</xsl:attribute>
                <xsl:attribute name="n">desc</xsl:attribute>
                <xsl:attribute name="matchPattern">(\w+\.\w+)</xsl:attribute>
                <xsl:attribute name="replacementPattern"
                    >#xpath(/tei:TEI/tei:text/tei:body/tei:list/tei:item/tei:desc[@xml:id='$1'])</xsl:attribute>
                <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">This pointer pattern
                    extracts item and desc.</xsl:element>
                <!--It won't work !-->
            </xsl:element>
            <xsl:element name="cRefPattern" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="name">cRefPattern</xsl:attribute>
                <xsl:attribute name="n">item</xsl:attribute>
                <xsl:attribute name="matchPattern">(\w+)</xsl:attribute>
                <xsl:attribute name="replacementPattern"
                    >#xpath(/tei:TEI/tei:text/tei:body/tei:list/tei:item[@xml:id='$1'])</xsl:attribute>
                <!--There should not be any whitespace in the xpath expressions.-->
                <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">This pointer pattern
                    extracts item.</xsl:element>
            </xsl:element>
        </xsl:element>
        <xsl:element name="refsDecl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="refState" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="unit">item</xsl:attribute>
            </xsl:element>
            <xsl:element name="refState" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="unit">desc</xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>



    <!--TODO: passer des @xml:id aux @n-->

    <xsl:template match="tei:item[not(parent::tei:taxonomy)]">
        <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n" select="@n"/>
            <xsl:attribute name="xml:id">
                <xsl:variable name="tokenized" select="tokenize(@xml:id, '_')"/>
                <xsl:value-of select="$tokenized[3]"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:desc[not(ancestor::tei:taxonomy)]">
        <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id">
                <xsl:variable name="tokenized" select="tokenize(@xml:id, '_')"/>
                <xsl:value-of select="concat($tokenized[3], '.', $tokenized[4])"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
