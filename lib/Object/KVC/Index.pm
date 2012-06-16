package Object::KVC::Index;

use 5.008008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.04';

sub new {
	my ( $class, $container ) = @_;

	confess "container object required"
	  unless ( defined($container) );

	confess "Object::KVC::List object required"
	  unless ( $container->isa("Object::KVC::List") );

	my $self = {
		CONTAINER => $container,
		INDEX     => {},
	};

	bless $self, $class;

	return $self;
}

sub container { return $_[0]->{CONTAINER}; }
sub get_index { return $_[0]->{INDEX}; }

sub make_index {
	my $self       = shift;
	my @index_keys = @_;

	croak "list of keys are required" if ( !@index_keys );

	my $found_property;
	foreach my $object ( $self->container->iter() ) {

		my @path = $self->_path( $object, \@index_keys );

		next if ( !@path );

		$found_property = 1;

		my $next = $self->{INDEX};
		my $node;
		my $key;

		while (@path) {
			$key = shift @path;

			if ( !defined $next->{$key} ) {
				$next->{$key} = {};
			}

			$node = $next;
			$next = $next->{$key};
		}

		if ( ref($next) =~ /HASH/ ) {
			$node->{$key} = Object::KVC::Set->new();
		}

		$node->{$key}->add($object);
	}
	
	confess "property in path '",join(" ",@index_keys ),"' not found"
	  unless ( $found_property );
}

sub fetch {
	my $self       = shift;
	my @index_keys = @_;

	my $ref = $self->{INDEX};

	foreach my $key (@index_keys) {
		if ( ref($ref) ne "HASH" ) {
			confess "$key not indexed";	
		}
		elsif( ! defined $ref->{$key} ) {
			confess "$key not indexed";	
		}
		$ref = $ref->{$key};
	}

	return $ref;
}

#Given a list of object properties/keys, which describe the attributes of the
#object, return a list of the corresponding values in string format.
#The position of each value in the list will correspond to the nesting level in
#the Index data structure.

sub _path {
	my ( $self, $object, $index_keys ) = @_;

	my @path;

	foreach my $key (@$index_keys) {
		if ( $object->has_defined($key) ) {
			if ( !$object->get($key)->isa('Object::KVC::Hash') ) {
				push @path, $object->get($key)->as_string();
			}
			else {
				return;
			}
		}
		else {
			return;
		}
	}

	return @path;
}

1;

__END__

=head1 NAME

Object::KVC::Index - Object::KVC::Hash attribute grouping

=head1 SYNOPSIS

  use Object::KVC;
 
  my $list = Object::KVC::List->new();
 
  my $object1 = Object::KVC::Hash->new();
  my $object2 = Object::KVC::Hash->new();
  
  $object1->set( "id", Object::KVC::String->new("id1234") );
  $object2->set( "id", Object::KVC::String->new("id1234") );
  .
  .
  .
  More $object attributes
  
  $list->add($object1);
  $list->add($object2);
 
  my $index = Object::KVC::Index->new( $list );
  $index->make_index( "id" );

  my $set = $index->fetch( "id" );
    # $set is a Object::KVC::Set containing $object1 and $object2 

=head1 DESCRIPTION

Object::KVC::Index groups Object::KVC::Hash objects having one or 
more identical attributes (key/value pairs) into Object::KVC::Sets.

The Object::KVC::Sets set objects can then be looked up using the
string value of the value in each property.

=head1 METHODS

=head2 new()

The constructor. An Object::KVC::List must be provided.

  $index = Object::KVC::Index->new( $list<Object::KVC::List> );

=head2 make_index( "key1", "key2", "key3" ... )

All objects in the supplied $list, with equal values for the specified keys,
will be grouped into an Object::KVC::Set. 

Objects without the specified property/key will be skipped.

  $index->make_index( "key1", "key2", "key3" );

=head2 fetch()

Return the Object::KVC::Set of objects having the specified values.

  $set = $index->fetch( "value1", "value2", "value2" );

=head1 COPYRIGHT AND LICENCE

Object::KVC::Index
Copyright (C) 2012  Trystan Johnson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.
