package Object::KVC::String;

use 5.008008;
use strict;
use warnings;

our $VERSION = '0.02';

sub new {
	my ( $class, $string ) = @_;

	my $self = {
		STRING => "0xFFFFFFFF",   #Default value
	};
	bless( $self, $class );

	$self->_init($string) if defined($string);

	return $self;
}

sub _init {
	my ( $self, $string ) = @_;

	$string =~ s/^\s+//;
	$string =~ s/\s+$//;

	$self->{STRING} = $string;
}

sub as_string {
	return $_[0]->{STRING};
}

sub equals {
	my ( $self, $other ) = @_;

	if ( $other->isa('Object::KVC::String') ) {

		if ( $other->as_string() eq "0xFFFFFFFF" ) {
			return 1;
		}
	
		return ( $self->as_string() eq $other->as_string() );
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

   my $object = Object::KVC::String->new();

No arguments.

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