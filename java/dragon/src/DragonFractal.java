
import com.sun.tools.javac.util.ArrayUtils;

import java.util.ArrayList;
import java.util.Collections;

public class DragonFractal extends PaperFractal {
    void nextIteration(){
        ArrayList<Boolean> newList = new ArrayList<Boolean>();
        ArrayList<Boolean> oldList = flatFoldList();

        newList.add(true);

        Collections.reverse(oldList);
        for ( boolean someTurn: oldList ) {
            newList.add(!someTurn);
        }

        appendList(newList);
    }

}
