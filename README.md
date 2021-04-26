# SPATIAL GRIDDED DATA FOR WEATHER, SOIL AND LAND USE
Code to create process spatial data into grid for the continental US. The data includes weather, soil and landuse
<html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 15 (filtered)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"Calibri Light";
	panose-1:2 15 3 2 2 2 4 3 2 4;}
@font-face
	{font-family:"Segoe UI";
	panose-1:2 11 5 2 4 2 4 2 2 3;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:8.0pt;
	margin-left:0in;
	line-height:107%;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
h1
	{mso-style-link:"Heading 1 Char";
	margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:0in;
	line-height:107%;
	page-break-after:avoid;
	font-size:16.0pt;
	font-family:"Calibri Light",sans-serif;
	color:#2E74B5;
	font-weight:normal;}
h2
	{mso-style-link:"Heading 2 Char";
	margin-top:2.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:0in;
	line-height:107%;
	page-break-after:avoid;
	font-size:13.0pt;
	font-family:"Calibri Light",sans-serif;
	color:#2E74B5;
	font-weight:normal;}
h3
	{mso-style-link:"Heading 3 Char";
	margin-top:2.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:0in;
	line-height:107%;
	page-break-after:avoid;
	font-size:12.0pt;
	font-family:"Calibri Light",sans-serif;
	color:#1F4D78;
	font-weight:normal;}
a:link, span.MsoHyperlink
	{color:#0563C1;
	text-decoration:underline;}
p
	{margin-right:0in;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman",serif;}
pre
	{mso-style-link:"HTML Preformatted Char";
	margin:0in;
	font-size:10.0pt;
	font-family:"Courier New";}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:8.0pt;
	margin-left:.5in;
	line-height:107%;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
p.MsoListParagraphCxSpFirst, li.MsoListParagraphCxSpFirst, div.MsoListParagraphCxSpFirst
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	line-height:107%;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
p.MsoListParagraphCxSpMiddle, li.MsoListParagraphCxSpMiddle, div.MsoListParagraphCxSpMiddle
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	line-height:107%;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
p.MsoListParagraphCxSpLast, li.MsoListParagraphCxSpLast, div.MsoListParagraphCxSpLast
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:8.0pt;
	margin-left:.5in;
	line-height:107%;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
span.Heading1Char
	{mso-style-name:"Heading 1 Char";
	mso-style-link:"Heading 1";
	font-family:"Calibri Light",sans-serif;
	color:#2E74B5;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";}
span.Heading2Char
	{mso-style-name:"Heading 2 Char";
	mso-style-link:"Heading 2";
	font-family:"Calibri Light",sans-serif;
	color:#2E74B5;}
span.Heading3Char
	{mso-style-name:"Heading 3 Char";
	mso-style-link:"Heading 3";
	font-family:"Calibri Light",sans-serif;
	color:#1F4D78;}
.MsoChpDefault
	{font-family:"Calibri",sans-serif;}
.MsoPapDefault
	{margin-bottom:8.0pt;
	line-height:107%;}
 /* Page Definitions */
 @page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
 /* List Definitions */
 ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
-->
</style>

</head>

<body lang=EN-US link="#0563C1" vlink="#954F72" style='word-wrap:break-word'>

<div class=WordSection1>

<h1><b><span style='font-size:26.0pt;line-height:107%;color:windowtext'>OBJECTIVES</span></b></h1>

<p class=MsoListParagraphCxSpFirst style='text-indent:-.5in'><span
style='font-size:12.0pt;line-height:107%;font-family:"Segoe UI",sans-serif'><span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>i.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span style='font-size:12.0pt;line-height:107%;font-family:"Segoe UI",sans-serif'>Describe
a database with weather, soil and land use for the US</span></p>

<p class=MsoListParagraphCxSpMiddle style='text-indent:-.5in'><span
style='font-size:12.0pt;line-height:107%;font-family:"Segoe UI",sans-serif'><span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp; </span>ii.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span style='font-size:12.0pt;line-height:107%;font-family:"Segoe UI",sans-serif'>Share
the codes used to obtain it, and the methodology followed for aggregating the
data</span></p>

<p class=MsoListParagraphCxSpLast style='text-indent:-.5in'><span
style='font-size:12.0pt;line-height:107%;font-family:"Segoe UI",sans-serif'><span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp; </span>iii.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span style='font-size:12.0pt;line-height:107%;font-family:"Segoe UI",sans-serif'>Provide
a tutorial on how to use it for maps and for obtaining characteristics at a
exact point (example: for trial characterization)</span></p>

<h1><b><span style='font-size:26.0pt;line-height:107%;color:windowtext'>Contact</span></b></h1>

<p style='margin-top:0in;margin-right:0in;margin-bottom:12.0pt;margin-left:
0in;background:white'><span style='font-family:"Segoe UI",sans-serif;
color:black'>Questions about the code and methodology: German Mandrini, Dpt of
Crop Sciences, University of Illinois at Urbana-Champaign,&nbsp;</span><span
style='color:black'><a href="mailto:germanmandrini@gmail.com"><span
style='font-family:"Segoe UI",sans-serif;color:black;text-decoration:none'>germanmandrini@gmail.com</span></a></span></p>

<p style='margin-top:0in;margin-right:0in;margin-bottom:12.0pt;margin-left:
0in;background:white'><span style='font-family:"Segoe UI",sans-serif;
color:black'>Questions about collaborations: Nicolas F Martin, Dpt of Crop
Sciences, University of Illinois at Urbana-Champaign,&nbsp;</span><span
style='color:black'><a href="mailto:nfmartin@illinois.edu"><span
style='font-family:"Segoe UI",sans-serif;color:black;text-decoration:none'>nfmartin@illinois.edu</span></a></span></p>

<p class=MsoNormal>&nbsp;</p>

<h1 style='margin-left:.25in;text-indent:-.25in'><b><span style='font-size:
26.0pt;line-height:107%;color:black'>1.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:26.0pt;line-height:107%;color:black'>DATABASE
DESCRIPTION</span></b></h1>

<p class=MsoNormal>Link to database: <a
href="https://uofi.box.com/s/yatgv535y7ouai3k8b0nwluj062uy6sj">https://uofi.box.com/s/yatgv535y7ouai3k8b0nwluj062uy6sj</a></p>

<p class=MsoNormal>The work has four output files:</p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td width=623 valign=top style='width:467.5pt;border:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>  Spatial
  data: it is the only spatial data, consisting in a 5 by 5 km grid over the
  US.</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'> Columns:</p>
  <p class=MsoListParagraphCxSpFirst style='margin-bottom:0in;text-indent:-.25in;
  line-height:normal'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>id_5000: unique number that identifies each cell. Key for
  merging with all other data sets.</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>id_tile: unique number that classifies a each tile. A tile is a
  group of cells used for splitting the data set into small portions that could
  be processed.</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>cult_count: the Nass provides a raster called National
  Cultivated layer that has where each 30 by 30 cell was classified as planted
  or not planted considering the time period from 2013 to 2017. This variable
  is the count of 30x30 m cells in each 5000x5000 m cell</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>US_state: State in the US. Based on the centroid of the cell</p>
  <p class=MsoListParagraphCxSpLast style='margin-bottom:0in;text-indent:-.25in;
  line-height:normal'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>US_region: Region in the US. Based on the centroid of the cell</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>&nbsp;</p>
  </td>
 </tr>
 <tr>
  <td width=623 valign=top style='width:467.5pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Landuse: csv
  file, showing the land allocation for each of the 5x5 km cell. </p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Only 19
  representative crops were selected: Corn, Soybeans, Winter Wheat, Fallow/Idle
  Cropland, Alfalfa, Spring Wheat, Cotton,Sorghum, Dbl Crop WinWht/Soybeans,
  Rice, Barley, Dry Beans, Durum Wheat, Canola, Oats, Peanuts, Almonds,
  Sunflower, Peas.</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>&nbsp;</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Columns:</p>
  <p class=MsoListParagraphCxSpFirst style='margin-bottom:0in;text-indent:-.25in;
  line-height:normal'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>id_5000: unique number that identifies each cell. Key for
  merging with all other data sets.</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>id_tile: unique number that classifies each tile. </p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Source: where data was obtained</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Variable: one of the 19 crops.</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Unit: unit in which the variable was measured. In this case it
  is the count of 30x30 m cells inside each of the 5000x5000 m cell. It can be
  easily converted to area multiplying the count by the size.</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Year: year in which the variable was measured</p>
  <p class=MsoListParagraphCxSpLast style='margin-bottom:0in;text-indent:-.25in;
  line-height:normal'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Value: value of the variable</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>More info: <a
  href="https://www.nass.usda.gov/Research_and_Science/Cropland/Release/">https://www.nass.usda.gov/Research_and_Science/Cropland/Release/</a></p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>&nbsp;</p>
  </td>
 </tr>
 <tr>
  <td width=623 valign=top style='width:467.5pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Weather: csv
  file, showing weather variables for each of the 5x5 km cells.</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Four
  variables were selected: precipitation (prcp), maximum and minimum
  temperature (tmax, tmin) and solar radiation (srad). Prcp is showed as total
  amount by month. Tmax, Tmin and srad are daily averages by month.</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>&nbsp;</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Columns:</p>
  <p class=MsoListParagraphCxSpFirst style='margin-bottom:0in;text-indent:-.25in;
  line-height:normal'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>id_5000: unique number that identifies each cell. Key for
  merging with all other data sets.</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>id_tile: unique number that classifies each tile. </p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Source: where data was obtained</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Variable: </p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Unit: unit in which the variable was measured</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Year: year in which the variable was measured</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Month: in which the variable was measured</p>
  <p class=MsoListParagraphCxSpLast style='margin-bottom:0in;text-indent:-.25in;
  line-height:normal'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Value: value of the variable</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>More info: <a
  href="https://daac.ornl.gov/DAYMET/guides/Daymet_V3_CFMosaics.html">https://daac.ornl.gov/DAYMET/guides/Daymet_V3_CFMosaics.html</a></p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Soils: csv
  file, showing weather variables for each of the 5x5 km cells.</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Four
  variables were selected: precipitation (prcp), maximum and minimum
  temperature (tmax, tmin) and solar radiation (srad). Prcp is showed as total
  amount by month. Tmax, Tmin and srad are daily averages by month.</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>&nbsp;</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>Columns:</p>
  <p class=MsoListParagraphCxSpFirst style='margin-bottom:0in;text-indent:-.25in;
  line-height:normal'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>id_5000: unique number that identifies each cell. Key for
  merging with all other data sets.</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>id_tile: unique number that classifies each tile. </p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Source: where data was obtained</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Unit: unit in which the variable was measured</p>
  <p class=MsoListParagraphCxSpMiddle style='margin-bottom:0in;text-indent:
  -.25in;line-height:normal'><span style='font-family:Symbol'>·<span
  style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Value: value of the variable</p>
  <p class=MsoListParagraphCxSpLast style='margin-bottom:0in;text-indent:-.25in;
  line-height:normal'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span></span>Variables:</p>
  <table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0 width=586
   style='width:439.25pt;border-collapse:collapse;border:none'>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><b><span
    style='color:black'>&nbsp;</span></b></p>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><b><span
    style='color:black'>Variable</span></b></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border:solid #5B9BD5 1.0pt;
    border-left:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><b><span
    style='color:black'>Description</span></b></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>BDRICM_M</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Depth to bedrock (R horizon) up to 200 cm</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>CLYPPT_M_sl3</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Clay content (0-2 micro meter) mass fraction in % at
    depth 0.15 m</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>OCDENS_M_sl1</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Soil organic carbon density in kg per cubic-m at depth
    0.00 m</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>PHIHOX_M_sl3</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Soil pH x 10 in H2O  at depth 0.15 m</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>SNDPPT_M_sl3</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Sand content (50-2000 micro meter) mass fraction in %
    at depth 0.15 m</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>AWCh1_M_sl1</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Derived available soil water capacity (volumetric
    fraction) with FC = pF 2.0 for depth 0 cm</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>AWCh1_M_sl2</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Derived available soil water capacity (volumetric
    fraction) with FC = pF 2.0 for depth 5 cm</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>AWCh1_M_sl3</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Derived available soil water capacity (volumetric
    fraction) with FC = pF 2.0 for depth 15 cm</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>AWCh1_M_sl4</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Derived available soil water capacity (volumetric
    fraction) with FC = pF 2.0 for depth 30 cm</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>AWCh1_M_sl5</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Derived available soil water capacity (volumetric
    fraction) with FC = pF 2.0 for depth 60 cm</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>AWCh1_M_sl6</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Derived available soil water capacity (volumetric
    fraction) with FC = pF 2.0 for depth 100 cm</span></p>
    </td>
   </tr>
   <tr style='height:15.0pt'>
    <td width=181 nowrap valign=bottom style='width:136.0pt;border:solid #5B9BD5 1.0pt;
    border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>AWCh1_M_sl7</span></p>
    </td>
    <td width=404 nowrap valign=bottom style='width:303.25pt;border-top:none;
    border-left:none;border-bottom:solid #5B9BD5 1.0pt;border-right:solid #5B9BD5 1.0pt;
    padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
    <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
    style='color:black'>Derived available soil water capacity (volumetric
    fraction) with FC = pF 2.0 for depth 200 cm</span></p>
    </td>
   </tr>
  </table>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>&nbsp;</p>
  <pre><span style='font-size:11.0pt;font-family:"Calibri",sans-serif'>More info: https://files.isric.org/soilgrids/data/recent/META_GEOTIFF_1B.csv</span></pre>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>&nbsp;</p>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'>&nbsp;</p>
  </td>
 </tr>
</table>

<p class=MsoNormal>&nbsp;</p>

<h1 style='margin-left:.25in;text-indent:-.25in'><b><span style='font-size:
26.0pt;line-height:107%;color:black'>2.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:26.0pt;line-height:107%;color:black'>CODES
INDEX</span></b></h1>

<p class=MsoNormal>&nbsp;</p>

<p class=MsoNormal>The following sections are only relevant to update the
database or create another one.</p>

<p class=MsoNormal><u>Link to folder with all data files</u>: <a
href="https://uofi.box.com/s/k46278qikvncl9marbmhnetbrn7fqz72">https://uofi.box.com/s/k46278qikvncl9marbmhnetbrn7fqz72</a></p>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=594
 style='width:445.25pt;border-collapse:collapse'>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><b><span
  style='color:black'>Order</span></b></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border:solid windowtext 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><b><span
  style='color:black'>File name</span></b></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border:solid windowtext 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><b><span
  style='color:black'>Objective</span></b></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>1</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>functions_grid_Dec10.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Functions used at different points of the project</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>2</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>grid_5000_creation_Dic10.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Create a grid of 5X5 km over the US</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>3</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>daymetA_download.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Download daily weather data</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>4</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>daymetB_make_monthly.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Transform the daily data into monthly (call)</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>5</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>daymetC_make_monthly_parallel.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Transform the daily data into monthly (execute)</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>6</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>daymetD_processing_call.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Process the monthly data for each cell of the grid (call)</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>7</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>daymetE_processing_parallel.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Process the monthly data for each cell of the grid
  (execute)</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>8</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>landuseA_mergeCDL.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Merge several CDL rasters (downloaded manually)</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>9</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>landuseB_process_CDL_paralel.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Obtains for each cell of the grid the CDL information</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>11</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>soilsA_call.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Obtains for each cell of the grid the soil information</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>10</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>soilsB_processing_paralel.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Obtains for each cell of the grid the soil information</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=59 nowrap valign=bottom style='width:44.0pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;text-align:right;
  line-height:normal'><span style='color:black'>13</span></p>
  </td>
  <td width=233 nowrap valign=bottom style='width:175.0pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>grid_tutorial.R</span></p>
  </td>
  <td width=302 nowrap valign=bottom style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='color:black'>Tutorial on how to open the grid and make maps</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal>&nbsp;</p>

<h1 style='margin-left:.25in;text-indent:-.25in'><b><span style='font-size:
26.0pt;line-height:107%;color:black'>3.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:26.0pt;line-height:107%;color:black'>METHODOLOGY</span></b></h1>

<p class=MsoNormal>&nbsp;</p>

<h2 style='margin-top:12.0pt;margin-right:0in;margin-bottom:12.0pt;margin-left:
0in;text-indent:0in'><b><span style='font-size:22.0pt;line-height:107%;
color:windowtext'>3.1.<span style='font:7.0pt "Times New Roman"'>&nbsp; </span></span></b><b><span
style='font-size:22.0pt;line-height:107%;color:windowtext'>GRID CREATION</span></b></h2>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.1.1.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>SOURCE
</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>National
Cultivated Layer: The Cultivated Layer is based on the most recent five years
(2013-2017).</span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.1.2.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>PROCESSING</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>The
National Cultivated Layer is a 30x30 m raster that classified each cell
depending if it was cultivated at least one year between 2013 and 2017 or not. </span></p>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>A
5x5 km was created using the same extent and for each cell the count of 30x30
cultivated cells was performed. Only cells whose count was positive were kept.
Each cell was identified by a unique number called id_5000.</span></p>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>Tiles
creation: another raster was created with a 100x100 km resolution. Each tile
was identified with a unique number called id_tile. The 5x5 raster was
overlapped with this 100x100km raster and the id_tile was transferred. This
allowed to group the 5x5 cells into tiles of 400 cells. </span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.1.3.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>SIZE</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>The
spatial file has 141,438 cells. Each one has an area of 5x5 km </span></p>

<h2 style='margin-top:12.0pt;margin-right:0in;margin-bottom:12.0pt;margin-left:
0in;text-indent:0in'><b><span style='font-size:22.0pt;line-height:107%;
color:windowtext'>3.2.<span style='font:7.0pt "Times New Roman"'>&nbsp; </span></span></b><b><span
style='font-size:22.0pt;line-height:107%;color:windowtext'>LAND ALLOCATION</span></b></h2>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.2.1.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>SOURCE
</span></b></h3>

<p class=MsoListParagraphCxSpFirst style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span style='font-family:"Arial",sans-serif'>National CDLs from
2008 to 2017. It is a 30 by 30 m raster where each cell is assigned to an id
that reference different use of the land</span></p>

<p class=MsoListParagraphCxSpLast style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><a
href="https://www.nass.usda.gov/Research_and_Science/Cropland/Release/"><span
style='font-family:"Arial",sans-serif'>https://www.nass.usda.gov/Research_and_Science/Cropland/Release/</span></a></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.2.2.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>PROCESSING</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>From
all the different uses in the National CDLs, we focused on 19 crops, called
Target Crops. They are: </span></p>

<table class=MsoTableGridLight border=1 cellspacing=0 cellpadding=0 width=366
 style='width:274.25pt;border-collapse:collapse;border:none'>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>1</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border:solid #BFBFBF 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>Corn</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>2</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Soybeans</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>3</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Winter Wheat</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>4</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Fallow/Idle Cropland</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>5</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Alfalfa</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>6</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Spring Wheat</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>7</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Cotton</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>8</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Sorghum</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>9</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Dbl Crop WinWht/Soybeans</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>10</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Rice</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>11</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Barley</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>12</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Dry Beans</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>13</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Durum Wheat</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>14</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>  Canola</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>15</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Oats</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>16</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Peanuts</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>17</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Almonds</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>18</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Sunflower</span></p>
  </td>
 </tr>
 <tr style='height:15.0pt'>
  <td width=64 nowrap valign=top style='width:48.0pt;border:solid #BFBFBF 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'>19</span></p>
  </td>
  <td width=302 nowrap valign=top style='width:226.25pt;border-top:none;
  border-left:none;border-bottom:solid #BFBFBF 1.0pt;border-right:solid #BFBFBF 1.0pt;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=MsoNormal style='margin-bottom:0in;line-height:normal'><span
  style='font-family:"Arial",sans-serif'> Peas.</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span style='font-family:"Arial",sans-serif'>&nbsp;</span></p>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>For
each of the id_5000, the count of 30x30 cells used for each crop each year was
performed. This value can easily be converted into area by considering the size
of the cells or into proportion of land allocation over the total size of the
cell. For example: if a cell has a count of corn in 2008 of 4500, this means
that from the 25 km2 of the cell, 4.05 km2 were used for corn. That is 16.2% of
the area.</span></p>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>A
second cleaning process was done over the spatial grid. The cells that did not
have any of the chosen 19 crops in the 10 considered years were removed. This
allows to decrease the size of the files and processing time.</span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.2.3.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>SIZE</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>The
land use table has 9,423,912 rows. Each row is the count of cells for a given
crop in a given year</span></p>

<h2 style='margin-top:12.0pt;margin-right:0in;margin-bottom:12.0pt;margin-left:
0in;text-indent:0in'><b><span style='font-size:22.0pt;line-height:107%;
color:windowtext'>3.3.<span style='font:7.0pt "Times New Roman"'>&nbsp; </span></span></b><b><span
style='font-size:22.0pt;line-height:107%;color:windowtext'>WEATHER</span></b></h2>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.3.1.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>SOURCE
</span></b></h3>

<p class=MsoListParagraphCxSpFirst style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
lang=ES-AR style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span lang=ES-AR style='font-family:"Arial",sans-serif'>Seminar: </span><a
href="https://www.youtube.com/watch?v=lR--GmLCkPU"><span lang=ES-AR
style='font-family:"Arial",sans-serif'>https://www.youtube.com/watch?v=lR--GmLCkPU</span></a></p>

<p class=MsoListParagraphCxSpMiddle style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span style='font-family:"Arial",sans-serif'>Daymetr package of R</span></p>

<p class=MsoListParagraphCxSpMiddle style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
lang=ES-AR style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span lang=ES-AR style='font-family:"Arial",sans-serif'>Catalog:
https://thredds.daac.ornl.gov/thredds/catalog/ornldaac/1328/catalog.html</span></p>

<p class=MsoListParagraphCxSpLast style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span style='font-family:"Arial",sans-serif'>User guide:
https://daac.ornl.gov/DAYMET/guides/Daymet_V3_CFMosaics.html</span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.3.2.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>PROCESSING</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>Four
variables were downloaded for the period 1980 to 2017. The variables are:
precipitation (prcp), maximum and minimum temperature (tmax, tmin) and solar
radiation (srad).  They were processed following 3 steps</span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.3.3.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>STEP
1: DOWNLOADING. </span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>This
was done using R studio and the function GET from the http package. For each of
the 4 variables, for each year a raster stack of 365 layers was download. Each
layer has daily data for a 1x1 km raster.</span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.3.4.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>STEP
2: TIME AGGREGATION</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>Each
of the stacks was time aggregated by month. In case of precipitation the daily
values were added by month. For the other variables, the daily values were
averaged by month.</span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.3.5.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>STEP
3: SPATIAL AGGREGATION</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>For
each of the id_5000 cells, the average values of all the 1x1 cells was obtained
and summarized in a data table.</span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.3.6.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>SIZE</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>The
weather data table has 191,789,928 rows. It is composed by the monthly value of
the four variables for the time period between 1980 and 2018 , for each of the
5x5 cells.</span></p>

<h2 style='margin-top:12.0pt;margin-right:0in;margin-bottom:12.0pt;margin-left:
0in;text-indent:0in'><b><span style='font-size:22.0pt;line-height:107%;
color:windowtext'>3.4.<span style='font:7.0pt "Times New Roman"'>&nbsp; </span></span></b><b><span
style='font-size:22.0pt;line-height:107%;color:windowtext'>SOILS</span></b></h2>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.4.1.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>SOURCE
</span></b></h3>

<p class=MsoListParagraphCxSpFirst style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span style='font-family:"Arial",sans-serif'>Source:
Soilgrids.com</span></p>

<p class=MsoListParagraphCxSpMiddle style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
lang=ES-AR style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span lang=ES-AR style='font-family:"Arial",sans-serif'>Catalog: </span><a
href="https://files.isric.org/soilgrids/data/recent/"><span lang=ES-AR
style='font-family:"Arial",sans-serif'>https://files.isric.org/soilgrids/data/recent/</span></a></p>

<p class=MsoListParagraphCxSpLast style='margin-top:12.0pt;margin-right:0in;
margin-bottom:12.0pt;margin-left:.5in;text-indent:-.25in;line-height:normal'><span
style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span style='font-family:"Arial",sans-serif'>Description of
variables: https://files.isric.org/soilgrids/data/recent/META_GEOTIFF_1B.csv</span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.4.2.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>PROCESSING</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>Different
variables that characterize soil chemical and physical properties were selected
(see above for the description of the variables). </span></p>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>The
raster files were downloaded from the soilgrid catalog. Then for each id_5000
cell they mean value of each soil variable was calculated. </span></p>

<h3 style='margin-left:0in;text-indent:0in'><b><span style='font-size:16.0pt;
line-height:107%;color:windowtext'>3.4.3.<span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></b><b><span style='font-size:16.0pt;line-height:107%;color:windowtext'>SIZE</span></b></h3>

<p class=MsoNormal style='margin-top:12.0pt;margin-right:0in;margin-bottom:
12.0pt;margin-left:0in;line-height:normal'><span style='font-family:"Arial",sans-serif'>The
soils data table has 1,697,256 rows. It is composed by the value of the 12
variables , for each of the 5x5 cells.</span></p>

<p class=MsoNormal><span style='font-family:"Arial",sans-serif'>&nbsp;</span></p>

<p class=MsoNormal>&nbsp;</p>

</div>

</body>

</html>
