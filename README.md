# Build Perl

Build one or more perl binaries.

Leave the system perl for the system and escape its single-release
multi-threaded trappings.  Now it's even easier to compile perl binaries for
your application code.  Just say what you want (5.22.1) and where you want it
(/opt/perl) then run get_perl.sh to deliver it.

Caveat: This perl is opinionated.  Namely

 1. It is not threaded.
 2. It is blind to 'perl5' directories; it sees no need for their existence.

You can override both of those, like most things, by using your own version of
tmpl/Policy.sh.  That first opinion is widely-shared, and the main reason you do
not want to use the perl that came with your OS -- leave that perl alone for
system purposes and use this perl for serious apps and other work.  That second
opinion is highly controversial, not widely shared, and does lead to a little
awkwardness when setting up a new project (because you have to nullify the perl5
directory as a recursive symbolic link so that cpanm works seamlessly).

When I create a new project layout, it usually includes the steps
```
mkdir -p lib dep/lib
(cd !$ && ln -s . perl5)
export PERL5LIB=lib:dep/lib
cpanm -l dep --install-deps .
```
and I look forward to the day when cpanminus has a way to forget about the
'perl5' dir.

http://praxilian.github.io/build-perl

http://github.com/praxilian/build-perl/wiki
