========================
Pari/GP builder for OS/X
========================

Contains:
---------

- ``makePariGP`` a shell script that compiles gp for Mac OS and creates an
  standalone App bundle.

- ``makedmg`` a shell script which creates a .dmg installer from any directory
  (in particular the PariGP.app created above).

Requirements:
-------------

- pari/GP sources in ``HOME/pari``

  ::
    
    $ git clone http://pari.math.u-bordeaux.fr/git/pari.git
    $ git tag
    $ git co -b pari-2.6

- GNU gcc compiler in ``/usr/local/bin/gcc-4.7``

- gmp, readline and ncurses static libraries in ``/opt/local/lib``::

    $ ls /opt/local/lib
    libreadline.a
    libncursesw.a
    libgmp.a

All these can be installed with homebrew

::
  
  brew install gcc readline gmp ncurses

Usage:
------

- make PariGP app bundle
  
  ::

    makePariGP


- make dmg to install in ``/Applications``

  ::

    makedmg PariGP-Tiny-2.6.1 PariGP.app /Applications/

- make separate bundles for data directories

  ::

    makedmg PariGP-data $HOME/pari/data /Applications/PariGP.app/Contents/Resources/share/pari


Icons:
------

The PariGP.icns is an archive containing different resolutions of the icon
(16,32,128,256,512 pixels).

Everything is generated from the svg icon file ``images/icon.svg`` which
contains a square element named ``PariGPicon``. This uses inkscape and
iconutil.

::

  makeIcons
