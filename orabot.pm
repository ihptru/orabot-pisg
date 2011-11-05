package Pisg::Parser::Format::orabot;

# Documentation for the Pisg::Parser::Format modules is found in Template.pm
# timestamp: 2011-01-01T00:00:00

use strict;
$^W = 1;

sub new
{
    my ($type, %args) = @_;
    my $timestamp = '\d+-[\d\w]+-\d+[ T](\d+):\d+:\d+';
    my $self = {
        cfg => $args{cfg},
        normalline => '^\[?'.$timestamp.']? <(\S+)> (.*)',
        actionline => '^\[?'.$timestamp.']? \* (\S+) (.*)',
        thirdline  => '\[?'.$timestamp.']? \*\*\* (\S+) (\S+) (\S+) (\S+) ?(.*)?',
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

# Parses the 'third' line - (the third line is everything else, like
# topic changes, mode changes, kicks, etc.)
# thirdline() has to return a hash with the following keys, for
# every format:
#   hour            - the hour we're in (for timestamp logging)
#   min             - the minute we're in (for timestamp logging)
#   nick            - the nick
#   kicker          - the nick which kicked somebody (if any)
#   newtopic        - the new topic (if any)
#   newmode         - deops or ops, must be '+o' or '-o', or '+ooo'
#   newjoin         - a new nick which has joined the channel
#   newnick         - a person has changed nick and this is the new nick
# 
# It should return a hash with the following (for formatting lines in html)
#
#   kicktext        - the kick reason (if any)
#   modechanges     - data of the mode change ('Nick' in '+o Nick')
#
# The hash may also have a "repeated" key indicating the number of times
# the line was repeated. (Used by eggdrops log for example.)
sub thirdline
{
    my ($self, $line, $lines) = @_;
    my %hash;

    if ($line =~ /$self->{thirdline}/o) {

        $hash{hour} = $1;
        $hash{min}  = $2;
        $hash{nick} = $3;

        # Format-specific stuff goes here.

        return \%hash;

    } else {
        return;
    }
}

1;
