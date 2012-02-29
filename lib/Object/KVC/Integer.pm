package Object::KVC::Integer;

use 5.008008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.03';

sub new {
	my ( $class, $number ) = @_;

	confess "integer required" 
	  unless defined($number);

	$number =~ s/^\s+|\s+$//g;

	confess "not an integer"
	  unless ( $number =~ /^\d+$/ );

	my $self = { INTEGER => $number };
	bless( $self, $class );

	return $self;
}

sub number { return $_[0]->{INTEGER}; }

sub as_string { return $_[0]->{INTEGER}; }

sub equals {
	my ( $self, $other ) = @_;

	if ( $other->isa('Object::KVC::Integer') ) {
		return $self->number() == $other->number();
	}
}

sub contains {
	my ( $self, $other ) = @_;
	return $self->equals($other);
}

sub intersects {
	my ( $self, $other ) = @_;
	return $self->equals($other);
}

sub gt {
	my ( $self, $other ) = @_;

	if ( $other->isa('Object::KVC::Integer') ) {
		return $self->number() > $other->number();
	}
}

sub lt {
	my ( $self, $other ) = @_;

	if ( $other->isa('Object::KVC::Integer') ) {
		return $self->number() < $other->number();
	}
}

sub incr {
	$_[0]->{INTEGER}++;
}

sub decr {
	$_[0]->{INTEGER}--;
}

1;
__END__

=head1 NAME

Object::KVC::Integer - Integer wrapper class

=head1 SYNOPSIS

  use Object::KVC::Integer;
  
  my $integer_1 = Object::KVC::Integer->new( 2 );
  my $integer_2 = Object::KVC::Integer->new( 3 );

  print $integer_1->as_string();

  $integer_1->equals( $integer_2 ) ? print "Yes, the objects are equal";

=head1 DESCRIPTION

Object::KVC::Integer is a integer wrapper class for use as a value
in a Object::KVC::Hash object.

=head1 METHODS

=head2 new()

The constructor.

   my $object = Object::KVC::Integer->new( 345 );

Integer to be wrapped must be provided as an argument. Leading and trailing
whitespace is stripped.

=head2 equals( <Object::KVC::Integer> )

Returns true if the wrapped integers are '=='

  $integer_1->equals( $integer_2 );

=head2 contains( <Object::KVC::Integer> )

Returns true if the wrapped integers are '=='

  $integer_1->contains( $integer_2 );

=head2 intersects( <Object::KVC::Integer> )

Returns true if the wrapped strings are '=='

  $integer_1->intersects( $integer_2 );

=head2 gt( <Object::KVC::Integer> )

Returns true if this integer object is '>' other

  $integer_1->gt( $integer_2 );

=head2 lt( <Object::KVC::Integer> )

Returns true if this integer object is '<' other

  $integer_1->lt( $integer_2 );

=head2 incr( <Object::KVC::Integer> )

Add 1 to the integer. '++'

  $integer_1->incr();

=head2 decr( <Object::KVC::Integer> )

Subtract 1 from the integer. '--'

  $integer_1->decr();

=head2 number()

Returns the integer value

  $integer_1->number();
  
=head2 as_string()

Returns the integer value

  $integer_1->as_string();

=head1 COPYRIGHT AND LICENSE

Object::KVC::Integer
Copyright (C) 2012  Trystan Johnson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.
