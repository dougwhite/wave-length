class_name GameManager
extends Node

var current_frequency = 0

var COLORS := [
	Color("#780063"),	# 00
	Color("#b00071"),	# 01
	Color("#c90149"),	# 02
	Color("#f5175f"),	# 03
	Color("#e21837"),	# 04
	Color("#f2302a"),	# 05
	Color("#e71318"),	# 06
	Color("#f93a33"),	# 07
	Color("#f9290e"),	# 08
	Color("#fa4c11"),	# 09
	Color("#e5580e"),	# 10
	Color("#f08500"),	# 11
	Color("#de7508"),	# 12
	Color("#f2ae06"),	# 13
	Color("#d69a06"),	# 14
	Color("#dabd00"),	# 15
	Color("#9cb607"),	# 16
	Color("#bbce00"),	# 17
	Color("#00bf01"),	# 18
	Color("#03ea01"),	# 19
	Color("#02c500"),	# 20
	Color("#06ec05"),	# 21
	Color("#10b230"),	# 22
	Color("#04ba95"),	# 23
	Color("#09898b"),	# 24
	Color("#0098cc"),	# 25
	Color("#0372a1"),	# 26
	Color("#0377d9"),	# 27
	Color("#0b57c2"),	# 28
	Color("#0e5df0"),	# 29
	Color("#1336d0"),	# 30
	Color("#1a51ee"),	# 31
	Color("#191fce"),	# 32
	Color("#3d2ce1"),	# 33
	Color("#3313c8"),	# 34
	Color("#3a15de"),	# 35
	Color("#3217d1"),	# 36
]

func frequency_color(band: int) -> Color:
	return COLORS[wrapi(band, 0, COLORS.size())]
