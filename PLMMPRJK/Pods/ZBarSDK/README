ZBAR BAR CODE READER
====================

ZBar Bar Code Reader is an open source software suite for reading bar
codes from various sources, such as video streams, image files and raw
intensity sensors. It supports EAN-13/UPC-A, UPC-E, EAN-8, Code 128,
Code 39, Codabar, Interleaved 2 of 5 and QR Code.  Included with the
library are basic applications for decoding captured bar code images and
using a video device (eg, webcam) as a bar code scanner.  For application
developers, language bindings are included for C, C++, Python and Perl
as well as GUI widgets for Qt, GTK and PyGTK.

Check the ZBar home page for the latest release, mailing lists, etc.
    http://zbar.sourceforge.net/

License information can be found in 'COPYING'.


BUILDING
========

See 'INSTALL' for generic configuration and build instructions.

The scanner/decoder library itself only requires a few standard
library functions which should be avilable almost anywhere.

The zbarcam program uses the video4linux API (v4l1 or v4l2) to access
the video device.  This interface is part of the linux kernel, a 2.6
kernel is recommended for full support.  More information is available
at
    http://www.linuxtv.org/wiki/

pkg-config is used to locate installed libraries.  You should have
installed pkg-config if you need any of the remaining components.
pkg-config may be obtained from
    http://pkg-config.freedesktop.org/

The zbarimg program uses ImageMagick to read image files in many
different formats.  You will need at least ImageMagick version 6.2.6
if you want to scan image files.  ImageMagick may be obtained from
    http://www.imagemagick.org/

The Qt widget requires Qt4.  You will need Qt4 if you would like to
use or develop a Qt GUI application with an integrated bar code
scanning widget.  Qt4 may be obtained from
    http://qt.nokia.com/products

The GTK+ widget requires GTK+-2.x.  You will need GTK+ if you would
like to use or develop a GTK+ GUI application with an integrated bar
code scanning widget.  GTK+ may be obtained from
    http://www.gtk.org/

The PyGTK wrapper for the GTK+ widget requires Python and PyGTK.  You
will need both if you would like to use or develop a PyGTK GUI
application with an integrated bar code scanning widget.  PyGTK may be
obtained from
    http://www.pygtk.org/

The Python bindings require Python (version?).  You will need Python
if you would like to scan images or video directly using Python.
Python is available from
    http://python.org/

The Perl bindings require Perl (version?).  You will need Perl if you
would like to scan images or video directly using Perl.  Perl is
available from
    http://www.perl.org/

If required libraries are not available you may disable building for
the corresponding component using configure (see configure --help).

The Perl bindings must be built separately after installing the
library.  see
    perl/README


RUNNING
=======

'make install' will install the library and application programs.  Run
'zbarcam' to start the video scanner.  use 'zbarimg barcode.jpg' to
decode a saved image file.  Check the manual to find specific options
for each program.


REPORTING BUGS
==============

Bugs can be reported on the sourceforge project page
    http://www.sourceforge.net/projects/zbar/

Please include the ZBar version number and a detailed description of
the problem.  You'll probably have better luck if you're also familiar
with the concepts from:
    http://www.catb.org/~esr/faqs/smart-questions.html
