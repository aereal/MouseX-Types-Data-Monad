requires 'perl', '5.008001';

requires 'Data::Monad';
requires 'Mouse';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

