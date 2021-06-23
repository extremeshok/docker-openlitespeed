<?php
$domain = $_SERVER['SERVER_NAME'];
$domain_parts = explode(".", $domain);

if ( ( "$domain_parts[0]" != "www" ) && ( "$domain_parts[0]" != "my" ) && ( "$domain_parts[0]" != "cdn" )  ) {
  $domain_name = $domain_parts[0];
  $email = "mail-at-". $domain;
} else {
  $domain_name = $domain_parts[1];
  $email = "mail-at-". $domain_parts[1] .".". $domain_parts[2];
        if ( ( "$domain_parts[3]" == "za" ) || ( "$domain_parts[3]" == "uk" ) ) {
                $email = $email .".". $domain_parts[3];
        }
}
#echo "DOMAIN: ". $domain;
#echo "DOMAIN_NAME: ". $domain_name;
#echo "EMAIL: ". $email;
?>
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title><?php echo $domain_name; ?></title>
	<meta name="description" content="<?php echo $domain_name; ?>">
	<meta name="author" content="https://extremeshok.com">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.0/build/pure-min.css" integrity="sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w" crossorigin="anonymous">
	<!--[if lt IE 9]>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.min.js" integrity="sha512-UDJtJXfzfsiPPgnI5S1000FPLBHMhvzAMX15I+qG2E2OAzC9P1JzUwJOfnypXiOH7MRPaqzhPbBGDNNj7zBfoA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<![endif]-->
	<!--[if lte IE 8]>
		<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.0/build/grids-responsive-old-ie-min.css">
	<![endif]-->
	<!--[if gt IE 8]><!-->
		<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.0/build/grids-responsive-min.css">
	<!--<![endif]-->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.15.3/css/fontawesome.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-backstretch/2.1.18/jquery.backstretch.min.js" integrity="sha512-bXc1hnpHIf7iKIkKlTX4x0A0zwTiD/FjGTy7rxUERPZIkHgznXrN/2qipZuKp/M3MIcVIdjF4siFugoIc2fL0A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  	<style>
		body {
			line-height: 1.7em;
			color: #000;
			background-color: #ddd;
			font-family: "Helvetica Neue", helvetica, arial, sans-serif;
			text-shadow: 1px 1px 16px rgba(255, 255, 255, 0.8);
			font-size: 34px;
			text-align: center;
			margin-top: 85px;
		}
		h1, h2, h3, h4, h5, h6, label { color: #fff; font-size: 42px; }
		h1 { text-transform: uppercase; font-size: 74px; }
	</style>
</head>

<body>
	<div class="pure-g">
		<div class="pure-u-1">
			<h1><?php echo $domain_name; ?></h1>
			<h4><?php echo $email; ?></h4>
		</div>
	</div>
  <div style="color: #ffffff;font-size:12px;position: absolute;clear:both;bottom: 0px;width: 100%;"><br>Powered by  <a style="color:#fff;" href="https://www.eXtremeSHOK.com">eXtremeSHOK.com</a></div>
</body>
<script>
/*
 * Here is an example of how to use Backstretch as a slideshow.
 * Just pass in an array of images, and optionally a duration and fade value.
 *
 * INFO: Duration is the amount of time in between slides,
 * INFO: and fade is value that determines how quickly the next image will fade in
 */
$.backstretch([
	"https://unsplash.it/g/1600?image=1015",
	"https://unsplash.it/g/1600?image=1016",
	"https://unsplash.it/g/1600?image=1017",
  "https://unsplash.it/g/1600?image=1018",
	"https://unsplash.it/g/1600?image=1019",
	"https://unsplash.it/g/1600?image=1020",
	"https://unsplash.it/g/1600?image=1021"
], {duration: 3000, fade: 750});
</script>
</html>
