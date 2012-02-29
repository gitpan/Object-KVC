package Object::KVC::Set;

use 5.008008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.03';

sub new {
	my ( $class ) = @_;
	return bless [], $class; 
}

sub add {
	my ( $self, $object ) = @_;

	confess "object required"
	  unless ( defined $object );

	confess "invalid object $object"
	  unless ( $object->can('equals') && $object->can('contains') );

	push @{$self}, $object;
}

sub first {
	return $_[0]->[0];
}

sub size {
	return scalar( @{ $_[0] } );
}

sub iter {
	return @{ $_[0] };
}

sub list {
	return $_[0];
}

sub equals {
	my ( $self, $other ) = @_;

	if ( $other->isa(__PACKAGE__) ) {

		if ( $self->size() != $other->size() ) {
			return undef;
		}

		foreach my $s ( $self->iter() ) {
			my $match = 0;
			foreach my $o ( $other->iter() ) {
				if ( $s->equals($o) ) {
					$match = 1;
				}
			}
			if ( !$match ) {
				return undef;
			}
		}

		return 1;
	}
}

sub contains {
	my ( $self, $other ) = @_;

	if ( $other->isa(__PACKAGE__) ) {
		
		#is every object in the other set contained
		#by something in this set?
		foreach my $o ( $other->iter() ) {
			my $match;
			
			foreach my $s ( $self->iter() ) {
	
				if ( $s->contains($o) ) {
					$match = 1;
					last;
				}
			}
			if ( !$match ) {
				return undef;
			}
		}
		return 1;
	}

	foreach my $s ( $self->iter() ) {
		return 1 if ( $s->contains($other) );
	}

	return 0;
}

#string version of contains
sub includes {
	my ( $self, $other ) = @_;

	#is the other Set a subset of this Set?
	if ( $other->isa(__PACKAGE__) ) {

		if ( $other->size() > $self->size() ) {
			return undef;
		}

		my $isect = $self->intersection($other);

		return $isect->size() == $other->size();
	}

	foreach my $s ( $self->iter() ) {

		if ( $s->equals($other) ) {
			return 1;
		}
	}
}

sub intersects {
	my ( $self, $other ) = @_;
	return 1 if ( $self->intersection($other)->size() >= 1 );		
}

sub intersection {
	my ( $self, $other ) = @_;

	confess "Set required"
	  unless $other->isa(__PACKAGE__);

	my $isect = __PACKAGE__->new();

	foreach my $s ( $self->iter() ) {
		foreach my $o ( $other->iter() ) {
			if ( $s->equals($o) ) {
				$isect->add($s);
				last;
			}
		}
	}

	return $isect;
}

sub union {
	my ( $self, $other ) = @_;

	confess "Set required"
	  unless $other->isa(__PACKAGE__);

	my $union = __PACKAGE__->new();

	foreach my $s ( $self->iter() ) {
		$union->add($s);
	}

	foreach my $o ( $other->iter() ) {
		if ( !$union->includes($o) ) {
			$union->add($o);
		}
	}
	return $union;
}

sub disjoint {
	my ( $self, $other ) = @_;
	my $isect = $self->intersection($other);
	return $isect->size() == 0;
}

sub difference {
	my ( $self, $other ) = @_;

	confess "Set required"
	  unless $other->isa(__PACKAGE__);

	my $diff = __PACKAGE__->new();

	foreach my $s ( $self->iter() ) {
		if ( !$other->contains($s) ) {
			$diff->add($s);
		}
	}

	return $diff;
}

sub as_string {
	my ( $self ) = @_;
	#carp "called as_string on Set";
	my $string;
	foreach my $s ( $self->iter() ) {
		$string .= $s->as_string()." ";
	}
	return $string;
}

1;
__END__

=head1 NAME

Object::KVC::Set - Set calculations on Object::KVC::Hash objects

=head1 SYNOPSIS

  use Object::KVC::Set;
  use Object::KVC::Hash;
  
  my $object_1 = Object::KVC::Hash->new();
  $object_1->set( "id", Object::KVC::String->new("id1234") );
  
  my $object_n = Object::KVC::Hash->new();    
  $object_n->set( "id", Object::KVC::String->new("id1234") );

  my $set1 = Object::KVC::Set->new();
  my $set2 = Object::KVC::Set->new();

  $set1->add( $object_1 );
  $set2->add( $object_n );

  my $intersection = $set1->intersection($set2);

  foreach my $object ( $intersection->iter() ) {
      print $object->get("last_name")->as_string() if ( $object->has_defined("last_name") );
      print "\n";
  }

=head1 DESCRIPTION

List based Set calculations on a set of Object::KVC::Hash objects
or any objects which implement 'equals' and 'contains' methods.

=head1 METHODS

=head2 new()

The constructor.

  my $set = Object::KVC::Set->new();

No arguments.
   
=head2 add( <object> )

Add a new object which has 'equals' and 'contains' methods to the Set.

  $set->add( $object ); 

=head2 iter()

Returns 'ARRAY' of the Set members.

  my @objects = $set->iter();

=head2 size()

Returns integer value of the Set cardinality.

  my $set_size = $set1->size();

=head2 equals( $set<Object::KVC::Set> )

Returns true if both sets are the same size and every object
in this Set has an equal object in the other Set.

  $set1->equals($set2);

=head2 contains( $set<Object::KVC::Set> or $other<object> )

Returns true if objects in this Set contain every object in the
other Set.

  $set1->contains( $set2 );

Returns true if an object in this Set contains the other object.

  $set1->contains( $object );

=head2 includes( $set<Object::KVC::Set> or $other<object> )

Returns true if objects in this Set equals every object in the
other Set.

  $set1->includes( $set2 );

Returns true if an object in this Set equals the other object.

  $set1->includes( $other );

=head2 difference( $set<Object::KVC::Set> )
 
Returns a Set with the relative complement, which is the set of 
objects in self, but not in other.

  $set1->difference( $set2 );

=head2 disjoint( $set<Object::KVC::Set> )

Returns true if the Sets are disjoint.

  $set1->disjoint( $set2 );

=head2 intersects( $set<Object::KVC::Set> )

Returns true if the Sets intersect.

  $set1->intersects( $set2 );

=head2 intersection( $set<Object::KVC::Set> )

Returns a Set containing the objects which exist in both Sets.

  $intersection = $set1->intersection( $set2 );

=head2 union( $set<Object::KVC::Set> )

Returns a Set containing all the objects which exist in both Sets.

  $union = $set1->union( $set2 );

=head1 COPYRIGHT AND LICENSE

Object::KVC::Set
Copyright (C) 2012  Trystan Johnson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.