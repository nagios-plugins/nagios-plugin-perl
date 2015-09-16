
use strict;
use Test::More tests => 3;
use_ok("Nagios::Monitoring::Plugin::Performance", use_die => 1);

eval { Nagios::Monitoring::Plugin::Functions::nagios_die("Testing") };
is( $@, "NAGIOS-MONITORING-PLUGIN-PERFORMANCE-02 UNKNOWN - Testing\n", "use_die correctly set on import");


use_ok("Nagios::Monitoring::Plugin::Performance");
eval { Nagios::Monitoring::Plugin::Functions::nagios_die("Test OK exit", 0) };

fail("Should not get here if code works correctly because prior nagios_die should have exited");
