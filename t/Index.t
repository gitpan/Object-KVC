use strict;
use warnings;

use Test::Simple tests => 5;
use Object::KVC;

my $list = Object::KVC::List->new();

my $object1 = Object::KVC::Hash->new();
my $object2 = Object::KVC::Hash->new();
my $object3 = Object::KVC::Hash->new();

$object1->set( "id", Object::KVC::String->new("id1234") );
$object1->set( "property1", Object::KVC::String->new("a") );
$object1->set( "property2", Object::KVC::String->new("b") );
$object1->set( "property3", Object::KVC::String->new("x") );

$list->add($object1);

$object2->set( "id", Object::KVC::String->new("id1234") );
$object2->set( "property1", Object::KVC::String->new("a") );
$object2->set( "property2", Object::KVC::String->new("b") );

$list->add($object2);

$object3->set( "id", Object::KVC::String->new("id1234") );
$object3->set( "property1", Object::KVC::String->new("a") );
$object3->set( "property2", Object::KVC::String->new("m") );
$object3->set( "property5", Object::KVC::String->new("n") );

$list->add($object3);

my $index = Object::KVC::Index->new($list);
$index->make_index("id");

my $seta1 = $index->fetch("id1234");

my $seta2 = Object::KVC::Set->new();
$seta2->add($object1);
$seta2->add($object2);
$seta2->add($object3);

ok ( $seta1->equals($seta2), "single property" );

my $index2 = Object::KVC::Index->new($list);
$index2->make_index("id","property2");

eval { my $setb1 = $index2->fetch("id1234","x"); };
ok ( $@ =~ /not indexed/, "not indexed");

my $setb1 = $index2->fetch("id1234","b");

my $setb2 = Object::KVC::Set->new();
$setb2->add($object1);
$setb2->add($object2);

ok ( $setb1->equals($setb2), "two properties, two values" );

my $setb3 = Object::KVC::Set->new();
$setb3->add($object3);

my $setb4 = $index2->fetch("id1234","m");

ok ( $setb3->equals($setb4), "two properties, one value" );

my $index3 = Object::KVC::Index->new($list);

eval { $index3->make_index("idx"); };
ok ( $@ =~ /property in path/, "no property");


