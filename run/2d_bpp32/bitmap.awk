BEGIN				{ flag = 0 }
$1 == "BitmapDX"		{ dx = $2 }
$1 == "BitmapDY"		{ dy = $2 }
$1 == "BitsPerPixel" && $2 == 8	{ valON = "0xff" }
$1 == "BitsPerPixel" && $2 == 16{ valON = "0xffff" }
$1 == "BitsPerPixel" && $2 == 32{ valON = "0xffffffff" }
$1 == "BitsPerPixel"		{ bpp = $2 }
$1 == "WidthBytes"		{ width = $2 }
flag == 1 && $1 == 0		{ print line; line = "" }
				{ ch = substr($3, length($3), 1) }
				{ linechar = "?" }
ch == "5"			{ linechar = "[" }
ch == "6"			{ linechar = ">" }
ch == "7"			{ linechar = "v" }
ch == "9"			{ linechar = "<" }
ch == "a"			{ linechar = "]" }
ch == "b"			{ linechar = "=" }
ch == "0"			{ linechar = "'" }
$3 == "0x0"			{ linechar = "." }
ch == "1"			{ linechar = "x" }
ch == "2"			{ linechar = "+" }
ch == "3"			{ linechar = "o" }
ch == "4"			{ linechar = "#" }
ch == "8"			{ linechar = "^" }
ch == "c"			{ linechar = "&" }
ch == "d"			{ linechar = "-" }
ch == "e"			{ linechar = "X" }
ch == "f"			{ linechar = "*" }
$3 == valON			{ linechar = "O" }
ch == "x"			{ linechar = "!" }
ch == "X"			{ linechar = "@" }
				{ line = line linechar }
flag == 0			{ line = "" }
$1 == "X" && $2 == "Y"		{ flag = 1
				  line = dx "x" dy ", "
				  line = line bpp " Bits/Pixel; width = " width
				}
END				{ print line }
