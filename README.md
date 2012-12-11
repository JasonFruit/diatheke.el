diatheke.el Emacs interface to the diatheke command-line Bible tool
======================================================================

### Copyright: (C) 2011 Jason R. Fruit ###

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 2 of the
    License, or (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with GNU Emacs; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
    02110-1301 USA

Commentary
----------------------------------------------------------------------

To use this minor mode, you must have
[diatheke](http://www.crosswire.org/wiki/Frontends:Diatheke) properly
installed and on your `PATH`; you must also have installed at least
one bible translation.

To install `diatheke.el`, save this file somewhere in your Emacs load
path and put the following in your .emacs:

    (require 'diatheke)

To toggle diatheke-mode, which is initially off, do:

    M-x diatheke-mode

Keybindings
----------------------------------------------------------------------

Once `diatheke-mode` is active, the following default keybindings will
be created:

 - **C-c C-b**: select a bible translation  
 - **C-c C-i**: insert a passage  
 - **C-c C-p**: search for a phrase  
 - **C-c C-m**: search for multiple words  
 - **C-c C-r**: search by regex  
