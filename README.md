# AXI4 Master-Slave Design

This repository contains a Verilog implementation of an AXI4 Master-Slave system, capable of burst read/write operations. It includes the following key components:

## Files in the Repository

1. **`axi4_master.sv`**:
   - Implements the AXI4 master interface.
   - Capable of generating burst read and write transactions.
   - Configurable for various burst lengths and data widths.

2. **`axi4_slave.sv`**:
   - Implements the AXI4 slave interface.
   - Responds to read/write requests from the master.
   - Handles burst transactions efficiently and ensures data integrity.

3. **`design.sv`**:
   - Integrates the AXI4 master and slave modules.
   - Integrates an example testbench or top-level design to verify the master-slave interaction.

4. **`testbench.sv`**:
   - Integrates the AXI4 master and slave modules.
   - Provides an example testbench or top-level design to verify the master-slave interaction.

## Features
- Fully compliant with the AXI4 protocol.
- Supports burst read/write transactions with various burst lengths.
- Parameterized data width and address width for flexibility.
- Modular design for ease of integration into larger systems.

## How to Use
1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/devadutt-github/axi4_master_slave.git
   ```

2. Simulate the design using any Verilog simulation tool (e.g., ModelSim, Synopsys VCS, or XSIM).
   ```bash
   # Example with ModelSim:
   vsim -do simulate.do
   ```
3. EDA PLayground : https://www.edaplayground.com/x/f6sw

4. Modify the `design.sv` file to customize parameters or to integrate the modules into your project.

## Testing
- A basic testbench is included in the `testbench.sv` file to demonstrate the interaction between the master and slave.
- The testbench generates burst transactions and verifies data correctness at the slave end.

## Future Work
- Add support for AXI4 QoS and user signals.
- Expand testbench coverage for corner cases and protocol violations.
- Include synthesis scripts and timing analysis for hardware implementation.

## Contributions
Contributions are welcome! Feel free to open an issue or submit a pull request for enhancements or bug fixes.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Acknowledgments
- ARM for providing detailed AXI4 protocol specifications.
- Community contributors for guidance and reviews.


