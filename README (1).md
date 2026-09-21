# Pattern Detector Using FSM (Verilog)

Detection of the binary sequence **`1101`** from a serial input stream, implemented as both a **Moore** and a **Mealy** finite state machine in Verilog HDL. Verified via RTL simulation in Vivado (XSIM).

## Overview

- **Target sequence:** `1101`
- **Overlap handling:** the FSM re-enters mid-sequence states on a match instead of resetting to idle, so back-to-back overlapping matches (e.g. in `1101101`) are still caught.
- Both Moore and Mealy variants are implemented to compare state-minimization and detection-speed tradeoffs between the two architectures.

## Repository Structure

```
.
├── pattern_detector_mealy.v   # Mealy FSM implementation
├── pattern_detector_moore.v   # Moore FSM implementation
├── tb_pattern_detector.v      # Testbench (swap module instantiation to test either)
└── README.md
```

## FSM Design

**Mealy (4 states):** output is combinational — depends on current state *and* input, so detection is signaled in the same cycle as the final input bit.

**Moore (5 states):** output depends only on current state (registered), so detection is signaled one cycle after the final input bit, but the output is glitch-free.

| | Mealy | Moore |
|---|---|---|
| States | 4 | 5 |
| Output depends on | State + input | State only |
| Detection latency | Same cycle | +1 cycle |

## How to Run (Vivado)

1. Add `pattern_detector_mealy.v` and `pattern_detector_moore.v` as **Design Sources**.
2. Add `tb_pattern_detector.v` as a **Simulation Source** (swap the instantiated module inside it to switch between Mealy and Moore).
3. Run Behavioral Simulation.
4. In the Tcl console:
   ```tcl
   restart
   run 200ns
   ```
5. Zoom-to-fit and inspect the `detected` signal against `din` in the waveform viewer.

## Key Design Notes

- Synchronous active-high reset, standard edge-triggered sequential design.
- Overlap-aware transitions: on a match, the FSM re-enters a mid-sequence state rather than `S0`.
- State `S2` self-loops on `din=1` to correctly handle runs of consecutive `1`s (e.g. `1111101`) without losing sync on the target pattern.
