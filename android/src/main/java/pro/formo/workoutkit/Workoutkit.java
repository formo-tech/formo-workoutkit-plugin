package pro.formo.workoutkit;

import com.getcapacitor.Logger;

public class Workoutkit {

    public String echo(String value) {
        Logger.info("Echo", value);
        return value;
    }
}
