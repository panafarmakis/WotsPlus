# WotsPlus
Wots+ Signature Scheme Utilizing Sha256 (Context of Sphincs+ Signature Scheme for Post-Quantum Cryptography)

This repository represents an implementation of Wots+ (Winternitz One-Time Signature Scheme) in context of SPHINCS+. It is developed as part of my MEng/Diploma Thesis `Hardware Implementation of SPHINCS+ (Wots+) Signature Scheme for Post Quantum Cryptography` from Electical and Computer Engineering Department, University of Patras, Patras Greece. 

SPHINCS+ describes a a stateless hash-based signature framework which can be combined with an arbitrary hash function.
The aim is to standardize cryptographic systems that are secure against attacks originating from both quantum and “classical” computers.
SPHINCS+ has significant advantages over the state of the art in terms of speed, signature size, and security, and is among the nine remaining signature schemes in the second round of the NIST Post-Quantum Cryptography standardization project. The main contribution is the introduction of tweakable hash function and a demonstration how it allows for a unified security analysis of hash-based signature schemes.

In the diploma Thesis, besides a general overview of SPHINCS+, I focused mainly on WOTS+ which is the one-time signature scheme utilized in SPHINCS+.

Before the Wots+ Signature Scheme is presented, I provide a Sha256 Hardware Implementation. Sha256 is a hash function which is internally used in WOTS+ and, consequently, in SPHINCS+. Sha256 is considered to be a performance critical component and, therefore, VHDL is used. Implementation of Sha256 consists of 3 Components and a Top-Level: a Finite State Machine. The Top Level synchronizes the components which do the required Sha256 computations depending on the phase/step of the Algorithm.

  
WOTS+ is the one-time signature scheme of SPHINCS+. The general data flow of WOTS+ is developed using C/C++ and VITIS HLS tool in order to present the hardware implementation. We perform hardware-software co-optimization, by using the synthesized RTL from VITIS and the hardware Implementation of Sha256. 











