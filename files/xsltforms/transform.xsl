<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="text"/>
   <xsl:template match="/">
      This is output from tango.xsl.
      <xsl:apply-templates/>
   </xsl:template>
</xsl:stylesheet>