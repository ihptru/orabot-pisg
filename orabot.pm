package Pisg::Parser::Format::orabot;

# Documentation for the Pisg::Parser::Format modules is found in Template.pm
# timestamp: 2011-01-01T00:00:00

use strict;
$^W = 1;

sub new
{
    my ($type, %args) = @_;
    my $timestamp = '\d+-[\d\w]+-\d+[ T](\d+):\d+:\d+';
    my $thirdtimestamp = '\d+-[\d\w]+-\d+[ T](\d+):(\d+):\d+';
    my $self = {
        cfg => $args{cfg},
        normalline => '^\[?'.$timestamp.']? <(\S+)> (.*)',
        actionline => '^\[?'.$timestamp.']? \* (\S+) (.*)',
        thirdline  => '^\[?'.$thirdtimestamp.']? \*\*\* (\S+) (\S+) (\S+) (\S+) ?(.*)?',
    };

    bless($self, $type);
    return $self;
}

sub normalline
{
    my ($self, $line, $lines) = @_;
    my %hash;

    if ($line =~ /$self->{normalline}/o) {

        $hash{hour}   = $1;
        $hash{nick}   = $2;
        $hash{saying} = $3;

        return \%hash;
    } else {
        return;
    }
}

sub actionline
{
    my ($self, $line, $lines) = @_;
    my %hash;

    if ($line =~ /$self->{actionline}/o) {

        $hash{hour}   = $1;
        $hash{nick}   = $2;
        $hash{saying} = $3;

        return \%hash;
    } else {
        return;
    }
}

sub thirdline
{
    my ($self, $line, $lines) = @_;
    my %hash;

    if ($line =~ /$self->{thirdline}/o) {

        $hash{hour} = $1;
        $hash{min}  = $2;
        $hash{nick} = $3;

	if (($4.$5) eq 'waskicked') {
            $hash{kicker} = $7;
            ($hash{kicktext} = $hash{kicker}) =~ s/\S+\s*//;
            $hash{kicker} =~ s/\s.*//;
            $hash{kicktext} =~ s/^\((.*)\)$/$1/;
        } elsif (($4.$5) eq 'changestopic') {
            $hash{newtopic} = $7;
        } elsif (($4.$5) eq 'giveschannel') {
	    $hash{newmode} = "+o";
            $hash{modechanges} = $7;
	    $hash{modechanges} =~ s/^status to\s*//;
	} elsif (($5.$6) eq 'removeschannel') {
	    $hash{newmode} = "-o";
	    $hash{modechanges} = $7;
	    $hash{modechanges} =~ s/^status from\s*//;
        } elsif (($5.$6) eq 'hasjoined') {
            $hash{newjoin} = $3;
        } elsif (($5.$6) eq 'nowknown') {
            $hash{newnick} = $7;
            $hash{newnick} =~ s/^as\s*//;
        }
		
        return \%hash;

    } else {
        return;
    }
}

1;
