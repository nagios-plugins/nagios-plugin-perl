use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile1(
    LICENSE => 'perl',
    MIN_PERL_VERSION => '5.006',
    META_MERGE => {
        resources => {
            repository => 'https://github.com/nagios-plugins/nagios-plugin-perl',
        },
    },
    #BUILD_REQUIRES => {
    #},

    NAME              => 'Nagios::Plugin',
    VERSION_FROM      => 'lib/Nagios/Plugin/Functions.pm', # finds $VERSION
    PREREQ_PM         => {
        Params::Validate    => 0,
        Class::Accessor     => 0,
        Test::More 	        => 0.62,
        Carp                => 0,
        Config::Tiny        => 0,
        File::Spec          => 0,
        File::Basename      => 0,
        IO::File            => 0,
        Math::Calc::Units   => 0,           # used in N::P::Performance
    }, # e.g., Module::Name => 1.1
    ABSTRACT_FROM => 'lib/Nagios/Plugin.pm',
    AUTHOR => 'Nagios Plugin Development Team <nagiosplug-devel@lists.sourceforge.net>',
);

sub WriteMakefile1 {  #Compatibility code for old versions of EU::MM. Written by Alexandr Ciornii, version 0.23. Added by eumm-upgrade.
    my %params=@_;
    my $eumm_version=$ExtUtils::MakeMaker::VERSION;
    $eumm_version=eval $eumm_version;
    die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
    die "License not specified" if not exists $params{LICENSE};
    if ($params{AUTHOR} and ref($params{AUTHOR}) eq 'ARRAY' and $eumm_version < 6.5705) {
        $params{META_ADD}->{author}=$params{AUTHOR};
        $params{AUTHOR}=join(', ',@{$params{AUTHOR}});
    }
    if ($params{TEST_REQUIRES} and $eumm_version < 6.64) {
        $params{BUILD_REQUIRES}={ %{$params{BUILD_REQUIRES} || {}} , %{$params{TEST_REQUIRES}} };
        delete $params{TEST_REQUIRES};
    }
    if ($params{BUILD_REQUIRES} and $eumm_version < 6.5503) {
        #EUMM 6.5502 has problems with BUILD_REQUIRES
        $params{PREREQ_PM}={ %{$params{PREREQ_PM} || {}} , %{$params{BUILD_REQUIRES}} };
        delete $params{BUILD_REQUIRES};
    }
    delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
    delete $params{MIN_PERL_VERSION} if $eumm_version < 6.48;
    delete $params{META_MERGE} if $eumm_version < 6.46;
    delete $params{META_ADD} if $eumm_version < 6.46;
    delete $params{LICENSE} if $eumm_version < 6.31;

    WriteMakefile(%params);
}

