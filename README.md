# Working of Neuron 
- The code first read the weights and biases from the .mif file and stors it in resgister
- It takes one input per clock cycle and multiplies it with a weight. A counter counts the no. of multiplications to synchronize it.
- The multiplication is added to the previous sum, and for the first cycle, the multiplication is added to the bias
- When the counter again reaches 0, the output is passed through the ReLU function to get the final output.

### HOW TO RUN THE CODE
> First, compile the neuron and test bench file 
```
iverilog -o executables/nueron.vvp nueron.v tb_.v
```
> Run the compiled file using the following command

```
vvp executables/nueron.vvp
```
