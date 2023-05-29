<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rs="http://www.battlescribe.net/schema/rosterSchema"
                exclude-result-prefixes="rs">

<xsl:template match="/">
  <html>
    <head>
        <title>Armia <xsl:value-of select="rs:roster/@name"/></title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous"></link>
    </head>
    <body>
        <h2>
            <xsl:value-of select="/rs:roster/rs:forces/rs:force/@catalogueName"/>
            Army: <xsl:value-of select="rs:roster/@name"/><small> (
                <xsl:for-each select="rs:roster/rs:costs/rs:cost">
                    <xsl:value-of select="@name"/>
                    :
                    <xsl:value-of select="@value"/>
                    /
                    <xsl:variable name="selectedTypeId" select="@typeId" />
                    <xsl:value-of select="/rs:roster/rs:costLimits/rs:costLimit[@typeId=$selectedTypeId]/@value"/>
                </xsl:for-each>
            )</small>
        </h2>
        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:rules/rs:rule">
        <p><strong><xsl:value-of select="@name"/>: </strong> <xsl:value-of select="rs:description"/></p>
        </xsl:for-each>

        <hr/>
        <h3>General</h3>
        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:categories/rs:category[@name='Generał']/rs:rules/rs:rule">
        <p><strong><xsl:value-of select="@name"/>: </strong> <xsl:value-of select="rs:description"/></p>
        </xsl:for-each>

        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection[@type='model']">
            <xsl:if test="rs:rules/rs:rule[@name='Generał']">
                <strong><xsl:value-of select="@name"/> </strong>
                <ul>
                    <xsl:for-each select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic">
                        <li><strong><xsl:value-of select="@name"/>: </strong><xsl:value-of select="."/> </li>
                    </xsl:for-each>
                    <xsl:for-each select="rs:rules/rs:rule[@name!='Generał']">
                        <li><strong><xsl:value-of select="@name"/>: </strong><xsl:value-of select="rs:description"/> </li>
                    </xsl:for-each>
                    <xsl:for-each select="rs:selections/rs:selection[@type='upgrade']">
                        <li>
                            <strong><xsl:value-of select="rs:profiles/rs:profile/@name"/> </strong>
                            (<xsl:value-of select="round(rs:costs/rs:cost/@value)"/>)
                            <xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='Opis']"/>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </xsl:for-each>

        <hr/>
        <h3>Grupy Dowódcze</h3>
        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:categories/rs:category[@name='Grupa Dowódcza']/rs:rules/rs:rule">
        <p><strong><xsl:value-of select="@name"/>: </strong> <xsl:value-of select="rs:description"/></p>
        </xsl:for-each>

        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection[@type='model']/rs:rules/rs:rule[@name='Grupa Dowódcza']">
            <ul>
                <li><strong>Grupa Dowódcza #<xsl:value-of select="position()" />: </strong><xsl:value-of select="round(../../rs:costs/rs:cost/@value)"/> </li>
            </ul>
        </xsl:for-each>

        <hr/>
        <h3>Czempioni</h3>
        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:categories/rs:category[@name='Czempion']/rs:rules/rs:rule">
        <p><strong><xsl:value-of select="@name"/>: </strong> <xsl:value-of select="rs:description"/></p>
        </xsl:for-each>

        <table class="table table-bordered table-hover table-condensed">
            <tr>
                <th>Nazwa</th>
                <th>Koszt</th>
                <th>Test</th>
                <th>Opis</th>
            </tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection[@type='model']">
                <xsl:if test="rs:rules/rs:rule[@name='Czempion']">
                    <xsl:call-template name="champion" />
                </xsl:if>
            </xsl:for-each>
        </table>

        <hr/>
        <h3>Magowie</h3>
        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:categories/rs:category[@name='Mag']/rs:rules/rs:rule">
        <p><strong><xsl:value-of select="@name"/>: </strong> <xsl:value-of select="rs:description"/></p>
        </xsl:for-each>

        <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection[@type='model']">
            <xsl:if test="rs:rules/rs:rule[@name='Mag']">
                <xsl:call-template name="mage" />
            </xsl:if>
        </xsl:for-each>

        <hr/>
        <h3>Oddziały</h3>
        <table class="table table-bordered table-hover table-condensed">
            <tr>
                <th>Nazwa</th>
                <th>Liczba Podstawek</th>
                <th>Koszt</th>
                <th>LD</th>
                <th>M</th>
                <th>WS</th>
                <th>S</th>
                <th>T</th>
                <th>A</th>
                <th>W</th>
                <th>Opis</th>
            </tr>
            <tr><td colspan="100"><strong><center>Oddziały Podstawowe</center></strong></td></tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection[@type='unit']">
                <xsl:if test="rs:categories/rs:category[@name='Oddziały Podstawowe']">
                    <xsl:call-template name="unit" />
                </xsl:if>
            </xsl:for-each>

            <tr><td colspan="100"><strong><center>Oddziały Elitarne</center></strong></td></tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection[@type='unit']">
                <xsl:if test="rs:categories/rs:category[@name='Oddziały Elitarne']">
                    <xsl:call-template name="unit" />
                </xsl:if>
            </xsl:for-each>

            <tr><td colspan="100"><strong><center>Oddziały Rzadkie</center></strong></td></tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection[@type='unit']">
                <xsl:if test="rs:categories/rs:category[@name='Oddziały Rzadkie']">
                    <xsl:call-template name="unit" />
                </xsl:if>
            </xsl:for-each>

            <tr><td colspan="100"><strong><center>Oddziały Unikalne</center></strong></td></tr>
            <xsl:for-each select="/rs:roster/rs:forces/rs:force/rs:selections/rs:selection[@type='unit']">
                <xsl:if test="rs:categories/rs:category[@name='Oddziały Unikalne']">
                    <xsl:call-template name="unit" />
                </xsl:if>
            </xsl:for-each>
        </table>
    </body>
  </html>
</xsl:template>

<xsl:template name="unit">
<tr>
    <td><strong><xsl:value-of select="@name"/></strong></td>
    <td><xsl:value-of select="rs:selections/rs:selection[@type='model']/@number"/></td>
    <td><xsl:value-of select="round(rs:selections/rs:selection[@type='model']/rs:costs/rs:cost/@value)"/></td>
    <td><xsl:value-of select="rs:selections/rs:selection[@type='model']/rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='LD']"/></td>
    <td><xsl:value-of select="rs:selections/rs:selection[@type='model']/rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='M']"/></td>
    <td><xsl:value-of select="rs:selections/rs:selection[@type='model']/rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='WS']"/></td>
    <td><xsl:value-of select="rs:selections/rs:selection[@type='model']/rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='S']"/></td>
    <td><xsl:value-of select="rs:selections/rs:selection[@type='model']/rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='T']"/></td>
    <td><xsl:value-of select="rs:selections/rs:selection[@type='model']/rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='A']"/></td>
    <td><xsl:value-of select="rs:selections/rs:selection[@type='model']/rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='W']"/></td>
    <td>
        <xsl:for-each select="rs:selections/rs:selection[@type='model']/rs:rules/rs:rule">
        <p><strong><xsl:value-of select="@name"/>: </strong><xsl:value-of select="rs:description"/></p>
        </xsl:for-each>
    </td>
</tr>
</xsl:template>


<xsl:template name="champion">
<tr>
    <td><strong><xsl:value-of select="@name"/></strong></td>
    <td><xsl:value-of select="round(rs:costs/rs:cost/@value)"/></td>
    <td><xsl:value-of select="rs:profiles/rs:profile[@typeName='Zdolność']/rs:characteristics/rs:characteristic[@name='Test']"/></td>
    <td><xsl:value-of select="rs:profiles/rs:profile[@typeName='Zdolność']/rs:characteristics/rs:characteristic[@name='Opis']"/></td>
</tr>
</xsl:template>

<xsl:template name="mage">
<h4><xsl:value-of select="@name"/></h4>
<ul>
<xsl:for-each select="rs:rules/rs:rule[@name!='Mag']">
    <li><strong><xsl:value-of select="@name"/>: </strong><xsl:value-of select="rs:description"/> </li>
</xsl:for-each>
</ul>
<table class="table table-bordered table-hover table-condensed">
    <tr>
        <th>Nazwa</th>
        <th>Koszt</th>
        <th>Opis</th>
    </tr>
    <tr><td colspan="100"><strong><center>Czary</center></strong></td></tr>
    <xsl:for-each select="rs:selections/rs:selection[@type='upgrade']">
        <xsl:if test="rs:profiles/rs:profile[@typeName='Czar']">
            <tr>
                <td><strong><xsl:value-of select="@name"/></strong></td>
                <td><xsl:value-of select="round(rs:costs/rs:cost/@value)"/></td>
                <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='Opis']"/></td>
            </tr>
        </xsl:if>
    </xsl:for-each>

    <tr><td colspan="100"><strong><center>Przedmioty Magiczne</center></strong></td></tr>
    <xsl:for-each select="rs:selections/rs:selection[@type='upgrade']">
        <xsl:if test="rs:profiles/rs:profile[@typeName='Przedmiot Magiczny']">
            <tr>
                <td><strong><xsl:value-of select="@name"/></strong></td>
                <td><xsl:value-of select="round(rs:costs/rs:cost/@value)"/></td>
                <td><xsl:value-of select="rs:profiles/rs:profile/rs:characteristics/rs:characteristic[@name='Opis']"/></td>
            </tr>
        </xsl:if>
    </xsl:for-each>
</table>
</xsl:template>

</xsl:stylesheet>