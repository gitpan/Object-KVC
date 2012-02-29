package Object::KVC::List;

use 5.008008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.03';

sub new {
	my ($class) = @_;
	return bless [], $class;
}

sub add {
	my ( $self, $object ) = @_;

	carp "Object::KVC::List::Entry object required"
	  unless ( $object->isa('Object::KVC::Hash') );

	push @$self, $object;
}

sub iter {
	return @{ $_[0] };
}

sub size {
	return scalar( $_[0]->iter() );
}

sub clone {
	my ($self) = @_;

	my $result = Object::KVC::List->new();

	foreach my $object ( $self->iter() ) {
		$result->add( $object->clone() );
	}

	return $result;
}

sub matches {
	my ( $self, $other, $result ) = @_;

	foreach my $object ( $self->iter() ) {
		if ( $object->matches($other) ) {
			$result->add($object);
		}
	}
}

sub contains {
	my ( $self, $other, $result ) = @_;

	foreach my $object ( $self->iter() ) {
		if ( $object->contains($other) ) {
			$result->add($object);
		}
	}
}

sub contained_by {
	my ( $self, $other, $result ) = @_;

	foreach my $object ( $self->iter() ) {
		if ( $object->contained_by($other) ) {
			$result->add($object);
		}
	}
}

sub search {
	my ( $self, $other, $result ) = @_;

	foreach my $object ( $self->iter() ) {
		if ( $object->matches($other) ) {
			$result->add($object);
		}
		elsif ( $object->contains($other) ) {
			$result->add($object);
		}
		elsif ( $object->contained_by($other) ) {
			$result->add($object);
		}
	}
}

sub _validate {
	my ( $self, $other, $result ) = @_;

	carp "other not defined"
	  unless ( defined $other );

	confess "container for result required"
	  unless ( defined $result );
}
1;

__END__

=head1 NAME

Object::KVC::List - Searchable container of Object::KVC::Hash objects

=head1 SYNOPSIS

  use Object::KVC::List;
  use Object::KVC::Hash;
  use Object::KVC::String;
  
  my $object_1 = Object::KVC::Hash->new();
  $object_1->set( "id",        Object::KVC::String->new("id1234") );
  $object_1->set( "last_name", Object::KVC::String->new("Hofstadter") );
  my $object_n = Object::KVC::Hash->new();    

  $object_n->set( "id", Object::KVC::String->new("id9999") );

  my $container = Object::KVC::List->new();

  $container->add( $object_1 );
  $container->add( $object_n );

  my $search = Object::KVC::Hash->new();
  $search->set( "id", Object::KVC::String->new("id1234") );

  my $search_result = Object::KVC::List->new();

  $container->matches( $search, $search_result );

  foreach my $object ( $search_result->iter() ) {
      print $object->get("last_name")->as_string() if ( $object->has_defined("last_name") );
      print "\n";
  }

=head1 DESCRIPTION

Object::KVC::List is a searchable 'ARRAY' based container of
Object::KVC::Hash objects.

=head1 METHODS

=head2 new()

The constructor.

   my $container = Object::KVC::List->new();

No arguments.
   
=head2 add( <Object::KVC::Hash> )

Add a new Object::KVC::Hash object to the container.

  $container->add( $object ); 

=head2 clone()

Return a new Object::KVC::List of cloned Object::KVC::Hash objects

  my $new_container = $container->clone(); 

Object::KVC::Hash->clone() does not clone the value objects in the
Object::KVC::Hash container elements.

=head2 iter()

Returns 'ARRAY' of the Object::KVC::Hash container elements.

  my @objects = $container->iter();

=head2 matches( $search<Object::KVC::Hash>, $result<Object::KVC::List> )

Store all objects which match $search in $result.

  $container->matches( $search, $result );

=head2 contains( $search<Object::KVC::Hash>, $result<Object::KVC::List> )

Store all objects which contain $search in $result.

  $container->contains( $search, $result );

=head2 contained_by( $search<Object::KVC::Hash>, $result<Object::KVC::List> )

Store all objects which are contained by $search in $result.

  $container->contained_by( $search, $result );

=head2 search( $search<Object::KVC::Hash>, $result<Object::KVC::List> )

Store all objects which match, contain or are contained by $search in $result.

Applies matches, contains, and contained_by in order.

  $container->search( $search, $result );

=head2 size()

Returns a count of the number of objects currently in the container.

  my $size = $container->size();

=head1 COPYRIGHT AND LICENSE

Object::KVC::List
Copyright (C) 2012  Trystan Johnson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.