import java.util.ArrayList;

public class PaperFractal extends PaperFoldedStrip {
    void nextIteration(){
        ArrayList<Boolean> someList = new ArrayList<Boolean>();
        someList.add(true);
        someList.add(false);

        appendList(someList);
    }

    void iterationUpTo(int someIteration)
    {
        while (someIteration > currentIteration()) {
            nextIteration();
        }
    }


}
