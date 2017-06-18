use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME                    => 'Nagios::Monitoring::Plugin',
    AUTHOR                  => 'Nagios Plugin Development Team <devteam@nagios.com>',
    VERSION_FROM            => 'lib/Nagios/Monitoring/Plugin/Functions.pm', # finds $VERSION
    ABSTRACT_FROM           => 'lib/Nagios/Monitoring/Plugin.pm', # retrieve abstract from module
    LICENSE                 => 'perl',
    MIN_PERL_VERSION        => '5.006',
    META_MERGE => {
        resources => {
            repository      => 'https://github.com/nagios-plugins/nagios-plugin-perl',
        },
    },
    PREREQ_PM => {
        Params::Validate    => 0,
        Class::Accessor     => 0,
        Test::More          => 0.62,
        Carp                => 0,
        Config::Tiny        => 0,
        File::Spec          => 0,
        File::Basename      => 0,
        IO::File            => 0,
        Math::Calc::Units   => 0,           # used in N::P::Performance
    }, # e.g., Module::Name => 1.1
);
