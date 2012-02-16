#!/usr/bin/perl

# A simple command-line tool for sending an SMS message

use 5.010 ;
use strict ;
use Carp ;
use Cwd 'abs_path' ;
use Data::Dumper ;
use IO::Interactive qw{ interactive } ;
use WWW::Twilio::API ;
use YAML qw{ LoadFile } ;

my $twilio_conf = get_twilio_conf() ;

my $status = join ' ', @ARGV ;
if ( length $status < 1 ) {
    while ( <STDIN> ) {
        $status .= $_ ;
        }
    chomp $status ;
    }

if ( length $status < 1 ) {
    say { interactive } 'No content' ;
    say { interactive } length $status ;
    exit ;
    }

my $twilio = WWW::Twilio::API->new(
    AccountSid => $twilio_conf->{ account_sid },
    AuthToken  => $twilio_conf->{ auth_token },
    ) ;

my $from     = $twilio_conf->{ from } ;
my $to       = $twilio_conf->{ to } ;
my $response = $twilio->POST(
    'SMS/Messages',
    From => $from,
    To   => $to,
    Body => $status,
    ) ;

say { interactive } $status ;

exit ;

#========= ========= ========= ========= ========= ========= =========

sub get_twilio_conf {
    my $twilio_conf = $ENV{ HOME } . '/.twilio.conf' ;
    my $config ;
    if ( defined $twilio_conf && -f $twilio_conf ) {
        $config = LoadFile( $twilio_conf ) ;
        }
    else {
        croak 'No configuration file' ;
        }
    return $config ;
    }

