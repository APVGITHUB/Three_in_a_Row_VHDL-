# Clock @ 125 MHz
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }];

# Reset
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { reset }];


# LEDs
set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports { leds[0] }];
set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports { leds[2] }];
set_property -dict { PACKAGE_PIN V6    IOSTANDARD LVCMOS33 } [get_ports { leds[4] }];
set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports { leds[6] }];
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { leds[1] }];
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { leds[3] }];
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { leds[5] }];
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { leds[7] }];

# 7 segments - SELECTOR
set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS33 } [get_ports { selector[3] }]; # 0
set_property -dict { PACKAGE_PIN T5    IOSTANDARD LVCMOS33 } [get_ports { selector[2] }]; # 1
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports { selector[1] }]; # 2
set_property -dict { PACKAGE_PIN W11   IOSTANDARD LVCMOS33 } [get_ports { selector[0] }]; # 3

# 7 segments - SEGMENTS
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports { segmentos[0] }]; #punto
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { segmentos[7] }]; # a
set_property -dict { PACKAGE_PIN U10   IOSTANDARD LVCMOS33 } [get_ports { segmentos[6] }]; # b
set_property -dict { PACKAGE_PIN Y12   IOSTANDARD LVCMOS33 } [get_ports { segmentos[5] }]; # c
set_property -dict { PACKAGE_PIN Y11   IOSTANDARD LVCMOS33 } [get_ports { segmentos[4] }]; # d
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports { segmentos[3] }]; # e
set_property -dict { PACKAGE_PIN B19   IOSTANDARD LVCMOS33 } [get_ports { segmentos[2] }]; # f
set_property -dict { PACKAGE_PIN C20   IOSTANDARD LVCMOS33 } [get_ports { segmentos[1] }]; # g

# Buttons
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { B1 }];
set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33 } [get_ports { B2 }];
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { B3 }];
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { B4 }];

#Speed
set_property -dict { PACKAGE_PIN V7    IOSTANDARD LVCMOS33 } [get_ports { speed }];

#Mode
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { mode[0] }];
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports { mode[1] }];

