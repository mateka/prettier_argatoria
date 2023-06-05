<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rs="http://www.battlescribe.net/schema/rosterSchema"
                exclude-result-prefixes="rs">

<!-- Transformation params-->

<!--
    Verbosity level:
    0 (default) - output only rules' names
    1 - output rules' names and descriptions
-->
<xsl:param name="verbose">0</xsl:param>

<!-- Templates -->
<xsl:template match="/">
    <!-- Check roster language (there are two game systems in BS)-->
    <xsl:variable name="language">
        <xsl:choose>
            <xsl:when test="/rs:roster/@gameSystemId='0744-20b6-d715-c575'">EN</xsl:when>
            <xsl:otherwise>PL</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="roster-name" select="/rs:roster/@name" />

    <html>
        <xsl:call-template name="document-head">
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="roster-name" select="$roster-name"/>
        </xsl:call-template>

        <xsl:call-template name="document-body">
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="roster-name" select="$roster-name"/>
        </xsl:call-template>
    </html>
</xsl:template>


<xsl:template name="document-head">
    <xsl:param name="language">PL</xsl:param>
    <xsl:param name="roster-name">Roster?</xsl:param>

    <head>
        <title>
            <xsl:choose>
                <xsl:when test="$language='EN'">Argatoria's army </xsl:when>
                <xsl:otherwise>Armia do Argatorii </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$roster-name"/>
        </title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous"></link>
    </head>
</xsl:template>


<xsl:template name="document-body">
    <xsl:param name="language">PL</xsl:param>
    <xsl:param name="roster-name">Roster?</xsl:param>

    <body>
        <xsl:call-template name="header">
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="roster-name" select="$roster-name"/>
        </xsl:call-template>

        <xsl:call-template name="heroes">
            <xsl:with-param name="language" select="$language"/>
        </xsl:call-template>

        <xsl:call-template name="units">
            <xsl:with-param name="language" select="$language"/>
        </xsl:call-template>
    </body>
</xsl:template>

<xsl:template name="header">
    <xsl:param name="language">PL</xsl:param>
    <xsl:param name="roster-name">Roster?</xsl:param>

    <h2>
        <!-- Output army's name -->
        <xsl:variable name="race" select="/rs:roster/rs:forces/rs:force/@catalogueName" />
        <xsl:choose>
            <xsl:when test="$language='EN'">
                <xsl:value-of select="$race"/>'s army
            </xsl:when>
            <xsl:otherwise>Armia <xsl:value-of select="$race"/></xsl:otherwise>
        </xsl:choose>
        <xsl:text disable-output-escaping="yes"> <![CDATA[&ldquo;]]></xsl:text>
        <xsl:value-of select="rs:roster/@name"/>
        <xsl:text disable-output-escaping="yes"><![CDATA[&rdquo;]]> </xsl:text>

        <!-- Output costs -->
        <small>
        (
            <xsl:for-each select="rs:roster/rs:costs/rs:cost">
                <xsl:variable name="selectedTypeId" select="@typeId" />
                <xsl:variable name="max-cost" select="/rs:roster/rs:costLimits/rs:costLimit[@typeId=$selectedTypeId]/@value"/>
                <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
                <xsl:value-of select="@name"/>: <xsl:value-of select="@value"/> / <xsl:value-of select="$max-cost"/>
            </xsl:for-each>
        )
        </small>
    </h2>

    <!-- Output global rules -->
    <xsl:apply-templates select="/rs:roster/rs:forces/rs:force/rs:rules">
        <xsl:with-param name="language" select="$language"/>
    </xsl:apply-templates>
    <hr/>
</xsl:template>


<xsl:template name="show-rules" match="rs:rules">
    <xsl:param name="language">PL</xsl:param>

    <xsl:choose>
        <xsl:when test="$verbose &gt; 0">
            <xsl:for-each select="rs:rule">
                <p><strong><xsl:value-of select="@name"/>: </strong> <xsl:value-of select="rs:description"/></p>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <xsl:for-each select="rs:rule">
                <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
                <xsl:value-of select="@name"/>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template name="heroes">
    <xsl:param name="language">PL</xsl:param>

    <h3>
        <xsl:choose>
            <xsl:when test="$language='EN'">Heroes</xsl:when>
            <xsl:otherwise>Bohaterowie</xsl:otherwise>
        </xsl:choose>
    </h3>
    <table class="table table-bordered table-hover table-condensed">
        <tr>
            <th>
                <xsl:choose>
                    <xsl:when test="$language='EN'">Name</xsl:when>
                    <xsl:otherwise>Nazwa</xsl:otherwise>
                </xsl:choose>
            </th>
            <th>
                <xsl:choose>
                    <xsl:when test="$language='EN'">Cost</xsl:when>
                    <xsl:otherwise>Koszt</xsl:otherwise>
                </xsl:choose>
            </th>
            <th>LD</th>
            <th>
                <xsl:choose>
                    <xsl:when test="$language='EN'">Test</xsl:when>
                    <xsl:otherwise>Test</xsl:otherwise>
                </xsl:choose>
            </th>
            <th>
                <xsl:choose>
                    <xsl:when test="$language='EN'">Description</xsl:when>
                    <xsl:otherwise>Opis</xsl:otherwise>
                </xsl:choose>
            </th>
        </tr>

        <xsl:variable name='hero-category-id'>
            <xsl:choose>
                <xsl:when test="$language='EN'">90cb-5b94-12bf-c937</xsl:when>
                <xsl:otherwise>982d-e25e-9a7a-d639</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='ld-id'>
            <xsl:choose>
                <xsl:when test="$language='EN'">6103-ad18-a530-9636</xsl:when>
                <xsl:otherwise>cac3-aea3-a917-6b13</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='test-id'>
            <xsl:choose>
                <xsl:when test="$language='EN'">3a4a-c8b6-95f1-24e0</xsl:when>
                <xsl:otherwise>d283-bd6e-44c3-e421</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name='description-id'>
            <xsl:choose>
                <xsl:when test="$language='EN'">80c5-70a3-dda4-71fe</xsl:when>
                <xsl:otherwise>d023-e767-bbca-ad83</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection">
            <xsl:if test="rs:categories/rs:category[@entryId=$hero-category-id]">
                <xsl:variable name='upgrades-count' select="count(rs:selections/rs:selection[@type='upgrade']) + 1" />
                <tr>
                    <td>
                        <xsl:attribute name="rowspan">
                            <xsl:value-of select="$upgrades-count"/>
                        </xsl:attribute>
                        <strong><xsl:value-of select="@name"/></strong>
                    </td>
                    <td><xsl:value-of select="round(rs:costs/rs:cost/@value)"/></td>
                    <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$ld-id]"/></td>
                    <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$test-id]"/></td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="$verbose &gt; 0">
                                <xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$description-id]"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="@name"/><xsl:text>, </xsl:text></xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="rs:rules">
                            <xsl:with-param name="language" select="$language"/>
                        </xsl:apply-templates>
                    </td>
                </tr>
                <xsl:for-each select="rs:selections/rs:selection[@type='upgrade']">
                    <tr>
                        <td><xsl:value-of select="round(rs:costs/rs:cost/@value)"/></td>
                        <td/>
                        <td/>
                        <td>
                            <xsl:choose>
                                <xsl:when test="$verbose &gt; 0">
                                    <strong><xsl:value-of select="rs:profiles/rs:profile/@name"/>: </strong>
                                    <xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic"/>
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="rs:profiles/rs:profile/@name"/></xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </table>
    <hr/>
</xsl:template>

<xsl:template name="units">
    <xsl:param name="language">PL</xsl:param>

    <h3>
        <xsl:choose>
            <xsl:when test="$language='EN'">Units</xsl:when>
            <xsl:otherwise>Oddziały</xsl:otherwise>
        </xsl:choose>
    </h3>
    
    <xsl:variable name='basic-units-category-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">38a8-b0e1-a7b1-6f5a</xsl:when>
            <xsl:otherwise>cf53-8f98-e5aa-f320</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='elite-units-category-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">6518-c7a0-7e65-5999</xsl:when>
            <xsl:otherwise>61c5-519d-b7db-d153</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='rare-units-category-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">75b7-154c-09bb-c13b</xsl:when>
            <xsl:otherwise>70ac-247a-953d-1088</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='uniqe-units-category-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">25b5-9054-a7c2-90ed</xsl:when>
            <xsl:otherwise>e7dc-90ea-f6c0-25b8</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <table class="table table-bordered table-hover table-condensed">
        <thead>
            <tr>
                <th>
                    <xsl:choose>
                        <xsl:when test="$language='EN'">Name</xsl:when>
                        <xsl:otherwise>Nazwa</xsl:otherwise>
                    </xsl:choose>
                </th>
                <th>
                    <xsl:choose>
                        <xsl:when test="$language='EN'">Count</xsl:when>
                        <xsl:otherwise>Liczba</xsl:otherwise>
                    </xsl:choose>
                </th>
                <th>
                    <xsl:choose>
                        <xsl:when test="$language='EN'">Cost</xsl:when>
                        <xsl:otherwise>Koszt</xsl:otherwise>
                    </xsl:choose>
                </th>
                <th>LD</th>
                <th>M</th>
                <th>WS</th>
                <th>S</th>
                <th>T</th>
                <th>A</th>
                <th>W</th>
            </tr>
        </thead>
        <tbody>
            <tr><td colspan="100"><small><center>
                <xsl:choose>
                    <xsl:when test="$language='EN'">Basic units</xsl:when>
                    <xsl:otherwise>Oddziały Podstawowe</xsl:otherwise>
                </xsl:choose>
            </center></small></td></tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection">
                <xsl:if test="rs:categories/rs:category[@entryId=$basic-units-category-id]">
                    <xsl:call-template name="unit">
                        <xsl:with-param name="language" select="$language"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>

            <tr><td colspan="100"><small><center>
                <xsl:choose>
                    <xsl:when test="$language='EN'">Elite units</xsl:when>
                    <xsl:otherwise>Oddziały Elitarne</xsl:otherwise>
                </xsl:choose>
            </center></small></td></tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection">
                <xsl:if test="rs:categories/rs:category[@entryId=$elite-units-category-id]">
                    <xsl:call-template name="unit">
                        <xsl:with-param name="language" select="$language"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>

            <tr><td colspan="100"><small><center>
                <xsl:choose>
                    <xsl:when test="$language='EN'">Rare units</xsl:when>
                    <xsl:otherwise>Oddziały Rzadkie</xsl:otherwise>
                </xsl:choose>
            </center></small></td></tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection">
                <xsl:if test="rs:categories/rs:category[@entryId=$rare-units-category-id]">
                    <xsl:call-template name="unit">
                        <xsl:with-param name="language" select="$language"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>

            <tr><td colspan="100"><small><center>
                <xsl:choose>
                    <xsl:when test="$language='EN'">Uniqe units</xsl:when>
                    <xsl:otherwise>Oddziały Unikalne</xsl:otherwise>
                </xsl:choose>
            </center></small></td></tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection">
                <xsl:if test="rs:categories/rs:category[@entryId=$uniqe-units-category-id]">
                    <xsl:call-template name="unit">
                        <xsl:with-param name="language" select="$language"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </tbody>
    </table>
</xsl:template>

<xsl:template name="unit">
    <xsl:param name="language">PL</xsl:param>

    <xsl:choose>
        <xsl:when test="@type='model'">
            <xsl:apply-templates select=".">
                <xsl:with-param name="language" select="$language"/>
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="rs:selections/rs:selection">
                <xsl:with-param name="language" select="$language"/>
            </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="unit-data" match="rs:selection">
    <xsl:param name="language">PL</xsl:param>

    <xsl:variable name='ld-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">2d74-3840-75ce-fb6a</xsl:when>
            <xsl:otherwise>93fa-4500-7c4e-a44c</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='m-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">bbba-6b29-970f-bb87</xsl:when>
            <xsl:otherwise>a9c9-ec0c-65ad-1dc0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='ws-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">bd6b-76ed-c7b4-ed41</xsl:when>
            <xsl:otherwise>d333-1828-755a-c589</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='s-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">0965-1c76-5e55-52f3</xsl:when>
            <xsl:otherwise>f957-7f6c-4fcc-ef66</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='t-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">6131-048c-0aa9-a832</xsl:when>
            <xsl:otherwise>b6c9-4b7e-33e0-6aca</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='a-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">2741-62c1-8198-f19f</xsl:when>
            <xsl:otherwise>395a-f9df-359b-774c</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name='w-id'>
        <xsl:choose>
            <xsl:when test="$language='EN'">a5bd-81d9-7061-d9fa</xsl:when>
            <xsl:otherwise>1aef-9fb8-6d60-bcdb</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <tr>
        <td rowspan="2"><strong><xsl:value-of select="@name"/></strong></td>
        <td><xsl:value-of select="@number"/></td>
        <td><xsl:value-of select="round(rs:costs/rs:cost/@value)"/></td>
        <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$ld-id]"/></td>
        <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$m-id]"/></td>
        <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$ws-id]"/></td>
        <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$s-id]"/></td>
        <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$t-id]"/></td>
        <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$a-id]"/></td>
        <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@typeId=$w-id]"/></td>
    </tr>
    <tr>
        <td colspan="100">
            <xsl:apply-templates select="rs:rules">
                <xsl:with-param name="language" select="$language"/>
            </xsl:apply-templates>
        </td>
    </tr>
</xsl:template>

</xsl:stylesheet>