/*
 * Adplug - Replayer for many OPL2/OPL3 audio file formats.
 * Copyright (C) 1999, 2000, 2001 Simon Peter, <dn.tlp@gmx.net>, et al.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *
 * arcfile.h - Archive file handling, by Simon Peter (dn.tlp@gmx.net)
 */

#include <fstream.h>

class zipfile
{
public:
	zipfile(char *filename = 0);
	~zipfile();

	void open(char *filename);
	void open(ifstream &f);

	char *getfname(unsigned int n)
	{ return fname[n]; };
	unsigned int getnames()
	{ return names; };

private:
	char *fname[256];
	unsigned int names;
};
