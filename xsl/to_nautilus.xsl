<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:ti="http://chs.harvard.edu/xmlns/cts">
    <xsl:strip-space elements="*"/>

    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="yes">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="/">
        <!--Metadata-->
        <xsl:for-each select="tei:teiCorpus">
            <xsl:variable name="revue" select="@xml:id"/>
            <xsl:result-document href="katabase/data/katabase/__cts__.xml">
                <ti:textgroup xsl:exclude-result-prefixes="tei" projid="frHist:katabase"
                    urn="urn:dts:frHist:katabase">
                    <ti:groupname xml:lang="{@xml:lang}">
                        <xsl:text>Catalogues de vente de manuscrits autographes</xsl:text>
                    </ti:groupname>
                </ti:textgroup>
            </xsl:result-document>

            <xsl:result-document href="katabase/data/katabase/{$revue}/__cts__.xml">
                <ti:work xsl:exclude-result-prefixes="tei" groupUrn="urn:dts:frHist:katabase"
                    urn="urn:dts:frHist:katabase.{$revue}">
                    <ti:title xml:lang="fr"> Revue des autographes </ti:title>
                    <xsl:for-each select="descendant::tei:TEI">
                        <ti:edition revueUrn="urn:dts:frHist:katabase.{$revue}"
                            urn="urn:dts:frHist:katabase.{$revue}.{@xml:id}">
                            <ti:label xml:lang="fr">Catalogue <xsl:value-of select="@xml:id"
                                /></ti:label>
                            <ti:description xml:lang="fr">
                                <xsl:value-of select="descendant::tei:sourceDesc"/>
                            </ti:description>
                        </ti:edition>
                    </xsl:for-each>
                </ti:work>
            </xsl:result-document>

        </xsl:for-each>
        <!--Metadata-->


        <!--Texts-->
        <xsl:for-each select="descendant::tei:TEI">
            <xsl:variable name="revue">
                <xsl:value-of select="ancestor::tei:teiCorpus/@xml:id"/>
            </xsl:variable>
            <xsl:variable name="catalogue">
                <xsl:value-of select="@xml:id"/>
            </xsl:variable>
            <xsl:result-document
                href="katabase/data/katabase/{$revue}/katabase.{$revue}.{$catalogue}.xml">
                <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type">Catalogue</xsl:attribute>
                    <xsl:attribute name="xml:id" select="@xml:id"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <!--Texts-->

    <xsl:template match="tei:samplingDecl">
        <xsl:element name="samplingDecl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:element name="refsDecl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">CTS</xsl:attribute>
            <xsl:element name="cRefPattern" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="name">cRefPattern</xsl:attribute>
                <xsl:attribute name="n">desc</xsl:attribute>
                <xsl:attribute name="matchPattern">(\w+).(\w+)</xsl:attribute>
                <xsl:attribute name="replacementPattern"
                    >#xpath(/tei:TEI/tei:text/tei:body/tei:list/tei:item[@n='$1']/tei:desc[@n='$2'])</xsl:attribute>
                <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">This pointer pattern
                    extracts item and desc.</xsl:element>
                <!--It won't work !-->
            </xsl:element>
            <xsl:element name="cRefPattern" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="name">cRefPattern</xsl:attribute>
                <xsl:attribute name="n">item</xsl:attribute>
                <xsl:attribute name="matchPattern">(\w+)</xsl:attribute>
                <xsl:attribute name="replacementPattern"
                    >#xpath(/tei:TEI/tei:text/tei:body/tei:list/tei:item[@n='$1'])</xsl:attribute>
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



    <xsl:template match="tei:item[not(parent::tei:taxonomy)]">
        <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n" select="@n"/>
            <xsl:if test="@xml:id">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:desc[not(ancestor::tei:taxonomy)]">
        <xsl:element name="desc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="n">
                <xsl:value-of select="count(preceding-sibling::tei:desc) + 1"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
