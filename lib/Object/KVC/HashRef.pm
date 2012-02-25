package Object::KVC::HashRef;

use 5.008008;
use strict;
use warnings;

our $VERSION = '0.02';

use Object::KVC::Hash;
our @ISA = qw(Object::KVC::Hash);

1;
__END__

=head1 NAME

Object::KVC::HashRef - An Object::KVC::HashRef object refers to
                       one or more Object::KVC::Hash objects
                       within a Object::KVC::List

=head1 SYNOPSIS

  use Object::KVC::HashRef;
  use Object::KVC::String;
  
  my $object1 = Object::KVC::HashRef->new();
  
  $object1->set( "type", Object::KVC::String->new("employee") );
  $object1->set( "id",   Object::KVC::String->new("id1234") );

=head1 DESCRIPTION

An Object::KVC::HashRef object refers to one or more
Object::KVC::Hash objects within a Object::KVC::List.

Object::KVC::HashRef inherits from Object::KVC::Hash. 

=head1 COPYRIGHT AND LICENSE

Object::KVC::HashRef
Copyright (C) 2012  Trystan Johnson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.