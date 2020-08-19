#!/usr/bin/perl

#------------------------------------------------------------------------------
# z80asm tests
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
BEGIN { use lib 't2'; use testlib; }
my $test = test_name();

my @bin = ( 1, 2, 3, 4, 5,
			unpack("C*", "helloworld"),
			0x34, 0x12, 0x34, 0x12, 0x34, 0x12,
			0x56, 0x78, 0x56, 0x78,
			0x56, 0x34, 0x12, 0x56, 0x34, 0x12, 0x56, 0x34, 0x12,
			0x78, 0x56, 0x34, 0x12, 0x78, 0x56, 0x34, 0x12, 0x78, 0x56, 0x34, 0x12,
			0x55, 0x55, 0xaa, 0xaa);
asm_ok(<<END, "", @bin);
	byte 	1
	db 		2
	defb 	3
	defb	c1, c2

	defm	"hello"
	dm		"world"

	defw	0x1234
	word	0x1234
	dw		0x1234

	defdb	0x5678
	ddb		0x5678

	defp	0x123456
	ptr		0x123456
	dp		0x123456

	defq	0x12345678
	dword	0x12345678
	dq		0x12345678

	defs	2, 0x55
	ds		2, 0xaa

	defc	c1 = 4
	dc		c2 = 5
END

run_ok("z80nm -a $test.o", <<"END", '');
Object  file $test.o at \$0000: Z80RMF14
  Name: $test
  Section "": 50 bytes
    C \$0000: 01 02 03 04 05 68 65 6C 6C 6F 77 6F 72 6C 64 34
    C \$0010: 12 34 12 34 12 56 78 56 78 56 34 12 56 34 12 56
    C \$0020: 34 12 78 56 34 12 78 56 34 12 78 56 34 12 55 55
    C \$0030: AA AA
  Symbols:
    L C \$0004 c1 (section "") (file $test.asm:27)
    L C \$0005 c2 (section "") (file $test.asm:28)
END
end_test();