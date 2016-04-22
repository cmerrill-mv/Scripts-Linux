#
#  (c) Copyright 1998-2004 Quest Software, Inc
#  ALL RIGHTS RESERVED
#
#  Quest Software, Inc.
#  4473 Willow Road, Suite 200
#  Pleasanton, CA 94588
#
#  DESCRIPTION
#      This script counts up the number of events that occured over a period
#      of time.  These events are totaled based on event type, instance,
#      and rule template name.
#
#  AUTHOR
#      Charles Merrill
#

use strict;

# Must set FGLHOME for program to run.
my $fgl_home = $ENV{'FGLHOME'};
if ($fgl_home eq "") {
    print "Please set FGLHOME and rerun\n";
    exit;
}

##### Declare variables  #####
my ($pre, $post, $begind, $begint, $endd, $endt, @ID4, $ID5, $Severity);
##########################
##### set test inputs ####
##### comment for use  ###
# $fgl_home = "/opt/foglight";
# $begind = "03/01/2004";
# $begint = "12:00:00";
# $endd = "04/10/2004";
# $endt = "12:00:00";
##### end test inputs ####
##########################

if (@ARGV ne 4) {
    print "\n\n usage: eventcount.pl <BegDate> <BegTime> <EndDate> <EndTime>\n";
    print "    where:\n";
    print "    <BegDate> : Date to start the counting from MM/DD/YY\n";
    print "    <BegTime> : Time of day to begin counting: HH:MM:SS\n";
    print "    <EndDate> : Date to end counting: MM/DD/YY\n";
    print "    <EndTime> : Time to day to end counting: HH:MM:SS\n\n";
    exit;
}

### begin date, begin time ##
$begind = $ARGV[0];
$begint = $ARGV[1];
##### end date, end time ####
$endd = $ARGV[2];  
$endt = $ARGV[3];

print "\nEvents fired from:  $begind $begint  to:  $endd $endt\n\n";
#print "    FGLHOME: $fgl_home\n\n";
  
open ( DBEXPORT, "\"$fgl_home/foglight\" dbexport -g neInfo -t neEventLog -F ID,Severity -b $begind $begint -e $endd $endt -D= | " ) or die " $! -- $?\n";

my %fired; # will hold all alert data

while ( <DBEXPORT> ) {
	next if ( /^\s?$/ ); # skip blanks

	chomp;

	my ( $pre, $Severity ) = split /=/, $_;
# attempt to split $ID at the first [ for the subtotals section #####

        my ($ID,$post) = split (/\[/,$pre);

##### setup for the totals section #####

        my ($ID1,$junk) = split (/\[/,$pre);
#       print "$ID1\n";
#       print "$pre\n";
#       print "$post\n";

        my ($ID2,$rule2) = split (/\:/,$ID1);
#       print "ID2 is $ID2\n";
#       print "$pre\n";
#       print "rule2 is $rule2\n";

        my ($ID3,$host3) = split (/\@/,$ID2);
#       print "ID3 is $ID3\n";
#       print "$pre\n";
#       print "rule2 is $rule2\n";
#       print "host3 is $host3\n";

#       my (@ID4) = ($ID3, ":", $rule2);
        my @ID4 = ($ID3, ":", $rule2);
#       my $ID5 = @ID4[0,1,2] ;
        my $ID5 = "$ID4[0] $ID4[1] $ID4[2]";
        my @ID6 = ($ID5, $Severity);
#	print "ID4 is @ID4\n";
#	print "ID5 is $ID5\n";
#	print "Severity is $Severity\n";
#	print "\@ID6 is @ID6\n";

##### end setup for totals section #####


#	if ( $ENV{'debug'} ) { print "DEBUG:: ID $ID and Severity $Severity\n"; }

###### totals section #####

	if ( $fired{$ID5} ) {
		my @tempArray = @{ $fired{$ID5} };

		my ( $warn, $crit, $fat, $clar ) = @tempArray;

		$warn++ if ( $Severity =~ /warn/i );
		$crit++ if ( $Severity =~ /crit/i );
		$fat++  if ( $Severity =~ /fat/i );
		$clar++ if ( $Severity =~ /clear/i );

		undef @tempArray;

		@tempArray = ( $warn, $crit, $fat, $clar );

		delete $fired{$ID5};

		$fired{$ID5} = [ @tempArray ];
	} else {
		my ( $warn, $crit, $fat, $clar );

		if ( $Severity =~ /warn/i )  { $warn++; } else { $warn = '0'; }
		if ( $Severity =~ /crit/i )  { $crit++; } else { $crit = '0'; }
		if ( $Severity =~ /fat/i )   { $fat++; }  else { $fat = '0'; }
		if ( $Severity =~ /clear/i ) { $clar++; } else { $clar = '0'; }

		my @tempArray = ( $warn, $crit, $fat, $clar );

		$fired{$ID5} = [ @tempArray ];
	}


##### end totals section ######

###### subtotals section #####

        if( $fired{$ID} ) {
                my @tempArray = @{ $fired{$ID} };

                my ( $warn, $crit, $fat, $clar ) = @tempArray;

                $warn++ if ( $Severity =~ /warn/i );
                $crit++ if ( $Severity =~ /crit/i );
                $fat++  if ( $Severity =~ /fat/i );
                $clar++ if ( $Severity =~ /clear/i );

                undef @tempArray;

                @tempArray = ( $warn, $crit, $fat, $clar );

                delete $fired{$ID};

                $fired{$ID} = [ @tempArray ];
        } else {
                my ( $warn, $crit, $fat, $clar );

                if ( $Severity =~ /warn/i )  { $warn++; } else { $warn = '0'; }
                if ( $Severity =~ /crit/i )  { $crit++; } else { $crit = '0'; }
                if ( $Severity =~ /fat/i )   { $fat++; }  else { $fat = '0'; }
                if ( $Severity =~ /clear/i ) { $clar++; } else { $clar = '0'; }

                my @tempArray = ( $warn, $crit, $fat, $clar );

                $fired{$ID} = [ @tempArray ];
        }
}

##### end subtotals section ######

##### print the totals #####
print "Template:Rule                                   Warn  Crit Fatal Norm Total\n";
print "---------------------------------------------------------------------------\n";

my ($rw, $rc, $rf, $rn, $rt) = 0;
foreach my $rule ( keys %fired ) {
    my $ID = $rule;
    if ($ID =~ /\ :/) {
        my @tempArray = @{ $fired{$ID} };
        my ( $w, $c, $f, $n ) = @tempArray;
        my $t = $w + $c + $f + $n;
        # running totals
        $rw = $rw + $w;
        $rc = $rc + $c;
        $rf = $rf + $f;
        $rn = $rn + $n;
        $rt = $rt + $t;
        printf "%-45.45s %5d %5d %5d %5d %5d\n", $ID, $w, $c ,$f, $n, $t;
    }
}
print "---------------------------------------------------------------------------\n";
printf "%-45.45s %5d %5d %5d %5d %5d\n\n", "Totals", $rw, $rc, $rf, $rn, $rt;

##### print the totals #####
print "Instance:Rule                                  Warn  Crit  Fatal Normal Tot\n";
print "---------------------------------------------------------------------------\n";

##### print the subtotals #####
my ($iw, $ic, $if, $in, $it) = 0;
foreach my $rule ( keys %fired ) {
        my $ID = $rule;
        if ( $ID =~ /\@/ ) {
        my @tempArray = @{ $fired{$ID} };

        my ( $w, $c, $f, $n ) = @tempArray;
        my $t = $w + $c + $f + $n;
        # running totals
        $iw = $iw + $w;
        $ic = $ic + $c;
        $if = $if + $f;
        $in = $in + $n;
        $it = $it + $t;
        printf "%-45.45s %5d %5d %5d %5d %5d\n", $ID, $w, $c ,$f, $n, $t;
    }
}
print "---------------------------------------------------------------------------\n";
printf "%-45.45s %5d %5d %5d %5d %5d\n\n", "Totals", $iw, $ic, $if, $in, $it;
