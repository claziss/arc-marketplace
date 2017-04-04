AC_INIT(arc-toolchain, 1.0)

AC_PROG_CC
AC_PROG_FGREP
AC_PROG_GREP

AC_PATH_PROG([BASH], [bash],
	[AC_MSG_ERROR([bash not found])])

AC_PATH_PROGS_FEATURE_CHECK([GAWK], [gawk awk],
	[AS_IF([$ac_path_GAWK --version 2>&1 | $FGREP GNU >/dev/null],
		[ac_cv_path_GAWK=$ac_path_GAWK ac_path_GAWK_found=:])],
	[AC_MSG_ERROR([GNU Awk not found])])
AC_SUBST([GAWK], [$ac_cv_path_GAWK])

AC_PATH_PROGS_FEATURE_CHECK([GSED], [gsed sed],
	[AS_IF([$ac_path_GSED --version 2>&1 | $FGREP GNU >/dev/null],
		[ac_cv_path_GSED=$ac_path_GSED ac_path_GSED_found=:])],
	[AC_MSG_ERROR([GNU sed not found])])
AC_SUBST([GSED], [$ac_cv_path_GSED])

AC_PATH_PROG([GNUPLOT], [gnuplot],
	[AC_MSG_ERROR([gnuplot not found])])

AC_PATH_PROG([DISPLAY], [display],
	[AC_MSG_ERROR([display not found])])

AC_PATH_PROG([CURL], [curl], [no])
AC_PATH_PROG([WGET], [wget], [no])
AC_PATH_PROG([FTP], [ftp], [no])
AS_IF([test x"$CURL" != xno], [FETCHER="$CURL -L -o - --ftp-pasv --retry 10"],
	[test x"$WGET" != xno], [FETCHER="$WGET -O -"],
	[test x"$FTP" != xno], [FETCHER="$FTP -o - -p"],
	[AC_MSG_ERROR([no file transfer utility found])])
AC_SUBST(FETCHER)

AC_CONFIG_FILES([Makefile])

AC_OUTPUT
