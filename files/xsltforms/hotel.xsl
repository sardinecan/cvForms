<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="html"/>
   <xsl:template match="/">
      <html><head><title>Test</title></head>
         <body>
            <h1>Hurrah! it works!</h1>
            <p>Root: <xsl:value-of select="name(./*)"/></p>
            <p>Data: <xsl:apply-templates/></p>
         </body>
      </html>
   </xsl:template>
   <xsl:template match="pag"/>
</xsl:stylesheet>