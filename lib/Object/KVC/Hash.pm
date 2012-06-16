package Object::KVC::Hash;

use 5.008008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.04';

sub new {
	my ( $class ) = @_;

	carp "constructor arguments not supported; use 'set'"
	  if ( scalar(@_) > 1 ); 

	return bless {}, $class;
}

sub set {
	my ( $self, $key, $value ) = @_;

	confess "invalid key"
	  unless ( defined($key) && length($key) );

	confess "undef is not a valid value for a property"
	  unless ( defined($value) );

	confess "$value not a valid object type for a property"
	  unless ( $value->can('equals') 
	  			&& $value->can('contains')
	  			&& $value->can('intersects')
	  			&& $value->can('as_string') );
 
	$self->{$key} = $value;
}

sub get {
	my ( $self, $key ) = @_;
	if ( defined( $self->{$key} ) ) {
		return $self->{$key};
	}
	else {
		confess $self->dump(),"\n undefined key $key. use 'has_defined' to
		  check for the existance of a key/value pair";
	}
}

sub has_defined {
	my ( $self, $key ) = @_;
	return 1 if defined $self->{$key};
}

sub delete_key {
	my ( $self, $key ) = @_;
	delete $self->{$key}
	  or carp "key $key delete error";
}

sub get_keys {
	return keys %{ $_[0] };
}

sub equals {
	my ( $self, $other ) = @_;

	if ( $other->isa(__PACKAGE__) ) {

		if ( scalar( keys %$self ) != scalar( keys %$other ) ) {
			return undef;
		}
	
		return $self->matches($other);
	}
}

sub matches {
	my ( $self, $other ) = @_;

	if ( $other->isa(__PACKAGE__) ) {

		foreach my $key ( keys %$other ) {
			if ( !defined( $self->{$key} ) ) {
				return undef;
			}
			if ( ! $self->{$key}->equals( $other->{$key} ) ) {
				return undef;
			}
		}
		return 1;
	}
}

sub intersects {
	my ( $self, $other ) = @_;

	if ( $other->isa(__PACKAGE__) ) {

		foreach my $key ( keys %$other ) {
			if ( !defined( $self->{$key} ) ) {
				return undef;
			}
			if ( ! $self->{$key}->intersects( $other->{$key} ) ) {
				return undef;
			}
		}
	
		return 1;
	}
}

sub contains {
	my ( $self, $other ) = @_;

	if ( $other->isa(__PACKAGE__) ) {

		foreach my $key ( keys %$other ) {
			if ( !defined( $self->{$key} ) ) {
				return undef;
			}
			if ( ! $self->{$key}->contains( $other->{$key} ) ) {
				return undef;
			}
		}
	
		return 1;
	}
}

sub contained_by {
	my ( $self, $other ) = @_;

	if ( $other->isa(__PACKAGE__) ) {

		foreach my $key ( keys %$other ) {
			if ( !defined( $self->{$key} ) ) {
				return undef;
			}
			if ( ! $other->{$key}->contains( $self->{$key} ) ) {
				return undef;
			}
		}
	
		return 1;
	}
}

sub clone {
	my ($self) = @_;
	my %clone = %$self;
	return bless( \%clone, ref $self ) ;
}

sub as_string {
	my ($self) = @_;
	my $string;
	foreach my $key  ( sort keys %$self ) {
		$string .= $key . " => " . $self->get($key) . " ";
	}
	return $string;
}

sub dump {
	my ($self) = @_;
	my $string;
	foreach my $key  ( sort keys %$self ) {
		$string .= $key . " => " . ref( $self->get($key) ) . " " . $self->get($key)->as_string() . "\n";
	}
	return $string;

}


1;
__END__

=head1 NAME

Object::KVC::Hash - Key Value Coding Hash object 

=head1 SYNOPSIS

  use Object::KVC::Hash;
  use Object::KVC::String;
  
  my $object1 = Object::KVC::Hash->new();
  my $object2 = Object::KVC::Hash->new();
  
  $object1->set( "id", Object::KVC::String->new("id1234") );
  $object2->set( "id", Object::KVC::String->new("id1234") );

  print $object1->get( "id" )->as_string();

  $object1->equals( $object2 ) ? print "Yes, the objects are equal";

=head1 DESCRIPTION

Object::KVC::Hash is a generic object which can be used to model
a variety of objects without having to write a large number
of classes.

Values must be wrapped in an object supporting the "equals,"
"contains," "intersects," and "as_string" methods.

The "equals," "contains," and "intersects," methods allow
two Object::KVC::Hash object properties to be compared.

The "equals," "contains," and "intersects" methods allow searching
of Object::KVC::Hash objects within an Object::KVC::List.

=head1 METHODS

=head2 new()

The constructor.

   my $object = Object::KVC::Hash->new();

No arguments.
   
=head2 clone()

Returns a new Object::KVC::Hash object with the same
key value pairs as the original object.

  my $cloned_object = $object->clone(); 

Does not copy the value objects.

=head2 set( <string>, <value object> )

Set a key value pair.

  $object->set( "key",  Object::KVC::String->new("string") );

Set throws an exception if the value object does not support
the required methods.

Same as:

  $object->{ "key" } = Object::KVC::String->new("string");

Without type checking.

=head2 get( <string> )

Get a value object.

  my $value = $object->get( "key" );

Throws an exception if the specified key if not defined.

Same as:

  my $value = $object->{"key"};

Without checking that the key is defined.

=head2 equals( $other<Object::KVC::Hash> )

Returns true if all keys exist in both objects and the
corresponding value objects are equal.

  $object1->equals( $object2 );
  
=head2 matches( $other<Object::KVC::Hash> )

Returns true if all keys in $object2 exist in $object1 and the
corresponding value objects are equal.

Returns false if $object2 has a key which does not exist in $object1.

  $object1->matches( $object2 );

=head2 intersects( $other<Object::KVC::Hash> )

Returns true if all keys in $object2 exist in $object1 and the
corresponding value objects intersect.

Returns false if $object2 has a key which does not exist in $object1.

  $object1->intersects( $object2 );

=head2 contains( $other<Object::KVC::Hash> )

Returns true if all keys in $object2 exist in $object1 and the
corresponding value objects in $object1 contain the corresponding 
value objects in $object2.

Returns false if $object2 has a key which does not exist in $object1.

  $object1->contains( $object2 );

=head2 contained_by( $other<Object::KVC::Hash> )

Returns true if all keys in $object2 exist in $object1 and the
corresponding value objects in $object2 contain the corresponding 
value objects in $object1.

Returns false if $object2 has a key which does not exist in $object1.

  $object1->contained_by( $object2 );

=head2 get_keys()

Returns 'ARRAY' of currently defined keys.

  my @keys = $object->get_keys()

Same as:

  my @keys = keys( %$object );

=head2 has_defined( <string> )

Returns true if a key value pair is defined.

  $object->has_defined( "key" );

Same as:

  defined( $object->{"key"} );

=head2 delete_key( <string> )

Delete a key value pair.

  $object->delete_key( "key" );

Same as.

  delete( $object->{"key"} );

=head2 as_string()

For debugging only.

=head2 dump()

For debugging only.

  print $object->dump();

=head1 COPYRIGHT AND LICENSE

Object::KVC::Hash
Copyright (C) 2012  Trystan Johnson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.
