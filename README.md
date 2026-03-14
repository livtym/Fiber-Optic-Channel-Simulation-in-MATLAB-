# Fiber Optic Channel Simulation in MATLAB
This project links custom functions in MATLAB to build a cohesive simulation of a fiber optic channel. It can be used to analyze the affects of attenuation, dispersion, modulation, and demodulation on received message. 

## Modulation/Demodulation Schemes

## Transmitter Function
The optical transmitter is comprised of two functions: the source generator and the transmitter. 

### Source Generator
The purpose of the source generator is to receive the text that is input by the user, and generate a string of binary code to transmit down the signal. Two scenarios can occur: the user may input a string of text, and the source generator will first convert each indivual character from its ASCII character to the decimal value, and then convert the decimal value to 8-bit binary, or, the user will randomly generate 8-bit binary. 

### Transmitter
The transmitter function generates the optical signal simply by calling the modulation function. This function has a container with the parameters such as bit rate, samples per bit, sampling frequency, and extinction ratio that correspond to the modulation function that is used. It also contains a structure with the parameters that are required for the receiver function. 

## SSFM Channel

## Receiver Function
The receiver function acts the same as the transmitter, by receiving the optical signal simply by calling the demodulator function. 

## Decoder
The decoder function acts opposite the source generator. The received signal is the binary bits passed through the fiber channel and demodulation by the demodulation function. If the original message was simply randomly generated binary bits, no decoding is required. If the original message was text, however, it is converted back first by converting to decimal-base, then ASCII encoding, and finally, the original text. 

## Combined Function
