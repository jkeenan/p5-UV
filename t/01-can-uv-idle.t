use strict;
use warnings;

use UV::Idle ();

use Test::More;

# are all of the UV::Handle functions exportable as we expect?
can_ok('UV::Idle', (
    qw(new on close closed loop data),
    qw(active closing has_ref ref unref),
));

# are the extra methods also available?
can_ok('UV::Idle', (
    qw(start stop),
));


done_testing;
