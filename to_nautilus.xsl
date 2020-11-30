<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:ti="http://chs.harvard.edu/xmlns/cts">
    <xsl:strip-space elements="*"/>

    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="yes">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>



    <!--On veut un truc de la forme: katabase/catalogue.catalogue1.xml, etc-->
    <xsl:template match="/">
        <!--Métadonnées-->
        <xsl:for-each select="tei:teiCorpus">
            <xsl:variable name="teiCorpusid" select="@xml:id"/>
            <xsl:result-document href="katabase/data/katabase/__cts__.xml">
                <ti:textgroup xsl:exclude-result-prefixes="tei" projid="frLit:katabase"
                    urn="urn:dts:frLit:katabase">
                    <ti:groupname xml:lang="{@xml:lang}">
                        <xsl:text>Catalogues de vente de manuscrits autographes</xsl:text>
                    </ti:groupname>
                </ti:textgroup>
            </xsl:result-document>

            <xsl:result-document href="katabase/data/katabase/{$teiCorpusid}/__cts__.xml">
                <ti:work xsl:exclude-result-prefixes="tei" groupUrn="urn:dts:frLit:katabase"
                    urn="urn:dts:frLit:katabase.{$teiCorpusid}">
                    <ti:title xml:lang="fr"> Revue des autographes </ti:title>
                    <xsl:for-each select="descendant::tei:TEI">
                        <ti:edition workUrn="urn:dts:frLit:katabase.{$teiCorpusid}"
                            urn="urn:dts:frLit:katabase.{$teiCorpusid}.{@xml:id}">
                            <ti:label xml:lang="fr">Catalogue <xsl:value-of select="@xml:id"
                                /></ti:label>
                            <ti:description xml:lang="fr">
                                <xsl:value-of select="descendant::tei:witness/text()"/>
                            </ti:description>
                        </ti:edition>
                    </xsl:for-each>
                </ti:work>
            </xsl:result-document>

        </xsl:for-each>
        <!--Métadonnées-->


        <!--Textes-->
        <xsl:for-each select="descendant::tei:TEI">
            <xsl:variable name="work">
                <xsl:value-of select="ancestor::tei:teiCorpus/@xml:id"/>
            </xsl:variable>
            <xsl:variable name="edition">
                <xsl:value-of select="@xml:id"/>
            </xsl:variable>
            <xsl:result-document
                href="katabase/data/katabase/{$work}/katabase.{$work}.{$edition}.xml">
                <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type">Catalogue</xsl:attribute>
                    <xsl:attribute name="xml:id" select="@xml:id"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <!--Textes-->



</xsl:stylesheet>
