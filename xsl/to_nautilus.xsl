<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:ti="http://chs.harvard.edu/xmlns/cts"
    xmlns:cpt="http://purl.org/capitains/ns/1.0#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/">
    <xsl:strip-space elements="*"/>

    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="yes">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="/">
        <!--Metadata-->
        <!--Ici on structure par revue: créer un tei:teiCorpus me semble le plus propre, on aurait donc
        un tei:teiCorpus par revue.-->
        <xsl:for-each select="tei:teiCorpus">
            <xsl:variable name="revue" select="@xml:id"/>
            <xsl:result-document href="data/katabase/__cts__.xml">
                <xsl:element name="ti:textgroup" namespace="http://chs.harvard.edu/xmlns/cts">
                    <!--<xsl:attribute name="projid">frHist:katabase</xsl:attribute>-->
                    <xsl:attribute name="urn">urn:dts:frHist:katabase</xsl:attribute>
                    <xsl:namespace name="dc">http://purl.org/dc/elements/1.1/</xsl:namespace>
                    <xsl:namespace name="dct">http://purl.org/dc/terms/</xsl:namespace>
                    <xsl:namespace name="ti">http://chs.harvard.edu/xmlns/cts</xsl:namespace>
                    <xsl:namespace name="cpt">http://purl.org/capitains/ns/1.0#</xsl:namespace>
                    <xsl:element name="ti:groupname" namespace="http://chs.harvard.edu/xmlns/cts">
                        <xsl:attribute name="xml:lang" select="@xml:lang"/>
                        <xsl:text>Catalogues de vente de manuscrits autographes</xsl:text>
                    </xsl:element>
                    <xsl:element name="ti:work" namespace="http://chs.harvard.edu/xmlns/cts">
                        <xsl:attribute name="groupUrn">urn:dts:frHist:katabase</xsl:attribute>
                        <xsl:attribute name="urn"
                            select="concat('urn:dts:frHist:katabase.', $revue)"/>
                        <xsl:element name="ti:title" namespace="http://chs.harvard.edu/xmlns/cts"
                            >Revue des autographes</xsl:element>
                        <xsl:element name="cpt:structured-metadata"
                            namespace="http://purl.org/capitains/ns/1.0#">
                            <!--Il faudra probablement reprendre le xpath et aller chercher ces infos dans les métadonnées du tei:teiCorpus
                            pour être vraiment propre-->
                            <xsl:element name="dc:creator"
                                namespace="http://purl.org/dc/elements/1.1/">
                                <xsl:value-of select="descendant::tei:TEI[1]//tei:editor"/>
                            </xsl:element>
                            <xsl:element name="dc:title"
                                namespace="http://purl.org/dc/elements/1.1/">
                                <xsl:value-of
                                    select="descendant::tei:TEI[1]//tei:sourceDesc//tei:title"/>
                            </xsl:element>
                            <xsl:element name="dc:language"
                                namespace="http://purl.org/dc/elements/1.1/">French</xsl:element>
                            <xsl:comment>On attend ici les dates de vie de la revue.</xsl:comment>
                            <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
                                <xsl:value-of select="//tei:TBC"/>
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="//tei:TBC"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:result-document>

            <xsl:result-document href="data/katabase/{$revue}/__cts__.xml">
                <xsl:element name="ti:work" namespace="http://chs.harvard.edu/xmlns/cts">
                    <xsl:attribute name="groupUrn">urn:dts:frHist:katabase</xsl:attribute>
                    <xsl:attribute name="urn" select="concat('urn:dts:frHist:katabase.', $revue)"/>
                    <xsl:namespace name="dc">http://purl.org/dc/elements/1.1/</xsl:namespace>
                    <xsl:namespace name="dct">http://purl.org/dc/terms/</xsl:namespace>
                    <xsl:namespace name="ti">http://chs.harvard.edu/xmlns/cts</xsl:namespace>
                    <xsl:namespace name="cpt">http://purl.org/capitains/ns/1.0#</xsl:namespace>
                    <xsl:element name="ti:title" namespace="http://chs.harvard.edu/xmlns/cts">
                        <xsl:attribute name=" xml:lang">fr</xsl:attribute>
                        <xsl:text>Revue des
                        autographes</xsl:text>
                    </xsl:element>
                    <xsl:for-each select="descendant::tei:TEI">
                        <xsl:element name="ti:edition" namespace="http://chs.harvard.edu/xmlns/cts">
                            <xsl:attribute name="groupUrn"
                                select="concat('urn:dts:frHist:katabase.', $revue)"/>
                            <xsl:attribute name="urn"
                                select="concat('urn:dts:frHist:katabase.', $revue, '.', @xml:id)"/>
                            <xsl:element name="ti:label"
                                namespace="http://chs.harvard.edu/xmlns/cts">
                                <xsl:attribute name=" xml:lang">fr</xsl:attribute>
                                <xsl:text>Catalogue </xsl:text>
                                <xsl:value-of select="@xml:id"/>
                            </xsl:element>
                            <xsl:element name="ti:description"
                                namespace="http://chs.harvard.edu/xmlns/cts">
                                <xsl:attribute name=" xml:lang">fr</xsl:attribute>
                                <xsl:value-of
                                    select="concat(substring(descendant::tei:sourceDesc/tei:bibl/tei:title, 1, 1), substring(lower-case(descendant::tei:sourceDesc/tei:bibl/tei:title), 2))"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="descendant::tei:sourceDesc//tei:num"/>
                                <xsl:text> (</xsl:text>
                                <xsl:value-of
                                    select="concat(descendant::tei:sourceDesc/tei:bibl/tei:date[1], ').')"
                                />
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
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
            <xsl:result-document href="data/katabase/{$revue}/katabase.{$revue}.{$catalogue}.xml">
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
