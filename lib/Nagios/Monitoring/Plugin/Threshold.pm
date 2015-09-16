package Nagios::Monitoring::Plugin::Threshold;

use 5.006;

use strict;
use warnings;

use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw(warning critical));

use Nagios::Monitoring::Plugin::Range;
use Nagios::Monitoring::Plugin::Functions qw(:codes nagios_die);
our ($VERSION) = $Nagios::Monitoring::Plugin::Functions::VERSION;

sub get_status 
{
	my ($self, $value) = @_;

	$value = [ $value ] if (ref $value eq "");
	foreach my $v (@$value) {
		if ($self->critical->is_set) {
			return CRITICAL if $self->critical->check_range($v);
		}
	}
	foreach my $v (@$value) { 
		if ($self->warning->is_set) {
			return WARNING if $self->warning->check_range($v);
		}
	}
	return OK;
}

sub _inflate
{
    my ($self, $value, $key) = @_;

    # Return an undefined range if $value is undef
    return Nagios::Monitoring::Plugin::Range->new if ! defined $value;

    # For refs, check isa N::P::Range
    if (ref $value) {
        nagios_die("Invalid $key object: type " . ref $value)
            unless $value->isa("Nagios::Monitoring::Plugin::Range");
        return $value;
    }

    # Another quick exit if $value is an empty string
    return Nagios::Monitoring::Plugin::Range->new if $value eq "";

    # Otherwise parse $value
    my $range = Nagios::Monitoring::Plugin::Range->parse_range_string($value);
    nagios_die("Cannot parse $key range: '$value'") unless(defined($range));
    return $range;
}

sub set_thresholds
{
	my ($self, %arg) = @_;

    # Equals new() as a class method
    return $self->new(%arg) unless ref $self;

    # On an object, just acts as special mutator
    $self->set($_, $arg{$_}) foreach qw(warning critical);
}

sub set
{
    my $self = shift;
    my ($key, $value) = @_;
    $self->SUPER::set($key, $self->_inflate($value, $key));
}
		
# Constructor - inflate scalars to N::P::Range objects
sub new 
{
    my ($self, %arg) = @_;
    $self->SUPER::new({
        map { $_ => $self->_inflate($arg{$_}, $_) } qw(warning critical)
    });
}

1;

__END__

=head1 NAME

Nagios::Monitoring::Plugin::Threshold - class for handling Nagios::Monitoring::Plugin thresholds.

=head1 SYNOPSIS

    # NB: This is an internal Nagios::Monitoring::Plugin class.
    # See Nagios::Monitoring::Plugin itself for public interfaces.
  
    # Constructor
    $t = Nagios::Monitoring::Plugin::Threshold->set_thresholds(
        warning  => $warning_range_string,
        critical => $critical_range_string,
    );

    # Value checking - returns CRITICAL if in the critical range,
    # WARNING if in the warning range, and OK otherwise
    $status = $t->get_status($value);

    # Accessors - return the associated N::P::Range object
    $warning_range  = $t->warning;
    $critical_range = $t->critical;


=head1 DESCRIPTION

Internal Nagios::Monitoring::Plugin class for handling threshold data. See 
Nagios::Monitoring::Plugin for public interfaces.

A threshold object contains (typically) a pair of ranges, associated 
with a particular severity e.g.

  warning  => range1
  critical => range2

=head1 AUTHOR

This code is maintained by the Nagios Plugin Development Team: see
https://nagios-plugins.org/ .

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006-2015 Nagios Plugin Development Team

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
