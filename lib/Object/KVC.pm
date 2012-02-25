package Object::KVC;

use 5.008008;
use strict;
use warnings;
use Object::KVC::Hash;
use Object::KVC::HashRef;
use Object::KVC::Integer;
use Object::KVC::List;
use Object::KVC::Set;
use Object::KVC::String;

our $VERSION = '0.02';

__END__

=head1 NAME

Object::KVC - Simple Key Value Coding

=head1 SYNOPSIS

  use Object::KVC;
  
  my $object1 = Object::KVC::Hash->new();
  my $object2 = Object::KVC::Hash->new();
  
  $object1->set( "id", Object::KVC::String->new("id1234") );
  $object2->set( "id", Object::KVC::String->new("id1234") );

  print $object1->get( "id" )->as_string();

  $object1->equals( $object2 ) ? print "Yes, the objects are equal";

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

Key Value Coding uses a hash key instead of an accessor method to 
access the values of an object.

Values must be wrapped in an object supporting the "equals,"
"contains," and "intersects" methods in order to allow two 
Object::KVC::Hash objects to be compared.

The "equals," "contains," and "intersects" methods allow searching
of Object::KVC::Hash objects within an Object::KVC::List.

=head1 COPYRIGHT AND LICENSE

Object::KVC
Copyright (C) 2012  Trystan Johnson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.