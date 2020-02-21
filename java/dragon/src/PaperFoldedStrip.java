import java.util.ArrayList;

public class PaperFoldedStrip {

    private ArrayList<ArrayList<Boolean>> foldLists;

    public PaperFoldedStrip(){
        foldLists = new ArrayList<ArrayList<Boolean>>();
    }

    public int currentIteration() {
        return foldLists.size();
    }

    public void appendList(ArrayList<Boolean> inputList) {
        this.foldLists.add(inputList);
    }

    public ArrayList<Boolean> flatFoldList(int thruIteration){
        ArrayList<Boolean> result = new ArrayList<Boolean>();
        if (thruIteration <= currentIteration() ) {
            for ( ArrayList<Boolean> some_list : foldLists.subList(0,(thruIteration ) )
                ) {
                for ( Boolean some_turn : some_list) {
                    result.add(some_turn);
                }
            }
        }
        return result;
    }

    public ArrayList<Boolean> flatFoldList() {
        return flatFoldList(currentIteration());
    }

}

