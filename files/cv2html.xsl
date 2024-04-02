<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:functx="http://www.functx.com"
   exclude-result-prefixes="xs"
   version="1.0">
   
   <xsl:output encoding="UTF-8" method="html" indent="yes"/>
   
   <xsl:template match="/">
      <html>
         <head>
            <title>Curriculum</title>
            <meta charset="UTF-8"/>
            <link rel="stylesheet" href="files/css/cv.css"/>
         </head>
         <body>
            <div class="container">
               <xsl:apply-templates/>
            </div>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template match="curriculum">
      <header>
         <xsl:apply-templates select="cvPart[@type='identity']"/>
      </header>
      <div class="vitae">
         <xsl:apply-templates select="cvPart[@type!='identity']"/>
      </div>
   </xsl:template>
   
   <xsl:template match="cvPart">
      <xsl:choose>
         <xsl:when test="normalize-space(.)!='' and normalize-space(.)!=normalize-space(./head)">
            <div class="{@type}">
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="head">
      <h2><xsl:apply-templates/></h2>
   </xsl:template>
   
   <xsl:template match="list">
      <ul class="{@type}">
         <xsl:apply-templates/>
      </ul>
   </xsl:template>
   
   <xsl:template match="item">
      <li><xsl:apply-templates/></li>
   </xsl:template>
   
   <xsl:template match="ref">
      <xsl:choose>
         <xsl:when test="@type='link'"><a href="{@target}"><xsl:apply-templates/></a></xsl:when>
         <xsl:when test="@type='mailto'"><a href="mailto:{@target}"><xsl:apply-templates/></a></xsl:when>
         <xsl:otherwise><a href="{@target}"><xsl:apply-templates/></a></xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="cvEntry[normalize-space(.)!='']">
      <section class="cvEntry">
         <xsl:apply-templates select="date | head"/>
         <section class="desc">
            <header>
               <strong><xsl:apply-templates select="position"/></strong>
               <xsl:text> </xsl:text>
               <xsl:apply-templates select="orgName"/>
               <xsl:text>, </xsl:text><xsl:apply-templates select="placeName | desc"/>
            </header>
            <xsl:apply-templates select="list[normalize-space()!=''] | degree[normalize-space()!=''] | rank[normalize-space()!='']"/>
         </section>
      </section>
   </xsl:template>
   
   <xsl:template match="cvPart[@type='skills' or @type='other' or @type='publications']/cvEntry[normalize-space(.)!='']">
      <section class="cvEntry">
         <xsl:apply-templates select="head"/>
         <section class="desc">
            <xsl:apply-templates select="list[normalize-space()!=''] | desc[normalize-space()!=''] | bibl[normalize-space()!='']"/>
         </section>
      </section>
   </xsl:template>
   
   <xsl:template match="list[@type='resources']">
      <p class="{@type}">
         <xsl:for-each select="item">
            <xsl:choose>
               <xsl:when test="position() != last()">
                  <xsl:apply-templates/><xsl:text> | </xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </p>
   </xsl:template>
   
   <xsl:template match="cvPart[@type='skills']/cvEntry/list">
      <p class="skills">
         <xsl:for-each select="item">
            <xsl:choose>
               <xsl:when test="position() != last()">
                  <xsl:apply-templates/><xsl:text> | </xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </p>
   </xsl:template>
   
   <xsl:template match="orgName">
      <xsl:choose>
         <xsl:when test="parent::cvEntry[@type='diploma' or @type='examination']"><strong><xsl:apply-templates/></strong></xsl:when>
         <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="emph">
      <em><xsl:apply-templates/></em>
   </xsl:template>
   
   <xsl:template match="date">
      <section class="date">
         <xsl:choose>
            <xsl:when test="@when">
               <xsl:variable name="date">
                  <xsl:call-template name="getDate">
                     <xsl:with-param name="date" select="@when"/>
                  </xsl:call-template>
               </xsl:variable>
               <xsl:value-of select="$date"/>
            </xsl:when>
            <xsl:when test="@from and @to">
               <xsl:variable name="from">
                  <xsl:call-template name="getDate">
                     <xsl:with-param name="date" select="@from"/>
                  </xsl:call-template>
               </xsl:variable>
               <xsl:variable name="to">
                  <xsl:call-template name="getDate">
                     <xsl:with-param name="date" select="@to"/>
                  </xsl:call-template>
               </xsl:variable>
               <xsl:value-of select="concat($from,  ' – ', $to)"/>
            </xsl:when>
         </xsl:choose>
      </section>
   </xsl:template>
   
   <xsl:template match="cvEntry/head">
      <section class="head">
         <xsl:apply-templates/>
      </section>
   </xsl:template>
   
   <xsl:template name="getDate">
      <xsl:param name="date"/>
      <xsl:variable name="year">
         <xsl:call-template name="getYear">
            <xsl:with-param name="date" select="$date"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="month">
         <xsl:call-template name="getMonth">
            <xsl:with-param name="date" select="$date"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="concat($month, ' ', $year)"/>
   </xsl:template>
   
   <xsl:template name="getYear">
      <xsl:param name="date"/>
      <xsl:value-of select="substring($date, 1, 4)"/>
   </xsl:template>
   
   <xsl:template name="getMonth">
      <xsl:param name="date"/>
      <xsl:variable name="month" select="substring($date, 6, 2)"/>
      <xsl:choose>
         <xsl:when test="$month = '01'"><xsl:text>janvier</xsl:text></xsl:when>
         <xsl:when test="$month = '02'"><xsl:text>février</xsl:text></xsl:when>
         <xsl:when test="$month = '03'"><xsl:text>mars</xsl:text></xsl:when>
         <xsl:when test="$month = '04'"><xsl:text>avril</xsl:text></xsl:when>
         <xsl:when test="$month = '05'"><xsl:text>mai</xsl:text></xsl:when>
         <xsl:when test="$month = '06'"><xsl:text>juin</xsl:text></xsl:when>
         <xsl:when test="$month = '07'"><xsl:text>juillet</xsl:text></xsl:when>
         <xsl:when test="$month = '08'"><xsl:text>août</xsl:text></xsl:when>
         <xsl:when test="$month = '09'"><xsl:text>septembre</xsl:text></xsl:when>
         <xsl:when test="$month = '10'"><xsl:text>octobre</xsl:text></xsl:when>
         <xsl:when test="$month = '11'"><xsl:text>novembre</xsl:text></xsl:when>
         <xsl:when test="$month = '12'"><xsl:text>décembre</xsl:text></xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="degree | rank | bibl">
      <p class="{local-name(.)}"><xsl:apply-templates/></p>
   </xsl:template>
   
   <xsl:template match="cvPart[@type='identity']/persName">
      <h1><xsl:apply-templates/></h1>
   </xsl:template>
   
   <xsl:template match="cvPart[@type='identity']/occupation">
      <h2 class="occupation"><xsl:apply-templates/></h2>
   </xsl:template>
   
   <xsl:template match="cvPart[@type='identity']/contact">
      <section class="{local-name(.)}">
         <h3>Coordonnées</h3>
         <ul>
            <xsl:for-each select="*[normalize-space(.)!='']">
               <li class="{local-name(.)}"><xsl:apply-templates/></li>
            </xsl:for-each>
         </ul>
      </section>
   </xsl:template>
   
   <xsl:template match="addrLine">
      <xsl:apply-templates/><br/>
   </xsl:template>
   
</xsl:stylesheet>