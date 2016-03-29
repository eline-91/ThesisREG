def convertDMS(inFile, outFile, position, order):
    myInputFile = open(inFile, 'r')
    myOutputFile = open(outputFile, 'w')

    header = myInputFile.readline()[0:-1] + "," + order[0] + "," + order[1]
    myOutputFile.write(header + "\n")
    for line in myInputFile:
        coords = line.split(",")[position].split("/")
        for i in range(len(coords)):
            coords[i] = ''.join(c for c in coords[i] if c.isdigit())
            if len(coords[i]) == 6:
                coords[i] = coords[i][0:2] + " " + coords[i][2:4] + " " + coords[i][4:6]
            elif len(coords[i]) == 5:
                coords[i] = coords[i][0:1] + " " + coords[i][1:3] + " " + coords[i][3:5]
            else:
                coords[i] = "-99"
        myOutputFile.write(line[0:-1] + "," + coords[0] + "," + coords[1] + "\n")

    myInputFile.close()
    myOutputFile.close()

if __name__ == "__main__":
##    inputFile = "C:/Users/Eline/Google Drive/Thesis_REG/Data/test_coords.csv"
##    outputFile = "C:/Users/Eline/Google Drive/Thesis_REG/Data/test_coords_output.csv"
##    position = 2
##    order = "yx"

    inputFile = "C:/Users/Eline/Google Drive/Thesis_REG/Data/Herd and sub-district level bTB1_coords.csv"
    outputFile = "C:/Users/Eline/Documents/Thesis_REG/Project/ThesisREG/data/bTB_Coordinates_DMS.csv"
    position = 5
    order = "yx"
    
    convertDMS(inputFile, outputFile, position, order)
