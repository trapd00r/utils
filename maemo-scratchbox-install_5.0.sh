#!/bin/sh
# Copyright (C) 2006-2009 Nokia Corporation
#
# This is proprietary software owned by Nokia Corporation.
# 
# Contact: Maemo Integration <integration@maemo.org>
# Version: $Revision: 2041 $
#
# Exit codes:
#   3 failed to download
#   2 failed to extract tar balls
#   1 other error
#
#   0 success
#

__self=`basename $0`

# Release configuration
__maemo_version=5.0
__maemo_release=fremantle
__target_toolchain=cs2007q3-glibc2.5

# Target configuration for armel
__armel_toolchain=${__target_toolchain}-arm
__armel_devkits=perl:debian-etch:qemu:doctools:autotools-legacy:python-legacy:svn:git
__armel_cputransp=qemu-arm-sb

# Target configuration for i386
__i386_toolchain=${__target_toolchain}-i386
__i386_devkits=perl:debian-etch:doctools:autotools-legacy:python-legacy:svn:git

# Scratchbox 
__scratchbox_version=1.0.26
__scratchbox_require=1.0.26
__scratchbox_release=apophis
__scratchbox_repository='deb http://scratchbox.org/debian/ fremantle main'
# FIXME Only removes first linefeed from line
# __scratchbox_devkits=`echo "$__armel_devkits $__i386_devkits" | sed "s,:,\n,g" | sort -u | sed "s,\n,\ ,g"`

# Defaults
__default_group=sbox
__default_scratchbox=/scratchbox

# Apt
__sources_dir=/etc/apt/sources.list.d
__sources_file=maemo5.0_scratchbox.list
__scratchbox_packages="scratchbox-core \
scratchbox-devkit-apt-https \
scratchbox-devkit-autotools-legacy \
scratchbox-devkit-debian \
scratchbox-devkit-doctools \
scratchbox-devkit-git \
scratchbox-devkit-perl \
scratchbox-devkit-python-legacy \
scratchbox-devkit-qemu \
scratchbox-devkit-svn \
scratchbox-libs \
scratchbox-toolchain-cs2007q3-glibc2.5-arm7 \
scratchbox-toolchain-cs2007q3-glibc2.5-i486 \
scratchbox-toolchain-host-gcc"

arch='i386'
delim='_'
suffix='.deb'

# Check for i386
echo -n "Running on i386 architecture... "
__uname_m=`uname -m`
if [ `expr match "$__uname_m" "i[3-6]86"` != 4 ] ; then
        echo "no. Assuming amd64."
        arch='amd64'
else
	echo "yes"
fi

# Shows usage text
usage() {
	cat <<EOF
Usage: $__self [OPTIONS]

Installer for Scratchbox $__scratchbox_version '$__scratchbox_release' release.
Scratchbox is a cross-compilation toolkit for Linux. This script installs
version which is suited for maemo $__maemo_version '$__maemo_release' release development.
This script cannot be used to update an existing installation.

 * Checks for compatibility of your Linux environment.
 * Downloads scratchbox packages from scratchbox.org
 * Installs Scratchbox to your computer

On Debian-based distributions, the toolkit will be installed per default
from Debian .deb packages. Packages install to default path /scratchbox .

On any other Linux distribution: the install will use .tar.gz files
which can be installed to any given path which ends in /scratchbox
e.g. to /scratchbox or /opt/scratchbox .


Options:
	-v	Display version and exit.
	-h	Show this usage guide.
	-c	Use existing downloads, don't try to download again.
	-a	Use APT for installation of the packages.
		(default on Debian based systems)
	-d	Install from Debian packages using wget and dpkg.
	-U	Attempt an upgrade on a system that already has scratchbox.
	-s PATH	Install from .tar.gz to path (to e.g. $__default_scratchbox).
	-g NAME	Specify Scratchbox user group (default $__default_group)
	-u USER	Specify users to add to Scratchbox (separated by commas).

EOF
}

# Show version information
version() {
	echo "Installer for Scratchbox $__scratchbox_version '$__scratchbox_release' release. ($Rev: 2041 $)"
}

# Fail in case str is empty and print out message
# empty (str,msg)
empty () {
	local str
	local message
	str=$1
	message=$2
	if [ "x$str" = "x" ] ; then
		echo "E: Program error. $message"
		echo "E: If this problem persists, please report to <integration@maemo.org>"
		exit 1
	fi
}

# Downloads file in url given with parameter
# download (outdir,url)
#	outdir must be non-empty
#	url must be non-empty
download() {
	local outdir
	local url
	local file
	outdir=$1
	url=$2
	file=`basename $url`
	empty "$outdir" "Download output directory string must be non-empty."
	empty "$url"  "Download URI string must be non-empty."
	# TODO Add timeout to file download
	$__wget -P $outdir $url
	if [ $? != 0 ] ; then
		echo "E: Couldn't retrieve file '$file'."
		exit 3
	fi
	# TODO Check that downloaded file is readable from path
}

# Test if string ends with given match
# string_endswith (string,match)
#	string must be non-empty
#	match must be non-empty
string_endswith() {
	local string
	local match
	string=$1
	match=$2
	empty "$string" "String to be checked must be non-empty."
	empty "$match" "Match to be checked must be non-empty."
	echo "$string" | grep -q "$match\$"
	return $?
}

# Run gunzip archive integrity check on file
# test_integrity (file)
#	file must be non-empty
test_integrity() {
	local file
	file=$1
	empty "$file" "File to be checked must be non-empty."
	# deb
	if string_endswith "$file" ".deb" ; then
		# control file present
		ar p $file control.tar.gz | gunzip -qt 2>/dev/null
		if [ $? -ne 0 ] ; then
			return $?
		fi
		# data file present
		ar p $file data.tar.gz | gunzip -qt 2>/dev/null
		if [ $? -ne 0 ] ; then
			return $?
		fi
		# debian-binary file present
		ar p $file debian-binary >/dev/null
		return $?
	fi
	# tar.gz
	if string_endswith "$file" ".tar.gz" ; then
		gunzip -qt $file 2>/dev/null
		return $?
	fi
	# don't know how to check
	echo "E: Don't know how to check file '$file'."
	exit 1
}

# Test if running this script on Debian or derivative distribution
# has_debian ()
has_debian () {
	if [ -r /etc/debian_version ] ; then
		return 0
	fi
	return 1
}

# Test if the environment supports the use of sources.list.d
has_new_apt () {
	if [ -d /etc/apt/sources.list.d ] ; then
		return 0
	fi
	return 1
}

# Scratchbox installation has toolchain installed
# TODO Add more toolchain sanity tests
# has_toolchain (scratchbox,toolchain)
# 	toolchain must be non-empty
has_toolchain() {
	local scratchbox
	local toolchain
	scratchbox=$1
	toolchain=$2
	empty "$toolchain" "Scratchbox toolchain string must be non-empty."
	if [ -d $scratchbox/compilers/$toolchain ] ; then
		return 0
	fi
	return 1
}

# Scratchbox installation has devkit installed
# TODO Add more devkit sanity tests
# TODO Required devkit minimum version check
# has_devkit (scratchbox,devkit)
# 	devkit must be non-empty
has_devkit() {
	local scratchbox
	local devkit
	scratchbox=$1
	devkit=$2
	empty "$devkit" "Scratchbox devkit string must be non-empty."
	if [ -d $scratchbox/devkits/$devkit ] ; then
		return 0
	fi
	return 1
}

# Scratchbox installation has sessions running 
# has_sessions (scratchbox)
has_sessions() {
	local scratchbox
	scratchbox=$1
	if ! $scratchbox/tools/bin/sb-conf list --targets 2>&1 | grep -q "^sbrsh-conf: No current target$" 1>/dev/null; then
		if [ `$scratchbox/tools/bin/sb-conf list --sessions | wc -l` -gt 1 ] ; then
			return 0
		fi
	fi
	return 1
}

# Download a file from url to dest directory
# get_file (url, dest, cached, description)
get_file () {
	local url
	local dest
	local cached
	local file
	local destfile
	url=$1
	dest=$2
	cached=$3
	file=`basename $url`
	destfile=$dest/$file
	empty "$dest" "Download output directory string must be non-empty."
	empty "$url"  "Download URI string must be non-empty."
	# Remove files downloaded earlier (default yes)
	if [ "x$cached" != "xyes" ] && [ -r $destfile ] ;  then
		echo "Removed earlier file '$file'."
		rm -f $destfile
	fi 
	# Download file found from URI if not already found
	if [ ! -r  $destfile ] ; then
		echo "Downloading '$file'."
		download $dest $url
	else
		echo "Using previously downloaded '$file'."
	fi
}

# Prints out an underlined text banner
# phase (text)
phase () {
	local text
	local underline
	text=$1
	underline=`echo $text | sed 's,.,-,g'`
	echo
	echo "$text"
	echo "$underline"
	echo
}

# Add users to scratchbox group, create directories and symlinks
# sb_addusers (scratchbox, users)
sb_addusers () {
	local scratchbox
	local users
	scratchbox=$1
	users=$2

	for __user in `echo "$users" | sed "s/,/ /g"` ; do
		echo "Adding scratchbox user '$__user'."
		$scratchbox/sbin/sbox_adduser "$__user" yes
		#if [ $? != 0 ] ; then
		#	echo "E: Adding scratchbox user failed. Installation not complete. Exiting."
		#	exit 1
		#else
		if [ ! -e "$scratchbox/users/$__user/home/user" ] ; then
			ln -s $__user $scratchbox/users/$__user/home/user
		fi
	done

}
# Main
# TODO Add long command line options
while getopts "hvcdFs:g:Uu:" opt ; do
	case "$opt" in
		h)
			usage 
			exit 0
			;;
		v)
			version 
			exit 0
			;;
		c)
			__cached=yes 
			;;
		a)
			__type=apt
			;;
		d)
			__type=deb
			;;

		F)	__type=deb
			echo "Option -F is deprecated."	
			;;
		U)	__upgrade=yes
			;;
		s)
			__type=tgz
			__scratchbox=$OPTARG
                        arch='i386'
                        delim='-'
                        suffix='.tar.gz'
			;;
		g)
			__scratchbox_group=$OPTARG
			;;
		u)
			__users=$OPTARG
			;;
		[?])
			usage
			exit 1
			;;
	esac
done

# Download path
__download_source_tarball=http://scratchbox.org/download/files/sbox-releases/branches/hathor/r1/tarball
__download_source_deb=http://scratchbox.org/download/files/sbox-releases/branches/hathor/r1/deb/${arch}
__download_dest=/tmp
__scratchbox_files="scratchbox-core${delim}1.0.26${delim}${arch}${suffix} \
scratchbox-devkit-apt-https${delim}1.0.11${delim}${arch}${suffix} \
scratchbox-devkit-autotools-legacy${delim}1.0${delim}${arch}${suffix} \
scratchbox-devkit-debian${delim}1.0.12${delim}${arch}${suffix} \
scratchbox-devkit-doctools${delim}1.0.15${delim}${arch}${suffix} \
scratchbox-devkit-git${delim}1.0.2${delim}${arch}${suffix} \
scratchbox-devkit-perl${delim}1.0.5${delim}${arch}${suffix} \
scratchbox-devkit-python-legacy${delim}1.0.2${delim}${arch}${suffix} \
scratchbox-devkit-qemu${delim}0.13.90-0rabbit1${delim}${arch}${suffix} \
scratchbox-devkit-svn${delim}1.0.1${delim}${arch}${suffix} \
scratchbox-libs${delim}1.0.26${delim}${arch}${suffix} \
scratchbox-toolchain-cs2007q3-glibc2.5-arm7${delim}1.0.16.1-8${delim}${arch}${suffix} \
scratchbox-toolchain-cs2007q3-glibc2.5-i486${delim}1.0.16.1-6${delim}${arch}${suffix} \
scratchbox-toolchain-host-gcc${delim}1.0.26${delim}${arch}${suffix}"

# Set Debian package defaults
if [ -z $__type ] ; then
	if has_debian ; then
		if has_new_apt ; then
			__type=apt
		else
			__type=deb
		fi
	else
		__type=tgz
	fi
fi

# Check sanity of __type
if [ $__type = "apt" ] ; then
	if has_debian ; then
		if ! has_new_apt ; then
			# Needs apt >= 0.6.43.3
			echo "E: APT does not support /etc/apt/sources.list.d on this system."
			exit 1
		fi
	else
		echo "E: Not on a Debian based system, cannot install using apt."
		exit 1
	fi
fi

# Runtime options
if [ $__type = "tgz" ] ; then
	if [ -z $__scratchbox ] ; then
		echo "E: Give installation path using '-s PATH' argument."
		usage
		exit 1
	fi
fi

# If installing from debian packages, set the default sb-path
if [ -z $__scratchbox ] ; then
	__scratchbox=/scratchbox
fi


# Scratchbox group defaults
if [ -z $__scratchbox_group ] ; then
	__scratchbox_group=$__default_group
fi

# Use cached file default
if [ -z $__cached ] ; then
	__cached=no
fi

# Set download path
if [ $__type = "tgz" ] ; then
	__download_source=$__download_source_tarball
else
	__download_source=$__download_source_deb
fi

echo "This script will install Scratchbox $__scratchbox_version '$__scratchbox_release' release to your computer."

phase "Install options"

cat <<END
Install from packages=$__type
Scratchbox install path=$__scratchbox
Scratchbox group=$__scratchbox_group
armel compiler=$__armel_toolchain
i386 compiler=$__i386_toolchain
armel devkits=$__armel_devkits
i386 devkits=$__i386_devkits
armel CPU transparency=$__armel_cputransp
END

phase "Checking for prerequisites"

# Check not run as user root
echo -n "Running as user root... "
__user=`whoami`
if [ x$__user != "xroot" ] ; then
	echo "no"
	echo "E: This script must be run as user root."
	exit 1
else
	echo "yes"
fi

# Check for fakeroot
echo -n "Not running as user root inside fakeroot... "
if [ ! -z "$FAKEROOTKEY" ] ; then
	echo "no"
	echo "E: This script should not be run inside fakeroot."
	exit 1
else
	echo "yes"
fi

# Check for running inside scratchbox
echo -n "Running outside of scratchbox... "
if [ -r /targets/links/scratchbox.config ] ; then
	echo "no"
	echo "E: This script needs to be run outside of scratchbox."
	exit 1
else
	echo "yes"
fi

# Check for mmap_min_addr
if [ `which lsb_release` ] && [ x`lsb_release -cs` = "xlucid" ] ; then
    echo "Check the mmap_min_addr value..."
    if [ -f "/proc/sys/vm/mmap_min_addr" ] && [ `sysctl -n vm.mmap_min_addr` -gt 4096 ] ; then
        echo "no"
        echo "E: Host kernel mmap_min_addr value is incompatible with the QEMU"
        echo "E: version used in scratchbox." 
        echo "E: You can set a supported value for your current session with"
        echo "E: 'sysctl vm.mmap_min_addr=0' as root."
        echo "E: For a permanent solution you may add 'vm.mmap_min_addr = 0'"
        echo "E: to /etc/sysctl.conf and run 'sysctl -p' as root"
        exit 1
    else
        echo "yes"
    fi
fi

# Check for scratchbox installation
echo -n "Scratchbox installation existing... "
if [ -f $__scratchbox/etc/scratchbox-version ] ; then
	if [ x"$__upgrade" = "xyes" ] ; then
		echo "yes, attempting to upgrade..."
	elif [ x"$__users" != "x" ] ; then
		echo "yes"
		echo "Adding users and creating Maemo specific directories..."
		sb_addusers $__scratchbox $__users
		echo "Done."
		exit 0
	else
		echo "yes"
		echo "E: Scratchbox already found in installation path '$__scratchbox'."
		echo "E: Please use the -U option to upgrade the existing installation."
		echo "E: To start fresh please remove your old scratchbox installation first."
		echo "E: Remember to copy your scratchbox users' home directories." 
		echo "E: Also run '$__scratchbox/sbin/sbox_ctl stop' before removing directory."
		exit 1
	fi
else
	echo "no"
fi

# Check for running on Linux
echo -n "Running on Linux kernel... "
if [ `uname -s` != "Linux" ] ; then
	echo "no"
	echo "E: Currently Scratcbox can only run under Linux."
	exit 1
else
	echo "yes"
fi


# Kernel has the binfmt_misc module
echo -n "Host kernel binfmt_misc support... "
if [ ! -d "/proc/sys/fs/binfmt_misc" ]; then
	echo "no"
	echo "E: Host kernel module binfmt_misc is required for the CPU transparency feature."
	exit 1
else
	echo "yes"
fi

# SELinux must be off
# TODO Not tested
echo -n "No host kernel SELinux extensions... "
if [ -f "/selinux/enforce" ] && [ `cat /selinux/enforce` -eq 1 ] ; then
	echo "no"
	echo "E: Scratchbox cannot be used under Security Enchanced Linux (SELinux)."
	echo "E: Change to permissive mode with 'echo 0 > /selinux/enforce' as root."
	exit 1
else
	echo "yes"
fi


# Host kernel local IPv4 port range...
# TODO Not tested
echo -n "Host kernel local IPv4 port range... "
if [ `cat /proc/sys/net/ipv4/ip_local_port_range | awk '{ print ($2-$1) }'` -lt 10000 ] ; then 
	echo "no"
	echo "E: Host kernel has IPv4 local port range under 10000."
	echo "E: This causes problems with fakeroot."
	echo "E: Increase with 'echo \"1024 65000\" > /proc/sys/net/ipv4/ip_local_port_range'"
	exit 1
else
	echo "yes"
fi

# Check for wget
if [ $__type != "apt" ] ; then
	__wget=`which wget`
	echo -n "wget tool in path... "
	if [ -z $__wget ] || [ ! -x $__wget ] ; then
		echo "no"
		echo "E: This script requires wget to download rootstraps and installer files."
		echo "E: On most Linux distributions this is provided by 'wget' package."
		exit 1
	else
		echo "$__wget"
	fi
fi

# Debian dpkg found and executable
if [ $__type = "deb"  ] ; then
	__dpkg=`which dpkg`
	echo -n "dpkg tool in path... "
	if [ -z $__dpkg ] || [ ! -x $__dpkg ] ; then
		echo "no"
		echo "E: This script requires dpkg to install .deb files."
		exit 1
	else
		echo "$__dpkg"
	fi
fi

# Scratchbox install path is sane
if [ $__type = "tgz" ] ; then
	echo -n "Scratchbox install path is sane... "
	if [ `expr match "$__scratchbox" '/'` -ne 1 ] ; then
		echo "no"
		echo "E: Scratchbox install path must start with '/'."
		exit 1
	fi
	if ! string_endswith "$__scratchbox" "/scratchbox" ; then
		echo "no"
		echo "E: Scratchbox install path must end with '/scratchbox'."
		exit 1
	fi
	echo "yes"
fi


# Check for existing binfmt_misc runner for arm binaries
echo -n "No conflicting binfmt_misc interpreter... "
for binfmt in /proc/sys/fs/binfmt_misc/* ; do
	if [ x`basename $binfmt` != "xstatus" ] && [ x`basename $binfmt` != "xregister" ]; then
		# Checking for arm signature
		grep -q "magic 7f454c4600010000000000000000000000002800" $binfmt
		if [ $? -eq 0 ] && [ `basename $binfmt` != "sbox-arm" ]; then
			echo "no"
			echo "E: Conflicting registration for arm programs with binfmt_misc. "
			echo "E: Please remove the conflicting package/program, and try again."
			echo -n "E: Conflicting "
			grep "^interpreter " $binfmt
			exit 1
		fi
	fi
done
echo "yes"

# Users given as parametre
echo -n "Scratchbox user names... "
for __user in `echo "$__users" | sed "s/,/ /g"` ; do
	if [ -z "$__user" ] ; then
		echo "no"
		echo "E: Empty username in scratchbox users list."
		exit 1
	fi
	echo -n "$__user "
	getent passwd "$__user" 2>/dev/null 1>&2
	if [ $? -ne 0 ] ; then
		echo "no"
		echo "E: User '$__user' not found with 'getent passwd $__user' command."
		exit 1
	fi
done
echo "yes"
echo

echo "Everything seems to be ok."

if [ $__type != "apt" ] ; then
	phase "Downloading scratchbox packages"

	# Download and run scratchbox from packages
	for __file in  ${__scratchbox_files} ; do
		get_file ${__download_source}/${__file} ${__download_dest} ${__cached}
		if ! [ -r ${__download_dest}/${__file} ] ; then
			echo "E: Downloaded file '$__file' not found from download path."
			exit 1
		fi
		if ! test_integrity ${__download_dest}/${__file} ; then
			echo "E: Downloaded file '$__file' failed integrity test."
			exit 1
		fi
	done

	phase "Setting up"

	# Install packages
	if [ $__type = "deb"  ] ; then
		# Install dpkg packages
		echo "Installing from Debian packages."
		__install_files=""
		for __file in  ${__scratchbox_files} ; do
		 	__install_files="$__install_files ${__download_dest}/${__file}"
		done

		dpkg -i $__install_files
	fi
	if [ $__type = "tgz"  ] ; then
		# Extract .tar.gz packages
		__extractdir=`dirname ${__scratchbox}`
		mkdir -p ${__extractdir}
		for __file in  ${__scratchbox_files} ; do
			echo "Extracting '$__file' to '$__scratchbox'."
			tar -C ${__extractdir} -xzf ${__download_dest}/${__file}
                        if [ $? != 0 ] ; then
                                echo "E: Failed to extract file '$__file'."
                                exit 2
                        fi
		done
		echo
		# Run first time script
		echo "Running first time script."
		if [ ! -x $__scratchbox/run_me_first.sh ] ; then
			echo "E: Scratchbox first time script is not executable."
			echo "E: Something went wrong with the install. Sorry."
			exit 1
		fi

		if [ x$__upgrade = "xyes" ] && [ -f $__scratchbox/.run_me_first_done ] ; then
			rm $__scratchbox/.run_me_first_done
		fi

		cat >$__scratchbox/run_me_first.commands << END
no
$__scratchbox_group
yes
END
		$__scratchbox/run_me_first.sh < $__scratchbox/run_me_first.commands
		rm -Rf __scratchbox/run_me_first.commands
	fi
else
	# apt here!!
	echo "# Scratchbox apt repository for maemo $__maemo_version $__maemo_release" > $__sources_dir/$__sources_file
	echo "# This file was automatically generated and may be overwritten." >> $__sources_dir/$__sources_file
	echo $__scratchbox_repository >> $__sources_dir/$__sources_file

	apt-get update
	if [ $? != 0 ] ; then
		echo "E: Running apt-get update failed."
		echo "E: Please correct the problem with apt and try again."
		echo "E: Or try an alternative installation method."
		exit 1
	fi

	apt-get install -y --force-yes $__scratchbox_packages
	if [ $? != 0 ] ; then
		echo "E: Installing packages with apt failed."
		echo "E: Try again later or try an alternative installation method."
		exit 1
	fi
fi

# Some small sanity checks
for __file in  $__scratchbox/sbin/sbox_adduser $__scratchbox/sbin/sbox_ctl $__scratchbox/login $__scratchbox/compilers/bin/gcc ; do
	if [ ! -x $__file ] ; then
		echo "E: Scratchbox command '$__file' is not executable."
		echo "E: Something went wrong with the install. Sorry."
		exit 1
	fi
done

# Test if devkits are present
# FIXME Add test when devkits string is fixed
#for __devkit in $__scratchbox_devkits ; do 
#	if ! has_devkit $__devkit ; then
#		echo "E: Devkit not found. Installation not complete. Exiting."
#		exit 1
#	fi
#done

sb_addusers $__scratchbox $__users

phase "Installation was successful!"

cat <<END
You now have Scratchbox $__scratchbox_version '$__scratchbox_release' release installed.

Scratchbox cannot be run as user root. Instead, use your normal login
user account. Add additional scratchbox users and sandboxes by running
the installer again (outside scratchbox with root permissions):

	# sh maemo-scratchbox-install_5.0.sh -u USER

Running this command will create sandbox environment for that user,
add user to the '$__scratchbox_group' scratchbox user group and add the maemo
specific symlinks. It will not try to install scratcbox again.
You will need to start a new login terminal after being added to the
'$__scratchbox_group' group for group membership to be effective.

END

# On Debian postinst scripts take care of this automagically
if [ $__type = "tgz" ] ; then
	cat <<END
Scratchbox service must be started for CPU transparency to be functional.
Run the following command (outside scratchbox with root permissions):

	# $__scratchbox/sbin/sbox_ctl start

Add this command to e.g. /etc/rc.local file to start scratchbox service
at boot time.

END
fi

cat <<END
Login to scratchbox session using the following command (as user):

	$ $__scratchbox/login

Refer to scratchbox.org documentation for more information re scratchbox:
http://scratchbox.org/documentation/user/scratchbox-1.0/

END
