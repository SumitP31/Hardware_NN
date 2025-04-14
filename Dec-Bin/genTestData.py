import sys
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder

outputPath = "./testData/"
headerFilePath = "./testData/"

try:
    import cPickle as pickle
except:
    import pickle
import gzip
import numpy as np

dataWidth = 16                    #specify the number of bits in test data
IntSize = 10 #Number of bits of integer portion including sign bit

try:
    testDataNum = int(sys.argv[1])
except:
    testDataNum = 3

def DtoB(num,dataWidth,fracBits): 
    int_length = dataWidth - fracBits - 1                       #funtion for converting into two's complement format
    if num < 0:
        sign = '1'        
    else:
        sign = '0'
    
    int_num = abs(num)
    frac_num = num - int_num

    if int_num >= 2**int_length:
        print("Number is too large to fit in the specified bit length.")
        
    int_bin = format(int_num, f'0{int_length}b')
    frac_bin = ""
    for i in range(fracBits):
        frac_num *= 2
        bit = int(frac_num)
        frac_bin += str(bit)
        frac_num -= bit
    # print(f"int_num: {int_num}, frac_num: {frac_num}, sign{sign}")
    result = sign + int_bin + frac_bin
    # print(result)

    return int(result)


def load_data():
    # Load CSV file
    df = pd.read_csv("qrs_103.csv")
    X = df.iloc[:,:-1].values
    data = df.iloc[:,-1].values
    # Initialize encoder
    encoder = LabelEncoder()
    y = encoder.fit_transform(data) # A = 0 ; N = 1 ; ~ = 2
    te_d = np.column_stack((X, y))
    index = np.where(y == 1)
    # print(index)
    return X,y

def genTestData(dataWidth,IntSize,testDataNum):
    dataHeaderFile = open(headerFilePath+"dataValues.h","w")
    dataHeaderFile.write("int dataValues[]={")
    te_d = load_data()
    test_inputs = [np.reshape(x, (1, 3)) for x in te_d[0]]
    x = len(test_inputs[0][0])
    d=dataWidth-IntSize
    count = 0
    fileName = 'test_data.txt'
    f = open(outputPath+fileName,'w')
    fileName = 'visual_data'+str(te_d[1][testDataNum])+'.txt'
    g = open(outputPath+fileName,'w')
    k = open('testData.txt','w')
    for i in range(0,x):
        k.write(str(test_inputs[testDataNum][0][i])+',')
        dInDec = DtoB(test_inputs[testDataNum][0][i],dataWidth,d)
        myData = bin(dInDec)[2:]
        dataHeaderFile.write(str(dInDec)+',')
        f.write(myData+'\n')
        if test_inputs[testDataNum][0][i]>0:
            g.write(str(1)+' ')
        else:
            g.write(str(0)+' ')
        count += 1
        if count%28 == 0:
            g.write('\n')
    k.close()
    g.close()
    f.close()
    dataHeaderFile.write('0};\n')
    dataHeaderFile.write('int result='+str(te_d[1][testDataNum])+';\n')
    dataHeaderFile.close()
        
        
def genAllTestData(dataWidth,IntSize):
    X,y = load_data()
    # print(tr_d)
    test_inputs = X
    x = len(test_inputs[0])
    print(len(test_inputs[0]))
    d=dataWidth-IntSize
    for i in range(len(test_inputs)):
        if i < 10:
            ext = "000"+str(i)
        elif i < 100:
            ext = "00"+str(i)
        elif i < 1000:
            ext = "0"+str(i)
        else:
            ext = str(i)
        fileName = 'test_data_'+ext+'.mif'
        f = open(outputPath+fileName,'w')
        for j in range(0,x):
            dInDec = DtoB(test_inputs[i][j],dataWidth,d)
            if i==0:
                print(dInDec)
            myData = dInDec
            f.write(f'{myData}\n')
        f.write(f'{DtoB((y[i]),dataWidth,0)}')
        f.close()



if __name__ == "__main__":
    # genTestData(dataWidth,IntSize,testDataNum=1)
    genAllTestData(dataWidth,IntSize)
