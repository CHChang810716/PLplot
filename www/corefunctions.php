<?php
	//
	// Print standard page header
	//
	function pageHeader($title="Main")
	{
		echo <<<END
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<!--
Copyright: Darren Hester 2006, http://www.designsbydarren.com
License: Released Under the "Creative Commons License", 
http://creativecommons.org/licenses/by-nc/2.5/
-->

<head>
  <title>PLplot Home Page - $title</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
  <meta name="description" content="Homepage of the open source PLplot project" />
  <meta name="keywords" content="plot,library,c++,python" />
  <link rel="stylesheet" title="liquid" href="css/style_liquid.css" type="text/css" media="screen,projection" />
  <link rel="alternate stylesheet" title="static" href="css/style_static.css" type="text/css" media="screen,projection" />
  <script type="text/javascript" src="js/slimbox.js"></script>
  <link rel="stylesheet" href="css/slimbox.css" type="text/css" media="screen" />
</head>

END;
	}

	//
	// Print menu code with selected element
	// $item might be: index, download, examples, development, credits
	//
	function pageMenu($item)#
	{
		echo "	<div id=\"pageheader\">\n";
		echo "	</div>\n";

		echo '	<div id="menubar">';
		echo '		<ul>';
		echo '		  <li><a href="index.php" ' . (($item=='index') ? ('id="selected"') : ('')) .'>Home</a></li>';
		echo '		  <li><a href="http://sourceforge.net/news/?group_id=2915" ' . (($item=='news') ? ('id="selected"') : ('')) .'>News</a></li>';
		echo '		  <li><a href="download.php" ' . (($item=='download') ? ('id="selected"') : ('')) .'>Download</a></li>';
		echo '		  <li><a href="examples.php" ' . (($item=='examples') ? ('id="selected"') : ('')) .'>Examples</a></li>';
		echo '		  <li><a href="documentation.php" ' . (($item=='documentation') ? ('id="selected"') : ('')) .'>Documentation</a></li>';
//		echo '		  <li><a href="development.php" ' . (($item=='development') ? ('id="selected"') : ('')) .'>Development</a></li>';
		echo '		  <li><a href="credits.php" ' . (($item=='credits') ? ('id="selected"') : ('')) .'>Credits</a></li>';
		echo '		</ul>';
		echo '	</div>';
	}

	//
	// Print a standard page footer
	//
	function pageFooter()
	{
		echo '		<div id="pagefooter">';
		echo '			<p>&copy; 2008 Plplot developer community.<br/>Design by <a href="http://DesignsByDarren.com">DesignsByDarren.com</a>, Some Rights Reserved.<br /><br/>';
		echo '			<a href="http://validator.w3.org/check?uri=referer"><img style="border:0;width:88px;height:31px" src="http://www.w3.org/Icons/valid-xhtml10" alt="Valid XHTML 1.0 Transitional" /></a>';
		echo '      <a href="http://jigsaw.w3.org/css-validator/check?uri=referer"><img style="border:0;width:88px;height:31px" src="http://jigsaw.w3.org/css-validator/images/vcss" alt="Valid CSS!" /></a>';
		echo '      </p>';
		echo '		</div>';
	}
	
	//
	// Print News from project page
	//
	function pageNews($newscount)
	{
		// Open the XML file for reading
		$fp = fopen("http://sourceforge.net/export/projnews.php?group_id=2915&limit=$newscount&flat=0&show_summaries=0","r")
		       or die("Error reading RSS data.");

		// Read the XML file 4KB at a time
		while ($data = fread($fp, 4096))
			// Parse each 4KB chunk with the XML parser created above
			echo $data;

					// Close the XML file
		fclose($fp);

		/* <?php include "http://sourceforge.net/export/projnews.php?group_id=2915&limit=3&flat=0&show_summaries=0" ?> */
	}

	//
	// Print a standard sidebar
	//
	function pageSidebar($news=0)
	{
		echo <<<END
		<!-- Sidebar -->
		<div id="rightside">
END;
//			Permanently disable and do another way (see above)
//                      because pageNews calls SF php script that returns
//			bad URL's.
		if(0) {
			echo "<h3>News</h3>\n";
			pageNews(3);
		}
		echo <<<END
			<h3>Resources</h3>
			<ul class="arrowlist">
				<li><a href="documentation.php">Documentation</a></li>
				<li><a href="http://www.miscdebris.net/plplot_wiki">Wiki</a></li>
				<li><a href="http://sourceforge.net/projects/plplot">SourceForge Project Page</a></li>
				<li><a href="http://sourceforge.net/projects/plplot/support">Project Support Page</a></li>
				<li><a href="http://sourceforge.net/mail/?group_id=2915">Mailing Lists</a></li>
				<li><a href="http://sourceforge.net/tracker/?group_id=2915&amp;tid=102915">Bug Tracker</a></li>
			</ul>
			<h3>Source Code</h3>
			<ul class="arrowlist">
				<li><a href="http://sourceforge.net/project/showfiles.php?group_id=2915&amp;package_id=2865">Download</a></li>
				<li><a href="http://sourceforge.net/svn/?group_id=2915">SVN Repository</a></li>
				<li><a href="http://plplot.svn.sourceforge.net/viewvc/plplot/">Browse SVN</a></li>
			</ul>

		</div>
END;
	}

?>
