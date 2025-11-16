# Week 7 - My RISC-V SoC Tapeout Journey

**Author:** Goutham Badhrinath V  

---

## 📘 Baby SoC Physical Design

**Installing and setting up ORFS**

```
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
sudo ./setup.sh
```

![image](https://github.com/user-attachments/assets/bec63ae7-4659-42e3-9c01-159a380316a7)

![image](https://github.com/user-attachments/assets/45108685-7362-47ee-b148-e7d1a7552a18)

```
./build_openroad.sh --local
```

![image](https://github.com/user-attachments/assets/2108fc17-2bb9-40cb-a30c-36cc0490dc8a)

![image](https://github.com/user-attachments/assets/8cc97b6f-f231-4f19-9bd9-e2da6e5980b3)

**Verify Installation**

```
source ./env.sh
yosys -help
openroad -help
cd flow
make
```
![image](https://github.com/user-attachments/assets/168b53ca-fb2d-441d-8aa8-2b0178abbb54)

![image](https://github.com/user-attachments/assets/aaf920bb-12e3-4044-a0a9-930b3ef748e9)

```
make gui_final
```
![image](https://github.com/user-attachments/assets/a7b0cca8-5296-4805-88fd-485a720e1bd5)


**ORFS Directory Structure and File formats**

![image](https://github.com/user-attachments/assets/e4f741ad-3f48-4e9a-a799-c8ff95bc74cf)


``` 
├── OpenROAD-flow-scripts             
│   ├── docker           -> It has Docker based installation, run scripts and all saved here
│   ├── docs             -> Documentation for OpenROAD or its flow scripts.  
│   ├── flow             -> Files related to run RTL to GDS flow  
|   ├── jenkins          -> It contains the regression test designed for each build update
│   ├── tools            -> It contains all the required tools to run RTL to GDS flow
│   ├── etc              -> Has the dependency installer script and other things
│   ├── setup_env.sh     -> Its the source file to source all our OpenROAD rules to run the RTL to GDS flow
```

Now, go to flow directory

![image](https://github.com/user-attachments/assets/70cb9a6b-b48c-497e-a050-dd6a5b90ea1d)

``` 
├── flow           
│   ├── design           -> It has built-in examples from RTL to GDS flow across different technology nodes
│   ├── makefile         -> The automated flow runs through makefile setup
│   ├── platform         -> It has different technology note libraries, lef files, GDS etc 
|   ├── tutorials        
│   ├── util            
│   ├── scripts             
```

Automated RTL2GDS Flow for VSDBabySoC:

Initial Steps:

- We need to create a directory `vsdbabysoc` inside `OpenROAD-flow-scripts/flow/designs/sky130hd`
- Now create a directory `vsdbabysoc` inside `OpenROAD-flow-scripts/flow/designs/src` and include all the verilog files here.
- Now copy the folders `gds`, `include`, `lef` and `lib` from the VSDBabySoC folder in your system into this directory.
  - The `gds` folder would contain the files `avsddac.gds` and `avsdpll.gds`
  - The `include` folder would contain the files `sandpiper.vh`, `sandpiper_gen.vh`, `sp_default.vh` and `sp_verilog.vh`
  - The `gds` folder would contain the files `avsddac.lef` and `avsdpll.lef`
  - The `lib` folder would contain the files `avsddac.lib` and `avsdpll.lib`
- Now copy the constraints file(`vsdbabysoc_synthesis.sdc`) from the VSDBabySoC folder in your system into this directory.
- Now copy the files(`macro.cfg` and `pin_order.cfg`) from the VSDBabySoC folder in your system into this directory.
- Now, create a `config.mk` file whose contents are shown below:

```
export DESIGN_NICKNAME = vsdbabysoc
export DESIGN_NAME = vsdbabysoc
export PLATFORM    = sky130hd

# export VERILOG_FILES_BLACKBOX = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/*.v
# export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
# Explicitly list the Verilog files for synthesis
export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vsdbabysoc.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/rvmyth.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/clk_gate.v

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/vsdbabysoc_synthesis.sdc

export vsdbabysoc_DIR = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)

export VERILOG_INCLUDE_DIRS = $(wildcard $(vsdbabysoc_DIR)/include/)
# export SDC_FILE      = $(wildcard $(vsdbabysoc_DIR)/sdc/*.sdc)
export ADDITIONAL_GDS  = $(wildcard $(vsdbabysoc_DIR)/gds/*.gds.gz)
export ADDITIONAL_LEFS  = $(wildcard $(vsdbabysoc_DIR)/lef/*.lef)
export ADDITIONAL_LIBS = $(wildcard $(vsdbabysoc_DIR)/lib/*.lib)
# export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.tcl

# Clock Configuration (vsdbabysoc specific)
# export CLOCK_PERIOD = 20.0
export CLOCK_PORT = CLK
export CLOCK_NET = $(CLOCK_PORT)

# Floorplanning Configuration (vsdbabysoc specific)
export FP_PIN_ORDER_CFG = $(wildcard $(DESIGN_DIR)/pin_order.cfg)
# export FP_SIZING = absolute

export DIE_AREA   = 0 0 1600 1600
export CORE_AREA  = 20 20 1590 1590

# Placement Configuration (vsdbabysoc specific)
export MACRO_PLACEMENT_CFG = $(wildcard $(DESIGN_DIR)/macro.cfg)
export PLACE_PINS_ARGS = -exclude left:0-600 -exclude left:1000-1600: -exclude right:* -exclude top:* -exclude bottom:*
# export MACRO_PLACEMENT = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macro_placement.cfg

export TNS_END_PERCENT = 100
export REMOVE_ABC_BUFFERS = 1

# Magic Tool Configuration
export MAGIC_ZEROIZE_ORIGIN = 0
export MAGIC_EXT_USE_GDS = 1

# CTS tuning
export CTS_BUF_DISTANCE = 600
export SKIP_GATE_CLONING = 1

# export CORE_UTILIZATION=0.1  # Reduce this value to allow more whitespace for routing.
```

Now go to terminal and run the following commands:

```
cd OpenROAD-flow-scripts
source env.sh
cd flow
```

Commands for **synthesis**:

```
make DESIGN_CONFIG=./designs/sky130hd/vsdbabysoc/config.mk synth
```

![image](https://github.com/user-attachments/assets/b61006cd-554c-425d-9bfb-6d6fa947118d)

![image](https://github.com/user-attachments/assets/353513a3-8272-4ddf-b178-eff0d70650a9)

Synthesis netlist:

![image](https://github.com/user-attachments/assets/c2464bd4-c95a-4917-b71d-4ffb7f031950)

Synthesis log:

![image](https://github.com/user-attachments/assets/9cd5f73d-a4cc-4174-889d-872eeff31fe0)

Synthesis Check:

![image](https://github.com/user-attachments/assets/aba75cdc-42ae-4989-b566-3f812ac5667d)

Synthesis Stats:

![image](https://github.com/user-attachments/assets/8553380f-abbb-4ea4-be61-5a59d092ed50)

![image](https://github.com/user-attachments/assets/b8bfc7c4-6a90-4697-8ad6-a3f33992f89d)

![image](https://github.com/user-attachments/assets/11ef305e-06b7-4124-a279-16198e18f120)

![image](https://github.com/user-attachments/assets/d1b7114f-8e88-465a-b4ba-c2f32a8bf312)

Commands for **floorplan**:

```
make DESIGN_CONFIG=./designs/sky130hd/vsdbabysoc/config.mk floorplan
```

![image](https://github.com/user-attachments/assets/46de8e09-36da-4678-b8a2-05a3623c8b34)

![image](https://github.com/user-attachments/assets/ce8cf1e2-ec77-4b8c-8de5-d60cbc16a8b9)

```
make DESIGN_CONFIG=./designs/sky130hd/vsdbabysoc/config.mk gui_floorplan
```
![image](https://github.com/user-attachments/assets/9398bb6a-51a7-41c7-9df6-7e15cfc14c1d)

![image](https://github.com/user-attachments/assets/57b1075e-cb18-4922-b0f8-e055bf5661d8)

```
make DESIGN_CONFIG=./designs/sky130hd/vsdbabysoc/config.mk place
```

![image](https://github.com/user-attachments/assets/33a6fe07-fd13-435f-9cf0-a4ebdc313842)

![image](https://github.com/user-attachments/assets/e165bdba-914e-417e-9578-630bd2b63514)

```
make DESIGN_CONFIG=./designs/sky130hd/vsdbabysoc/config.mk gui_place
```

![image](https://github.com/user-attachments/assets/8df8d550-d1e7-447e-8e7d-3a56f8043f87)

![image](https://github.com/user-attachments/assets/1b2c60f4-cb75-405d-a2ba-0e200a48b299)

Heatmap:

![image](https://github.com/user-attachments/assets/08984176-1b8b-4326-ac68-8aeb3c9262b9)

![image](https://github.com/user-attachments/assets/f4297129-92d3-49ab-b993-ae70597a4891)

![image](https://github.com/user-attachments/assets/c0c8e9ca-7960-4cb0-bd36-b9601f0697db)


```
make DESIGN_CONFIG=./designs/sky130hd/vsdbabysoc/config.mk cts
```

![image](https://github.com/user-attachments/assets/fbd2d4a2-248a-450f-bdcc-fd0ab0c9c2f4)

![image](https://github.com/user-attachments/assets/a17cd95d-cfb8-47f2-9e79-a2e71d0499d6)

```
make DESIGN_CONFIG=./designs/sky130hd/vsdbabysoc/config.mk gui_cts
```

![image](https://github.com/user-attachments/assets/7a390b9d-90f1-406b-b397-254187828bfd)

![image](https://github.com/user-attachments/assets/b43cfb6a-f095-4c9f-adc2-b562b42142b4)

![image](https://github.com/user-attachments/assets/da5935db-358b-4edc-ade0-9823625ba062)

CTS final report:

![image](https://github.com/user-attachments/assets/d545c7f2-9514-4ee2-a76b-1fe5ee60c88e)


