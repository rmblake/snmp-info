package SNMP::Info::Layer7::Eaton;

use strict;
use warnings;
use Exporter;
use SNMP::Info::Layer7;

@SNMP::Info::Layer7::Eaton::ISA       = qw/SNMP::Info::Layer7 Exporter/;
@SNMP::Info::Layer7::Eaton::EXPORT_OK = qw//;

our ($VERSION, %GLOBALS, %MIBS, %FUNCS, %MUNGE);

$VERSION = '0.01';

%MIBS = (
    %SNMP::Info::Layer7::MIBS,
    'XUPS-MIB'       => 'xupsIdentManufacturer',
    'UPS-MIB'        => 'upsIdentManufacturer',
    'EATON-OIDS'     => 'eaton',
    'EATON-EPDU-MIB' => 'partNumber'
);

%GLOBALS = (
    %SNMP::Info::Layer7::GLOBALS,
    'xos_ver'        => 'xupsAgentSoftwareVersion',
    'uos_ver'        => 'upsAgentSoftwareVersion',
    'pos_ver'         => 'firmwareVersion',
    'xups_serial'        => 'xupsIdentSerialNumber',
    'ups_serial'        => 'upsIdentSerialNumber',
    'pdu_serial'	=> 'serialNumber',
    'xmodel'         => 'xupsIdentModel',
    'model'         => 'upsIdentModel',
    'vendor'        => 'xupsIdentManufacturer',
    'pmodel'        => 'productName',
    'xuoutput'      => 'xupsOutputSource',
    'xubattstat'    => 'xupsBatteryAbmStatus'
);

%FUNCS = (
    %SNMP::Info::Layer7::FUNCS,

);

%MUNGE = (
    # Inherit all the built in munging
    %SNMP::Info::Layer7::MUNGE,
);


sub vendor {
    return 'eaton';
}

sub os {
    return 'eaton_os';
}

sub os_ver {
    my $eaton = shift;
    my $os_ver = $eaton->xos_ver() || $eaton->pos_ver() || 'unknown';
    return $os_ver if defined $os_ver;
}

sub model {
    my $eaton = shift;
    my $model = $eaton->xmodel() ||  $eaton->pmodel() || 'unknown';
    return $model if defined $model;
    
}

sub serial {
    my $eaton = shift;
    my $serial = $eaton->xups_serial() || $eaton->pdu_serial() ||  'unknown';
    return $serial if defined $serial;
    
}

# Power supply status methods
sub ps1_type {
    return 'UPS Status';
}

sub ps1_status {
    my $eaton = shift;
    my $status = $eaton->xuoutput();
    
    return $status if defined $status;
    return 'unknown';
}


sub ps2_type {
    return 'Battery Status';
}

sub ps2_status {
    my $eaton = shift;
    my $status = $eaton->xubattstat();
    
    return $status if defined $status;
    return 'unknown';
}

1;
__END__

=head1 NAME
SNMP::Info::Layer7::Eaton - SNMP Interface to Eaton UPS/PDU devices
=head1 AUTHOR
Rob Blake
=head1 SYNOPSIS
 # Let SNMP::Info determine the correct subclass for you.
 my $eaton = new SNMP::Info(
                          AutoSpecify => 1,
                          Debug       => 1,
                          DestHost    => 'myrouter',
                          Community   => 'public',
                          Version     => 2
                        )
    or die "Can't connect to DestHost.\n";


 my $class      = $eaton->class();
 print "SNMP::Info determined this device to fall under subclass : $class\n";

=head1 DESCRIPTION
Provides abstraction to the configuration information obtainable from an
Eaton UPS/PDU via SNMP.
=head2 Inherited Classes
=over
=item SNMP::Info::Layer7
=back
=head2 Required MIBs
=over
=item F<XUPS-MIB>
=item F<UPS-MIB>
=item F<EATON-OIDS>
=item F<EATON-EPDU-MIB>
=back
All required MIBs can be found in the netdisco-mibs package.
=head1 GLOBALS
These are methods that return scalar value from SNMP
=head2 Overrides
=over
=item $eaton->vendor()
Returns 'eaton'
=item $eaton->model()
Returns the UPS model
=item $eaton->serial()
Returns the UPS serial number
=back
=cut
