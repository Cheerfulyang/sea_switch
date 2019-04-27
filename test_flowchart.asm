/* ETH header offset(14) */
field type = 1(96, 16)

/* IP header offset(14) */
field saddr = 1(96, 32)
field daddr = 1(128, 32)



/* SEANET header offset(34) */
field next_id = 1(0, 8)


/* SEADP header offset(78) */
field seadp_type = 1(32, 8)
field cache_flag = 1(36, 8)



/* table */

table t1, 0, 0, 20
	match type
	match daddr
	match next_id
	entry entry1
	entry entry2
endtable

table t2, 0, 0, 20
	match seadp_type
	match cache_flag
	entry entry2
endtable


entry entry1, 1, check_ip
	priority	1
	counter		0
	matchx	type, 0x0800, 0xffff
	matchx 	daddr, 
	matchx 	next_id
endentry

entry entry2, 2, check_data
	priority	1
	counter		0
	matchx	seadp_type, 0x0800, 0x0000
endentry


proc chech_ip, 1
	br		daddr, 192.168.1.1, got2
	br		next_id, 0x01, fwd
	outp	port_cs
got2:
	goto 	t2
fwd:
	goto 	t_fwd


proc chech_data, 2
	br		next_id, 0x01, fwd
	br		seadp_type, 0x40, fwd
	br		seadp_type, 0x10, fwd
	outp	port_cs
fwd:
	goto 	t_fwd

