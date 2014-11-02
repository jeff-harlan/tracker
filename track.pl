#!/opt/local/bin/perl -w
#!/usr/local/bin/perl -w

use strict;
use WWW::Mechanize;
use JSON;
use Math::Trig qw(great_circle_distance great_circle_bearing deg2rad rad2deg cotan atan tan);

my $ip = "10.20.30.249";
my $port = "8080";
my @arr;

my $lat=37.2267;
my $lon=-121.9736;
my $alt=450;

my $uri = "http://$ip:$port/dump1090/data.json";

sub nesw { deg2rad( $_[0] ), deg2rad( 90 - $_[1] ) }

my $km;
my $deg;
my $elev;

my @us = nesw( $lon, $lat );
my @them;

my $www = WWW::Mechanize->new();

$www->get( $uri );

eval {
	my $json = JSON->new();
	my $text = $json->allow_nonref->utf8->relaxed->escape_slash->loose->allow_singlequote->allow_barekey->decode($www->content());
	foreach my $entry (@{$text}) {
		@arr = values %{$entry};
		if ( $arr[1] ) {
			print "@arr:";
			@them = nesw( $arr[10], $arr[3] );
			$km = great_circle_distance( @us, @them, 6378 );
			$deg = rad2deg( great_circle_bearing( @us, @them ));
			$elev = rad2deg( atan2( $arr[12] - $alt, 3280.8 * $km ));
			printf "%0.3f %0.3f\n", $deg,$elev;
		}
	}

};
if($@) {
	print STDERR "oops\n";
}

__DATA__

messages: validposition: track: lat: vert_rate: validtrack: squawk: seen: flight: speed: lon: hex: altitude:
