#!/bin/sh
#
#  This file was produced by running the Policy_sh.SH script, which
#  gets its values from config.sh, which is generally produced by
#  running Configure.  
#
#  The Policy.sh file gets overwritten each time
#  Configure is run.  Any variables you add to Policy.sh will be lost
#  unless you copy Policy.sh somewhere else before running Configure.
#
#  Allow Configure command-line overrides; usually these won't be
#  needed, but something like -Dprefix=/test/location can be quite
#  useful for testing out new versions.

#Site-specific values:

case "$perladmin" in
'') perladmin='postmaster@localhost.localdomain' ;;
esac

# Installation prefixes.  Allow a Configure -D override.  You
# may wish to reinstall perl under a different prefix, perhaps
# in order to test a different configuration.
# For an explanation of the installation directories, see the
# INSTALL file section on "Installation Directories".
case "$prefix" in
'') prefix="<%base%>/<%version%>" ;;
esac

# By default, the next three are the same as $prefix.  

case "$siteprefix" in
'') siteprefix="/usr/local" ;;
esac

case "$vendorprefix" in
'') vendorprefix="" ;;
esac

# Where installperl puts things.
case "$installprefix" in
'') installprefix="$prefix" ;;
esac

# Note that there are three broad hierarchies of installation 
# directories, as discussed in the INSTALL file under 
# "Installation Directories":
#
#  =item Directories for the perl distribution
#
#  =item Directories for site-specific add-on files
#
#  =item Directories for vendor-supplied add-on files
#
#  See Porting/Glossary for the definitions of these names, and see the
#  INSTALL file for further explanation and some examples.
# 
# WARNING:  Be especially careful about architecture-dependent and
# version-dependent names, particularly if you reuse this file for
# different versions of perl.

bin="$installprefix/bin"
scriptdir="$installprefix/bin"
privlib="$installprefix/lib"
archlib="$installprefix/lib/$(arch)-linux"
man1dir="$installprefix/man/man1"
man3dir="$installprefix/man/man3"
man1ext='1'
man3ext='3'
html1dir=' '
html3dir=' '

sitebin="$siteprefix/bin"
sitescript="$siteprefix/script"
sitelib="$siteprefix/lib/site_perl"
sitearch="$sitelib/$(arch)-linux"
siteman1dir="$siteprefix/man/man1"
siteman3dir="$siteprefix/man/man3"
sitehtml1dir=' '
sitehtml3dir=' '

# Use siteprefix rather than vendorprefix
#vendorbin="$sitebin"
#vendorscript="$sitescript"
#vendorlib="$siteprefix/share/perl/<%version%>"
#vendorarch="$vendorlib/$(arch)-linux"
#vendorman1dir="$siteman1dir"
#vendorman3dir="$siteman3dir"
#vendorhtml1dir=' '
#vendorhtml3dir=' '

#  Lastly, you may add additional items here.  For example, to set the
#  pager to your local favorite value, uncomment the following line in
#  the original Policy_sh.SH file and re-run   sh Policy_sh.SH.
#
pager='/usr/bin/less -FRSX'

#  A full Glossary of all the config.sh variables is in the file
#  Porting/Glossary.
