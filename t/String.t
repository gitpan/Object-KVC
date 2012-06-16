use strict;
use warnings;

use Test::Simple tests => 8;

use Object::KVC::String;

my $s1 = Object::KVC::String->new(" x");
my $s2 = Object::KVC::String->new("x");
my $s3 = Object::KVC::String->new("y");

eval { my $s4 = Object::KVC::String->new(); };

ok ( $@ =~ /string required/, "null input" );

ok( $s1->equals($s2), "equals" );

ok( !$s1->equals($s3), "!equals" );

ok( $s2->contains($s1), "contains" );

ok ( $s1->as_string() eq "x", "as_string");

ok ( $s1->intersects($s2), "intersects");

ok ( ! $s1->intersects($s3), "!intersects");

my $s4 = Object::KVC::String->new("string31");

my $s5 = Object::KVC::String->new("string11");

ok ( ! $s4->intersects($s5), "!intersects");