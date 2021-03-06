package mapreduce;

import java.io.IOException;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class LanguageLetterReducer extends Reducer<Text, DoubleWritable, Text, DoubleWritable> {
	
	static enum ReducerCounters { REDUCER_RECORDS }
	
	public void reduce(Text key, Iterable<DoubleWritable> values, Context context)
	throws IOException, InterruptedException {

		double sum = 0;
		for (DoubleWritable val : values) {
				sum += val.get();
		}
		
		context.write(key, new DoubleWritable(sum));
		context.getCounter(ReducerCounters.REDUCER_RECORDS).increment(1);
		
	}

}
