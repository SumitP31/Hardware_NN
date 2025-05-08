outputPath = "."
headerPath = "."

def DtoB(num,dataWidth,fracBits): 
    # print("error")
    int_length = dataWidth - fracBits - 1                       #funtion for converting into two's complement format
    if num < 0:
        sign = '1'  
        # print("negative")      
    else:
        sign = '0'
        # print("negative")
    
    int_num = abs(int(num))
    frac_num = abs(num) - abs(int_num)

    # print(f'frac_num = {num} - {int_num} = {frac_num}')
    # print(f"int_num: {int_num}, frac_num: {frac_num}, sign{sign}")

    if int_num >= 2**int_length:
        print("Number is too large to fit in the specified bit length.")
        
    int_bin = format(int_num, f'0{int_length}b')
    frac_bin = ""
    for i in range(fracBits):
        
        frac_num *= 2
       
        bit = int(frac_num)
        # print(f'bit = {bit}')
        frac_bin += str(bit)
        frac_num -= bit
    # print(f"int_num: {int_num}, frac_num: {frac_num}, sign{sign}")
    result = sign + int_bin + frac_bin
    # print(f'{result} = {int_bin} + {frac_bin}' )

    return int(result)

def genWegitsAndBias(dataWidth,weightFracWidth,biasFracWidt,weightArray,biasArray):
    biasFracWidth = biasFracWidt
    bias_dataWidth = 15
    weightIntWidth = dataWidth-weightFracWidth
    biasIntWidth = bias_dataWidth-biasFracWidth
    print(biasFracWidth)
    myWeights = weightArray
    myBiases = biasArray
    try:
        for layer in range(0,len(myWeights)):
            for neuron in range(0,len(myWeights[layer])):
                fi = 'w_'+str(layer+1)+'_'+str(neuron)+'.mif'
                f = open(outputPath+fi,'w')
                for weight in range(0,len(myWeights[layer][neuron])):
                    if 'e' in str(myWeights[layer][neuron][weight]):
                        p = '0'
                    else:
                        if myWeights[layer][neuron][weight] > 2**(weightIntWidth-1):
                            myWeights[layer][neuron][weight] = 2**(weightIntWidth-1)-2**(-weightFracWidth)
                        elif myWeights[layer][neuron][weight] < -2**(weightIntWidth-1):
                            myWeights[layer][neuron][weight] = -2**(weightIntWidth-1)
                        # print(f'{myWeights[layer][neuron][weight]}, datawidth{dataWidth}, weightIntWidth{weightIntWidth}, weightFracWidth{weightFracWidth}')
                        # print(f'{myWeights[layer][neuron][weight]}')
                        wInDec = DtoB(myWeights[layer][neuron][weight],dataWidth,weightFracWidth)
                        # print(f'{wInDec}')
                        p = wInDec
                    f.write(f'{p} \n')
                f.close()
    except:
        print("Number of weights do not match with number of neurons")
        
    try:
        for layer in range(0,len(myBiases)):
            for neuron in range(0,len(myBiases[layer])):
                fi = 'b_'+str(layer+1)+'_'+str(neuron)+'.mif'
                p = myBiases[layer][neuron][0]
                if 'e' in str(p): #To remove very small values with exponents
                    res = '0'
                else:
                    if p > 2**(biasIntWidth-1):
                        p = 2**(biasIntWidth-1)-2**(-biasFracWidth)
                    elif p < -2**(biasIntWidth-1):
                        p = -2**(biasIntWidth-1)
                    # print(f'{p}, datawidth{dataWidth}, biasIntWidth{biasIntWidth}, biasFracWidth{biasFracWidth}') 
                    # print(f'{p}')   
                    bInDec = DtoB(p,bias_dataWidth,biasFracWidth)
                    print(bInDec)
                    res = bInDec
                f = open(outputPath+fi,'w')
                f.write(f'{res}')
                f.close()
    except:
        print("Number of biases do not match with number of neurons")

if __name__ == "__main__":
    # Example usage
    dataWidth = 3
    weightFracWidth = 1
    biasFracWidth = 10
    weightArray = [
        [[1,1,1]]
    ]
    biasArray = [ [[-2.9]]]
    
    genWegitsAndBias(dataWidth, weightFracWidth, biasFracWidth, weightArray, biasArray)