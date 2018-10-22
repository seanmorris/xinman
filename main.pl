#! /usr/bin/env perl

use strict;
use warnings;
use Cwd            qw( abs_path );
use File::Basename qw( dirname );

my $devicesById   = {};
my $devicesByName = {};

my $appPath       = dirname(abs_path($0));

foreach(`xinput list`)
{
	/^.+?(\w.+?)\s+id=(\d+).+?$/;

	my $device = {
		name => $1
		, id => $2
	};

	$devicesById->{$2}   = $device;
	$devicesByName->{$1} = $device;
}

my $disableFileName = $appPath . '/auto/off';

if(! -e $disableFileName)
{
	exit;
}

my $disableFile;

open $disableFile, $disableFileName;

foreach(<$disableFile>)
{
	if(exists($devicesByName->{$_}))
	{
		my $id = $devicesByName->{$_}{id};

		printf STDERR "Disabling device #%d (%s).\n", $id, $_;

		`xinput disable $id`;
	}
}
