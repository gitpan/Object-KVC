use strict;
use warnings;

use Test::Simple tests => 12;

use Object::KVC::Set;
use Object::KVC::String;

my $s1 = Object::KVC::String->new("10.1.2.3");
my $s2 = Object::KVC::String->new("10.1.2.3");
my $s3 = Object::KVC::String->new("10.1.1.3");
my $s4 = Object::KVC::String->new("10.1.3.3");
my $s5 = Object::KVC::String->new("10.1.3.4");

ok( $s1->equals($s2), "equals" );

my $set1 = Object::KVC::Set->new();
my $set2 = Object::KVC::Set->new();

$set1->add($s1);
$set2->add($s2);

ok( $set1->equals($set2), "equals" );

$set2->add($s3);

ok( !$set1->equals($set2), "!equals - Set" );

ok( $set2->contains($set1), "contains - Set" );

ok( !$set1->contains($set2), "!contains - Set" );

ok( !$set1->equals($s1), "!equals - object" );

ok( $set2->includes($s1), "includes" );

my $union = $set1->union($set2);

ok( $union->equals($set2), "union" );

my $isect = $set1->intersection($set2);

ok( $isect->includes($s1) && $isect->size() == 1, "intersection" );

my $diff = $set2->difference($set1);

ok( $diff->includes($s3) && $diff->size() == 1, "difference" );

my $set3 = Object::KVC::Set->new();

$set3->add($s4);
$set3->add($s5);

ok( $set1->disjoint($set3), "disjoint" );

ok( $set3->size() == 2, "size" );