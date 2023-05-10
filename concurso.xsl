<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">
    <xsl:output method="html" indent="yes"/>
    <xsl:template match="/">
        <html lang="es">
            <head>
                <meta charset="UTF-8"/>
                <title>Participantes</title>
                <link rel="stylesheet" href="estilos.css"/>
            </head>
            <body>
                <div class="header">
                    <h1>Información del concurso</h1>
                </div>

                <main>

                    <!-- Se define la subsección del listado de participantes -->
                    <h2>Listado de Participantes</h2>
                    
                    <!-- Se ordena los participantes por apellido en orden ascendente -->
                    <ol class="participantes">
                        <xsl:apply-templates select="//participante">
                                <xsl:sort select="apellidos" order="ascending"/>
                        </xsl:apply-templates>
                    </ol>
                
                    <!-- Se define la subsección de los 5 mejores participantes con más de 20 puntos -->
                    <h2>5 - Mejores participantes con más de 20 puntos</h2>
                    
                    <!-- Se crea una tabla con los participantes que tienen 20 o más puntos y los ordena por puntaje en orden descendente -->
                    <table class="participantes-t ancho">
                        <thead>
                            <tr>
                                <th>Posición</th>
                                <th>Participante</th>
                                <th>Puntos</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Se itera sobre los participantes con 20 o más puntos y crea una fila en la tabla para los 5 mejores -->
                            <xsl:for-each select="//participante[puntos >= 20]">
                                <xsl:sort select="puntos" order="descending"/>
                                <xsl:if test="position()&lt;=5">
                                    <tr>
                                        <td><xsl:value-of select="position()"/></td>
                                        <td>
                                            <xsl:value-of select="apellidos"/>
                                            <xsl:text>, </xsl:text>
                                            <xsl:value-of select="nombre"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="puntos"/>
                                        </td>
                                    </tr>
                                </xsl:if>
                            </xsl:for-each>
                        </tbody>
                    </table>

                    <!-- Se define la subsección de las estadísticas -->
                    <div class="estad"> 
                        <h2>Estadísticas</h2>
                        
                        <!-- Se cuenta el número total de participantes -->
                        <xsl:variable name="v_num_part" select="count(//participante)"/>
                        
                        <!-- Se cuenta el número de participantes entre 18 y 35 años -->
                        <xsl:variable name="v_num_part_18_35" select="count(//participante[edad&gt;=18 and edad&lt;=35])"/>
                        
                        <!-- Se cuenta el número de participantes entre 36 y 55 años -->
                        <xsl:variable name="v_num_part_36_55" select="count(//participante[edad&gt;35 and edad&lt;=55])"/>

                        <!-- Se cuenta el número de participantes mayores de 55 años -->
                        <xsl:variable name="v_num_part_55" select="count(//participante[edad&gt;55])"/>

                        <!-- Se muestran las estadísticas sobre los participantes 'número total, puntuación media y distribución por edad' -->
                        <ul>
                            <li><span>Número total de participantes:</span> <span class="stats">
                            <xsl:value-of select="$v_num_part"/>
                            </span></li>
                            <li><span>Puntuación media:</span> <span class="stats">
                            <xsl:value-of select="round((sum(//participante/puntos) div count(//participante) * 10)) div 10"/>
                            </span></li>
                            <li><span>Participantes de 18 a 35 años:</span> 
                            <span class="stats">
                            <xsl:value-of select="$v_num_part_18_35"/> 
                            (<xsl:value-of select="format-number($v_num_part_18_35 div $v_num_part, '0.00%')"/>)
                            </span></li>
                            <li><span>Participantes de 36 a 55 años:</span> 
                            <span class="stats">
                            <xsl:value-of select="$v_num_part_36_55"/>
                            (<xsl:value-of select="format-number($v_num_part_36_55 div $v_num_part, '0.00%')"/>)
                            </span></li>
                            <li><span>Participantes de más de 55 años:</span> 
                            <span class="stats">
                            <xsl:value-of select="$v_num_part_55"/>
                            (<xsl:value-of select="format-number($v_num_part_55 div $v_num_part, '0.00%')"/>)
                            </span></li>
                        </ul>
                        
                        <!-- Se muestra una tabla con el número de participantes por provincia. -->
                        <table class="participantes-t">
                            <thead>
                                <tr>
                                    <th>Provincia</th>
                                    <th>Nº Participantes</th>
                                </tr>
                            </thead>
                            <tbody>

                            <!--Se itera sobre cada provincia y se cuenta el número de participantes en ella. -->
                            <xsl:for-each select="//participante[not (provincia=preceding::provincia)]">
                            <xsl:sort select="provincia"/>
                            <xsl:variable name="v_provincia" select="provincia"/>
                                <tr>
                                    <td><xsl:value-of select="provincia"/></td>
                                    <td><xsl:value-of select="count(//participante[provincia=$v_provincia])"/></td>
                                </tr>
                            </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </main>
            </body>
        </html>
    </xsl:template>

    <!-- Se muestra el apellido, nombre, código y puntuación de cada participante de la lista -->
    <xsl:template match="participante">
                <li><xsl:value-of select="apellidos"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="nombre"/>
                    <xsl:text>. (</xsl:text>
                    <xsl:value-of select="@codigo"/>
                    <xsl:text>) - </xsl:text>
                    <xsl:value-of select="puntos"/>
                    <xsl:text> puntos</xsl:text>
                </li>
    </xsl:template>
</xsl:stylesheet>