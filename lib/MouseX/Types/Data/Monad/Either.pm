package MouseX::Types::Data::Monad::Either;

use strict;
use warnings;

use Carp qw( croak );
use Mouse::Util::TypeConstraints;

subtype 'Either', # `Maybe` is already defined by Mouse
  as 'Data::Monad::Either',
  (
    constraint_generator => sub {
      my ($type_parameter) = @_;
      my $check = $type_parameter->_compiled_type_constraint;

      # type_constraints is a ArrayRef that sorted by name,
      # so the first element from valid type constraints must be Left type
      my ($left_t, $right_t) = @{ $type_parameter->{type_constraints} // [] };
      croak 'Either must have Left and Right type constraints'
        unless defined($left_t) && ($left_t =~ m/\ALeft\[?/) && defined($right_t) && ($right_t =~ m/\ARight\[?/);

      return sub {
        my ($either) = @_;
        return $either->is_right ? $right_t->check($either) : $left_t->check($either);
      };
    }
  );

subtype 'Left',
  as 'Data::Monad::Either::Left',
  (
    constraint_generator => sub {
      my ($type_parameter) = @_;
      my $check = $type_parameter->_compiled_type_constraint;

      return sub {
        my ($left) = @_;
        my ($result) = $check->($left->value); # Data::Monad::Either#value is context-aware method
        return $result;
      };
    }
  );

subtype 'Right',
  as 'Data::Monad::Either::Right',
  (
    constraint_generator => sub {
      my ($type_parameter) = @_;
      my $check = $type_parameter->_compiled_type_constraint;

      return sub {
        my ($right) = @_;
        my ($result) = $check->($right->value); # Data::Monad::Either#value is context-aware method
        return $result;
      };
    }
  );

1;
