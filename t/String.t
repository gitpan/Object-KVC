use strict;
use warnings;

use Test::Simple tests => 4;

use Object::KVC::String;

my $s1 = Object::KVC::String->new("x");
my $s2 = Object::KVC::String->new("x");
my $s3 = Object::KVC::String->new("y");
my $s4 = Object::KVC::String->new("z");

ok( $s1->equals($s2), "equals" );

ok( !$s1->equals($s3), "!equals" );

ok( $s2->contains($s1), "contains" );

ok ( $s1->as_string() eq "x", "as_string");
