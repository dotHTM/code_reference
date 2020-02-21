import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;

public class Main {

    static Hashtable<String, Long> timerStorage = new Hashtable<String, Long>();

    static long timeNow(String someKey){
        Date dateObj = new Date();
        long now = dateObj.getTime();
        timerStorage.put(someKey, now);
        return now;
    }
    static long start(String someKey){
        return timeNow("start_"+someKey);
    }
    static long end(String someKey){
        timeNow("end_"+someKey);
        long diff = timerStorage.get("end_" + someKey) - timerStorage.get("start_" + someKey);
        timerStorage.put("diff_"+someKey, diff);
        return diff;
    }


    static void print(Object input){
        System.out.println(String.valueOf(input));
    }


    public static void main(String[] args) {

        DragonFractal dragon = new DragonFractal();

        dragon.nextIteration();

        int maxIter = 25;

        start("iterate");
        dragon.iterationUpTo(maxIter);
        print( "Accessed in: " +  String.valueOf(end("iterate")));


        print("----");
        print("Current itteration");
        start("current");
        print(dragon.currentIteration());
        print("Accessed in: " +  String.valueOf(end("current")));
        
        print("----");
        print("length of flatfoldlist");
        start("length");
        print(dragon.flatFoldList().size());
        print( "Accessed in: " +  String.valueOf(end("length")));
    }
}
