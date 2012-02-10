use strict;
use warnings;

use Test::Simple tests => 4;

use Object::KVC::List;
use Object::KVC::Hash;
use Object::KVC::String;

my $ce1 = Object::KVC::Hash->new();
my $ce2 = Object::KVC::Hash->new();
my $ce3 = Object::KVC::Hash->new();
my $search = Object::KVC::Hash->new();

$ce1->set( "S1", Object::KVC::String->new("string11") );
$ce1->set( "D1", Object::KVC::String->new("string12") );

$ce2->set( "S1", Object::KVC::String->new("string21") );
$ce2->set( "D1", Object::KVC::String->new("string22") );

$ce3->set( "S1", Object::KVC::String->new("string31") );
$ce3->set( "D1", Object::KVC::String->new("string32") );

$search->set( "S1", Object::KVC::String->new("string31") );
$search->set( "D1", Object::KVC::String->new("string32") );

my $container = Object::KVC::List->new();

$container->add($ce1);
$container->add($ce2);
$container->add($ce3);

my $search_result;
 
$search_result = Object::KVC::List->new();
$container->matches($search, $search_result);

ok ( scalar( $search_result->iter() ) == 1, "matches" );

$search_result = Object::KVC::List->new();
$container->contains($search, $search_result);

ok ( scalar( $search_result->iter() ) == 1, "contains" );

$search_result = Object::KVC::List->new();
$container->contained_by($search, $search_result);

ok ( scalar( $search_result->iter() ) == 1, "contained_by" );

$search_result = Object::KVC::List->new();
$container->search($search, $search_result);

ok ( scalar( $search_result->iter() ) == 1, "search" );
