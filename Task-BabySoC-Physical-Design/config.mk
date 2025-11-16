# Author : Goutham Badhrinath
# Title : Configuartion file for Physical Design
export DESIGN_NICKNAME = vsdbabysoc
export DESIGN_NAME = vsdbabysoc
export PLATFORM = sky130hd

# Explicitly list the Verilog files for synthesis
export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vsdbabysoc.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/rvmyth.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/clk_gate.v

export vsdbabysoc_DIR = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)

export VERILOG_INCLUDE_DIRS = $(wildcard $(vsdbabysoc_DIR)/include/)
export SDC_FILE      = $(wildcard $(vsdbabysoc_DIR)/sdc/vsdbabysoc_synthesis.sdc)
export ADDITIONAL_GDS  = $(wildcard $(vsdbabysoc_DIR)/gds/*.gds.gz)
export ADDITIONAL_LEFS = $(wildcard $(vsdbabysoc_DIR)/lef/*.lef)
#export ADDITIONAL_LIBS = $(wildcard $(vsdbabysoc_DIR)/lib/*.lib)

# Clock Configuration (vsdbabysoc specific)
export CLOCK_PORT = CLK
export CLOCK_NET = $(CLOCK_PORT)

export LAYOUT_CONF = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/layout_conf/vsdbabysoc

# Floorplanning Configuration
export FP_PIN_ORDER_CFG = $(wildcard $(LAYOUT_CONF)/pin_order.cfg)
export FP_SIZING = absolute
export DIE_AREA = 0 0 1600 1600
export CORE_AREA = 20 20 1590 1590   # leave margins


# Placement Configuration
export PLACE_DENSITY = 0.55
#export RTLMP_ARGS = -halo_width 50 -halo_height 50 -target_util 0.50

export MACRO_PLACE_HALO    = 10 10
export MACRO_PLACE_CHANNEL = 40 40
export RTLMP_FLOW = 0
export MACRO_PLACEMENT = $(wildcard $(LAYOUT_CONF)/macro.cfg)
export PLACE_PINS_ARGS = -exclude left:0-600 -exclude left:1000-1600: -exclude right:* -exclude top:* -exclude bottom:*

export TNS_END_PERCENT = 100
export REMOVE_ABC_BUFFERS = 1

# Magic configuration
export MAGIC_ZEROIZE_ORIGIN = 0
export MAGIC_EXT_USE_GDS = 1

# CTS configuration
export CTS_BUF_DISTANCE = 600
export SKIP_GATE_CLONING = 1

export ROUTING_LAYER_ADJUSTMENT = 0.3
#export CORE_UTILIZATION = 0.1

