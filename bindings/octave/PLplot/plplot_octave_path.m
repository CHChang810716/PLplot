## Copyright (C) 1998, 1999, 2000 Joao Cardoso.
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by the
## Free Software Foundation; either version 2 of the License, or (at your
## option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## This file is part of plplot_octave.

# path = plplot_octave_path([path])
#
# set or return the current directory path of octave_plplot scripts

function path = plplot_octave_path(path)

global __pl_plplot_octave_path

if (!exist("__pl_plplot_octave_path"))
  __pl_plplot_octave_path = "/usr/local/share/plplot_octave";
endif

if (nargin == 0)
	path = __pl_plplot_octave_path;
elseif (nargin == 1 && isstr(path))
	__pl_plplot_octave_path = path;
else
	help octave_plplot_path
endif

endfunction
