# WotsPlus
**Wots+ Signature Scheme**

**This repository represents an implementation of Wots+ (Winternitz One-Time Signature Scheme) in context of SPHINCS+**. It is developed as part of my MEng/Diploma Thesis `Hardware Implementation of SPHINCS+ (Wots+) Signature Scheme for Post Quantum Cryptography` at the Electical and Computer Engineering Department, University of Patras, Patras Greece. 

SPHINCS+ describes a stateless hash-based signature framework which can be combined with an arbitrary hash function.
The aim is to standardize cryptographic systems that are secure against attacks originating from both quantum and “classical” computers.
SPHINCS+ has significant advantages over the state of the art in terms of speed, signature size, and security, and is among the nine remaining signature schemes in the second round of the NIST Post-Quantum Cryptography standardization project.

Besides a general overview of SPHINCS+, we focused mainly on WOTS+ which is the one-time signature scheme utilized in SPHINCS+. Regarding the implementation, a bottom-up approach is followed. 
We presented a Hardware Implementation of Sha256 which is a hash function, internally used in WOTS+ and, consequently, in SPHINCS+. Since Sha256 is considered to be a performance critical component VHDL is used. The architecture of Sha256 consists of 3 Components and a Top-Level: a Finite State Machine. The Top Level synchronizes the components which do the required Sha256 computations depending on the phase/step of the Algorithm. 
The general data flow of WOTS+ is developed using C/C++. We synthesize the C/C++ implementation of WOTS+ using VITIS HLS tool in order to obtain the hardware implementation. 
Finally, we perform hardware-software co-optimization, by using the synthesized RTL from VITIS and the hardware Implementation of Sha256. 

This teqnique allowed us to present an approx. 60x times accelerated hardware implementation of the signature scheme regarding signature generation and an approx. 55x accelerated implementation regarding signature verification. 

`Sphincs+ Reference Website`
[https://sphincs.org/]

`Thesis Website (In Greek)`
[https://hdl.handle.net/10889/23270]

Tools: Xilinx Vivado, Xilinx VITIS HLS.

Languages: VHDL, C/C++.










