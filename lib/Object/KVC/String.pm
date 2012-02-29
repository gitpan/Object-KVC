package Object::KVC::String;

use 5.008008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.03';

sub new {
	my ( $class, $string ) = @_;

	confess "string required"
	  unless defined($string);

	$string =~ s/^\s+|\s+$//;

	my $self = { STRING => $string };
	bless( $self, $class );

	return $self;
}

sub as_string { return $_[0]->{STRING}; }

sub equals {
	my ( $self, $other ) = @_;

	if ( $other->isa('Object::KVC::String') ) {
		return $self->as_string() eq $other->as_string();
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

1;
__END__

=head1 NAME

Object::KVC::String - String wrapper class

=head1 SYNOPSIS

  use Object::KVC::String;
  
  my $string_1 = Object::KVC::String->new("some string");
  my $string_2 = Object::KVC::String->new("some string");

  print $string_1->as_string();

  $string_1->equals( $string_2 ) ? print "Yes, the objects are equal";

=head1 DESCRIPTION

Object::KVC::String is a string wrapper class for use as a value
in an Object::KVC::Hash object.

=head1 METHODS

=head2 new()

The constructor.

   my $object = Object::KVC::String->new( "string" );

String to be wrapped must be provided as an argument. Leading and trailing
whitespace is stripped.

=head2 equals( <Object::KVC::String> )

Returns true if the wrapped strings are 'eq'

  $string_1->equals( $string_2 );

=head2 contains( <Object::KVC::String> )

Returns true if the wrapped strings are 'eq'

  $string_1->contains( $string_2 );

=head2 intersects( <Object::KVC::String> )

Returns true if the wrapped strings are 'eq'

  $string_1->intersects( $string_2 );

=head2 as_string()

Returns the string value

  $string_1->as_string();

=head1 COPYRIGHT AND LICENSE

Object::KVC::String
Copyright (C) 2012  Trystan Johnson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.
