import time

class PaperFractal:
    def __init__(self):
        self.foldLists = []

    def flatFolds(self):
        resultList = []
        for someList in self.foldLists:
            for someItem in someList:
                resultList.append(someItem)
        return resultList

    def currentIteration(self):
        return len( self.foldLists )

    def nextIteration(self):
        tempFoldLists = [True]
        self.foldLists.append(tempFoldLists)

    def iterationUpTo(self, targetIteration):
        if self.currentIteration() < targetIteration:
            self.nextIteration()
            self.iterationUpTo(targetIteration)

class DragonFractal(PaperFractal):

    def nextIteration(self):
        tempFoldLists = [True]
        workingCopyList = self.flatFolds()
        for i in range( len(workingCopyList)-1, 0-1, -1 ):
            tempFoldLists.append( not( workingCopyList[i] ) )
        self.foldLists.append(tempFoldLists)


def main():
    maxIteration = 25

    someFractal = DragonFractal()

    startTime = time.time()
    someFractal.iterationUpTo(maxIteration)
    elapsedTime = time.time() - startTime
    print("calculated up to " + str(maxIteration) + " in " + str(elapsedTime) )

    print("----")
    print("currentIteration:")
    startTime = time.time()
    print(" "+str(someFractal.currentIteration()))
    elapsedTime = time.time() - startTime
    print("accessed in " + str(elapsedTime))

    print("----")
    print("len(flatFolds):")
    startTime = time.time()
    print(" "+str( len( someFractal.flatFolds() ) ))
    elapsedTime = time.time() - startTime
    print("accessed in " + str(elapsedTime))

    print("----")
    print("2^iteration")
    startTime = time.time()
    print(" "+str(pow(2,maxIteration)))
    elapsedTime = time.time() - startTime
    print("accessed in " + str(elapsedTime))


if __name__ == "__main__":
    main()



